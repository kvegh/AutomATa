#!/bin/bash

/usr/bin/python3 /usr/bin/ansible-playbook -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=2 -e project_name=${1} rhel_sshkeysremove.yml 
/usr/bin/python3 /usr/bin/ansible-playbook -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=2 -e project_name=${1} rhel_sshkeysremove.yml 
/usr/bin/python3 /usr/bin/ansible-playbook -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=2 -e project_name=${1} rhel_sshkeysremove.yml 
/usr/bin/python3 /usr/bin/ansible-playbook -l gateway -b -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=2 -e project_name=${1} rhel_vmdestroy.yml 
