for i in $( openstack baremetal node list -c Name -f value); do
  right_name=`echo $i | sed -e 's/overcloud_\([a-z]*\)\([0-9]\)/mauro-\1-\2/'`
  echo openstack baremetal node set --property capabilities='profile:baremetal,boot_option:local,node:'${right_name}',cpu_vt:true,cpu_aes:true,cpu_hugepages:true,cpu_hugepages_1g:true' $i

done
# Setting iSCSI for Ceph nodes due to not having enough memory for direct mode copy
openstack baremetal node set --deploy-interface iscsi overcloud_ceph3
openstack baremetal node set --deploy-interface iscsi overcloud_ceph2
openstack baremetal node set --deploy-interface iscsi overcloud_ceph1

# Soft RAID steps
openstack baremetal node set --raid-interface agent overcloud_compute1
openstack baremetal node set --target-raid-config '{"logical_disks": [{"raid_level":"1","size_gb":"MAX","controller":"software","is_root_volume":true,"physical_disks":[ "/dev/vda", "/dev/vdb"]}]}' overcloud_compute1
#openstack baremetal node set --property root_device='{"name": "/dev/md127"}' overcloud_compute1

# Set root disk for Ceph OSD Nodes
for i in $( openstack baremetal node list -c Name -f value | grep ceph); do
  openstack baremetal node set --property root_device='{"name": "/dev/vda"}' $i
done
