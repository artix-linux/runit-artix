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
RCBINDIR = $(PREFIX)/lib/rc/bin
RCDIR = $(SYSCONFDIR)/rc

TMPFILES = tmpfile.conf

BIN = zzz pause modules-load

STAGES = 1 2 3 ctrlaltdel

RCBIN = rc/halt rc/shutdown
RC = rc/rc.local rc/rc.shutdown rc/functions rc/rc.conf

LN = ln -sf
CP = cp -R --no-dereference --preserve=mode,links -v
RM = rm -f
RMD = rm -fr --one-file-system
M4 = m4 -P
CHMODAW = chmod a-w
CHMODX = chmod +x

HASRC = yes
HASSYSV = no

EDIT = sed \
	-e "s|@RUNITDIR[@]|$(RUNITDIR)|g" \
	-e "s|@SERVICEDIR[@]|$(SERVICEDIR)|g" \
	-e "s|@RUNSVDIR[@]|$(RUNSVDIR)|g" \
	-e "s|@RUNDIR[@]|$(RUNDIR)|g" \
	-e "s|@RCDIR[@]|$(RCDIR)|g"

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

all-runit: $(STAGES)
		$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)

all-rc: $(RC) rc/shutdown
	$(CC) $(CFLAGS) rc/halt.c -o rc/halt $(LDFLAGS)

install-runit:
	install -d $(DESTDIR)$(RUNITDIR)
	install -m755 $(STAGES) $(DESTDIR)$(RUNITDIR)

	$(LN) $(RUNDIR)/reboot $(DESTDIR)$(RUNITDIR)/
	$(LN) $(RUNDIR)/stopit $(DESTDIR)$(RUNITDIR)/

	install -d $(DESTDIR)$(SVDIR)
	$(CP) sv/* $(DESTDIR)$(SVDIR)/

	install -d $(DESTDIR)$(RUNSVDIR)
	$(CP) runsvdir/* $(DESTDIR)$(RUNSVDIR)/

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
	install -d $(DESTDIR)$(RCDIR)
	install -d $(DESTDIR)$(RCDIR)/sysinit.d
	install -d $(DESTDIR)$(RCDIR)/shutdown.d
	install -m755 $(RC) $(DESTDIR)$(RCDIR)
	install -m644 rc/sysinit.d/* $(DESTDIR)$(RCDIR)/sysinit.d
	install -m644 rc/shutdown.d/* $(DESTDIR)$(RCDIR)/shutdown.d
	install -m644 rc/crypt.awk $(DESTDIR)$(RCDIR)

	install -d $(DESTDIR)$(RCBINDIR)
	install -m644 $(RCBIN) $(DESTDIR)$(RCBINDIR)

	$(LN) halt $(DESTDIR)$(RCBINDIR)/poweroff
	$(LN) halt $(DESTDIR)$(RCBINDIR)/reboot

install_sysv:
	install -d $(DESTDIR)$(BINDIR)
	$(LN) runit-init $(DESTDIR)$(BINDIR)/init
	$(LN) $(RCBINDIR)/halt $(DESTDIR)$(BINDIR)/halt
	$(LN) $(RCBINDIR)/shutdown $(DESTDIR)$(BINDIR)/shutdown
	$(LN) halt $(DESTDIR)$(BINDIR)/poweroff
	$(LN) halt $(DESTDIR)$(BINDIR)/reboot
	install -d $(DESTDIR)$(MANDIR)/man8
	install -m644 rc/shutdown.8 $(DESTDIR)$(MANDIR)/man8/shutdown.8
	install -m644 rc/halt.8 $(DESTDIR)$(MANDIR)/man8/halt.8
	$(LN) halt.8 $(DESTDIR)$(MANDIR)/man8/poweroff.8
	$(LN) halt.8 $(DESTDIR)$(MANDIR)/man8/reboot.8

install: install-runit
ifeq ($(HASRC),yes)
install: install-rc
ifeq ($(HASSYSV),yes)
install: install_sysv
endif
endif

clean-runit:
	-rm -f pause
	-rm -f $(STAGES)

clean-rc:
	-rm -f rc/halt
	-rm -f rc/shutdown $(RC)

clean: clean-runit
ifeq ($(HASRC),yes)
clean: clean-rc
endif

clean:

.PHONY: all install clean install-runit install-rc clean-runit clean-rc all-runit all-rc install_sysv
