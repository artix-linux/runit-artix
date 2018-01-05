PREFIX ?=	/usr
SCRIPTS=	1 2 3 ctrlaltdel

all:
	$(CC) $(CFLAGS) halt.c -o halt $(LDFLAGS)
	$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)

install:
	install -d ${DESTDIR}${PREFIX}/lib/runit-artix/bin
	install -m755 halt ${DESTDIR}${PREFIX}/lib/runit-artix/bin/halt
	install -m755 pause ${DESTDIR}${PREFIX}/lib/runit-artix/bin/pause
	install -m755 shutdown ${DESTDIR}${PREFIX}/lib/runit-artix/bin/shutdown
	install -m755 modules-load ${DESTDIR}${PREFIX}/lib/runit-artix/bin/modules-load
	install -m755 zzz ${DESTDIR}${PREFIX}/lib/runit-artix/bin/zzz
	ln -sf halt ${DESTDIR}${PREFIX}/lib/runit-artix/bin/poweroff
	ln -sf halt ${DESTDIR}${PREFIX}/lib/runit-artix/bin/reboot
	install -d ${DESTDIR}${PREFIX}/share/man/man1
	install -m644 pause.1 ${DESTDIR}${PREFIX}/share/man/man1
	install -d ${DESTDIR}${PREFIX}/share/man/man8
	install -m644 zzz.8 ${DESTDIR}${PREFIX}/share/man/man8/zzz-runit.8
	install -m644 shutdown.8 ${DESTDIR}${PREFIX}/share/man/man8/shutdown-runit.8
	install -m644 halt.8 ${DESTDIR}${PREFIX}/share/man/man8/halt-runit.8
	install -m644 modules-load.8 ${DESTDIR}${PREFIX}/share/man/man8
	ln -sf halt-runit.8 ${DESTDIR}${PREFIX}/share/man/man8/poweroff-runit.8
	ln -sf halt-runit.8 ${DESTDIR}${PREFIX}/share/man/man8/reboot-runit.8
	install -d ${DESTDIR}/etc/runit/sv
	install -d ${DESTDIR}/etc/runit/runsvdir
	install -d ${DESTDIR}/etc/runit/core-services
	install -m644 core-services/*.sh ${DESTDIR}/etc/runit/core-services
	install -m755 ${SCRIPTS} ${DESTDIR}/etc/runit
	install -m644 functions $(DESTDIR)/etc/runit
	install -m644 crypt.awk  ${DESTDIR}/etc/runit
	install -m644 rc.conf ${DESTDIR}/etc/runit
	install -m755 rc.local ${DESTDIR}/etc/runit
	install -m755 rc.shutdown ${DESTDIR}/etc/runit
	ln -sf /run/runit/reboot ${DESTDIR}/etc/runit/
	ln -sf /run/runit/stopit ${DESTDIR}/etc/runit/
	cp -aP runsvdir/* ${DESTDIR}/etc/runit/runsvdir/
	cp -aP services/* ${DESTDIR}/etc/runit/sv/

clean:
	-rm -f halt pause

.PHONY: all install clean
