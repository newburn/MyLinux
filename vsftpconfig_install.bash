#!/bin/bash
#author: Su, Chin-Tsai (So Jin Zai)
#Data: 2017/12/28
#OS: CentOS 6.9
#Version: 0.1
#comment: fix every port for connection
#

declare myaccount=`whoami`
if [ $myaccount != "root" ]; then
echo 'Please executed installation with root authority !!!'
echo ' '
exit
fi

####
declare isvsftpd=`rpm -qa | grep vsftpd | wc -l`
if [ $isvsftpd<1 ]; then
echo 'Installing vsftpd from YUM'
yum -y install vsftpd >> /dev/null
fi

export today=`date +%Y%m%d`
export vsftpdfile='/etc/vsftpd/vsftpd.conf'
export vsftpdfile_backup='/etc/vsftpd/vsftpd_conf_raw'$today
if [ ! -e $vsftpdfile_backup ]; then
cp $vsftpdfile $vsftpdfile_backup
echo -n "The raw configuration file is copy to $vsftpdfile_backup ."
sleep 2
fi

echo "vsftpd Auto-Configuration Process Loading..."
sleep 2

#
#######

echo 'anonymous_enable=NO' > $vsftpdfile

##### allow local user login ######
echo 'local_enable=YES' >> $vsftpdfile

#### allow write or upload, but beware to privacy policy ######
echo 'write_enable=YES' >> $vsftpdfile

##  default authority is rwxr-xr-x  ###
echo 'local_umask=022' >> $vsftpdfile

echo 'anon_upload_enable=NO' >> $vsftpdfile
echo 'anon_mkdir_write_enable=NO' >> $vsftpdfile

echo 'dirmessage_enable=YES' >> $vsftpdfile

################################
echo 'xferlog_enable=YES' >> $vsftpdfile
echo 'xferlog_file=/var/log/xferlog' >> $vsftpdfile
echo 'xferlog_std_format=YES' >> $vsftpdfile

###################
echo 'connect_from_port_20=YES' >> $vsftpdfile
echo '#ftp_data_port=989' >> $vsftpdfile
###################################

echo 'idle_session_timeout=600' >> $vsftpdfile
echo 'data_connection_timeout=120' >> $vsftpdfile
echo 'ftpd_banner=Welcome to my FTP server' >> $vsftpdfile

#####    chroot be able to avoid to access other folders  ###  
echo 'chroot_local_user=YES' >> $vsftpdfile
echo 'chroot_list_enable=YES' >> $vsftpdfile
echo 'chroot_list_file=/etc/vsftpd/chroot_list' >> $vsftpdfile

###############
echo 'userlist_enable=YES' >> $vsftpdfile
echo 'userlist_deny=YES' >> $vsftpdfile
echo 'userlist_file=/etc/vsftpd/ftpusers' >> $vsftpdfile

####################
echo 'ls_recurse_enable=NO' >> $vsftpdfile
echo 'listen=YES' >> $vsftpdfile
echo '#listen_ipv6=YES' >> $vsftpdfile
echo 'pam_service_name=vsftpd' >> $vsftpdfile
echo 'tcp_wrappers=YES' >> $vsftpdfile

#################
echo '#listen_address=127.0.0.1' >> $vsftpdfile
echo '#max_clients=5' >> $vsftpdfile
echo '#max_per_ip=2' >> $vsftpdfile
echo '#local_max_rate=102400' >> $vsftpdfile

##### cite from https://access.redhat.com/solutions/3436 
echo 'ssl_enable=YES' >> $vsftpdfile
echo 'ssl_ciphers=HIGH' >> $vsftpdfile
###################
echo '#allow_anon_ssl=YES' >> $vsftpdfile
echo '#force_anon_data_ssl=YES' >> $vsftpdfile
echo '#force_anon_logins_ssl=YES' >> $vsftpdfile

#########
echo 'force_local_data_ssl=YES' >> $vsftpdfile
echo 'force_local_logins_ssl=YES' >> $vsftpdfile
######
echo 'ssl_tlsv1=YES' >> $vsftpdfile
echo 'ssl_tlsv1_1=YES' >> $vsftpdfile
echo 'ssl_tlsv1_2=YES' >> $vsftpdfile
echo 'ssl_sslv2=NO' >> $vsftpdfile
echo 'ssl_sslv3=NO' >> $vsftpdfile
echo 'rsa_cert_file=/etc/vsftpd/vsftpd.pem' >> $vsftpdfile
echo 'rsa_private_key_file=/etc/vsftpd/vsftpd.pem' >> $vsftpdfile

#### if ras_cert_file is none, ftpes. if true, it is ftps ####
declare mypwd=`pwd`
cd /etc/pki/tls/certs/
declare hname=`hostname`
##################
make /etc/vsftpd/vsftpd.pem << EOF >> /dev/null
MYCONTRY
MYSTATE
MYCITY
MYCORP
MYUNIT
$hostname
myemail@email.com
EOF
chmod 600 /etc/vsftpd/vsftpd.pem
################

cd $mypwd
echo 'require_ssl_reuse=NO' >> $vsftpdfile
echo 'implicit_ssl=YES' >> $vsftpdfile
echo 'listen_port=990' >> $vsftpdfile

####   pasv for firewall  #####
## default: no firewall  ####
echo 'pasv_enable=YES' >> $vsftpdfile
echo 'pasv_min_port=60010' >> $vsftpdfile
echo 'pasv_max_port=60020' >> $vsftpdfile
setsebool -P ftpd_use_passive_mode 1
iptables -A INPUT -p tcp --dport 60010:60020 -j ACCEPT

###################################
iptables -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 990 -j ACCEPT
iptables-save >> /dev/null

semanage port -a -t ftp_port_t -p tcp 990
setsebool -P ftp_home_dir 1
setsebool -P allow_ftpd_full_access 1

#################

service vsftpd restart
sleep 1
echo 'Service vsftpd configureation is done !'


