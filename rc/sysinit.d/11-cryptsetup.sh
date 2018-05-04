# Set up non-root encrypted partition mappings
if [[ -f /etc/crypttab ]] && type -p cryptsetup >/dev/null; then
	status "Activating encrypted devices" awk -f /etc/rc/crypt.awk /etc/crypttab
	# Maybe someone has LVM on an encrypted block device
	activate_vgs
fi
