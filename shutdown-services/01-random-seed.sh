stat_busy "Saving random seed..."
    ( umask 077; bytes=$(cat /proc/sys/kernel/random/poolsize) || bytes=512; dd if=/dev/urandom of=/var/lib/random-seed count=1 bs=$bytes >/dev/null 2>&1 )
stat_done
