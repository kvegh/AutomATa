#!/bin/bash

ssh ansible@gateway "sudo virsh list --name" | grep -v ansible | grep -v ^$ > inv_input

cat <<__EOF__ > inventory_hetzner/hosts
[baremetal]
gateway
hetzner

[win_vms]
__EOF__

for host in `grep win inv_input` ; do echo ${host} ansible_host=`ssh ansible@gateway "sudo virsh domifaddr $host" | grep 192.168.122 | awk '{print $4}' | cut -d/ -f1` ; done >> inventory_hetzner/hosts
echo -e "\n[rhel_vms]" >> inventory_hetzner/hosts
grep rhel inv_input >> inventory_hetzner/hosts

echo -e "\n[network]" >> inventory_hetzner/hosts
echo "f5" >> inventory_hetzner/hosts

if [ "$1" == "--list" ] ; then

python inventory2json.py inventory_hetzner/hosts

elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
