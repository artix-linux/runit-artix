if [ -x /sbin/lvmetad -o -x /bin/lvmetad ]; then
    msg "Activating lvmetad..."
    lvmetad -p /run/lvmetad.pid || emergency_shell
fi

if [ -x /sbin/vgchange -o -x /bin/vgchange ]; then
    msg "Activating LVM devices..."
    vgchange --sysinit -a y || emergency_shell
fi
