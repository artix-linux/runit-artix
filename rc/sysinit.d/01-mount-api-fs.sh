# mount the API filesystems
# /proc, /sys, /run, /dev, /run/lock, /dev/pts, /dev/shm
mountpoint -q /proc    || mount -t proc proc /proc -o nosuid,noexec,nodev
mountpoint -q /sys     || mount -t sysfs sys /sys -o nosuid,noexec,nodev
mountpoint -q /run     || mount -t tmpfs run /run -o mode=0755,nosuid,nodev
mountpoint -q /dev     || mount -t devtmpfs dev /dev -o mode=0755,nosuid
mkdir -p /dev/{pts,shm}
mountpoint -q /dev/pts || mount -t devpts devpts /dev/pts -o mode=0620,gid=5,nosuid,noexec
mountpoint -q /dev/shm || mount -t tmpfs shm /dev/shm -o mode=1777,nosuid,nodev
mountpoint -q /sys/kernel/security || mount -n -t securityfs securityfs /sys/kernel/security
mountpoint -q /sys/firmware/efi/efivars || mount -n -t efivarfs -o ro efivarfs /sys/firmware/efi/efivars
mountpoint -q /sys/fs/cgroup || mount -o mode=0755 -t tmpfs cgroup /sys/fs/cgroup
mountpoint -q /sys/fs/cgroup/openrc || mkdir -p /sys/fs/cgroup/openrc && mount -t cgroup -o none,name=openrc cgroup /sys/fs/cgroup/openrc
awk '$4 == 1 { system("mountpoint -q /sys/fs/cgroup/" $1 " || { mkdir -p /sys/fs/cgroup/" $1 " && mount -t cgroup -o " $1 " cgroup /sys/fs/cgroup/" $1 " ;}" ) }' /proc/cgroups

findmnt / --options ro &>/dev/null || status "Mounting root read-only" mount -o remount,ro /
