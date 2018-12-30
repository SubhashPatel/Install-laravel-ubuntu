#!/bin/bash

#######################################
# Bash script to install an Laravel PHP Framework in ubuntu
# Do not run scripat as a root user
# Author: Subhash (serverkaka.com)

# Check if not running as root
if [ "$(id -u)" = "0" ]; then
   echo "This script must be run as a non root user" 1>&2
   exit 1
fi

# Check port 80 is Free or Not
netstat -ln | grep ":80 " 2>&1 > /dev/null
if [ $? -eq 1 ]; then
     echo go ahead
else
     echo Port 80 is allready used
     exit 1
fi

# Update system
sudo apt-get update -y

# Prerequisite
sudo apt-get install zip unzip -y

# Installing Apache and PHP 7.2
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update -y
sudo apt-get install apache2 libapache2-mod-php7.2 php7.2 php7.2-xml php7.2-gd php7.2-opcache php7.2-mbstring -y

# Installing Laravel
cd /tmp
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Create Laravel App
cd /var/www/html
sudo composer create-project laravel/laravel your-project --prefer-dist

# Configure Apache
sudo chgrp -R www-data /var/www/html/your-project
sudo chmod -R 775 /var/www/html/your-project/storage

# Create laravel Virtualhost file for apache
cd /etc/apache2/sites-available
sudo wget https://s3.amazonaws.com/serverkaka-pubic-file/laravel/laravel.conf

# Enable VHost files
sudo a2dissite 000-default.conf
sudo a2ensite laravel.conf
sudo a2enmod rewrite

# Adjust the Firewall
ufw allow 80/tcp

# Restart Apache
sudo service apache2 restart
