# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

status "Remounting rootfs read-only..." mount -o remount,ro / || emergency_shell

if [ -x /sbin/dmraid -o -x /bin/dmraid ]; then
    status "Activating dmraid devices..." dmraid -i -ay
fi

if [ -x /bin/btrfs ]; then
    status "Activating btrfs devices..." btrfs device scan || emergency_shell
fi

if [ -x /sbin/vgchange -o -x /bin/vgchange ]; then
    status "Activating LVM devices..." vgchange --sysinit -a y || emergency_shell
fi

if [ -e /etc/crypttab ]; then
    status "Activating encrypted devices..." awk -f /etc/runit/crypt.awk /etc/crypttab

    if [ -x /sbin/vgchange -o -x /bin/vgchange ]; then
        status "Activating LVM devices for dm-crypt..." vgchange --sysinit -a y
    fi
fi

if [ -e /etc/zfs/zpool.cache -a -x /usr/bin/zfs ]; then
    status "Activating ZFS devices..." zpool import -c /etc/zfs/zpool.cache -N -a

    status "Mounting ZFS file systems..." zfs mount -a

    status "Sharing ZFS file systems..." zfs share -a

    # NOTE(dh): ZFS has ZVOLs, block devices on top of storage pools.
    # In theory, it would be possible to use these as devices in
    # dmraid, btrfs, LVM and so on. In practice it's unlikely that
    # anybody is doing that, so we aren't supporting it for now.
fi

[ -f /fastboot ] && FASTBOOT=1
[ -f /forcefsck ] && FORCEFSCK="-f"
for arg in $(cat /proc/cmdline); do
    case $arg in
        fastboot) FASTBOOT=1;;
        forcefsck) FORCEFSCK="-f";;
    esac
done

if [ -z "$FASTBOOT" ]; then
    stat_busy "Checking filesystems:"
    fsck -A -T -a -t noopts=_netdev $FORCEFSCK
    if [ $? -gt 1 ]; then
        stat_fail
        emergency_shell
    else
        stat_done
    fi
fi

status "Mounting rootfs read-write..." mount -o remount,rw / || emergency_shell

status "Mounting all non-network filesystems..." mount -a -t "nosysfs,nonfs,nonfs4,nosmbfs,nocifs" -O no_netdev || emergency_shell
