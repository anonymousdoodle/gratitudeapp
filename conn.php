<?php

    $serverHost = "localhost";
    $user = "root";
    $password = '';
    $database = "answers";

    $connectNow = new mysqli($serverHost, $user, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query to get a random question
$query = "SELECT QuestionID, question FROM q_questions ORDER BY RAND() LIMIT 1";
$result = $conn->query($query);

// Return JSON response
header('Content-Type: application/json');
echo json_encode($result->fetch_assoc());

// Close connection
$conn->close();

?>