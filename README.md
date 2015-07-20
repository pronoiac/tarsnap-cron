tarsnap-cron
============

Cron scripts (bash/shell) for tarsnap backup, including scheduled deletion of old backups.

Description
-----------

[tarsnap][tarsnap] is a very useful backup service, with lots of features, which I won't go into here. It allows separate roles, so you could have servers that cannot delete their own backups, even if they're hacked. 

These scripts attempt to make it easier for scheduled backups, with scheduled deletion of old backups. If you want to keep X daily backups, Y weekly backups and Z monthly backups, you can.

Archiving and pruning can be run on different systems. The default weekly backups are on Mondays, and monthly backups are on the first. 

This is based on work by [Tim Bishop][bishop]. 


Changes from the original
-------------------------

I'm writing and testing this on Linux systems. It may work on FreeBSD, or not. You can try it, or just try Bishop's code. 

Note: I modified the format of the archive names. 
* an example from Bishop's script - 20140201-010100-monthly-/var/www
* an example from my script - hostname-www-2014-02-01-0101-monthly

I changed it to incorporate backups from a previous system of my design. The systems to prune old backups are incompatible, so if you switch between this script and his, old backups will stick around longer than they should. It would probably take manual cleanup to fix. 

I think this version is more extendible. Instead of reinventing cron, it simply uses a customized crontab. Hourly and yearly backups wouldn't be hard to implement, if there's any demand. 

[tarsnap]: http://www.tarsnap.com 
[bishop]: http://www.bishnet.net/tim/blog/2009/01/28/automating-tarsnap-backups/
