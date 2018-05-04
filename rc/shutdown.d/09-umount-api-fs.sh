run_hook shutdown_preumount
status "Unmounting non-API filesystems" umount -r -a -t nosysfs,noproc,nodevtmpfs,notmpfs
run_hook shutdown_postumount
