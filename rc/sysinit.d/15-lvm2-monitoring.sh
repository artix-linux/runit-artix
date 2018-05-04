# Enable monitoring of LVM2 groups, now that the filesystems are mounted rw
[[ $USELVM = [Yy][Ee][Ss] && -x $(type -P lvm) && -d /sys/block ]] &&
	status "Activating monitoring of LVM2 groups" \
		vgchange --monitor y >/dev/null
