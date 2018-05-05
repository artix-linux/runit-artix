## Runit init scripts for Artix Linux

This repository contains the runit init scripts for the Artix Linux
distribution.

## Dependencies

- GNU coreutils
- GNU bash
- A POSIX awk
- procps-ng
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

Some codes are based on void-runit, which is licensed under CC0-1.0

The rest of runit-artix is licensed under the terms as described in the
COPYING file.
