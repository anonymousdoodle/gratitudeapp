<?php

$question = $_POST['question'];

$conn->query("insert into q_answers values('".$question."')");


?>