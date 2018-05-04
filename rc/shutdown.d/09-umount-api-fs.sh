run_hook shutdown_preumount
status "Unmounting non-API filesystems" umount_all
run_hook shutdown_postumount
