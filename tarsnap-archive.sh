#!/bin/sh

# Tarsnap backup script
# Written by Tim Bishop, 2009.
# Modified by Pronoiac, 2014. 

# Directories to backup - set in
CONFIG=/etc/tarsnap-cron.conf
# e.g. 
# # label	path
# home 	/home
# etc 	/etc
# www 	/var/www

timestamp=`date +%Y-%m-%d-%H%M`

# the last part of the suffix is now specified on the command line
# cron should call this with daily, weekly, monthly, as appropriate
# typical suffix: 2014-02-22-1920-daily
if [ $# -ne 0 ]
then
  SUFFIX=$timestamp-$1
else
  SUFFIX=$timestamp
fi

# Path to tarsnap
#TARSNAP="/home/tdb/tarsnap/tarsnap.pl"
TARSNAP="/usr/local/bin/tarsnap"
# TARSNAP="echo"

PREFIX=`hostname`

BANDWIDTH=100000
# bytes per second

EXTRA_PARAMETERS="--maxbw-rate-up $BANDWIDTH"

# end of config


# Do backups
echo Starting backups. 
while read line; do
    case "$line" in \#*) continue;; esac # skip lines starting with "#"
    set $line
    # typical label & path: home and /home
    label=$1
    path=$2
    echo "==> create $PREFIX-$label-$SUFFIX"
    echo "cd $path && \
      $TARSNAP $EXTRA_PARAMETERS -c -f $PREFIX-$label-$SUFFIX ."
done <$CONFIG
