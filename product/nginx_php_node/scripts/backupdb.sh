#!/bin/bash
DATE=$(date +%d-%m-%Y)
BACKUP_DIR="/var/www/backup"
BACKUP_DIR=$(printenv | grep BACKUP_DIR | cut -d "=" -f 2)
MYSQL_USER=$(printenv | grep MYSQL_USER | cut -d "=" -f 2)
MYSQL_PASSWORD=$(printenv | grep MYSQL_PASSWORD | cut -d "=" -f 2)
MYSQL_ROOT_HOST=$(printenv | grep MYSQL_ROOT_HOST | cut -d "=" -f 2)


mkdir -p ${BACKUP_DIR}/${DATE}
databases=`mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h ${MYSQL_ROOT_HOST} -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema)"`

for db in $databases
do
echo $db
mysqldump --force --opt --user=${MYSQL_USER} -p${MYSQL_PASSWORD} -h ${MYSQL_ROOT_HOST} --databases ${db} | gzip > "${BACKUP_DIR}/${DATE}/${db}.sql.gz"
done
find ${BACKUP_DIR}/* -mtime +10 -exec rm {} \;
