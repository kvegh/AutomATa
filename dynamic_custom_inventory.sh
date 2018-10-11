#!/bin/bash

ssh ansible@gateway "sudo virsh list --state-running --name" | grep -v ansible | grep -v ^$ > inv_input

cat <<__EOF__ > inventory
[barelaptop]
gateway

[win_vms]
__EOF__

for host in `grep win inv_input` ; do echo ${host} ansible_host=`ssh ansible@gateway "sudo virsh domifaddr $host" | grep 192.168.122 | awk '{print $4}' | cut -d/ -f1` ; done >> inventory
echo -e "\n[rhel_vms]" >> inventory 
grep rhel inv_input >> inventory 

echo -e "\n[network]" >> inventory
echo "f5" >> inventory 

if [ "$1" == "--list" ] ; then

python ../inventory2json.py inventory

elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
