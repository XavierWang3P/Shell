#!/bin/bash

# 环境变量
Current_Time=$(date +"%y%m%d")

# 备份存储文件夹、数据库、网站文件夹位置信息
Backup_Dir="/www/wwwbackup"
COS_Backup_Dir="Sites-Backup"

Websites_Dir="/www/wwwroot"
Websites_Select=("网站域名")
Nginx_Conf="/etc/nginx/sites-enabled"
SSL_Cert="/etc/nginx/ssl"

Database_Dir="/usr/local/mysql/bin/mysqldump"
Database_Select=("数据库名")
MySQL_Username='数据库用户名'
MySQL_Password='数据库密码'
MySQL_Port="3306"
MySQL_Host="localhost"


# 准备环境
mkdir -p $Backup_Dir/$Current_Time
mkdir -p $Backup_Dir/$Current_Time/Temp_Dir


# 备份网站
for websites in "${Websites_Select[@]}"
do
#       tar --totals=SIGUSR1 -czf $Backup_Dir/$Current_Time/Backup-${websites}-$Current_Time.tar.gz $Websites_Dir/${websites}
        7z a $Backup_Dir/$Current_Time/Backup-${websites}-$Current_Time.7z $Websites_Dir/${websites}
done


# 备份数据库
for databases in "${Database_Select[@]}"
do
        mysqldump -u$MySQL_Username -p$MySQL_Password -h$MySQL_Host -P$MySQL_Port ${databases} > $Backup_Dir/$Current_Time/Temp_Dir/${databases}.sql
done

# tar --totals=SIGUSR1 -czf $Backup_Dir/$Current_Time/Backup-Database-$Current_Time.tar.gz $Backup_Dir/$Current_Time/Temp_Dir/*.sql
7z a $Backup_Dir/$Current_Time/Backup-Database-$Current_Time.7z $Backup_Dir/$Current_Time/Temp_Dir/*.sql
rm -rf $Backup_Dir/$Current_Time/Temp_Dir


# 备份 Nginx 配置文件
7z a $Backup_Dir/$Current_Time/Backup-NginxConf-$Current_Time.7z $Nginx_Conf/*.conf
7z a $Backup_Dir/$Current_Time/Backup-SSLCert-$Current_Time.7z $SSL_Cert/*


# 将备份文件上传至 COS Bucket
coscmd upload -r $Backup_Dir/$Current_Time $COS_Backup_Dir/$Current_Time


# 删除 30 天前的本地备份文件
find $Backup_Dir -mtime +30 | xargs rm -rvf