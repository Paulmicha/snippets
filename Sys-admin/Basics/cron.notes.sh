#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Bash basics notes : cron snippets.
#   

#   Edit current user's cron tasks.
crontab -e

#   Example :
*/10 * * * * wget -O - -q -t 1 http://my.site.com/cron.php?cron_key=foobar | /usr/bin/logger -t crontab
