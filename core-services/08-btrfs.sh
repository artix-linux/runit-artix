if [ -x /bin/btrfs ]; then
    msg "Activating btrfs devices..."
    btrfs device scan || emergency_shell
fi
