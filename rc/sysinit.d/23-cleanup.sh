
install -m0664 -o root -g utmp /dev/null /run/utmp
if [ ! -e /var/log/wtmp ]; then
    install -m0664 -o root -g utmp /dev/null /var/log/wtmp
fi
if [ ! -e /var/log/btmp ]; then
    install -m0600 -o root -g utmp /dev/null /var/log/btmp
fi

# Remove leftover files
remove_leftover

rm -f /etc/nologin #/forcefsck /forcequotacheck /fastboot
