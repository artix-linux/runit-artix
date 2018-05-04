# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

if [ -x /usr/bin/tmpfiles ]; then
    status "Setting up tmpfiles.d entries for /dev..." tmpfiles --prefix=/dev --create --boot
fi

status "Starting udev daemon" udevd --daemon

stat_busy "Triggering udev uevents"
    udevadm trigger --action=add --type=subsystems
    udevadm trigger --action=add --type=devices
stat_done

status "Waiting for udev uevents to be processed" udevadm settle
