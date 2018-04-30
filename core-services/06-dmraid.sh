if [ -x /sbin/dmraid -o -x /bin/dmraid ]; then
    msg "Activating dmraid devices..."
    dmraid -i -ay
fi
