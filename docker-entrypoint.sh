#!/bin/bash
set -e

# Function to initialize the database
init_database() {
    # Wait for a few seconds to ensure database is ready
    echo "Waiting for PostgreSQL to be ready..."
    sleep 5

    if [ -n "$DATABASE_URL" ]; then
        # Parse the DATABASE_URL
        USER=$(echo $DATABASE_URL | awk -F[:@] '{print $2}' | sed 's/\/\///')
        PASS=$(echo $DATABASE_URL | awk -F[:@] '{print $3}')
        HOST=$(echo $DATABASE_URL | awk -F[:@/] '{print $4}')
        PORT=$(echo $DATABASE_URL | awk -F[:@/] '{print $5}')
        DB=$(echo $DATABASE_URL | awk -F[:@/] '{print $6}')

        echo "Initializing database..."
        PGPASSWORD=$PASS psql -h $HOST -p $PORT -U $USER -d $DB -f /docker-entrypoint-initdb.d/init.sql
    else
        echo "DATABASE_URL not set. Skipping database initialization."
    fi
}

# Initialize the database
init_database

# Start Apache in foreground
echo "Starting Apache..."
apache2-foreground