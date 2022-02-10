#!/bin/bash
#set -x

export THT=/home/stack/base
export LOG=logs/deploy_$(date +%F_%s).log
export OUTPUT=logs/output_$(date +%F_%s).log
export NETBOT_SEND=./netbot-send.py
export STACKNAME=mauro

[ -w deploy_nr.txt ] && echo $(( $(cat deploy_nr.txt) + 1 )) > deploy_nr.txt || echo 1 > deploy_nr.txt
export DEPLOY_NR=$(cat deploy_nr.txt)


echodo () {

   echo "======================================================== " >> deploy_attempts.log
   echo "Deploy attempt #${DEPLOY_NR} $( date '+%F %T' ) " >> deploy_attempts.log
   echo "======================================================== " >> deploy_attempts.log
   echo "$*" >> deploy_attempts.log
   eval $*
   if [ $? -ne 0 ]; then
	echo "FAILURES:" >> deploy_attempts.log
	openstack stack failures list --long $STACKNAME >> deploy_attempts.log
        [[ -x $NETBOT_SEND ]] && $NETBOT_SEND "Deploy $DEPLOY_NR failed!"
   else
	echo "SUCCESFUL!" >> deploy_attempts.log
        [[ -x $NETBOT_SEND ]] && $NETBOT_SEND "Deploy $DEPLOY_NR succeeded!"

   fi
   echo "======================================================== " >> deploy_attempts.log
}

touch $LOG
rm last.log
ln -s $LOG last.log

source ~/stackrc
cd ~/

echodo time openstack overcloud deploy --templates --stack $STACKNAME \
     -n templates/network_data.yaml \
     -r templates/roles_data.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-mds.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-rgw.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/manila-cephfsganesha-config.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-dashboard.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/network-environment.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovs.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/services/barbican.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/barbican-backend-simple-crypto.yaml \
     -e /usr/share/openstack-tripleo-heat-templates/environments/services/octavia.yaml \
     -e templates/node-info.yaml \
     -e templates/inject-trust-anchor-hiera.yaml \
     -e templates/network-environment.yaml \
     -e templates/storage-environment.yaml \
     -e templates/ceph-config.yaml \
     -e templates/common.yaml \
     -e templates/hostnames.yaml \
     -e templates/predictable-ips.yaml \
     -e templates/security.yaml \
     -e templates/extras.yaml \
     -e templates/rhsm.yaml \
     -e templates/barbican.yaml \
     -e templates/octavia.yaml \
     -e templates/fencing.yaml \
     -e templates/dra.yaml \
     -e templates/containers-prepare-parameter.yaml \
     --log-file $LOG \
     --validation-errors-nonfatal \
     --ntp-server 10.10.0.10 | tee -a last-output.log


