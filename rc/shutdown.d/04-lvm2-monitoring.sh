# stop monitoring of LVM2 groups before unmounting filesystems
[[ $USELVM = [Yy][Ee][Ss] && -x $(type -P lvm) ]] &&
	status "Deactivating monitoring of LVM2 groups" vgchange --monitor n
