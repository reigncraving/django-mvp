#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Connect to DB:
python <<END
import sys
import time as t
import psycopg2

suggest_unrecoverable_after = 30
start = t.time()

while True:
    try:
        psycopg2.connect(
           dbname="${POSTGRES_DB}",
           user="${POSTGRES_USER}",
           password="${POSTGRES_PASSWORD}",
           host="${POSTGRES_HOST}",
           port="${POSTGRES_PORT}",
        )
        break
    except psycopg2.OperationalError as error:
        sys.stderr.write("Waiting for PostgreSQL to become available..\n")
        if t.time() - start > suggest_unrecoverable_after:
            sys.stderr.write("[Unrecoverable] Timeout reached: '{}'\n".format(error))
    t.sleep(1)
END

>&2 echo "🛢️ PostgreSQL is online"

# Execute the command passed as argument to this script
exec "$@"
