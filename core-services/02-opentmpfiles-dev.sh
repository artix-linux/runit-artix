if [ -x /usr/bin/tmpfiles ]; then
#     sv check udev >/dev/null || exit 1
    msg "Setting up tmpfiles.d entries for /dev..."
    tmpfiles --prefix=/dev --create --boot
fi
