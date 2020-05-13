#!/bin/bash

if [ -z $1 ]; then
    echo "Use $0 <DB_USER>"
    exit 1;
fi

SITEDIR=$1;
TS=`date +%Y%m%d_%H%M%S`;
BACKUPDIR="/backup/wp/db";

# Check if backup dir exists
if [ ! -d $BACKUPDIR ];then
    # Create backup dir
    sudo mkdir -p "$BACKUPDIR"
    chmod 777 $BACKUPDIR
fi

# DUMP WP database
sudo tar -cpzf $BACKUPDIR/SITE_BKP_$TS.tar.gz $SITEDIR

# Check if DB dump process was finished successfuly
if [ $? -ne 0 ]; then
    echo "The backup from $SITEDIR has failed"
fi