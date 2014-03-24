#!/bin/bash

# Tarsnap backup script
# Written by Tim Bishop, 2009.
# Modified by Pronoiac, 2014. 

# Directories to backup - set in
CONFIG=/etc/tarsnap-cron.conf
#CONFIG=tarsnap-cron.conf

# note: this evals the config file, which can present a security issue
# unless it's locked with the right permissions - e.g. not world-writable
if [ ! -r "$CONFIG" ] ; then 
    echo "ERROR: Couldn't read config file $CONFIG"
    echo Exiting now!
    exit 1
fi

source $CONFIG

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

for BACKUP in "${BACKUP_ARRAY[@]}"; do
    SPLIT=(${BACKUP//=/ })
    # typical label & path: www and /var/www
    label=${SPLIT[0]}
    path=${SPLIT[1]}

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
done

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
