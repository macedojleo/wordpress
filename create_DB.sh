#!/bin/bash

if [ -z $1 ]; then
    #echo "Use $0 <DB_USER> <WP_CONFIG PATH: e.g /var/www/html/>"
    echo "Use $0 <DB_USER>"
    exit 1;
fi

DATABASE="wordpress"
#WP_CONFIG_PATH=$2
DBUSER=$1

# Install pwgen and generate a new password
sudo apt -y install pwgen
PASS=`pwgen -s 10 1`

#Create database and user
sudo mysql -u root <<EOF
CREATE DATABASE $DATABASE DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$PASS';
GRANT ALL ON $DATABASE.* TO '$DBUSER' IDENTIFIED BY '$PASS';
FLUSH PRIVILEGES;
EOF

sudo echo "DB User: $DBUSER" | tee  /tmp/.db_credentials
sudo echo "DB Pass: $PASS"  | tee  /tmp/.db_credentials
sudo echo "DB: $DATABASE" | tee /tmp/.db_credentials