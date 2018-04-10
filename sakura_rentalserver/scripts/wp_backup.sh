#!/usr/bin/env bash

LIFELIMIT_PAR_DAY=3
BACKUP_DIR=~/backup
BACKUP_FILE_SUFFIX=$(date +"%Y%m%d_%H%M%S")

if [ ! -e "${BACKUP_DIR}" ]; then
    mkdir -p ${BACKUP_DIR}
fi

cd ${BACKUP_DIR} || exit 1;
{% if usacloud.install -%}
export SACLOUD_OJS_ACCESS_KEY_ID="{{ usacloud.ojs_access_key_id|default('', true) }}"
export SACLOUD_OJS_SECRET_ACCESS_KEY="{{ usacloud.ojs_secret_access_key|default('', true) }}"
if [ -n "${SACLOUD_OJS_ACCESS_KEY_ID}" ] && [ -n "${SACLOUD_OJS_SECRET_ACCESS_KEY}" ] ; then
    echo "# ---------------------------"
    echo "# Backup old backup files(Server => Object Strage)"
    echo "# ---------------------------"
    find *.tar.gz -mtime +${LIFELIMIT_PAR_DAY} -exec ~/bin/usacloud object-storage put -y {} {} \;
fi
{% endif %}

echo "# ---------------------------"
echo "# Cleanup old backup files"
echo "# ---------------------------"
find *.tar.gz -mtime +${LIFELIMIT_PAR_DAY} -exec ls -l {} \;
find *.tar.gz -mtime +${LIFELIMIT_PAR_DAY} -exec rm {} \;

cd ~/www || exit 1;
echo "# ---------------------------"
echo "# Export WordPress database"
echo "# ---------------------------"
~/bin/wp db export ${BACKUP_DIR}/wp_database_${BACKUP_FILE_SUFFIX}.sql

cd ~/www/wp-content || exit 1;

echo "# ---------------------------"
echo "# Create archive uploads directory"
echo "# ---------------------------"
tar vcfz ${BACKUP_DIR}/wp_uploads_${BACKUP_FILE_SUFFIX}.tar.gz ./uploads/*
echo "archive file: wp_uploads_${BACKUP_FILE_SUFFIX}.tar.gz"

cd ${BACKUP_DIR} || exit 1;
echo "# ---------------------------"
echo "# Create archive Database export file"
echo "# ---------------------------"
tar vcfz wp_database_${BACKUP_FILE_SUFFIX}.tar.gz wp_database_${BACKUP_FILE_SUFFIX}.sql
echo "archive file: wp_uploads_${BACKUP_FILE_SUFFIX}.tar.gz"

echo "# ---------------------------"
echo "# Remove Database export file"
echo "# ---------------------------"
rm wp_database_${BACKUP_FILE_SUFFIX}.sql
echo "remove file: wp_database_${BACKUP_FILE_SUFFIX}.sql"

exit 0;
