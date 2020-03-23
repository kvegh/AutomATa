#!/bin/bash

if [ "`whoami`" == "awx" ] 
then 
  mkdir ~/.ssh 
  chmod 700 ~/.ssh
  ssh-keyscan gateway > ~/.ssh/known_hosts
  ssh-keyscan 192.168.122.1 >> ~/.ssh/known_hosts
fi
#   ssh -i /opt/data/skeys/`whoami`/cred1 ansible@gateway "sudo virsh list --name --all" | grep -v ansible | grep -v win2k16r2 | grep -v image | grep -v img | grep -v ^$ > inv_input
  ssh ansible@gateway "sudo virsh list --name --all" | grep -v ansible | grep -v win2k16r2 | grep -v image | grep -v img | grep -v ^$ > inv_input

cat <<__EOF__ > inventory/hosts
[baremetal]
gateway
hetzner

[win_vms]
__EOF__

if [ "`whoami`" == "awx" ] 
then 
	for host in `grep win inv_input` ; do echo ${host} ansible_host=`ssh -i /opt/data/skeys/$(whoami)/cred1 ansible@gateway "sudo virsh domifaddr $host" | grep 192.168.122 | awk '{print $4}' | cut -d/ -f1` ; done >> inventory/hosts
else
  for host in `grep win inv_input` ; do echo ${host} ansible_host=`ssh ansible@gateway "sudo virsh domifaddr $host" | grep 192.168.122 | awk '{print $4}' | cut -d/ -f1` ; done >> inventory/hosts
fi
echo -e "\n[rhel_vms]" >> inventory/hosts
grep rhel\- inv_input | grep -v beta | grep -v rhel-ceph >> inventory/hosts

echo -e "\n[network]" >> inventory/hosts
echo "f5" >> inventory/hosts

echo -e "\n[ceph]" >> inventory/hosts
grep ceph inv_input >> inventory/hosts

if [ "$1" == "--list" ] ; then

python3 inventory2json.py inventory/hosts

elif [ "$1" == "--host" ]; then
  echo '{"_meta": {"hostvars": {}}}'
else
  echo "{ }"
fi
