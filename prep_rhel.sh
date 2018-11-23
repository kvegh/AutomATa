#!/bin/bash

ansible-playbook -b -i inventory/dynamic_custom_inventory.sh -e number_of_hosts=2 -e project_name=infra rhel_vmcreate.yml 
ansible-playbook -b -i inventory/dynamic_custom_inventory.sh rhel_sshkeysremove.yml 
ansible-playbook -b -i inventory/dynamic_custom_inventory.sh rhel_sshkeyssetup.yml 