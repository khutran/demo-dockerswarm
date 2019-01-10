#!/bin/bash
# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /tmp/supervisor*
exec /usr/sbin/php-fpm --nodaemonize &
exec supervisord -c /etc/supervisord.conf
