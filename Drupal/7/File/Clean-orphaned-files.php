<?php

/**
 *  Remove files no longer in use,
 *  physically & in DB
 *  
 *  Sources :
 *  https://www.drupal.org/node/733258#comment-7427898
 */

//      Ex: with devel module, path /devel/php
//      copy/paste :
$result = db_query("SELECT fid FROM file_managed WHERE NOT EXISTS (SELECT * FROM file_usage WHERE file_managed.fid = file_usage.fid)");
for ($i = 1; $i <= $result->rowCount(); $i++) {
  $record = $result->fetchObject();
  $file = file_load($record->fid);
  if ($file != NULL) {
    file_delete($file);
  }
}

