#!/usr/bin/env bash

LIFELIMIT_PAR_DAY=3
BACKUP_DIR=${HOME}/backup
BACKUP_DATE=$(date +"%Y%m%d")
BACKUP_TIME=$(date +"%H%M%S")
BACKUP_DATETIME="${BACKUP_DATE}_${BACKUP_TIME}"

if [ ! -e "${BACKUP_DIR}" ]; then
    mkdir -p ${BACKUP_DIR}
fi

cd ${BACKUP_DIR} || exit 1;

# export SACLOUD_OJS_ACCESS_KEY_ID="[YOUR_BUCKET_ACCESS_KEY]"
# export SACLOUD_OJS_SECRET_ACCESS_KEY="[YOUR_BUCKET_SECRET_KEY]"
# echo "# ---------------------------"
# echo "# Backup old backup files(Server => Object Strage)"
# echo "# ---------------------------"
# find *.tar.gz -mtime +${LIFELIMIT_PAR_DAY} -exec ${HOME}/bin/usacloud object-storage put -y {} {} \;

echo "# ---------------------------"
echo "# Cleanup old backup files"
echo "# ---------------------------"
find *.tar.gz -mtime +${LIFELIMIT_PAR_DAY} -exec ls -l {} \;
find *.tar.gz -mtime +${LIFELIMIT_PAR_DAY} -exec rm {} \;

cd ${HOME}/www || exit 1;
echo "# ---------------------------"
echo "# Export WordPress database"
echo "# ---------------------------"
${HOME}/bin/wp db export ${BACKUP_DIR}/wp_backup_${BACKUP_DATETIME}_database.sql

cd ${HOME}/www/wp-content || exit 1;

echo "# ---------------------------"
echo "# Create archive uploads directory"
echo "# ---------------------------"
tar vcfz ${BACKUP_DIR}/wp_backup_${BACKUP_DATETIME}_uploads.tar.gz ./uploads/*
echo "archive file: wp_backup_${BACKUP_DATETIME}_uploads.tar.gz"

cd ${BACKUP_DIR} || exit 1;
echo "# ---------------------------"
echo "# Create archive Database export file"
echo "# ---------------------------"
tar vcfz wp_backup_${BACKUP_DATETIME}_database.tar.gz wp_backup_${BACKUP_DATETIME}_database.sql
echo "archive file: wp_backup_${BACKUP_DATETIME}_database.tar.gz"

echo "# ---------------------------"
echo "# Remove Database export file"
echo "# ---------------------------"
rm wp_backup_${BACKUP_DATETIME}_database.sql
echo "remove file: wp_backup_${BACKUP_DATETIME}_database.sql"

echo "# ---------------------------"
echo "# All Backup files"
echo "# ---------------------------"
ls -l

exit 0;
