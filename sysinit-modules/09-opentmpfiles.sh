msg "Setting up tmpfiles.d entries..."
if [ -x /usr/bin/tmpfiles ]; then
    tmpfiles --exclude-prefix=/dev --create --remove --boot
fi
