<?php
include 'dbcon.php';

$username = $_GET['username'];

$sql = "SELECT * FROM user WHERE username='" . $username . "'";

$result = mysqli_query($conn, $sql);

if ($result) {
  if (mysqli_num_rows($result) > 0) {
    echo 'exists';
  } else {
    echo 'available';
  }
} else {
  echo 'error';
}

?>