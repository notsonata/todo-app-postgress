<?php
// delete_task.php
require_once 'config.php';

if (isset($_GET['task_id']) && is_numeric($_GET['task_id'])) {
    $task_id = intval($_GET['task_id']);
    // Debugging line - remove or comment out
    // echo "Deleting task with ID: $task_id<br>";

    $query = "DELETE FROM task WHERE task_id = $1";
    $result = pg_query_params($db, $query, array($task_id));
    
    if ($result) {
        pg_free_result($result);
        // Debugging line - remove or comment out
        // echo "Task deleted successfully. Redirecting to index.php...<br>";
        header("Location: index.php");
        exit();
    } else {
        die("Error deleting task: " . pg_last_error());
    }
} else {
    die("Invalid task ID");
}
?>