## Runit init scripts for Artix Linux

This repository contains the runit init scripts for the Artix Linux
distribution.

This work is based on Void Linux's
[void-runit](https://github.com/voidlinux/void-runit). Patches to Void
Linux's repo will also be applied here.

## Dependencies

- GNU coreutils
- A POSIX shell
- A POSIX awk
- procps-ng (needs pkill -s0,1)
- runit
- opentmpfiles
- opensysusers

### How to use it

To see enabled services for "current" runlevel:

    $ ls -l /run/runit/service

To see available runlevels (default and single, which just runs sulogin):

    $ ls -l /etc/runit/runsvdir

To enable and start a service into the "current" runlevel:

    # ln -s /etc/runit/sv/<service> /run/runit/service

To disable and remove a service:

    # rm -f /run/runit/service/<service>

To view status of all services for "current" runlevel:

    # sv status /run/runit/service/*

Feel free to send patches and contribute with improvements!

## Copyright

runit-artix is in the public domain.

To the extent possible under law, the creator of this work has waived
all copyright and related or neighboring rights to this work.

http://creativecommons.org/publicdomain/zero/1.0/
