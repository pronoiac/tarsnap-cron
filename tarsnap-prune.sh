#!/bin/sh

# Tarsnap backup script
# Written by Tim Bishop, 2009.
# Modified by Pronoiac, 2014. 

# Directories to backup
#DIRS="/home /etc /usr/local/etc"
# meh. 
LABELS="www home"

# Number of daily backups to keep
DAILY=7

# Number of weekly backups to keep
WEEKLY=5
# Which day to do weekly backups on
# 1-7, Monday = 1
WEEKLY_DAY=1

# Number of monthly backups to keep
MONTHLY=12
# Which day to do monthly backups on
# 01-31 (leading 0 is important)
MONTHLY_DAY=01

# Path to tarsnap
#TARSNAP="/home/tdb/tarsnap/tarsnap.pl"
TARSNAP="/usr/local/bin/tarsnap"
# TARSNAP="echo"

# PREFIX="foobar" # I use the hostname at the start
PREFIX=`hostname`

# end of config


# using tail to find archives to delete, but its
# +n syntax is out by one from what we want to do
# (also +0 == +1, so we're safe :-)
DAILY=`expr $DAILY + 1`
WEEKLY=`expr $WEEKLY + 1`
MONTHLY=`expr $MONTHLY + 1`

# Do deletes
TMPFILE=/tmp/tarsnap.archives.$$
$TARSNAP --configfile /etc/tarsnap.conf --list-archives > $TMPFILE
DELARCHIVES=""
for label in $LABELS; do
	# daily
	for i in `grep -E "^$prefix-$label-.+-daily$" $TMPFILE | sort -rn | tail -n +$DAILY`; do
		echo "==> delete $i"
		DELARCHIVES="$DELARCHIVES -f $i"
	done

	# weekly
	for i in `grep -E "^$PREFIX-$label-.+-weekly$" $TMPFILE | sort -rn | tail -n +$WEEKLY`; do
		echo "==> delete $i"
		DELARCHIVES="$DELARCHIVES -f $i"
	done

	# monthly
	for i in `grep -E "^$prefix-$label-.+-monthly$" $TMPFILE | sort -rn | tail -n +$MONTHLY`; do
		echo "==> delete $i"
		DELARCHIVES="$DELARCHIVES -f $i"
	done
done
if [ X"$DELARCHIVES" != X ]; then
	echo "==> delete $DELARCHIVES"
	echo $TARSNAP -d $DELARCHIVES
fi

rm $TMPFILE
