if [ -z "$VIRTUALIZATION" ] && [ -n "$HARDWARECLOCK" ]; then
    status "Saving hardware clock..." hwclock --systohc ${HARDWARECLOCK:+--$(echo $HARDWARECLOCK |tr A-Z a-z)}
fi

halt -w # for utmp
