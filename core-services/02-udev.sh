# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

if [ -x /usr/lib/systemd/systemd-udevd ]; then
    _udevd=/usr/lib/systemd/systemd-udevd
elif [ -x /sbin/udevd -o -x /bin/udevd ]; then
    _udevd=udevd
else
    msg_warn "cannot find udevd!"
fi

if [ -x /usr/bin/tmpfiles ]; then
    msg "Setting up tmpfiles.d entries for /dev..."
    tmpfiles --prefix=/dev --create --boot
fi

if [ -n "${_udevd}" ]; then
    msg "Starting udev and waiting for devices to settle..."
    ${_udevd} --daemon
    udevadm trigger --action=add --type=subsystems
    udevadm trigger --action=add --type=devices
    udevadm settle
fi
