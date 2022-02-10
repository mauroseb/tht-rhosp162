export DIB_LOCAL_IMAGE=./rhel-8.4-x86_64-kvm.qcow2
export REG_METHOD=portal
export REG_USER={{ rhn-user }}
export REG_PASSWORD={{ rhn-pass }}
export REG_POOL_ID={{ rhn-pool }}
export REG_RELEASE="8.4"
export REG_REPOS="rhel-8-for-x86_64-baseos-eus-rpms rhel-8-for-x86_64-appstream-eus-rpms rhel-8-for-x86_64-highavailability-eus-rpms ansible-2.9-for-rhel-8-x86_64-rpms fast-datapath-for-rhel-8-x86_64-rpms openstack-16.1-for-rhel-8-x86_64-rpms"
export DIB_BLOCK_DEVICE_CONFIG='''
- local_loop:
    name: image0
- partitioning:
    base: image0
    label: mbr
    partitions:
      - name: root
        flags: [ boot,primary ]
        size: 35G
- mkfs:
    name: fs_root
    base: root
    type: xfs
    label: "img-rootfs"
    mount:
        mount_point: /
        fstab:
            options: "rw,relatime"
            fsck-passno: 1
'''
