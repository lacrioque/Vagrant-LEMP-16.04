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
sudo apt-get install -y php-fpm php-xml php-mbstring php-imap php-zip zlibc php-gd php-mysql  > /dev/null 2>&1

# Nginx Config
echo "(Overwriting default Nginx config to work with PHP...)"
sudo rm -rf /etc/nginx/sites-available/default > /dev/null 2>&1
cp /var/www/.provision/nginx_vhost /etc/nginx/sites-available/default > /dev/null 2>&1

#MySQL config
echo "(Creating user and database for LimeSurvey...)" > /dev/null 2>&1
sudo mysql -uroot -proot -e "CREATE USER limesurvey IDENTIFIED BY 'limesurvey'" > /dev/null 2>&1
sudo mysql -uroot -proot -e "GRANT ALL ON *.* TO limesurvey IDENTIFIED BY 'limesurvey'" > /dev/null 2>&1
sudo mysql -uroot -proot -e "CREATE DATABASE limesurvey" > /dev/null 2>&1

#Self-signed certificates for basic ssl
echo "(Creating a self-signed certificate...)"
mkdir -p /etc/nginx/certs
openssl req \
-newkey rsa:4096 \
-nodes \
-keyout /etc/nginx/certs/selfsigned.key \
-x509 \
-days 365 \
-out /etc/nginx/certs/selfsigned.crt \
-subj "/C=DE/ST=Hamburg/L=Hamburg/O=SelfSigned/CN=*.localhost" > /dev/null 2>&1


# Restarting Nginx for config to take effect
echo "(Restarting Nginx for changes to take effect...)"
sudo service nginx restart > /dev/null 2>&1

echo "(Setting Ubuntu (user) password to \"vagrant\"...)"
echo "ubuntu:vagrant" | chpasswd

echo "(Setting up LimeSurvey...)"
/usr/bin/php /var/www/application/commands/console.php install admin password MainAdmin no@email.com > /dev/null 2>&1


echo "(Cleaning up additional setup files and logs...)"
sudo rm -r /var/www/html
# sudo rm /var/www/ubuntu-xenial-16.04-cloudimg-console.log

echo "+---------------------------------------------------------+"
echo "|                      S U C C E S S                      |"
echo "+---------------------------------------------------------+"
echo "|   You're good to go! You can now view your server at    |"
echo "|                 \"10.10.10.1/\" in a browser.           |"
echo "|                                                         |"
echo "|  If you haven't already, I would suggest editing your   |"
echo "|     hosts file with \"10.10.10.1  limesurvey.vagrant\"  |"
echo "|         so that you can view your server with           |"
echo "|      \"limesurvey.vagrant/\" instead of \"10.10.10.1/\" |"
echo "|                      in a browser.                      |"
echo "|                                                         |"
echo "|          You can SSH in with ubuntu / vagrant           |"
echo "|                                                         |"
echo "|        You can login to MySQL with root / root          |"
echo "+---------------------------------------------------------+"