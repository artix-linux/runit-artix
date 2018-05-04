unset HOSTNAME

if [[ -s /etc/hostname ]]; then
	HOSTNAME=$(< /etc/hostname)
fi

if [[ $HOSTNAME ]]; then
	stat_busy "Setting hostname: $HOSTNAME"
	echo "$HOSTNAME" >| /proc/sys/kernel/hostname && stat_done || stat_fail
fi
