#!/bin/bash
set -e

# Remove any stale PID files left over from an ungraceful reboot
rm -f /var/run/squid.pid /run/squid.pid /var/run/squid/squid.pid

# Start Squid in the foreground (pass any CMD arguments)
exec squid -N "$@"
