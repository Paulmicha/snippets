<?php

// Source : https://www.drupal.org/node/1545298

// Queue node for reindexing by apachesolr.
// Happens on next cron or next manual (re)indexing.
// @see admin/config/search/apachesolr
$id = 123;
$type = 'node';
$bundle = 'node_type';
$indexer_table = apachesolr_get_indexer_table($type);
db_merge($indexer_table)
  ->key(array(
    'entity_type' => $type,
    'entity_id' => $id,
  ))
  ->insertFields(array(
    'entity_type' => $type,
    'entity_id' => $id,
    'bundle' => $bundle,
    'status' => 1,
  ))
  ->fields(array(
    'changed' => REQUEST_TIME,
  ))
  ->execute();
