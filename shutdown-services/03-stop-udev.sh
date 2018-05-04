if [ -z "$VIRTUALIZATION" ]; then
    status "Stopping udev..." udevadm control --exit
fi
