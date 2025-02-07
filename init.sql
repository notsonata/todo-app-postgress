CREATE TABLE IF NOT EXISTS task (
    task_id SERIAL PRIMARY KEY,
    task VARCHAR(250) NOT NULL,
    status VARCHAR(30) NOT NULL
);

-- Insert initial data
INSERT INTO task (task_id, task, status) VALUES
    (1, 'Read an article on React.js', 'Done'),
    (2, 'Organize a meeting', 'Pending')
ON CONFLICT (task_id) DO NOTHING;

-- Reset the sequence to continue from our last insert
SELECT setval('task_task_id_seq', 3, false);