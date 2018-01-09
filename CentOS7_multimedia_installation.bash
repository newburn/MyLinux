#!/bin/bash
#author: Su, Chin-Tsai(So Jin Zai)
#Date: 2018/01/08
#Version: 0.1
#cite form https://wiki.centos.org/TipsAndTricks/MultimediaOnCentOS7
#

declare myaccount=`whoami`
if [ $myaccount != "root" ]; then
  echo 'Please executed installation with root authority !!!'
  echo 'eg. sudo or su -'
  echo ' '
  exit
fi


#echo -n 'Installing rpmfusion-free and rpmfusion-nofree repository...'
#yum -y install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm >> /dev/null
#yum -y install https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm >> /dev/null
#echo ''

echo -n 'Installing nux-dextop repository...'
yum -y install http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm >> /dev/null
echo ''

echo -n "Installing adobe repository..."
yum -y install http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm >> /dev/null
echo ''
echo -n "Installing flash-plugin..."
yum -y install flash-plugin >> /dev/null
echo ''
echo -n "Installing java plugin for Firefox..."
yum -y install icedtea-web >> /dev/null
echo ''
echo -n "Installing Handbrake, VLC and smplayer..."
yum -y install vlc smplayer ffmpeg HandBrake-{gui,cli} >> /dev/null
echo ''
echo -n "Installing gstreamer libs..."
yum -y install libdvdcss gstreamer{,1}-plugins-ugly gstreamer-plugins-bad-nonfree gstreamer1-plugins-bad-freeworld >> /dev/null
echo ''
echo "The Installation process is done. "

