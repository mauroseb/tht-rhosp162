for i in $( openstack baremetal node list -c Name -f value); do

  echo $i:
  openstack baremetal node show -f value -c properties $i

done
