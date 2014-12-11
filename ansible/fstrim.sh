#!/bin/sh

LOG=/var/log/fstrim.log

set -e
echo '*** $(date -R) ***' >> $LOG
exec /sbin/fstrim -v / >> $LOG
