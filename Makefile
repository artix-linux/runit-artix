SYSCONFDIR = /etc
PREFIX ?=	/usr
SCRIPTS=	1 2 3 ctrlaltdel rc.local rc.shutdown
BIN_LIBDIR = ${PREFIX}/lib/runit-artix/bin
BINDIR = ${PREFIX}/bin
MANDIR = ${PREFIX}/share/man

BIN = zzz pause modules-load

CTTL_BIN = halt shutdown

RUNITDIR = $(SYSCONFDIR)/runit

SYSINITDIR = $(RUNITDIR)/sysinit-services

SVDIR = $(RUNITDIR)/sv

RUNSVDIR = $(RUNITDIR)/runsvdir

SHUTDOWNDIR = $(RUNITDIR)/shutdown-services

SYSINIT = $(wildcard sysinit-services/*.sh)

SHUTDOWN = $(wildcard shutdown-services/*.sh)

MISC = functions crypt.awk rc.conf


LN = ln -sf
CP = cp -R --no-dereference --preserve=mode,links -v

all:
	$(CC) $(CFLAGS) halt.c -o halt $(LDFLAGS)
	$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)

install:
	install -d ${DESTDIR}${BINDIR}
	install -m755 $(BIN) ${DESTDIR}${BINDIR}

	install -d ${DESTDIR}${BIN_LIBDIR}
	install -m755 $(CTTL_BIN) ${DESTDIR}${BIN_LIBDIR}

	$(LN) halt ${DESTDIR}${BIN_LIBDIR}/poweroff
	$(LN) halt ${DESTDIR}${BIN_LIBDIR}/reboot

	install -d ${DESTDIR}$(SVDIR)
	install -d ${DESTDIR}$(RUNSVDIR)

	install -d ${DESTDIR}$(SYSINITDIR)
	install -m644 $(SYSINIT) ${DESTDIR}$(SYSINITDIR)

	install -d ${DESTDIR}$(SHUTDOWNDIR)
	install -m644 $(SHUTDOWN) ${DESTDIR}$(SHUTDOWNDIR)

	install -m755 ${SCRIPTS} ${DESTDIR}$(RUNITDIR)
	install -m644 $(MISC) $(DESTDIR)$(RUNITDIR)

	$(LN) /run/runit/reboot ${DESTDIR}$(RUNITDIR)/
	$(LN) /run/runit/stopit ${DESTDIR}$(RUNITDIR)/
	$(CP) runsvdir/* ${DESTDIR}$(RUNSVDIR)/
	$(CP) services/* ${DESTDIR}$(SVDIR)/

	install -d ${DESTDIR}${MANDIR}/man1
	install -m644 pause.1 ${DESTDIR}${MANDIR}/man1
	install -d ${DESTDIR}${MANDIR}/man8
	install -m644 zzz.8 ${DESTDIR}${MANDIR}/man8/zzz.8
	install -m644 modules-load.8 ${DESTDIR}${MANDIR}/man8

install_sysv:
	install -d ${DESTDIR}${PREFIX}/bin
	$(LN) runit-init ${DESTDIR}${BINDIR}/init
	$(LN) ${BIN_LIBDIR}/halt ${DESTDIR}${BINDIR}/halt
	$(LN) ${BIN_LIBDIR}/shutdown ${DESTDIR}${BINDIR}/shutdown
	$(LN) halt ${DESTDIR}${BINDIR}/poweroff
	$(LN) halt ${DESTDIR}${BINDIR}/reboot
	install -m644 shutdown.8 ${DESTDIR}${MANDIR}/man8/shutdown.8
	install -m644 halt.8 ${DESTDIR}${MANDIR}/man8/halt.8
	$(LN) halt.8 ${DESTDIR}${MANDIR}/man8/poweroff.8
	$(LN) halt.8 ${DESTDIR}${MANDIR}/man8/reboot.8

clean:
	-rm -f halt pause

.PHONY: all install install_sysv clean
