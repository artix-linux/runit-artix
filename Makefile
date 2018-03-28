PREFIX ?=	/usr
SCRIPTS=	1 2 3 ctrlaltdel

all:
	$(CC) $(CFLAGS) halt.c -o halt $(LDFLAGS)
	$(CC) $(CFLAGS) pause.c -o pause $(LDFLAGS)

install:
	install -d ${DESTDIR}${PREFIX}/bin
	install -d ${DESTDIR}${PREFIX}/lib/runit-artix/bin
	install -m755 pause ${DESTDIR}${PREFIX}/bin/pause
	install -m755 modules-load ${DESTDIR}${PREFIX}/bin/modules-load
	install -m755 zzz ${DESTDIR}${PREFIX}/bin/zzz
	install -m755 halt ${DESTDIR}${PREFIX}/lib/runit-artix/bin/halt
	install -m755 shutdown ${DESTDIR}${PREFIX}/lib/runit-artix/bin/shutdown
	ln -sf halt ${DESTDIR}${PREFIX}/lib/runit-artix/bin/poweroff
	ln -sf halt ${DESTDIR}${PREFIX}/lib/runit-artix/bin/reboot
	install -d ${DESTDIR}${PREFIX}/share/man/man1
	install -m644 pause.1 ${DESTDIR}${PREFIX}/share/man/man1
	install -d ${DESTDIR}${PREFIX}/share/man/man8
	install -m644 zzz.8 ${DESTDIR}${PREFIX}/share/man/man8/zzz.8
	install -m644 modules-load.8 ${DESTDIR}${PREFIX}/share/man/man8
	install -d ${DESTDIR}/etc/runit/sv
	install -d ${DESTDIR}/etc/runit/runsvdir
	install -d ${DESTDIR}/etc/runit/core-services
	install -d ${DESTDIR}/etc/runit/shutdown-services
	install -m644 core-services/*.sh ${DESTDIR}/etc/runit/core-services
	install -m644 shutdown-services/*.sh ${DESTDIR}/etc/runit/shutdown-services
	install -m755 ${SCRIPTS} ${DESTDIR}/etc/runit
	install -m644 functions $(DESTDIR)/etc/runit
	install -m644 crypt.awk  ${DESTDIR}/etc/runit
	install -m644 rc.conf ${DESTDIR}/etc/runit
	install -m755 rc.local ${DESTDIR}/etc/runit
	install -m755 rc.shutdown ${DESTDIR}/etc/runit
	ln -sf /run/runit/reboot ${DESTDIR}/etc/runit/
	ln -sf /run/runit/stopit ${DESTDIR}/etc/runit/
	cp -R --no-dereference --preserve=mode,links -v runsvdir/* ${DESTDIR}/etc/runit/runsvdir/
	cp -R --no-dereference --preserve=mode,links -v services/* ${DESTDIR}/etc/runit/sv/

install_sysv:
	install -d ${DESTDIR}${PREFIX}/bin
	ln -sf runit-init ${DESTDIR}${PREFIX}/bin/init
	ln -sf ${PREFIX}/lib/runit-artix/bin/halt ${DESTDIR}${PREFIX}/bin/halt
	ln -sf ${PREFIX}/lib/runit-artix/bin/shutdown ${DESTDIR}${PREFIX}/bin/shutdown
	ln -sf halt ${DESTDIR}${PREFIX}/bin/poweroff
	ln -sf halt ${DESTDIR}${PREFIX}/bin/reboot
	install -m644 shutdown.8 ${DESTDIR}${PREFIX}/share/man/man8/shutdown.8
	install -m644 halt.8 ${DESTDIR}${PREFIX}/share/man/man8/halt.8
	ln -sf halt.8 ${DESTDIR}${PREFIX}/share/man/man8/poweroff.8
	ln -sf halt.8 ${DESTDIR}${PREFIX}/share/man/man8/reboot.8

clean:
	-rm -f halt pause

.PHONY: all install install_sysv clean
