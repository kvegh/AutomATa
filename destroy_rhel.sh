#!/bin/bash

ansible-playbook -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=2 -e project_name=${1} rhel_sshkeysremove.yml 
ansible-playbook -l gateway -b -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=${2} -e project_name=${1} rhel_vmdestroy.yml 
