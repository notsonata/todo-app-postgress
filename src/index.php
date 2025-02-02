<?php
// index.php
require_once 'config.php';

// Fetch tasks using prepared statement
$query = "SELECT * FROM task ORDER BY task_id ASC";
$result = pg_query_params($db, $query, array());

if (!$result) {
    die("Error in query: " . pg_last_error());
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Todo List</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>

<body>
    <nav>
        <a class="heading" href="index.php">ToDo App</a>
    </nav>
    
    <div class="container">
        <div class="input-area">
            <form method="POST" action="add_task.php">
                <input 
                    type="text" 
                    name="task" 
                    placeholder="write your tasks here..." 
                    required 
                    maxlength="250"
                >
                <button type="submit" class="btn" name="add">Add Task</button>
            </form>
        </div>

        <table class="table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Tasks</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $count = 1;
                while ($row = pg_fetch_assoc($result)) {
                    $taskId = htmlspecialchars($row['task_id']);
                    $task = htmlspecialchars($row['task']);
                    $status = htmlspecialchars($row['status']);
                ?>
                    <tr class="border-bottom">
                        <td><?php echo $count++; ?></td>
                        <td><?php echo $task; ?></td>
                        <td><?php echo $status; ?></td>
                        <td class="action">
                            <?php if ($status !== "Done") { ?>
                                <a href="update_task.php?task_id=<?php echo $taskId; ?>" 
                                   class="btn-completed"
                                   title="Mark as completed">
                                </a>
                            <?php } ?>
                                <a href="delete_task.php?task_id=<?php echo $taskId; ?>" 
                                class="btn-remove"
                                title="Delete task"
                                id="delete-btn-<?php echo $taskId; ?>"
                                onclick="handleDelete(event, <?php echo $taskId; ?>)">
                                </a>
                        </td>
                    </tr>
                <?php } ?>
            </tbody>
        </table>

        <?php if (pg_num_rows($result) === 0) { ?>
            <p class="no-tasks">No tasks found. Add a task to get started!</p>
        <?php } ?>
    </div>

    <?php
    pg_free_result($result);
    pg_close($db);
    ?>

    <script>
        function handleDelete(event, taskId) {
            event.preventDefault(); // Prevent default link behavior

            if (confirm('Are you sure you want to delete this task?')) {
                // If confirmed, proceed with deletion
                window.location.href = `delete_task.php?task_id=${taskId}`;
            } else {
                // If canceled, refresh the page to reset any issues
                window.location.href = window.location.href;

            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            const inputField = document.querySelector('input[name="task"]');
            if (inputField) {
                inputField.focus();
            }
        });
    </script>
</body>
</html>