for i in $(openstack baremetal node list -f value -c UUID) ; do
  echo openstack baremetal node maintenance set $i
  echo openstack baremetal node delete $i
done
