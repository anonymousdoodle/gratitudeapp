<?php

include 'questions.php';

$query = $db->query("SELECT * FROM q_questions");

while($rowData = $query->fetch_assoc()){
    $result[] = $rowData;
}

echo json_encode($result);

?>