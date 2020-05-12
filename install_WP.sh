#!/bin/bash

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
    echo "Use $0 <domain Name e.g: test.com> <short domain name: e.g test> <db user>"
    exit 1;
fi

dbuser=$3
domainName=$1
domainShort=$2

service apache2 status;

if [ $? -ne 0 ]; then
    echo "Apache2 service is not available... Installing it."
    sudo bash install_LAMP.sh
fi

# Create site dir and logdir
sudo mkdir /var/www/$domainShort
sudo mkdir /var/log/apache2/$domainShort

#Create configuration site file
echo "<VirtualHost *:80>
      <Directory /var/www/$domainShort/>
       AllowOverride All
      </Directory>
        ServerName $domainName
        ServerAlias www.$domainName
        DocumentRoot /var/www/$domainShort
        LogLevel warn
        ErrorLog  /var/log/apache2/$domainShort/error.log
        CustomLog /var/log/apache2/$domainShort/access.log combined
        #ServerAdmin youradmin@yourdomain
</VirtualHost>" | sudo tee /etc/apache2/sites-available/$domainShort.conf

# Create wordpress DB
sudo bash create_DB.sh $dbuser

# WordPress steps
cd /tmp

# If not exists, Download WP
if [ ! -f /tmp/latest.tar.gz ]; then
    curl -O -q https://wordpress.org/latest.tar.gz
fi

# Extract WP from tar.gz file
sudo tar -xzf latest.tar.gz

# Create .htaccess file
sudo touch /tmp/wordpress/.htaccess

# Create WP config file from sample config file.
sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

# Create upgrade dir
sudo mkdir /tmp/wordpress/wp-content/upgrade

# Copy all WP files to the root site
sudo cp -a /tmp/wordpress/. /var/www/$domainShort

# Adjust WP files permissions
sudo chown -R www-data:www-data /var/www/$domainName
sudo find /var/www/$domainName/ -type d -exec chmod 755 {} \;
sudo find /var/www/$domainName/ -type f -exec chmod 644 {} \;

# Apache disable default site
sudo a2dissite 000-default.conf
# Apache Enable new configuration site.
sudo a2ensite $domainShort.conf
# Enable Apache module rewrite
sudo a2enmod rewrite
# Reload Apache configuration
sudo systemctl restart apache2

echo " Use the command: curl -s  https://api.wordpress.org/secret-key/1.1/salt/ to get the WP secret Keys and replace the following values in the file /var/www/$domainName/wp-config.php:

define('AUTH_KEY',         'VALUE');
define('SECURE_AUTH_KEY',  'VALUE');
define('LOGGED_IN_KEY',    'VALUE');
define('NONCE_KEY',        'VALUE');
define('AUTH_SALT',        'VALUE');
define('SECURE_AUTH_SALT', 'VALUE');
define('LOGGED_IN_SALT',   'VALUE');
define('NONCE_SALT',       'VALUE');
"