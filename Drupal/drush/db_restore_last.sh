#!/bin/bash
# -*- coding: UTF8 -*-

#   DB script : restore last dump.
#   @todo make this reusable : pass instance as argument,
#   or use docroot's parent folder name (as instance name).
INSTANCE="www.example.com"
DOCROOT="/var/www/$INSTANCE/docroot"
DUMP_FILE_LAST="$HOME/$INSTANCE/dumps/last.sql.gz"
drush sql-drop -y --root=$DOCROOT
drush sql-query --file=$DUMP_FILE_LAST --root=$DOCROOT

#   Dear drush sql-query : who asked you to leave the file unzipped behind ?
gzip "$HOME/$INSTANCE/dumps/last.sql"
