#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Manual DB dump custom script
#   
#   Installation :
#   $ nano dump.sh
#       (copy/paste this file contents + save)
#   $ chmod u+x dump.sh
#   
#   Usage :
#   $ cd path/to/docroot
#   $ ../scripts/dump.sh
#   

DOCROOT="../docroot"
DUMP_DIR="../db_dumps"
INSTANCE_NAME="Drupal-7-0.12-Local-Paul"
DUMP_FILE="${INSTANCE_NAME}-$(date +%F-%H.%M.%S)"

DB="drupal-7"
DB_U="drupal"
DB_P="paul2015"

echo "Creating DB dump ${DUMP_FILE}..."

cd $DUMP_DIR
mysqldump -u$DB_U -p$DB_P $DB > "${DUMP_FILE}.sql"
tar czf "${DUMP_FILE}.sql.tgz" "${DUMP_FILE}.sql"
rm "${DUMP_FILE}.sql"
cd $DOCROOT

echo "Created ${DUMP_FILE}.sql.tgz successfully."
