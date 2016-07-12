<?php

/**
 * @file
 * Rewinds hook_update 'schema_version' number in system table.
 *
 * Allows to launch again previous updates.
 *
 * Usage example :
 * $ drush scr scripts/rewind_update.php
 */

// @todo make this reusable (pass args).
$version_modifier = -1;
$module_name = 'change_this_module_name';
$schema_version = db_query('SELECT schema_version FROM {system} WHERE name = :name', array(':name' => $module_name))
  ->fetchField();

if (!empty($schema_version) && $schema_version > 1) {
  $new_schema_version = $schema_version + $version_modifier;
  $num_updated = db_update('system')
    ->fields(array(
      'schema_version' => $new_schema_version,
    ))
    ->condition('name', $module_name, '=')
    ->execute();
  if ($num_updated == 1) {
    echo "$module_name's schema_version is now $new_schema_version.";
  }
  else {
    echo "Error : $module_name's schema_version could not be rewinded.";
  }
}
else {
  echo 'Error : module ' . $module_name . ' was not found in {system} table.';
}
