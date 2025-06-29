#!/bin/bash
set -e

# Remove old server PID
rm -f /var/www/app/tmp/pids/server.pid

# Run the container's main command
exec "$@"
