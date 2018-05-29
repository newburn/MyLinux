#!/bin/bash
#
#Author: Su, CHin-Tsai
#Version: 0.8
#Goal: Installing php 7.2 on CentOS to replace default php 5.5
#reference: https://webtatic.com/packages/php72/
#
declare name=`whoami`
if [ $name != 'root' ]
then
echo "your account is $name ."
echo 'you are not a root, please swap to root by su -'
echo
exit
fi

echo -n 'Remove old default php 5.5 ...'
yum remove php-*

echo -n 'Installing epel and webstatic repository of YUM ...'
yum install epel-release
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

echo -n 'Installing mod_php72w php72w-opcache for httpd/apache  2.4'
yum install mod_php72w php72w-opcache php72w-fpm

echo -n 'Installing plug-in of php 7.2 ...'

yum install php72w-common php72w-bcmath php72w-cli php72w-devel php72w-gd php72w-imap php72w-interbase php72w-intl php72w-ldap php72w-mbstring php72w-mysqlnd php72w-odbc php72w-pecl-* php72w-mongodb php72w-pgsql php72w-phpdg php72w-process php72w-pspell php72w-recode php72w-soap php72w-tidy php72w-xml

echo -n 'Installation of php 7.2 is done.'


