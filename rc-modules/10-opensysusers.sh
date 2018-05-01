msg "Setting up sysusers.d entries..."
if [ -x /usr/bin/sysusers ]; then
    sysusers
fi
