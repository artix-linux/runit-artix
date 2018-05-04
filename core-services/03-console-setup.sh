# vim: set ts=4 sw=4 et:

[ -n "$VIRTUALIZATION" ] && return 0

TTYS=${TTYS:-12}
if [ -n "$FONT" ]; then
    _index=0
    stat_busy "Configuring virtual console"
    while [ ${_index} -le $TTYS ]; do
        setfont ${FONT_MAP:+-m $FONT_MAP} ${FONT_UNIMAP:+-u $FONT_UNIMAP} \
                $FONT -C "/dev/tty${_index}"
        _index=$((_index + 1))
    done
    stat_done
fi

if [ -n "$KEYMAP" ]; then
    status "Setting up keymap to '${KEYMAP}'" loadkeys -q -u ${KEYMAP}
fi

if [ -n "$HARDWARECLOCK" ]; then
    stat_busy "Setting up RTC to '${HARDWARECLOCK}'"
        TZ=$TIMEZONE hwclock --systz \
            ${HARDWARECLOCK:+--$(echo $HARDWARECLOCK |tr A-Z a-z) --noadjfile} && stat_done || stat_fail && emergency_shell
fi
