#!/bin/bash
# -*- coding: UTF8 -*-

# Updates localization strings.
# Automatically downloads and updates your translations
# by fetching them from localize.drupal.org
# See https://www.drupal.org/project/l10n_update
drush l10n-update-refresh -y
drush l10n-update -y
