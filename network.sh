#!/bin/bash

./prep.sh $1
ansible-playbook -l rhel_vms -i inventory/dynamic_custom_inventory.sh rhel_satreg.yml -b 
/usr/bin/python3.6 /usr/bin/ansible-playbook -l win_vms -i inventory/dynamic_custom_inventory.sh win_webserversetup.yml 
ansible-playbook -l rhel_vms -i inventory/dynamic_custom_inventory.sh rhel_webserversetup.yml -b 

