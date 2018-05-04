RCBIN = halt shutdown
RC = rc.local rc.shutdown functions rc.conf

LN = ln -sf
RM = rm -f
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

all:	$(RC) shutdown
	$(CC) $(CFLAGS) halt.c -o halt $(LDFLAGS)

install:
	install -d $(DESTDIR)$(RCDIR)
	install -d $(DESTDIR)$(RCDIR)/sysinit.d
	install -d $(DESTDIR)$(RCDIR)/shutdown.d
	install -m755 $(RC) $(DESTDIR)$(RCDIR)
	install -m644 sysinit.d/* $(DESTDIR)$(RCDIR)/sysinit.d
	install -m644 shutdown.d/* $(DESTDIR)$(RCDIR)/shutdown.d

	install -d $(DESTDIR)$(RCBINDIR)
	install -m644 $(RCBIN) $(DESTDIR)$(RCBINDIR)
	install -m644 crypt.awk $(DESTDIR)$(RCBINDIR)

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
	install -m644 shutdown.8 $(DESTDIR)$(MANDIR)/man8/shutdown.8
	install -m644 halt.8 $(DESTDIR)$(MANDIR)/man8/halt.8
	$(LN) halt.8 $(DESTDIR)$(MANDIR)/man8/poweroff.8
	$(LN) halt.8 $(DESTDIR)$(MANDIR)/man8/reboot.8

clean:
	-rm -f halt
	-rm -f shutdown $(RC)

.PHONY: all install install_sysv clean
