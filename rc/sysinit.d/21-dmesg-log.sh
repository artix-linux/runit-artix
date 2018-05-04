stat_busy "Saving dmesg log"
	if [[ -e /proc/sys/kernel/dmesg_restrict ]] &&
		(( $(< /proc/sys/kernel/dmesg_restrict) == 1 )); then
		install -Tm 0600 <( dmesg ) /var/log/dmesg.log
	else
		install -Tm 0644 <( dmesg ) /var/log/dmesg.log
	fi
(( $? == 0 )) && stat_done || stat_fail
