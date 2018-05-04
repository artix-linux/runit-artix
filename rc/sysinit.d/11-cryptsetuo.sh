# Set up non-root encrypted partition mappings
if [[ -f /etc/crypttab ]] && type -p cryptsetup >/dev/null; then
	read_crypttab do_unlock
	# Maybe someone has LVM on an encrypted block device
	activate_vgs
fi
