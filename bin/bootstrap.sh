#!/usr/bin/env bash

#general upadte
apt-get update
apt-get -y upgrade

#install Apache
apt-get install -y apache2

#replace default html dir with link to drupal docroot
if ! [ -L /var/www ]; then
  rm -rf /var/www/html
  ln -fs /vagrant/PROJECT/docroot /var/www/html
fi

#enable ssl and other Apache bits
a2enmod ssl
a2enmod headers
a2ensite default-ssl
a2enmod rewrite

#install PHP
add-apt-repository ppa:ondrej/php
apt-get install -y php7.3 php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-mysql php7.3-mbstring php7.3-zip php7.3-fpm php7.3-intl php7.3-simplexml php7.3-gd php7.3-curl
apt-get install -y libapache2-mod-php7.3

#install composer
apt-get install -y composer

#install MySql
apt-get install -y mysql-server

#DB set up - this part takes a while
mysql -u root -s < /vagrant/bin/setdrupaluser.sql
mysql -u drupal "-pdrupal" -s < /vagrant/bin/resetcmdb.sql

#Copy web files into place (excluded from git)
tar -zxf /vagrant/files.tar.gz -C /vagrant/PROJECT/docroot/
chmod 777 -R /vagrant/PROJECT/docroot/sites/default/files

#Copy misc dev files into place
#make sure you have a settings.local.php with correct settings to copy into place
cp /vagrant/xfiles/settings.local.php /vagrant/PROJECT/docroot/sites/default/.

# ** If you are testing provisioning/destroying your environment over and over, you can get copies of these files from an Ubuntu Apache install and add below **
#these cert files are here only as a convenince to not have to accept new self-signed cert in browser each time if doing multiple vagrant destroys / ups
# cp /vagrant/xfiles/ssl-cert-snakeoil.pem /etc/ssl/certs/.
# cp /vagrant/xfiles/ssl-cert-snakeoil.key /etc/ssl/private/.

#Modify apache conf to allow redirects
sed -ri 's!AllowOverride None!AllowOverride All!g' /etc/apache2/apache2.conf

#restart apache
systemctl restart apache2

#Call update.php page to initialize DB
curl -k --silent -o /dev/null https://localhost/update.php
curl -k --silent -o /dev/null https://localhost/update.php/selection