#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Bash script : init user drushrc "dynamization".
#
#   Setup a script in current user's home dir to allow automatically loading
#   custom drushrc, commands and aliases from any git repo dir with a /drush
#   sub-folder present.
#
#   Example project :
#   /path/to/project/
#       ├── .git/
#       │   └── ...
#       ├── ...
#       └── drush/
#           ├── aliases/
#           │   └── ...
#           ├── commands/
#           │   └── ...
#           └── drushrc.php
#
#   Example usage : install drush-patchfile.
#   $ git clone git@bitbucket.org:davereid/drush-patchfile.git /path/to/project/drush/commands
#
#   Tested on Debian 8 "Jessie"
#   @timestamp 2015/08/29 15:08:24
#
#   Sources :
#   https://github.com/Lullabot/drupal-boilerplate
#   http://grayside.org/node/93
#   https://bitbucket.org/davereid/drush-patchfile
#   

#   Connected as the user who will need this setup, e.g. current project's.
if [ ! -d "$HOME/.drush" ]; then
    mkdir "$HOME/.drush"
fi

cat > "$HOME/.drush/drushrc.php" <<'EOF'
<?php
// Load a drushrc.php file from the 'drush' folder at the root of the current
// git repository. Customize as desired.
// (Script by grayside; @see: http://grayside.org/node/93)
$repo_dir = drush_get_option('root') ? drush_get_option('root') : getcwd();
$success = drush_shell_exec('cd %s && git rev-parse --show-toplevel 2> ' . drush_bit_bucket(), $repo_dir);
if ($success) {
  $output = drush_shell_exec_output();
  $repo = $output[0];
  $options['config'] = $repo . '/drush/drushrc.php';
  $options['include'] = $repo . '/drush/commands';
  $options['alias-path'] = $repo . '/drush/aliases';
}
EOF
