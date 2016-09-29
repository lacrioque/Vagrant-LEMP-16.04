#!/bin/bash

echo "(Setting up your Vagrant box...)"

echo "(Updating apt-get...)"
sudo apt-get update > /dev/null 2>&1

# Nginx
echo "(Installing Nginx...)"
sudo apt-get install -y nginx > /dev/null 2>&1

# MySQL
echo "(Preparing for MySQL Installation...)"
sudo apt-get install -y debconf-utils > /dev/null 2>&1
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"

echo "(Installing MySQL...)"
sudo apt-get install -y mysql-server > /dev/null 2>&1


echo "(Installing PHP and MySQL module...)"
sudo apt-get install -y php-fpm php-mysql > /dev/null 2>&1

# Nginx Config
echo "(Overwriting default Nginx config to work with PHP...)"
sudo rm -rf /etc/nginx/sites-available/default > /dev/null 2>&1
cp /var/www/.provision/nginx_vhost /etc/nginx/sites-available/default > /dev/null 2>&1

# Restarting Nginx for config to take effect
echo "(Restarting Nginx for changes to take effect...)"
sudo service nginx restart > /dev/null 2>&1

echo "(Setting Ubuntu (user) password to \"vagrant\"...)"
echo "ubuntu:vagrant" | chpasswd

echo "+---------------------------------------------------------+"
echo "|                      S U C C E S S                      |"
echo "+---------------------------------------------------------+"
echo "|   You're good to go! You can now view your server at    |"
echo "|                 \"127.0.0.1/\" in a browser.              |"
echo "|                                                         |"
echo "|  If you haven't already, I would suggest editing your   |"
echo "|     hosts file with \"127.0.0.1  projectname.vagrant\"    |"
echo "|         so that you can view your server with           |"
echo "|      \"projectname.vagrant/\" instead of \"127.0.0.1/\"     |"
echo "|                      in a browser.                      |"
echo "|                                                         |"
echo "|          You can SSH in with ubuntu / vagrant           |"
echo "|                                                         |"
echo "|        You can login to MySQL with root / root          |"
echo "+---------------------------------------------------------+"