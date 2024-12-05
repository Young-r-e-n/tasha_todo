<?php
require '../config/db.php';

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

$method = $_SERVER['REQUEST_METHOD'];

try {
    switch ($method) {
        case 'POST': // Create
            if (!isset($_POST['title'])) {
                http_response_code(400);
                echo json_encode(['success' => false, 'message' => 'Title is required']);
                exit;
            }
            $title = $_POST['title'];
            $completed = isset($_POST['completed']) ? $_POST['completed'] : 0;

            $stmt = $pdo->prepare('INSERT INTO todos (title, completed) VALUES (?, ?)');
            $stmt->execute([$title, $completed]);
            echo json_encode(['success' => true, 'message' => 'Todo created']);
            break;

        case 'GET': // Read
            $stmt = $pdo->query('SELECT * FROM todos');
            $todos = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(['success' => true, 'todos' => $todos]);
            break;
            case 'PUT': // Update
                parse_str(file_get_contents('php://input'), $putData);
                if (!isset($putData['id']) || !isset($putData['title'])) {
                    http_response_code(400);
                    echo json_encode(['success' => false, 'message' => 'ID and Title are required']);
                    exit;
                }
                $id = $putData['id'];
                $title = $putData['title'];
                $completed = isset($putData['completed']) ? intval($putData['completed']) : 0; // Ensure it's an integer
    
                error_log("Updating Todo - ID: $id, Title: $title, Completed: $completed"); // Debugging log
    
                $stmt = $pdo->prepare('UPDATE todos SET title = ?, completed = ? WHERE id = ?');
                $stmt->execute([$title, $completed, $id]);
                echo json_encode(['success' => true, 'message' => 'Todo updated']);
                break;

        case 'DELETE': // Delete
            parse_str(file_get_contents('php://input'), $deleteData);
            if (!isset($deleteData['id'])) {
                http_response_code(400);
                echo json_encode(['success' => false, 'message' => 'ID is required']);
                exit;
            }
            $id = $deleteData['id'];

            $stmt = $pdo->prepare('DELETE FROM todos WHERE id = ?');
            $stmt->execute([$id]);
            echo json_encode(['success' => true, 'message' => 'Todo deleted']);
            break;

        default:
            http_response_code(405);
            echo json_encode(['success' => false, 'message' => 'Method not allowed']);
            break;
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Internal server error']);
}
