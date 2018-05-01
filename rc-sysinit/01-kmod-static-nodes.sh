# Some kernel modules must be loaded before starting udev(7).
# Load them by looking at the output of `kmod static-nodes`.

for f in $(kmod static-nodes 2>/dev/null|awk '/Module/ {print $2}'); do
	modprobe -bq $f 2>/dev/null
done

[ -n "$VIRTUALIZATION" ] && return 0

# Do not try to load modules if kernel does not support them.
[ ! -e /proc/modules ] && return 0

msg "Loading kernel modules..."
modules-load -v | tr '\n' ' ' | sed 's:insmod [^ ]*/::g; s:\.ko\(\.gz\)\? ::g'
echo

msg "Creating list of required static device nodes..."
[[ -d /run/tmpfiles.d ]] || mkdir /run/tmpfiles.d
kmod static-nodes --format=tmpfiles --output=/run/tmpfiles.d/kmod.conf
echo
