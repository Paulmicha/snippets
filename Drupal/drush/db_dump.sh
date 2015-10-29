#!/bin/bash
# -*- coding: UTF8 -*-

#   DB script : make dump + (over)write last dump file copy.
#   @todo make this reusable : pass instance as argument,
#   or use docroot's parent folder name (as instance name).
INSTANCE="www.example.com"
DOCROOT="/var/www/$INSTANCE/docroot"
cd $DOCROOT
newrev=$(git log --pretty=format:'%H' -n 1)

DUMP_DIR="$HOME/$INSTANCE/dumps/$(date +%Y)/$(date +%m)/$(date +%d)"
DUMP_FILE="${DUMP_DIR}/$(date +%H)-$(date +%M)-$(date +%S)-${newrev:0:8}.sql"
DUMP_FILE_LAST="$HOME/$INSTANCE/dumps/last.sql.gz"

if [ ! -d $DUMP_DIR ]; then
  mkdir -p $DUMP_DIR
fi

drush sql-dump --gzip --root=$DOCROOT --result-file=$DUMP_FILE --structure-tables-list="cache*,history,watchdog"
cp -f "$DUMP_FILE.gz" $DUMP_FILE_LAST
