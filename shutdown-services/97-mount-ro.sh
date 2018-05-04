if [ -z "$VIRTUALIZATION" ]; then
    stat_busy "Unmounting filesystems, disabling swap..."
    swapoff -a
    umount -r -a -t nosysfs,noproc,nodevtmpfs,notmpfs
    stat_done
    stat_busy "Remounting rootfs read-only..."
    mount -o remount,ro /
    stat_done
fi
sync
