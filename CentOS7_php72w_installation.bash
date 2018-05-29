#!/bin/bash
#
#Author: Su, CHin-Tsai(So Jin Zai)
#Date: 2018/05/29
#Version: 0.3
#Goal: Installing php 7.2 on CentOS to replace default php 5.5
#reference: https://webtatic.com/packages/php72/
#remark: 0.3: add systemctl restart  php-fpm and systemctl restart httpd
#
declare myaccount=`whoami`
if [ $myaccount != "root" ]; then
  echo 'Please executed installation with root authority !!!'
  echo 'eg. sudo or su -'
  echo ' '
  exit
fi

echo -n 'Remove old default php 5.5 ...'
yum -y remove php-* >> /dev/null

echo -n 'Installing epel and webstatic repository of YUM ...'
yum -y install epel-release >> /dev/null
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm >> /dev/null

echo -n 'Installing mod_php72w php72w-opcache for httpd/apache  2.4'
yum install mod_php72w php72w-opcache php72w-fpm

echo -n 'Installing plug-in of php 7.2 ...'

yum -y install php72w-common php72w-bcmath php72w-cli php72w-devel php72w-gd php72w-imap php72w-interbase php72w-intl php72w-ldap php72w-mbstring php72w-mysqlnd php72w-odbc php72w-pecl-* php72w-mongodb php72w-pgsql php72w-phpdg php72w-process php72w-pspell php72w-recode php72w-soap php72w-tidy php72w-xml >> /dev/null

echo -n 'Restarting php-fpm and httpd/apache, please remember customize your php.ini'
systemctl restart php-fpm
systemctl restart httpd

echo -n 'Installation of php 7.2 is done.'


