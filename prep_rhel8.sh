#!/bin/bash

ansible-playbook -l gateway -b -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=3 -e project_name=${1} rhel8_vmcreate.yml 
ansible-playbook -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=3 -e project_name=${1} rhel_sshkeysremove.yml 
ansible-playbook -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=3 -e project_name=${1} rhel_sshkeyssetup.yml 
