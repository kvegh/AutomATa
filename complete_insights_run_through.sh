#!/bin/bash

# This script prepares the whole insights demo environment end-to-end

echo "***** MOVING from $1 to $2 *****" 
echo "***** TIME: `date`  *****" 
echo

echo "***** CWD to WD *****" 
cd /home/ansible/projects/AutomATa/

echo "***** INSIGHTS UNREG $2 *****" 
ansible-playbook insights_unreg.yml -b -l rhel_vms -i inventory/dynamic_custom_inventory.sh 

echo "***** SAT DROP $1 *****" 
ansible-playbook -i inventory/dynamic_custom_inventory.sh -e project_name=$1 satellite_drop_hosts.yml

echo "***** DESTROYING $1 *****" 
ssh gateway "/home/ansible/insights_destroy.sh $1"

echo "***** CREATING $2 *****" 
./create_insights.sh $2

echo "***** SATREG $2 *****" 
ansible-playbook -l rhel_vms -i inventory/dynamic_custom_inventory.sh rhel_satreg.yml --become 

###########################################################################################
# First section 

echo -e "I am patiently waiting. Do you want me to get on with the next step and update the RHEL VMs? \c" 
# read -n 2

echo "***** UPDATE $2 *****" 
ansible-playbook rhel_update.yml -b -l rhel_vms -i inventory/dynamic_custom_inventory.sh 

###########################################################################################
# Second section 

echo -e "I am patiently waiting. Do you want me to get on with the next step and move and update the RHEL VMs again? \c" 
# read -n 2

echo "**** MOVE hosts $2 to new LCE" 
ansible-playbook satellite_move_hosts.yml -e project_name=$2 -i inventory/dynamic_custom_inventory.sh 

echo "***** UPDATE $2 second round *****" 
ansible-playbook rhel_update.yml -b -l rhel_vms -i inventory/dynamic_custom_inventory.sh 

###########################################################################################
# Third section 

echo -e "I am patiently waiting. Do you want me to get on with the next step and get those VMs insighted? \c" 
# read -n 2

echo "***** PLANTING INSIGHTS ISSUES $2 *****" 
ansible-playbook rhel_insights_issues.yml -b -i inventory/dynamic_custom_inventory.sh -e project_name=$2 

echo "***** INSIGHTS REG $2 *****" 
ansible-playbook rhel_insights.yml -b -l rhel_vms -i inventory/dynamic_custom_inventory.sh 

# echo "**** AND NOW WE WAIT ******" 
# sleep 13m 

echo "**** MAIN SECTION DONE, YOUR TURN ******" 
echo "***** TIME: `date`  *****" 

# echo RUNNING INSIGHTS TESTS 

# while true ; do date ; ansible rhel_vms -m shell -b -i inventory/dynamic_custom_inventory.sh -a "insights-client --diagnosis ; insights-client --status " ; sleep 1m ; done 
