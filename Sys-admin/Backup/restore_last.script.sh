#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Manual DB dump custom script : restore last
#   
#   Installation :
#   $ nano dump.sh
#       (copy/paste this file contents + save)
#   $ chmod u+x restore_last.sh
#   
#   Usage :
#   $ cd path/to/docroot
#   $ ../scripts/restore_last.sh
#   

DOCROOT="../docroot"
DUMP_DIR="../db_dumps"

DB="drupal-7"
DB_U="drupal"
DB_P="paul2015"


cd $DUMP_DIR
DUMP_FILE_RAW="$(ls -t | head -1)"
if ! [ -f $DUMP_FILE_RAW ] ; then
    echo "No DB dump file found."
    exit
fi

#   Requires double extension ".sql.tgz" + uncompressed file ".sql"
DUMP_FILE="${DUMP_FILE_RAW%.*}"

echo "Restoring DB dump ${DUMP_FILE}..."

tar xzf $DUMP_FILE_RAW
mysqldump -u$DB_U -p$DB_P --add-drop-table --no-data $DB | grep ^DROP | mysql -u$DB_U -p$DB_P $DB
mysql -h localhost -u$DB_U -p$DB_P --default_character_set=utf8 $DB < $DUMP_FILE
rm $DUMP_FILE

cd $DOCROOT

echo "Restored ${DUMP_FILE} successfully."

