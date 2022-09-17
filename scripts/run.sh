#!/bin/bash
set -e

# Restore the database if it does not already exist.
if [ -f /pb_data/data.db ]; then
	echo "Database already exists, skipping restore"
else
	echo "No database found, restoring from replica if exists"
	litestream restore -v -if-replica-exists -o /pb_data/data.db "${REPLICA_URL}"
fi

# Run litestream with your app as the subprocess.
exec litestream replicate -exec '/usr/local/bin/pocketbase --dir /pb_data serve --http="127.0.0.1:8080" --https="127.0.0.1:8080"'