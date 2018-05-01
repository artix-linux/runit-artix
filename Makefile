SYSCONFDIR = /etc
PREFIX ?= /usr
BINDIR = ${PREFIX}/bin
RCBINDIR = ${PREFIX}/lib/rc/bin
MANDIR = ${PREFIX}/share/man

RCDIR = $(SYSCONFDIR)/rc
SYSINITDIR = $(RCDIR)/sysinit.d
SHUTDOWNDIR = $(RCDIR)/shutdown.d

SYSINIT = $(wildcard rc-sysinit/*.sh)
SHUTDOWN = $(wildcard rc-shutdown/*.sh)

RUNITDIR = $(SYSCONFDIR)/runit
SVDIR = $(RUNITDIR)/sv
RUNSVDIR = $(RUNITDIR)/runsvdir

BIN = zzz pause modules-load
RC_BIN = halt shutdown
RC_SCRIPTS =  functions crypt.awk rc.conf rc.local rc.shutdown
STAGES = 1 2 3 ctrlaltdel

LN = ln -sf
CP = cp -R --no-dereference --preserve=mode,links -v
RM = rm -f
RMD = rm -fr --one-file-system
M4 = m4 -P
CHMODAW = chmod a-w
CHMODX = chmod +x

EDIT = sed -e "s|@RCDIR[@]|$(RCDIR)|g"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@$(M4) $@.in | $(EDIT) >$@
	@$(CHMODAW) "$@"
	@$(CHMODX) "$@"

all:	$(STAGES)
	$(CC) $(CFLAGS) halt.c -o halt $(LDFLAGS)
	$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)


install:

	install -d ${DESTDIR}$(SYSINITDIR)
	install -m644 $(SYSINIT) ${DESTDIR}$(SYSINITDIR)

	install -d ${DESTDIR}$(SHUTDOWNDIR)
	install -m644 $(SHUTDOWN) ${DESTDIR}$(SHUTDOWNDIR)

	install -m755 ${RC_SCRIPTS} ${DESTDIR}$(RCDIR)

	install -d ${DESTDIR}$(SVDIR)
	$(CP) services/* ${DESTDIR}$(SVDIR)/

	install -d ${DESTDIR}$(RUNSVDIR)
	$(CP) runsvdir/* ${DESTDIR}$(RUNSVDIR)/

# 	install -d ${DESTDIR}$(RUNITDIR)/service
# 	$(LN) $(RUNITDIR)/service ${DESTDIR}$(RUNSVDIR)/default

	install -d ${DESTDIR}${BINDIR}
	install -m755 $(BIN) ${DESTDIR}${BINDIR}

	install -d ${DESTDIR}${RCBINDIR}
	install -m755 $(RC_BIN) ${DESTDIR}${RCBINDIR}

	install -m755 ${STAGES} ${DESTDIR}$(RUNITDIR)

	$(LN) halt ${DESTDIR}${RCBINDIR}/poweroff
	$(LN) halt ${DESTDIR}${RCBINDIR}/reboot

	$(LN) /run/runit/reboot ${DESTDIR}$(RUNITDIR)/
	$(LN) /run/runit/stopit ${DESTDIR}$(RUNITDIR)/

	install -d ${DESTDIR}${MANDIR}/man1
	install -m644 pause.1 ${DESTDIR}${MANDIR}/man1
	install -d ${DESTDIR}${MANDIR}/man8
	install -m644 zzz.8 ${DESTDIR}${MANDIR}/man8/zzz.8
	install -m644 modules-load.8 ${DESTDIR}${MANDIR}/man8

install_sysv:
	install -d ${DESTDIR}${PREFIX}/bin
	$(LN) runit-init ${DESTDIR}${BINDIR}/init
	$(LN) ${RCBINDIR}/halt ${DESTDIR}${BINDIR}/halt
	$(LN) ${RCBINDIR}/shutdown ${DESTDIR}${BINDIR}/shutdown
	$(LN) halt ${DESTDIR}${BINDIR}/poweroff
	$(LN) halt ${DESTDIR}${BINDIR}/reboot
	install -m644 shutdown.8 ${DESTDIR}${MANDIR}/man8/shutdown.8
	install -m644 halt.8 ${DESTDIR}${MANDIR}/man8/halt.8
	$(LN) halt.8 ${DESTDIR}${MANDIR}/man8/poweroff.8
	$(LN) halt.8 ${DESTDIR}${MANDIR}/man8/reboot.8

clean:
	-rm -f halt pause
	-rm -f $(STAGES)

.PHONY: all install install_sysv clean
