<?php
$host = 'localhost';
$db = 'todo_app';
$user = 'root'; // Default MySQL user
$password = ''; // Default MySQL password

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Connection failed: " . $e->getMessage());
}
?>
