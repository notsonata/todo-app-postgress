#!/bin/bash
set -e

# Function to initialize the database
init_database() {
    echo "Waiting for PostgreSQL to be ready..."
    sleep 5

    if [ -n "$DATABASE_URL" ]; then
        # Production mode (Render)
        if [[ $DATABASE_URL =~ ^postgresql://([^:]+):([^@]+)@([^/]+)/(.+)$ ]]; then
            USER="${BASH_REMATCH[1]}"
            PASS="${BASH_REMATCH[2]}"
            HOST="${BASH_REMATCH[3]}"
            DB="${BASH_REMATCH[4]}"

            echo "Production mode: Connecting to Render PostgreSQL..."
            PGPASSWORD="$PASS" psql "$DATABASE_URL" -f /docker-entrypoint-initdb.d/init.sql
        else
            echo "Invalid DATABASE_URL format"
            echo "Expected format: postgresql://username:password@host/database"
            exit 1
        fi
    else
        # Local development mode
        echo "Local development mode: Connecting to Docker PostgreSQL..."
        # Wait for local PostgreSQL to be ready
        until PGPASSWORD=postgrespass psql -h db -U postgres -d todo -c '\q' 2>/dev/null; do
            echo "PostgreSQL is unavailable - sleeping"
            sleep 1
        done

        echo "PostgreSQL is up - executing init script"
        PGPASSWORD=postgrespass psql -h db -U postgres -d todo -f /docker-entrypoint-initdb.d/init.sql
    fi
}

# Initialize the database
init_database

# Start Apache in foreground
echo "Starting Apache..."
apache2-foreground