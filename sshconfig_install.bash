#!/bin/bash
#author: Su, Chin-Tsai (So Jin Zai)
#Data: 2017/12/19
#Version: 0.3
#

declare myaccount=`whoami`
if [ $myaccount != "root" ]; then
echo 'Please executed installation with root authority !!!'
echo ' '
exit
fi

export today=`date +%Y%m%d`
export sshdfile='/etc/ssh/sshd_config'
export sshdfile_backup='/etc/ssh/sshd_config_raw'$today
if [ -e $sshdfile_backup ]; then
cp $sshdfile $sshdfile_backup
echo -n 'The raw configuration file is copy to $sshdfile_backup .'
sleep 2
fi

echo 'sshd Auto-Configuration Process Loading...'
sleep 2


#
#######
if read -t 6 -p 'sshd port number: [Default is 22] ' sshport; then
  if [ $sshport=='' ]
  then 
     declare sshport=22 
  fi
  echo  -e "port: $sshport"
else
     declare sshport=22
  echo  -e "\nport: 22"
fi

if [ $sshport != 22 ]
then  # selinux allow other port
  semanage port -a -t ssh_port_t -p tcp $sshport
  iptables -A INPUT -p tcp -dport $sshport -j ACCEPT
  iptables-save
fi

echo 'Port '$sshport > $sshdfile
######

echo '#ListenAddess 0.0.0.0'>> $sshdfile
echo '#ListenAddess ::'>> $sshdfile
echo 'Protocol 2 '>> $sshdfile

####  some bugs are going to fix  ###############
if read -t 10 -p 'Would like limits users ? [Default is no. ] ' allowuser; then
  if [ $allowuser=='' ]
  then
     declare sshuser='#AllowUsers'
     echo -e "No limited"
  else
     declare sshuser='AllowUsers '$allowuser
     echo -e "Allow $allowuser Only"
  fi
else
     declare sshuser='AllowUsers'
     echo  -e "\nNo limited"
fi


echo "$sshuser" >> $sshdfile
######

echo 'SyslogFacility AUTHPRIV' >> $sshdfile
echo 'LoginGraceTime 1m' >> $sshdfile


##########  permit root login  ############
if read -t 10 -p 'Would like to permit Root login ? [Default is no. ] ' permitroot; then
  if [ $allowuser=='' ]
  then
     declare loginuser='PermitRootLogin no'
     echo -e "Deny Root Login"
  else
     declare loginuser='PermitRootLogin yes'
     echo -e "Permit Root Login"
  fi
else
     declare loginuser='PermitRootLogin no'
     echo  -e "\nDeny Root Login"
fi


echo "$loginuser" >> $sshdfile
echo '#StrickModes yes' >> $sshdfile
echo '#MaxAuthTries 6' >> $sshdfile
echo '#MaxSessions 10' >> $sshdfile
echo 'PasswordAuthentication yes' >> $sshdfile
echo 'ChallengeResponseAuthentication no' >> $sshdfile
echo 'GSSAPIAuthentication yes' >> $sshdfile
echo 'GSSAPICleanupCredentials yes' >> $sshdfile
echo 'UsePAM yes' >> $sshdfile
echo 'AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES' >> $sshdfile
echo 'AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT' >> $sshdfile
echo 'AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE' >> $sshdfile
echo '#AllowAgentForwarding yes' >> $sshdfile
echo '#AllowTcpForwarding yes' >> $sshdfile
echo 'X11Forwarding yes' >> $sshdfile
echo '#TCPKeepAlive yes' >> $sshdfile
echo '#Compression delayed' >> $sshdfile
echo '#ClientAliveInterval 0' >> $sshdfile
echo '#ClientAliveCountMax 3' >> $sshdfile
echo '#ChrootDirectory none' >> $sshdfile
echo '#Banner none' >> $sshdfile
echo 'Subsystem       sftp    /usr/libexec/openssh/sftp-server' >> $sshdfile

echo 'Restarting sshd service ..'
service sshd restart
sleep 1
echo 'Service sshd configureation is done !'

 



