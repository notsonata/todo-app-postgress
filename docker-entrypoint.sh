#!/bin/bash
set -e

# Function to initialize the database
init_database() {
    echo "Waiting for PostgreSQL to be ready..."
    sleep 5

    if [ -n "$DATABASE_URL" ]; then
        # Use proper URL parsing
        if [[ $DATABASE_URL =~ ^postgres://([^:]+):([^@]+)@([^:]+):([^/]+)/(.+)$ ]]; then
            USER="${BASH_REMATCH[1]}"
            PASS="${BASH_REMATCH[2]}"
            HOST="${BASH_REMATCH[3]}"
            PORT="${BASH_REMATCH[4]}"
            DB="${BASH_REMATCH[5]}"

            echo "Attempting database connection..."
            echo "Host: $HOST"
            echo "Port: $PORT"
            echo "Database: $DB"
            echo "User: $USER"
            
            export PGPASSWORD="$PASS"
            psql "postgresql://$USER:$PASS@$HOST:$PORT/$DB" -f /docker-entrypoint-initdb.d/init.sql
        else
            echo "Invalid DATABASE_URL format"
            exit 1
        fi
    else
        echo "DATABASE_URL not set. Skipping database initialization."
    fi
}

# Initialize the database
init_database

# Start Apache in foreground
echo "Starting Apache..."
apache2-foreground