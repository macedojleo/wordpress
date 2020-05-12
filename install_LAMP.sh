#!/bin/bash

# Update packages 
sudo apt -y update && sudo apt -y upgrade
# Install tasksel
sudo apt -y install tasksel
# Install lamp-server
sudo tasksel install lamp-server
# Install php modules
sudo apt -y install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

# Restart apache 2 to reload new PHP modules
sudo systemctl restart apache2
