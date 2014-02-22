#!/bin/sh

# Tarsnap backup script
# Written by Tim Bishop, 2009.
# Modified by Pronoiac, 2014. 

# Directories to backup
DIRS="/home /etc /usr/local/etc"
# tofix: not currently in use

# Which day to do weekly backups on
# 1-7, Monday = 1
WEEKLY_DAY=1

# Which day to do monthly backups on
# 01-31 (leading 0 is important)
MONTHLY_DAY=01

# Path to tarsnap
#TARSNAP="/home/tdb/tarsnap/tarsnap.pl"
TARSNAP="/usr/local/bin/tarsnap"
# TARSNAP="echo"

PREFIX=`hostname`

BANDWIDTH=100000
# bytes per second

EXTRA_PARAMETERS="--maxbw-rate-up $BANDWIDTH"

# end of config


# day of week: 1-7, monday = 1
DOW=`date +%u`
# day of month: 01-31
DOM=`date +%d`
# month of year: 01-12
MOY=`date +%m`
# year
YEAR=`date +%Y`
# time
# TIME=`date +%H%M%S`
TIME=`date +%H%M`

BACKUP="$YEAR$MOY$DOM-$TIME"

# Backup name
if [ X"$DOM" = X"$MONTHLY_DAY" ]; then
	# monthly backup
	SUFFIX="monthly"
elif [ X"$DOW" = X"$WEEKLY_DAY" ]; then
	# weekly backup
	SUFFIX="weekly"
else
	# daily backup
	SUFFIX="daily"
fi

# Do backups
echo Backing up /home files...
cd /home && \
  $TARSNAP $EXTRA_PARAMETERS -c -f $PREFIX-home-$BACKUP-$SUFFIX .

echo Backing up web files...
cd /var/www && \
  $TARSNAP $EXTRA_PARAMETERS -c -f $PREFIX-www-$BACKUP-$SUFFIX .
