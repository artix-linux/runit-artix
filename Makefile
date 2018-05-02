SYSCONFDIR = /etc
PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
RCBINDIR = $(PREFIX)/lib/rc/bin
MANDIR = $(PREFIX)/share/man

RCDIR = $(SYSCONFDIR)/rc
SYSINITDIR = $(RCDIR)/sysinit.d
SHUTDOWNDIR = $(RCDIR)/shutdown.d

SYSINIT = $(wildcard rc-sysinit/*.sh)
SHUTDOWN = $(wildcard rc-shutdown/*.sh)

RUNITDIR = $(SYSCONFDIR)/runit
SVDIR = $(RUNITDIR)/sv
RUNSVDIR = $(RUNITDIR)/runsvdir

SERVICEDIR = /etc/service
RUNDIR = /run/runit

BIN = zzz pause modules-load
RCBIN = halt shutdown
SCRIPT = shutdown
RCSCRIPTS =  functions crypt.awk rc.conf rc.local rc.shutdown
STAGES = 1 2 3 ctrlaltdel

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
	-e "s|@RUNDIR[@]|$(RUNDIR)|g"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@$(M4) $@.in | $(EDIT) >$@
	@$(CHMODAW) "$@"
	@$(CHMODX) "$@"

all:	$(STAGES) $(SCRIPT)
	$(CC) $(CFLAGS) halt.c -o halt $(LDFLAGS)
	$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)

install:

	install -d $(DESTDIR)$(SYSINITDIR)
	install -m644 $(SYSINIT) $(DESTDIR)$(SYSINITDIR)

	install -d $(DESTDIR)$(SHUTDOWNDIR)
	install -m644 $(SHUTDOWN) $(DESTDIR)$(SHUTDOWNDIR)

	install -m755 $(RCSCRIPTS) $(DESTDIR)$(RCDIR)

	install -d $(DESTDIR)$(SVDIR)
	$(CP) sv/* $(DESTDIR)$(SVDIR)/

	install -d $(DESTDIR)$(RUNSVDIR)
	$(CP) runsvdir/* $(DESTDIR)$(RUNSVDIR)/

# 	$(LN) runit/runsvdir/default $(DESTDIR)$(SERVICEDIR)

	install -d $(DESTDIR)$(BINDIR)
	install -m755 $(BIN) $(DESTDIR)$(BINDIR)

	install -d $(DESTDIR)$(RCBINDIR)
	install -m755 $(RCBIN) $(DESTDIR)$(RCBINDIR)

	install -m755 $(STAGES) $(DESTDIR)$(RUNITDIR)

	$(LN) halt $(DESTDIR)$(RCBINDIR)/poweroff
	$(LN) halt $(DESTDIR)$(RCBINDIR)/reboot

	$(LN) $(RUNDIR)/reboot $(DESTDIR)$(RUNITDIR)/
	$(LN) $(RUNDIR)/stopit $(DESTDIR)$(RUNITDIR)/

	install -d $(DESTDIR)$(MANDIR)/man1
	install -m644 pause.1 $(DESTDIR)$(MANDIR)/man1
	install -d $(DESTDIR)$(MANDIR)/man8
	install -m644 zzz.8 $(DESTDIR)$(MANDIR)/man8/zzz.8
	install -m644 modules-load.8 $(DESTDIR)$(MANDIR)/man8

install_sysv:
	install -d $(DESTDIR)$(PREFIX)/bin
	$(LN) runit-init $(DESTDIR)$(BINDIR)/init
	$(LN) $(RCBINDIR)/halt $(DESTDIR)$(BINDIR)/halt
	$(LN) $(RCBINDIR)/shutdown $(DESTDIR)$(BINDIR)/shutdown
	$(LN) halt $(DESTDIR)$(BINDIR)/poweroff
	$(LN) halt $(DESTDIR)$(BINDIR)/reboot
	install -m644 shutdown.8 $(DESTDIR)$(MANDIR)/man8/shutdown.8
	install -m644 halt.8 $(DESTDIR)$(MANDIR)/man8/halt.8
	$(LN) halt.8 $(DESTDIR)$(MANDIR)/man8/poweroff.8
	$(LN) halt.8 $(DESTDIR)$(MANDIR)/man8/reboot.8

clean:
	-rm -f halt pause
	-rm -f $(STAGES) $(SCRIPT)

.PHONY: all install install_sysv clean
