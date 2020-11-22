
echo "***** MOVING  from $1 to $2 *****" 
cd /home/ansible/projects/AutomATa/

echo "***** SAT DROP $1 *****" 
ansible-playbook -i inventory/dynamic_custom_inventory.sh -e project_name=$1 satellite_drop_hosts.yml

echo "***** DESTROYING $1 *****" 
ssh gateway "/home/ansible/insights_destroy.sh $1"

echo "***** CREATING $2 *****" 
./create_insights.sh $2

echo "***** SATREG $2 *****" 
ansible-playbook -l rhel_vms -i inventory/dynamic_custom_inventory.sh rhel_satreg.yml --become 

echo "***** UPDATE $2 *****" 
ansible-playbook rhel_update.yml -b -l rhel_vms -i inventory/dynamic_custom_inventory.sh --timeout 120 

echo "**** MOVE hosts $2 to new LCE" 
ansible-playbook satellite_move_hosts.yml -e project_name=$2 -i inventory/dynamic_custom_inventory.sh 

echo "***** UPDATE $2 second round *****" 
ansible-playbook rhel_update.yml -b -l rhel_vms -i inventory/dynamic_custom_inventory.sh --timeout 120 

echo "***** PLANTING INSIGHTS ISSUES $2 *****" 
ansible-playbook rhel_insights_issues.yml -b -l rhel_vms -i inventory/dynamic_custom_inventory.sh 

echo "***** INSIGHTS REG $2 *****" 
ansible-playbook rhel_insights.yml -b -l rhel_vms -i inventory/dynamic_custom_inventory.sh 


