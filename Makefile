SYSCONFDIR = /etc
PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
LIBDIR = $(PREFIX)/lib
RCLIBDIR = $(LIBDIR)/rc

########### runit ###########

RCDIR = $(SYSCONFDIR)/rc
RUNITDIR = $(SYSCONFDIR)/runit
SVDIR = $(RUNITDIR)/sv
RUNSVDIR = $(RUNITDIR)/runsvdir
SERVICEDIR = /etc/service
RUNDIR = /run/runit
TMPFILESDIR = $(LIBDIR)/tmpfiles.d


TMPFILES = misc/tmpfile.conf

BIN = script/zzz src/pause

STAGES = \
	script/1 \
	script/2 \
	script/3 \
	script/ctrlaltdel

RCLOCAL = script/rc.local script/rc.shutdown

AGETTY_CONSOLE = $(wildcard sv/agetty-console/*)
AGETTY_CONSOLE_S = supervise.agetty-console

AGETTY_GENERIC = $(wildcard sv/agetty-generic/*)

AGETTY_SERIAL = $(wildcard sv/agetty-serial/*)

AGETTY_TTY1 = $(wildcard sv/agetty-tty1/*)
AGETTY_TTY1_S = supervise.agetty-tty1

AGETTY_TTY2 = $(wildcard sv/agetty-tty2/*)
AGETTY_TTY2_S = supervise.agetty-tty2

AGETTY_TTY3 = $(wildcard sv/agetty-tty3/*)
AGETTY_TTY3_S = supervise.agetty-tty3

AGETTY_TTY4 = $(wildcard sv/agetty-tty4/*)
AGETTY_TTY4_S = supervise.agetty-tty4

AGETTY_TTY5 = $(wildcard sv/agetty-tty5/*)
AGETTY_TTY5_S = supervise.agetty-tty5

AGETTY_TTY6 = $(wildcard sv/agetty-tty6/*)
AGETTY_TTY6_S = supervise.agetty-tty6

AGETTY_TTYAMA0 = $(wildcard sv/agetty-ttyAMA0/*)
AGETTY_TTYAMA0_S = supervise.agetty-ttyAMA0

AGETTY_TTYS0 = $(wildcard sv/agetty-ttyS0/*)
AGETTY_TTYS0_S = supervise.agetty-ttyS0

AGETTY_TTYUSB0 = $(wildcard sv/agetty-ttyUSB0/*)
AGETTY_TTYUSB0_S = supervise.agetty-ttyUSB0

AGETTY_SULOGIN = $(wildcard sv/sulogin/*)
AGETTY_SULOGIN_S = supervise.sulogin

AGETTY_SYMS = \
	agetty-tty1 \
	agetty-tty2 \
	agetty-tty3 \
	agetty-tty4 \
	agetty-tty5 \
	agetty-tty6

SULOGIN_SYM = sulogin

########### end ###########

LN = ln -sf
CP = cp -R --no-dereference --preserve=mode,links -v
RM = rm -f
RMD = rm -fr --one-file-system
M4 = m4 -P
CHMODAW = chmod a-w
CHMODX = chmod +x

EDIT = sed \
	-e "s|@RCDIR[@]|$(RCDIR)|g" \
	-e "s|@RUNITDIR[@]|$(RUNITDIR)|g" \
	-e "s|@SERVICEDIR[@]|$(SERVICEDIR)|g" \
	-e "s|@RUNSVDIR[@]|$(RUNSVDIR)|g" \
	-e "s|@RUNDIR[@]|$(RUNDIR)|g" \
	-e "s|@SYSCONFDIR[@]|$(SYSCONFDIR)|g" \
	-e "s|@RCLIBDIR[@]|$(RCLIBDIR)|g"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@$(M4) $@.in | $(EDIT) >$@
	@$(CHMODAW) "$@"
	@$(CHMODX) "$@"

all: all-runit

all-runit: $(STAGES) $(RCLOCAL)
		$(CC) $(CFLAGS) src/pause.c -o src/pause $(LDFLAGS)

install-runit:
	install -d $(DESTDIR)$(RUNITDIR)
	install -m755 $(STAGES) $(DESTDIR)$(RUNITDIR)

	install -d $(DESTDIR)$(RUNSVDIR)/single

	install -d $(DESTDIR)$(RUNSVDIR)/default
	$(LN) default $(DESTDIR)$(RUNSVDIR)/current

	$(LN) $(RUNDIR)/reboot $(DESTDIR)$(RUNITDIR)/
	$(LN) $(RUNDIR)/stopit $(DESTDIR)$(RUNITDIR)/

	install -d $(DESTDIR)$(RCDIR)
	install -m755 $(RCLOCAL) $(DESTDIR)$(RCDIR)

	install -d $(DESTDIR)$(BINDIR)
	install -m755 $(BIN) $(DESTDIR)$(BINDIR)

	install -d $(DESTDIR)$(TMPFILESDIR)
	install -m755 $(TMPFILES) $(DESTDIR)$(TMPFILESDIR)/runit.conf

	install -d $(DESTDIR)$(SVDIR)/agetty-console
	install -Dm755 $(AGETTY_CONSOLE) $(DESTDIR)$(SVDIR)/agetty-console
	$(LN) $(RUNDIR)/$(AGETTY_CONSOLE_S) $(DESTDIR)$(SVDIR)/agetty-console/supervise

	install -d $(DESTDIR)$(SVDIR)/agetty-generic
	install -Dm755 $(AGETTY_GENERIC) $(DESTDIR)$(SVDIR)/agetty-generic

	install -d $(DESTDIR)$(SVDIR)/agetty-serial
	install -Dm755 $(AGETTY_SERIAL) $(DESTDIR)$(SVDIR)/agetty-serial

	install -d $(DESTDIR)$(SVDIR)/agetty-tty1
	install -Dm755 $(AGETTY_TTY1) $(DESTDIR)$(SVDIR)/agetty-tty1
	$(LN) $(RUNDIR)/$(AGETTY_TTY1_S) $(DESTDIR)$(SVDIR)/agetty-tty1/supervise
#
	install -d $(DESTDIR)$(SVDIR)/agetty-tty2
	install -Dm755 $(AGETTY_TTY2) $(DESTDIR)$(SVDIR)/agetty-tty2
	$(LN) $(RUNDIR)/$(AGETTY_TTY2_S) $(DESTDIR)$(SVDIR)/agetty-tty2/supervise

	install -d $(DESTDIR)$(SVDIR)/agetty-tty3
	install -Dm755 $(AGETTY_TTY3) $(DESTDIR)$(SVDIR)/agetty-tty3
	$(LN) $(RUNDIR)/$(AGETTY_TTY3_S) $(DESTDIR)$(SVDIR)/agetty-tty3/supervise

	install -d $(DESTDIR)$(SVDIR)/agetty-tty4
	install -Dm755 $(AGETTY_TTY4) $(DESTDIR)$(SVDIR)/agetty-tty4
	$(LN) $(RUNDIR)/$(AGETTY_TTY4_S)  $(DESTDIR)$(SVDIR)/agetty-tty4/supervise

	install -d $(DESTDIR)$(SVDIR)/agetty-tty5
	install -Dm755 $(AGETTY_TTY5) $(DESTDIR)$(SVDIR)/agetty-tty5
	$(LN) $(RUNDIR)/$(AGETTY_TTY5_S) $(DESTDIR)$(SVDIR)/agetty-tty5/supervise

	install -d $(DESTDIR)$(SVDIR)/agetty-tty6
	install -Dm755 $(AGETTY_TTY6) $(DESTDIR)$(SVDIR)/agetty-tty6
	$(LN) $(RUNDIR)/$(AGETTY_TTY6_S) $(DESTDIR)$(SVDIR)/agetty-tty6/supervise

	install -d $(DESTDIR)$(SVDIR)/agetty-ttyAMA0
	install -Dm755 $(AGETTY_TTYAMA0) $(DESTDIR)$(SVDIR)/agetty-ttyAMA0
	$(LN) $(RUNDIR)/$(AGETTY_TTYAMA0_S) $(DESTDIR)$(SVDIR)/agetty-ttyAMA0/supervise

	install -d $(DESTDIR)$(SVDIR)/agetty-ttyS0
	install -Dm755 $(AGETTY_TTYS0) $(DESTDIR)$(SVDIR)/agetty-ttyS0
	$(LN) $(RUNDIR)/$(AGETTY_TTYS0_S) $(DESTDIR)$(SVDIR)/agetty-ttyS0/supervise

	install -d $(DESTDIR)$(SVDIR)/agetty-ttyUSB0
	install -Dm755 $(AGETTY_TTYUSB0) $(DESTDIR)$(SVDIR)/agetty-ttyUSB0
	$(LN) $(RUNDIR)/$(AGETTY_TTYUSB0_S) $(DESTDIR)$(SVDIR)/agetty-ttyUSB0/supervise

	install -d $(DESTDIR)$(SVDIR)/sulogin
	install -Dm755 $(AGETTY_SULOGIN) $(DESTDIR)$(SVDIR)/sulogin
	$(LN) $(RUNDIR)/$(AGETTY_SULOGIN_S) $(DESTDIR)$(SVDIR)/sulogin/supervise

	for g in $(AGETTY_SYMS); do $(LN) $(SVDIR)/$$g $(DESTDIR)$(RUNSVDIR)/default/$$g; done
	for g in $(SULOGIN_SYM); do $(LN) $(SVDIR)/$$g $(DESTDIR)$(RUNSVDIR)/single/$$g; done

	install -d $(DESTDIR)$(MANDIR)/man1
	install -m644 man/pause.1 $(DESTDIR)$(MANDIR)/man1
	install -d $(DESTDIR)$(MANDIR)/man8
	install -m644 man/zzz.8 $(DESTDIR)$(MANDIR)/man8/zzz.8

install: install-runit

clean-runit:
	-$(RM) src/pause $(STAGES) $(RCLOCAL)

clean: clean-runit

.PHONY: all install clean install-runit clean-runit
