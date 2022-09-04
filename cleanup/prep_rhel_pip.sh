#!/bin/bash
cp /home/ansible/.ssh/known_hosts.bak /home/ansible/.ssh/known_hosts
ansible-playbook -l gateway -b -i inventory/hosts -e number_of_hosts=2 -e project_name=${1} rhel_vmcreate.yml 
ansible-playbook -i inventory/hosts -e number_of_hosts=2 -e project_name=${1} rhel_sshkeysremove.yml 
ansible-playbook -i inventory/hosts -e number_of_hosts=2 -e project_name=${1} rhel_sshkeyssetup.yml 
