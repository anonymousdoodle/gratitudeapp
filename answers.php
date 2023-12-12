<?php

$answer = $_POST['answer'];


$conn->query("insert into q_answers values('".$answer."')");


?>