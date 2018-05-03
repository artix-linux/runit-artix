SYSCONFDIR = /etc
PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man
LIBDIR = $(PREFIX)/lib
RCBINDIR = $(PREFIX)/lib/runit/bin
TMPFILESDIR = $(LIBDIR)/tmpfiles.d
RUNITDIR = $(SYSCONFDIR)/runit
SVDIR = $(RUNITDIR)/sv
RUNSVDIR = $(RUNITDIR)/runsvdir
SERVICEDIR = /etc/service
RUNDIR = /run/runit

TMPFILES = tmpfile.conf

BIN = zzz pause modules-load bootlogd

RCBIN = halt shutdown

SHUTDOWN = shutdown

STAGES = 1 2 3 ctrlaltdel functions runit.conf

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
	-e "s|@RUNDIR[@]|$(RUNDIR)|g"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@$(M4) $@.in | $(EDIT) >$@
	@$(CHMODAW) "$@"
	@$(CHMODX) "$@"

all:	$(STAGES) shutdown
	$(CC) $(CFLAGS) halt.c -o halt $(LDFLAGS)
	$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)
	$(CC) -ansi -O2 -fomit-frame-pointer -W -Wall -D_GNU_SOURCE bootlogd.c -o bootlogd $(LDFLAGS) -lutil

install:
	### rc

	install -d $(DESTDIR)$(RCBINDIR)
	install -m644 $(RCBIN) $(DESTDIR)$(RCBINDIR)

	$(LN) halt $(DESTDIR)$(RCBINDIR)/poweroff
	$(LN) halt $(DESTDIR)$(RCBINDIR)/reboot

	### runit

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
	install -m644 bootlogd.8 $(DESTDIR)$(MANDIR)/man8/bootlogd.8

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
	-rm -f halt pause bootlogd
	-rm -f $(STAGES) shutdown

.PHONY: all install install_sysv clean
