# bring up the loopback interface
[[ -d /sys/class/net/lo ]] && status "Bringing up loopback interface" ip link set up dev lo
