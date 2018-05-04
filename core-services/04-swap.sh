# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

status "Initializing swap..." swapon -a || emergency_shell
