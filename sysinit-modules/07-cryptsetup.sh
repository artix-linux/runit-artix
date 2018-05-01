if [ -e /etc/crypttab ]; then
    msg "Activating encrypted devices..."
    awk -f /etc/runit/crypt.awk /etc/crypttab

    if [ -x /sbin/vgchange -o -x /bin/vgchange ]; then
        msg "Activating LVM devices for dm-crypt..."
        vgchange --sysinit -a y || emergency_shell
    fi
fi
