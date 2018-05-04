run_hook sysinit_prefsck
if [[ -x $(type -P fsck) ]]; then
	stat_busy "Checking filesystems"
		fsck_all >|"${FSCK_OUT:-/dev/stdout}" 2>|"${FSCK_ERR:-/dev/stdout}"
	declare -r fsckret=$?
	(( fsckret <= 1 )) && stat_done || stat_fail
else
	declare -r fsckret=0
fi
# Single-user login and/or automatic reboot if needed
run_hook sysinit_postfsck

fsck_reboot $fsckret
