<?php
// update_task.php
require_once 'config.php';

if (isset($_GET['task_id']) && is_numeric($_GET['task_id'])) {
    $task_id = intval($_GET['task_id']);
    
    $query = "UPDATE task SET status = $1 WHERE task_id = $2";
    $result = pg_query_params($db, $query, array('Done', $task_id));
    
    if ($result) {
        pg_free_result($result);
        header('location: index.php');
        exit();
    } else {
        die("Error updating task: " . pg_last_error());
    }
} else {
    die("Invalid task ID");
}
?>