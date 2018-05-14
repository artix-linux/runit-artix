SYSCONFDIR = /etc
PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
LIBDIR = $(PREFIX)/lib
RCLIBDIR = $(LIBDIR)/rc
RCDIR = $(SYSCONFDIR)/rc

########### runit ###########

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

########### rc ###########

RCSVDIR = $(RCLIBDIR)/sv.d
RCRUNDIR = /run/sv.d

CONF = script/rc.conf

RCFUNC = script/functions script/cgroup-release-agent

RCBIN = \
	script/rc-sysinit \
	script/rc-shutdown \
	script/rc-sv \
	script/modules-load

RCSVD = \
	sv.d/root \
	sv.d/binfmt \
	sv.d/bootlogd \
	sv.d/cleanup \
	sv.d/console-setup \
	sv.d/dmesg \
	sv.d/hostname \
	sv.d/hwclock \
	sv.d/kmod-static-nodes \
	sv.d/misc \
	sv.d/mount-all \
	sv.d/net-lo \
	sv.d/netfs \
	sv.d/random-seed \
	sv.d/remount-root \
	sv.d/swap \
	sv.d/sysctl \
	sv.d/sysusers \
	sv.d/tmpfiles-dev \
	sv.d/tmpfiles-setup \
	sv.d/udev \
	sv.d/udev-trigger \
	sv.d/udev-settle \
	sv.d/modules \
	sv.d/sysfs \
	sv.d/devfs \
	sv.d/procfs \
	sv.d/cgroups

# SYSINIT = \
# 	01-sysfs \
# 	02-procfs \
# 	03-devfs \
# 	04-cgroups \
# 	05-root \
# 	10-hostname \
# 	15-hwclock \
# 	20-kmod-static-nodes \
# 	25-tmpfiles-dev \
# 	30-udev \
# 	31-udev-trigger \
# 	32-modules \
# 	33-udev-settle \
# 	40-console-setup \
# 	45-net-lo \
# 	50-misc \
# 	55-remount-root \
# 	60-mount-all \
# 	65-swap \
# 	70-random-seed \
# 	75-tmpfiles-setup \
# 	80-sysusers \
# 	85-dmesg \
# 	90-sysctl \
# 	95-binfmt \
# 	99-cleanup
#
# SHUTDOWN = \
# 	10-random-seed \
# 	20-cleanup \
# 	30-udev \
# 	40-misc \
# 	50-swap \
# 	60-root \
# 	70-remount-root

# 	sv.d/timezone \
# 	sv.d/lvm-monitoring \
# 	sv.d/lvm \
# 	sv.d/cryptsetup

########### end ###########

LN = ln -sf
CP = cp -R --no-dereference --preserve=mode,links -v
RM = rm -f
RMD = rm -fr --one-file-system
M4 = m4 -P
CHMODAW = chmod a-w
CHMODX = chmod +x

EDIT = sed \
	-e "s|@RUNITDIR[@]|$(RUNITDIR)|g" \
	-e "s|@SERVICEDIR[@]|$(SERVICEDIR)|g" \
	-e "s|@RUNSVDIR[@]|$(RUNSVDIR)|g" \
	-e "s|@RUNDIR[@]|$(RUNDIR)|g" \
	-e "s|@RCLIBDIR[@]|$(RCLIBDIR)|g" \
	-e "s|@RCDIR[@]|$(RCDIR)|g" \
	-e "s|@RCSVDIR[@]|$(RCSVDIR)|g" \
	-e "s|@RCRUNDIR[@]|$(RCRUNDIR)|g"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@$(M4) $@.in | $(EDIT) >$@
	@$(CHMODAW) "$@"
	@$(CHMODX) "$@"

all: all-runit all-rc

all-runit: $(STAGES)
		$(CC) $(CFLAGS) src/pause.c -o src/pause $(LDFLAGS)

all-rc: $(RCBIN) $(RCSVD) $(RCFUNC) $(CONF)

install-runit:
	install -d $(DESTDIR)$(RUNITDIR)
	install -m755 $(STAGES) $(DESTDIR)$(RUNITDIR)

	install -d $(DESTDIR)$(RUNSVDIR)/single

	install -d $(DESTDIR)$(RUNSVDIR)/default
	$(LN) default $(DESTDIR)$(RUNSVDIR)/current

	$(LN) $(RUNDIR)/reboot $(DESTDIR)$(RUNITDIR)/
	$(LN) $(RUNDIR)/stopit $(DESTDIR)$(RUNITDIR)/

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

install-rc:
	install -d $(DESTDIR)$(RCDIR)
	install -m755 $(CONF) $(DESTDIR)$(RCDIR)

	install -d $(DESTDIR)$(BINDIR)
	install -m755 $(RCBIN) $(DESTDIR)$(BINDIR)

	install -d $(DESTDIR)$(RCLIBDIR)
	install -m755 $(RCFUNC) $(DESTDIR)$(RCLIBDIR)

	install -d $(DESTDIR)$(RCSVDIR)
	install -m755 $(RCSVD) $(DESTDIR)$(RCSVDIR)

	install -d $(DESTDIR)$(RCDIR)/sysinit

	$(LN) $(RCSVDIR)/sysfs $(DESTDIR)$(RCDIR)/sysinit/01-sysfs
	$(LN) $(RCSVDIR)/procfs $(DESTDIR)$(RCDIR)/sysinit/02-procfs
	$(LN) $(RCSVDIR)/devfs $(DESTDIR)$(RCDIR)/sysinit/03-devfs
	$(LN) $(RCSVDIR)/cgroups $(DESTDIR)$(RCDIR)/sysinit/04-cgroups
	$(LN) $(RCSVDIR)/root $(DESTDIR)$(RCDIR)/sysinit/05-root
	$(LN) $(RCSVDIR)/hostname $(DESTDIR)$(RCDIR)/sysinit/10-hostname
	$(LN) $(RCSVDIR)/hwclock $(DESTDIR)$(RCDIR)/sysinit/15-hwclock
	$(LN) $(RCSVDIR)/kmod-static-nodes $(DESTDIR)$(RCDIR)/sysinit/20-kmod-static-nodes
	$(LN) $(RCSVDIR)/tmpfiles-dev $(DESTDIR)$(RCDIR)/sysinit/25-tmpfiles-dev
	$(LN) $(RCSVDIR)/udev $(DESTDIR)$(RCDIR)/sysinit/30-udev
	$(LN) $(RCSVDIR)/udev-trigger $(DESTDIR)$(RCDIR)/sysinit/31-udev-trigger
	$(LN) $(RCSVDIR)/modules $(DESTDIR)$(RCDIR)/sysinit/32-modules
	$(LN) $(RCSVDIR)/udev-settle $(DESTDIR)$(RCDIR)/sysinit/33-udev-settle
	$(LN) $(RCSVDIR)/console-setup $(DESTDIR)$(RCDIR)/sysinit/40-console-setup
	$(LN) $(RCSVDIR)/net-lo $(DESTDIR)$(RCDIR)/sysinit/45-net-lo
	$(LN) $(RCSVDIR)/misc $(DESTDIR)$(RCDIR)/sysinit/50-misc
	$(LN) $(RCSVDIR)/remount-root $(DESTDIR)$(RCDIR)/sysinit/55-remount-root
	$(LN) $(RCSVDIR)/mount-all $(DESTDIR)$(RCDIR)/sysinit/60-mount-all
	$(LN) $(RCSVDIR)/swap $(DESTDIR)$(RCDIR)/sysinit/65-swap
	$(LN) $(RCSVDIR)/random-seed $(DESTDIR)$(RCDIR)/sysinit/70-random-seed
	$(LN) $(RCSVDIR)/tmpfiles-setup $(DESTDIR)$(RCDIR)/sysinit/75-tmpfiles-setup
	$(LN) $(RCSVDIR)/sysusers $(DESTDIR)$(RCDIR)/sysinit/80-sysusers
	$(LN) $(RCSVDIR)/dmesg $(DESTDIR)$(RCDIR)/sysinit/85-dmesg
	$(LN) $(RCSVDIR)/sysctl $(DESTDIR)$(RCDIR)/sysinit/90-sysctl
	$(LN) $(RCSVDIR)/binfmt $(DESTDIR)$(RCDIR)/sysinit/95-binfmt
	$(LN) $(RCSVDIR)/cleanup $(DESTDIR)$(RCDIR)/sysinit/99-cleanup

	install -d $(DESTDIR)$(RCDIR)/shutdown

	$(LN) $(RCSVDIR)/random-seed $(DESTDIR)$(RCDIR)/shutdown/10-random-seed
	$(LN) $(RCSVDIR)/cleanup $(DESTDIR)$(RCDIR)/shutdown/20-cleanup
	$(LN) $(RCSVDIR)/udev $(DESTDIR)$(RCDIR)/shutdown/30-udev
	$(LN) $(RCSVDIR)/misc $(DESTDIR)$(RCDIR)/shutdown/40-misc
	$(LN) $(RCSVDIR)/swap $(DESTDIR)$(RCDIR)/shutdown/50-swap
	$(LN) $(RCSVDIR)/root $(DESTDIR)$(RCDIR)/shutdown/60-root
	$(LN) $(RCSVDIR)/remount-root $(DESTDIR)$(RCDIR)/shutdown/70-remount-root

	install -d $(DESTDIR)$(MANDIR)/man8
	install -m644 man/modules-load.8 $(DESTDIR)$(MANDIR)/man8

install: install-runit install-rc

clean-runit:
	-$(RM) src/pause $(STAGES)

clean-rc:
	-$(RM) $(RCBIN) $(RCSVD) $(RCFUNC) $(CONF)

clean: clean-runit clean-rc

.PHONY: all install clean install-runit clean-runit
