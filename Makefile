SYSCONFDIR = /etc
PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
LIBDIR = $(PREFIX)/lib
TMPFILESDIR = $(LIBDIR)/tmpfiles.d

RUNITDIR = $(SYSCONFDIR)/runit
SVDIR = $(RUNITDIR)/sv
RUNSVDIR = $(RUNITDIR)/runsvdir
SERVICEDIR = /etc/service
RUNDIR = /run/runit

RCDIR = $(SYSCONFDIR)/rc
RCLIBDIR = $(LIBDIR)/rc
RCSVDIR = $(RCDIR)/sv.d

RCBIN = rc/rc-sv
#rc/rc-sysinit rc/rc-shutdown

RCSVD = \
	rc/sv.d/api-fs \
	rc/sv.d/binfmt \
	rc/sv.d/bootlogd \
	rc/sv.d/cleanup \
	rc/sv.d/console-setup \
	rc/sv.d/cryptsetup \
	rc/sv.d/dmesg \
	rc/sv.d/fsck \
	rc/sv.d/hostname \
	rc/sv.d/hwclock \
	rc/sv.d/kill-all \
	rc/sv.d/kmod-static-nodes \
	rc/sv.d/lvm-monitoring \
	rc/sv.d/lvm \
	rc/sv.d/mount-all \
	rc/sv.d/mount-ro \
	rc/sv.d/net-lo \
	rc/sv.d/netfs \
	rc/sv.d/random-seed \
	rc/sv.d/remount-rw \
	rc/sv.d/swap \
	rc/sv.d/sysctl \
	rc/sv.d/sysusers \
	rc/sv.d/timezone \
	rc/sv.d/tmpfiles-dev \
	rc/sv.d/tmpfiles-setup \
	rc/sv.d/udev

TMPFILES = tmpfile.conf

BIN = zzz pause modules-load

STAGES = 1 2 3 ctrlaltdel

RC = rc/rc.local rc/rc.local.shutdown rc/rc.conf
RCFUNC = rc/functions

LN = ln -sf
CP = cp -R --no-dereference --preserve=mode,links -v
RM = rm -f
RMD = rm -fr --one-file-system
M4 = m4 -P
CHMODAW = chmod a-w
CHMODX = chmod +x

HASRC = yes

EDIT = sed \
	-e "s|@RUNITDIR[@]|$(RUNITDIR)|g" \
	-e "s|@SERVICEDIR[@]|$(SERVICEDIR)|g" \
	-e "s|@RUNSVDIR[@]|$(RUNSVDIR)|g" \
	-e "s|@RUNDIR[@]|$(RUNDIR)|g" \
	-e "s|@RCDIR[@]|$(RCDIR)|g" \
	-e "s|@RCLIBDIR[@]|$(RCLIBDIR)|g"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@$(M4) $@.in | $(EDIT) >$@
	@$(CHMODAW) "$@"
	@$(CHMODX) "$@"



all: all-runit
ifeq ($(HASRC),yes)
all: all-rc
endif

all-runit:
		$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)

all-rc: $(RC) $(STAGES) $(RCBIN) $(RCSVD) $(RCFUNC)

install-runit:
	install -d $(DESTDIR)$(RUNITDIR)
	install -d $(DESTDIR)$(RUNSVDIR)
	install -d $(DESTDIR)$(RUNSVDIR)/default
	install -d $(DESTDIR)$(SVDIR)/sulogin
	$(LN) $(RUNSVDIR)/default $(DESTDIR)$(RUNSVDIR)/current
	$(CP) sv/sulogin $(DESTDIR)$(SVDIR)/
	$(CP) runsvdir/single $(DESTDIR)$(RUNSVDIR)/

	$(LN) $(RUNDIR)/reboot $(DESTDIR)$(RUNITDIR)/
	$(LN) $(RUNDIR)/stopit $(DESTDIR)$(RUNITDIR)/

	install -d $(DESTDIR)$(BINDIR)
	install -m755 $(BIN) $(DESTDIR)$(BINDIR)

	install -d $(DESTDIR)$(TMPFILESDIR)
	install -m755 $(TMPFILES) $(DESTDIR)$(TMPFILESDIR)/runit.conf

	install -d $(DESTDIR)$(MANDIR)/man1
	install -m644 pause.1 $(DESTDIR)$(MANDIR)/man1
	install -d $(DESTDIR)$(MANDIR)/man8
	install -m644 zzz.8 $(DESTDIR)$(MANDIR)/man8/zzz.8
	install -m644 modules-load.8 $(DESTDIR)$(MANDIR)/man8

install-rc:
	install -d $(DESTDIR)$(RUNITDIR)
	install -m755 $(STAGES) $(DESTDIR)$(RUNITDIR)

	install -d $(DESTDIR)$(RCDIR)

	install -m755 $(RC) $(DESTDIR)$(RCDIR)

	install -d $(DESTDIR)$(RUNITDIR)
	install -m755 $(STAGES) $(DESTDIR)$(RUNITDIR)

	install -d $(DESTDIR)$(BINDIR)
	install -m755 $(RCBIN) $(DESTDIR)$(BINDIR)

	install -d $(DESTDIR)$(RCLIBDIR)
	install -m644 $(RCFUNC) $(DESTDIR)$(RCLIBDIR)

	install -d $(DESTDIR)$(RCSVDIR)
	install -m755 $(RCSVD) $(DESTDIR)$(RCSVDIR)

install-getty:
	install -d $(DESTDIR)$(SVDIR)
	$(CP) sv/agetty-* $(DESTDIR)$(SVDIR)/

	install -d $(DESTDIR)$(RUNSVDIR)/default
	$(CP) runsvdir/default $(DESTDIR)$(RUNSVDIR)/

install: install-runit
ifeq ($(HASRC),yes)
install: install-rc
endif

clean-runit:
	-rm -f pause

clean-rc:
	-rm -f $(RC) $(STAGES) $(RCBIN) $(RCSVD) $(RCFUNC)

clean: clean-runit
ifeq ($(HASRC),yes)
clean: clean-rc
endif

clean:

.PHONY: all install clean install-runit install-rc install-getty clean-runit clean-rc all-runit all-rc
