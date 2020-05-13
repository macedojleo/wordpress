#!/bin/bash

# Before to schedule this process or run it manually, be sure the user who will start this process has SUDO privileges.

if [ -z $1 ]; then
    echo "Use $0 <DB_USER>"
    exit 1;
fi

DBNAME=$1;
TS=`date +%Y%m%d_%H%M%S`;
BACKUPDIR="/backup/wp/db";

# Check if backup dir exists
if [ ! -d $BACKUPDIR ];then
    # Create backup dir
    sudo mkdir -p "$BACKUPDIR"
    chmod 777 $BACKUPDIR
fi

# DUMP WP database
sudo mysqldump -u root $DBNAME | tee $BACKUPDIR/DB_DUMP_$TS.sql

# Check if DB dump process was finished successfuly
if [ $? -ne 0 ]; then
    echo "DB $DBNAME Backup has failed"
fi