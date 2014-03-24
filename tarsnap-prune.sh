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

# Number of daily / weekly / monthly backups to keep
DAILY=7
WEEKLY=5
MONTHLY=12

# Path to tarsnap
#TARSNAP="/home/tdb/tarsnap/tarsnap.pl"
TARSNAP="/usr/local/bin/tarsnap"
# TARSNAP="echo"

# PREFIX="foobar" # I use the hostname at the start
PREFIX=`hostname`

# DEBUG=true

# end of config


# using tail to find archives to delete, but its
# +n syntax is out by one from what we want to do
# (also +0 == +1, so we're safe :-)
DAILY=`expr $DAILY + 1`
WEEKLY=`expr $WEEKLY + 1`
MONTHLY=`expr $MONTHLY + 1`

# Do deletes
if [ "$DEBUG" = "true" ]
then
    TMPFILE=/tmp/tarsnap.archives
    if [ ! -f $TMPFILE ]; then
        $TARSNAP --configfile /etc/tarsnap.conf --list-archives > $TMPFILE
    fi
else
    TMPFILE=/tmp/tarsnap.archives.$$
    $TARSNAP --configfile /etc/tarsnap.conf --list-archives > $TMPFILE
fi

DELARCHIVES=""

while read line; do
    case "$line" in \#*) continue;; esac # skip lines starting with "#"
    set $line
    # typical label & path: home and /home
    label=$1
    path=$2

	# daily
	for i in `grep -E "^$PREFIX-$label-.+-daily$" $TMPFILE | sort -rn | tail -n +$DAILY`; do
		echo "==> delete $i"
		DELARCHIVES="$DELARCHIVES -f $i"
	done

	# weekly
	for i in `grep -E "^$PREFIX-$label-.+-weekly$" $TMPFILE | sort -rn | tail -n +$WEEKLY`; do
		echo "==> delete $i"
		DELARCHIVES="$DELARCHIVES -f $i"
	done

	# monthly
	for i in `grep -E "^$PREFIX-$label-.+-monthly$" $TMPFILE | sort -rn | tail -n +$MONTHLY`; do
		echo "==> delete $i"
		DELARCHIVES="$DELARCHIVES -f $i"
	done
done <$CONFIG

if [ X"$DELARCHIVES" != X ]; then
    echo "==> delete $DELARCHIVES"

    if [ "$DEBUG" = "true" ]
    then
        echo $TARSNAP -d $DELARCHIVES
    else
        $TARSNAP -d $DELARCHIVES
        rm $TMPFILE
    fi
fi
