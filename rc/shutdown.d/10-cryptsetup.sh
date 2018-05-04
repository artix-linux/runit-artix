# Kill non-root encrypted partition mappings
if [[ -f /etc/crypttab ]] && type -p cryptsetup >/dev/null; then
	# Maybe someone has LVM on an encrypted block device
	# executing an extra vgchange is errorless
	[[ $USELVM = [Yy][Ee][Ss] ]] && vgchange --sysinit -a n &>/dev/null
	read_crypttab do_lock
fi
