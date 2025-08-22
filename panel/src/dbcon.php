<?php

$servername = "172.26.0.3";
$username = "system";
$password = "system!#24";
$dbname = "system";

$conn = mysqli_connect($servername, $username, $password, $dbname);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
?>