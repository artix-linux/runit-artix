run_hook sysinit_premount
status "Mounting local filesystems" \
	mount_all
run_hook sysinit_postmount
