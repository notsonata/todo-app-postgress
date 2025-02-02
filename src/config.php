<?php
// config.php
function connect_with_retry($retries = 5, $delay = 2) {
    // Retrieve environment variables or use defaults
    $host = getenv('DB_HOST') ?: 'localhost';  // Default for local dev
    $user = getenv('DB_USER') ?: 'postgres';   // Default user
    $password = getenv('DB_PASSWORD') ?: '';   // Default password
    $database = getenv('DB_NAME') ?: 'todo';   // Default database name

    // Prepare the connection string
    $connection_string = sprintf(
        "host=%s dbname=%s user=%s password=%s",
        $host,
        $database,
        $user,
        $password
    );

    // Retry logic for connecting to DB
    for ($i = 0; $i < $retries; $i++) {
        try {
            $db = pg_connect($connection_string);
            if ($db) {
                pg_set_error_verbosity($db, PGSQL_ERRORS_VERBOSE);
                return $db;
            }
        } catch (Exception $e) {
            if ($i === $retries - 1) {
                die("Connection failed after {$retries} attempts: " . $e->getMessage());
            }
            sleep($delay);
        }
    }
    return false;
}

// Fetch the database URL from environment variable or use defaults
$db_url = getenv('DATABASE_URL') ?: 'postgres://postgres:password@localhost/todo';

// Attempt to connect
$db = connect_with_retry();

// Error handling if connection fails
if (!$db) {
    die("Connection failed: " . pg_last_error());
}

?>