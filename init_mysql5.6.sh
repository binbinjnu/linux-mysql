#!/bin/bash
#1. check if download the mysql rpm package,if not,download

ql_rpm_package=`find / -name "mysql*release*rpm*"`  
mysql_rpm_package_name=mysql*release*rpm*  
if [ `find / -name "mysql*release*rpm*"|wc -l` -ne 0 ];then  
	echo -e "yes,you have the mysql rpm package,it's in :\n$mysql_rpm_package\n"  
else    
	echo -e "you don't have the mysql rpm pakage,now we start download\n------------------------"  
	wget https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm  
	echo -e "complete download mysql rpm\n"  
fi  

#2. check if install local mysql rpm ,if not,install

if [ `rpm -qa|grep mysql_rpm_package_name|wc -l` -ge 1 ];then  
	echo -e "yes,you have installed local mysql rpm:"  
	rpm -qa | grep mysql_rpm_package_name  
	echo  
else  
	echo -e "begin install rpm kagage\n-------------------------"  
	yum localinstall -y mysql57-community-release-el7-11.noarch.rpm  
	echo -e "complete install mysql rpm package,these are mysql in yum repository list:"  
	yum repolist enabled|grep mysql  
	echo  
fi  

# 3.check if install mysql,if not,install

if [ `rpm -qa|grep mysql|wc -l` -gt 1 ];then  
    echo -e "yes,you have installed mysql:"  
    rpm -qa |grep mysql  
    echo  
else  
    echo -e "you don't install mysql,now we start install mysql\n-----------------------"  
    yum install -y mysql-community-server  
    echo -e "complete install mysql,these are the all installed:"  
    rpm -qa|grep mysql  
    echo  
fi  

#4. start mysql

echo -e "start mysql"  
systemctl start mysqld  
echo -e "mysql has started\n"  

#5. set mysql start when we start the CentOS

echo -e "set mysql start when we start the CentOS"  
systemctl enable mysqld  
systemctl daemon-reload  
echo -e "set succeed\n"  

# 6.show root initial password

USERNAME=root  
INITIAL_PASSWORD=$(awk '/temporary password/{print $NF}' /var/log/mysqld.log)  
echo -e "your initial mysql password for root is:\n$INITIAL_PASSWORD"  

mysql -uroot -p$INITIAL_PASSWORD<< EOF

set global validate_password_policy=LOW;
set global validate_password_length=6;
alter user user() identified by "123456";

CREATE USER 'leishen'@'localhost' IDENTIFIED BY 'leishen123456';
GRANT ALL ON *.* TO 'leishen'@'localhost';
CREATE USER 'leishen'@'%' IDENTIFIED BY 'leishen123456';
GRANT ALL ON *.* TO 'leishen'@'%';

EOF

