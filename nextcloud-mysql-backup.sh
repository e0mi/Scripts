#!/bin/bash

BACKUP_DIR=/backupmysql
KEEP_DAYS=30
srv=127.0.0.1
user=USER
password=PASSWORD
s=0
DATE=`date +%d-%m-%y`
containername=Cloud

docker exec -itu www-data $containername php occ maintenance:mode --on
   if [ $? -eq "0" ]; then


mysqldump -h $srv -u $user -p$password --all-databases | gzip > ${BACKUP_DIR}/${DATE}-domain.cloud.sql.gz
   if [ $? -ne "0" ]; then
        let s=$s+1
   fi

mysqldump -h $srv -u $user -p$password --all-databases > ${BACKUP_DIR}/${DATE}-domain.cloud.sql
   if [ $? -ne "0" ]; then
        let s=$s+1
   fi 
 fi
docker exec -itu www-data $containername php occ maintenance:mode --off

echo Deleting Backups older than $KEEP_DAYS Days...
find $BACKUP_DIR -type f -mtime $KEEP_DAYS -delete
   if [ $? -ne "0" ]; then
        let s=$s+1
   fi

   if [ $s -ne "0" ]; then
        exit 1
   fi