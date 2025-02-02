<?php
// config.php
function connect_with_retry($database_url, $retries = 5, $delay = 2) {
    $db_parts = parse_url($database_url);
    $host = $db_parts['host'] ?? 'localhost';
    $user = $db_parts['user'] ?? 'postgres';
    $password = $db_parts['pass'] ?? '';
    $database = ltrim($db_parts['path'], '/');

    $connection_string = sprintf(
        "host=%s dbname=%s user=%s password=%s",
        $host,
        $database,
        $user,
        $password
    );

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


$db = connect_with_retry(
    getenv('DATABASE_URL') ?: 'postgres://postgres@localhost/todo' // Default for local dev
);


if (!$db) {
    die("Connection failed: " . pg_last_error());
}
?>