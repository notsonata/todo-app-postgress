<?php
// add_task.php
require_once 'config.php';

if (isset($_POST['add'])) {
    if (!empty($_POST['task'])) {
        $task = $_POST['task'];
        
        $query = "INSERT INTO task (task, status) VALUES ($1, $2)";
        $result = pg_query_params($db, $query, array($task, 'Pending'));
        
        if ($result) {
            pg_free_result($result);
            header('location: index.php');
            exit();
        } else {
            die("Error adding task: " . pg_last_error());
        }
    }
}
?>