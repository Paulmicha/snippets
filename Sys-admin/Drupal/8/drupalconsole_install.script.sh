#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Drupal Console install script.
#
#   Sources :
#   https://drupalconsole.com/
#

# (as root)
curl https://drupalconsole.com/installer -L -o drupal.phar
mv drupal.phar /usr/local/bin/drupal
chmod +x /usr/local/bin/drupal

# Copy configuration files to user home directory.
# (as any user)
drupal init --override

# Note : Update DrupalConsole to the latest version.
# drupal self-update
