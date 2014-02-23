tarsnap-cron
============

Cron scripts for tarsnap backup, including scheduled deletion of old backups.

Description
-----------

[tarsnap][tarsnap] is a very useful backup service, with lots of features, which I won't go into here. It allows separate roles, so you could have servers that cannot delete their own backups, even if they're hacked. 

These scripts attempt to make it easier for scheduled backups, with scheduled deletion of old backups. It lets you keep X daily backups, Y weekly backups and Z monthly backups, you can. 

Archiving and pruning can be run on different systems. The default weekly backups are on Mondays, and monthly backups are on the first. 

This is based on work by [Tim Bishop][bishop]. I'm writing and testing this on Linux systems. It may work on FreeBSD, or not. You can try it, or just try his code. 

[tarsnap]: http://www.tarsnap.com 
[bishop]: http://www.bishnet.net/tim/blog/2009/01/28/automating-tarsnap-backups/
