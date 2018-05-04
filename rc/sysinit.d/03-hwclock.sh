HWCLOCK_PARAMS="--systz"

if [[ $HARDWARECLOCK ]]; then

	[[ -f /etc/adjtime ]] && { read ; read ; read ADJTIME; } < /etc/adjtime

	if [[ $ADJTIME == 'LOCAL' ]]; then
		if	[[ $HARDWARECLOCK == 'UTC' ]]; then
			printf "${C_FAIL}@RCDIR@/rc.conf says the RTC is in UTC, but /etc/adjtime says it is in localtime.\n${C_OTHER}."
		fi
	else
		if [[ $HARDWARECLOCK == 'LOCALTIME' ]]; then
			printf "${C_FAIL}@RCDIR@/rc.conf says the RTC is in localtime, but hwclock (/etc/adjtime) thinks it is in UTC.\n${C_OTHER}."
		fi
	fi

	case $HARDWARECLOCK in
		UTC) HWCLOCK_PARAMS+=" --utc --noadjfile";;
		localtime) HWCLOCK_PARAMS+=" --localtime --noadjfile";;
		*) HWCLOCK_PARAMS="";;
	esac
fi

if [[ $HWCLOCK_PARAMS ]]; then
	stat_busy "Adjusting system time and setting kernel time zone"

	# Adjust the system time for time zone offset if rtc is not in UTC, as
	# filesystem checks can depend on system time. This also sets the kernel
	# time zone, used by e.g. vfat.

	hwclock $HWCLOCK_PARAMS && stat_done || stat_fail

	unset TZ
fi
