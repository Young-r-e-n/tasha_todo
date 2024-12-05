<?php
require '../config/db.php';

// CORS headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json');

// Ensure it's a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

// Get form input from $_POST
$username = isset($_POST['username']) ? $_POST['username'] : null;
$password = isset($_POST['password']) ? $_POST['password'] : null;

// Validate input
if (empty($username) || empty($password)) {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Username and password are required']);
    exit;
}

// Hash the password before storing it
$hashedPassword = password_hash($password, PASSWORD_BCRYPT);

try {
    $stmt = $pdo->prepare('INSERT INTO users (username, password) VALUES (?, ?)');
    $stmt->execute([$username, $hashedPassword]);
    
    // Successful registration
    echo json_encode(['success' => true, 'message' => 'User registered successfully']);
} catch (PDOException $e) {
    // Check for duplicate entry
    if ($e->getCode() == 23000) {
        http_response_code(400);
        echo json_encode(['success' => false, 'message' => 'Username already exists']);
    } else {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Internal server error']);
    }
}
?>