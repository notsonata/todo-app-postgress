#!/bin/bash
set -e

# Function to initialize the database
init_database() {
    echo "Waiting for PostgreSQL to be ready..."
    sleep 5

    if [ -n "$DATABASE_URL" ]; then
        # Use regex pattern that matches Render's PostgreSQL URL format
        if [[ $DATABASE_URL =~ ^postgresql://([^:]+):([^@]+)@([^/]+)/(.+)$ ]]; then
            USER="${BASH_REMATCH[1]}"
            PASS="${BASH_REMATCH[2]}"
            HOST="${BASH_REMATCH[3]}"
            DB="${BASH_REMATCH[4]}"

            echo "Attempting database connection..."
            echo "Host: $HOST"
            echo "Database: $DB"
            echo "User: $USER"
            
            # Use the full DATABASE_URL directly
            PGPASSWORD="$PASS" psql "$DATABASE_URL" -f /docker-entrypoint-initdb.d/init.sql
        else
            echo "Invalid DATABASE_URL format"
            echo "Expected format: postgresql://username:password@host/database"
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