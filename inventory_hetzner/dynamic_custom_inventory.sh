#!/bin/bash

ssh ansible@hetzner "sudo virsh list --name --all" | grep -v ansible | grep -v image |  grep -v ^$ > inv_input

cat <<__EOF__ > inventory_hetzner/hosts
[baremetal]
hetzner

[win_vms]
__EOF__

for host in `grep win inv_input` ; do echo ${host} ansible_host=`ssh ansible@hetzner "sudo virsh domifaddr $host" | grep 192.168.122 | awk '{print $4}' | cut -d/ -f1` ; done >> inventory_hetzner/hosts
echo -e "\n[rhel_vms]" >> inventory_hetzner/hosts
grep rhel inv_input >> inventory_hetzner/hosts

# Gatewayed VMs on hetzner once again: 

echo -e "\n[openshift]" >> inventory_hetzner/hosts
grep openshift inv_input >> inventory_hetzner/hosts
echo -e "\n[infrastructure]" >> inventory_hetzner/hosts
echo "ansible-h" >> inventory_hetzner/hosts
echo "satellite-h" >> inventory_hetzner/hosts
echo "zabbix-h" >> inventory_hetzner/hosts
echo -e "\n[gatewayed:children]" >> inventory_hetzner/hosts
echo -e "rhel_vms" >> inventory_hetzner/hosts
echo -e "win_vms" >> inventory_hetzner/hosts
echo -e "infrastructure" >> inventory_hetzner/hosts
echo -e "openshift" >> inventory_hetzner/hosts


echo -e "\n[network]" >> inventory_hetzner/hosts
echo "f5-h" >> inventory_hetzner/hosts

if [ "$1" == "--list" ] ; then

python inventory2json.py inventory_hetzner/hosts

elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
