#!/bin/bash

if [ "`whoami`" == "awx" ] 
then 
  mkdir ~/.ssh 
  chmod 700 ~/.ssh
  ssh-keyscan gateway > ~/.ssh/known_hosts 2>/dev/null
  ssh-keyscan 192.168.122.1 >> ~/.ssh/known_hosts 2>/dev/null
fi
  ssh -i /opt/data/skeys/`whoami`/cred1 ansible@gateway "sudo virsh list --name --all" | grep -v ansible | grep -v win2k16r2 | grep -v image | grep -v img | grep -v ^$ > inv_input

cat <<__EOF__ > inventory/hosts
[baremetal]
gateway
hetzner

[win_vms]
__EOF__

	for host in `grep win inv_input` ; do echo ${host} ansible_host=`ssh -i /opt/data/skeys/$(whoami)/cred1 ansible@gateway "sudo virsh domifaddr $host" | grep 192.168.122 | awk '{print $4}' | cut -d/ -f1` ; done >> inventory/hosts

echo -e "\n[rhel_vms]" >> inventory/hosts
grep rhel\- inv_input | grep -v beta | grep -v rhel-ceph | grep -v instest >> inventory/hosts

echo -e "\n[network]" >> inventory/hosts
echo "f5" >> inventory/hosts

echo -e "\n[ceph]" >> inventory/hosts
grep ceph inv_input >> inventory/hosts

echo -e "\n[insights_vms]" >> inventory/hosts
grep instest inv_input >> inventory/hosts

echo -e "\n[infrastructure]" >> inventory/hosts
grep netapp inv_input >> inventory/hosts
echo rhnetappcluster >> inventory/hosts
echo rhnetappcluster2 >> inventory/hosts
grep sat inv_input >> inventory/hosts
grep ansible inv_input >> inventory/hosts

sed -i -e '/^rhel/ s/$/.kveghdemo.at/g' inventory/hosts 

if [ "$1" == "--list" ] ; then

python3 inventory2json.py inventory/hosts

elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
