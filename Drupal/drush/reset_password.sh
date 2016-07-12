#!/bin/bash
# -*- coding: UTF8 -*-

# Resets "admin" user password.
drush upwd admin --password="admin"

# Gets an admin one-time login link.
drush uli
