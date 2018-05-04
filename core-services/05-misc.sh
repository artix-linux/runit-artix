# vim: set ts=4 sw=4 et:

stat_busy "Initializing random seed..."
cp /var/lib/random-seed /dev/urandom >/dev/null 2>&1 || true
( umask 077; bytes=$(cat /proc/sys/kernel/random/poolsize) || bytes=512; dd if=/dev/urandom of=/var/lib/random-seed count=1 bs=$bytes >/dev/null 2>&1 )
stat_done

status "Setting up loopback interface..." ip link set up dev lo

[ -r /etc/hostname ] && read -r HOSTNAME < /etc/hostname
if [ -n "$HOSTNAME" ]; then
    stat_busy "Setting up hostname to '${HOSTNAME}'..."
    printf "%s" "$HOSTNAME" > /proc/sys/kernel/hostname
    stat_done
else
    printf "Didn't setup a hostname!\n"
fi

if [ -n "$TIMEZONE" ]; then
    status "Setting up timezone to '${TIMEZONE}'..."
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
fi

if [ -x /usr/bin/sysusers ]; then
    status "Setting up sysusers.d entries..." sysusers
fi

if [ -x /usr/bin/tmpfiles ]; then
    status "Setting up tmpfiles.d entries..." tmpfiles --exclude-prefix=/dev --create --remove --boot
fi
