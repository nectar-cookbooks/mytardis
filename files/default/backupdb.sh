#!/bin/sh
# Create a dump of the MyTardis Postgres database
if [ ! -d /var/lib/mytardis/backup ] ; then
    echo Cannot find the backup directory
    exit 1
fi
cd /var/lib/mytardis/backup
/usr/bin/pg_dump mytardis > mytardis-db-dump-`date +%FT%T`
if [ $? != 0 ] ; then
    echo Database dump command failed
    exit 2
fi

if [ $# -gt 0 -a "X$1" = "X--purgeOld" ] ; then
    # Delete dumps older than 7 days.
    find . -name mytardis-db-dump\* -ctime 7 -exec rm {} \;
fi
