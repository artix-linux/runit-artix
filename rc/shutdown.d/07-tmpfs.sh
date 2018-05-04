# unmount any non-API partitions that are backed by swap; we don't want to
# move their contents into memory (waste of time and might caues OOM).
status "Unmounting swap-backed filesystems" umount_all "tmpfs"
