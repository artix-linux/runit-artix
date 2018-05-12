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

RCLIBDIR = $(LIBDIR)/rc

TMPFILES = tmpfile.conf
BIN = zzz pause
STAGES = 1 2 3 ctrlaltdel

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
	-e "s|@RCLIBDIR[@]|$(RCLIBDIR)|g"

%: %.in Makefile
	@echo "GEN $@"
	@$(RM) "$@"
	@$(M4) $@.in | $(EDIT) >$@
	@$(CHMODAW) "$@"
	@$(CHMODX) "$@"



all: all-runit

all-runit: $(STAGES)
		$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)

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

	install -d $(DESTDIR)$(RUNITDIR)
	install -m755 $(STAGES) $(DESTDIR)$(RUNITDIR)

install-getty:
	install -d $(DESTDIR)$(SVDIR)
	$(CP) sv/agetty-* $(DESTDIR)$(SVDIR)/

	install -d $(DESTDIR)$(RUNSVDIR)/default
	$(CP) runsvdir/default $(DESTDIR)$(RUNSVDIR)/

install: install-runit install-getty

clean-runit:
	-$(RM) pause $(STAGES)

clean: clean-runit

.PHONY: all install clean install-runit install-getty clean-runit
