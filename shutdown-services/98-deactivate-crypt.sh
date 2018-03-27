if [ -z "$VIRTUALIZATION" ]; then
    deactivate_vgs
    deactivate_crypt
    if [ -e /run/runit/reboot ] && command -v kexec >/dev/null; then
        msg "Triggering kexec..."
        kexec -e 2>/dev/null
        # not reached when kexec was successful.
    fi
fi
