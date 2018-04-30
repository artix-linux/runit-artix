if [ -e /etc/zfs/zpool.cache -a -x /usr/bin/zfs ]; then
    msg "Activating ZFS devices..."
    zpool import -c /etc/zfs/zpool.cache -N -a

    msg "Mounting ZFS file systems..."
    zfs mount -a

    msg "Sharing ZFS file systems..."
    zfs share -a

    # NOTE(dh): ZFS has ZVOLs, block devices on top of storage pools.
    # In theory, it would be possible to use these as devices in
    # dmraid, btrfs, LVM and so on. In practice it's unlikely that
    # anybody is doing that, so we aren't supporting it for now.
fi
