<?php
function connect_with_retry($retries = 5, $delay = 2) {
    $database_url = getenv('DATABASE_URL');
    
    if ($database_url) {
        // Parse Render's DATABASE_URL
        $db_parts = parse_url($database_url);
        $host = $db_parts['host'];
        $port = $db_parts['port'] ?? '5432';
        $user = $db_parts['user'];
        $password = $db_parts['pass'];
        $database = ltrim($db_parts['path'], '/');
        
        $connection_string = sprintf(
            "host=%s port=%s dbname=%s user=%s password=%s sslmode=require",
            $host,
            $port,
            $database,
            $user,
            $password
        );
    } else {
        // Local development fallback
        $connection_string = "host=db dbname=todo user=postgres password=postgrespass";
    }

    for ($i = 0; $i < $retries; $i++) {
        $db = @pg_connect($connection_string);
        if ($db) {
            pg_set_error_verbosity($db, PGSQL_ERRORS_VERBOSE);
            return $db;
        }
        if ($i < $retries - 1) {
            sleep($delay);
        }
    }
    
    die("Failed to connect to the database after {$retries} attempts.");
}

$db = connect_with_retry();