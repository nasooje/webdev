<?php

$servername = "172.26.0.7";
$username = "pipe";
$password = "vkdlvm1357!#%&";
$dbname = "pipe";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("데이터베이스 연결에 실패했습니다. 관리자에게 문의해주세요.");
}

$sql = "SELECT name, is_run FROM status";
$result = $conn->query($sql);
$results = array();
while ($row = $result->fetch_assoc()) {
    $name = $row["name"];
    $is_run = $row["is_run"];
    
    if ($is_run) {
        $random_number = "ON";
    } else {
        $random_number = "OFF";
    }
    
    $results[$name] = $random_number;
}

$conn->close();
echo json_encode($results);

?>