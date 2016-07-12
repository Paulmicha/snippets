#!/bin/bash
# -*- coding: UTF8 -*-

##
#   MySQL Dump all available databases in specified folder.
#   
#   Usage :
#   $ ./mass_dump.script.sh
#   $ ./mass_dump.script.sh $/my_dumps my_username mysql_password
#   

TIMESTAMP="$(date +%F-%H.%M.%S)"


#   Arg 1 : Path to dump files
DUMP_DIR=$1
if [[ -z $1 ]]; then
    echo -n "Enter path where to dump files : "
    read DUMP_DIR
fi

#   Arg 2 : MySQL User
DB_U=$2
if [[ -z $2 ]]; then
    echo -n "Enter MySQL User : "
    read DB_U
fi

#   Arg 3 : MySQL Password
DB_P=$3
if [[ -z $3 ]]; then
    echo -n "Enter MySQL Password : "
    read -s DB_P
fi


#   Fetch all database names.
#   @evol add param for filtering out some databases ?
DBS=`mysql -u$DB_U -p$DB_P -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)"`

#   Count them.
DBS_LEN=0
for DB in $DBS; do
    ((DBS_LEN++))
done

#   Confirm.
echo "Detected ${DBS_LEN} databases :"
for DB in $DBS; do
    echo "  ${DB}"
done
read -p "Y or N : proceed with dumping all ${DBS_LEN} databases in ${DUMP_DIR} ?" -n 1 -r
echo

#   Execute mass dump.
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "→ Starting mass dump."
    echo
    COUNT=0
    for DB in $DBS; do
      ((COUNT++))
      DUMP_FILE="${DB}-$(date +%F-%H.%M.%S).sql"
      echo "Step ${COUNT} / ${DBS_LEN}"
      #   Dump.
      echo "Dumping ${DUMP_FILE} ..."
      mysqldump --force -u$DB_U -p$DB_P $DB > $DUMP_FILE
      #   Compress.
      echo "Compressing to ${DUMP_FILE}.tgz ..."
      tar czf "${DUMP_FILE}.tgz" $DUMP_FILE
      #   Remove uncompressed file.
      rm $DUMP_FILE
      echo "Done."
      echo
    done
    echo "Finished dumping ${COUNT} databases."
    echo
fi
