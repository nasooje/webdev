
<?php
include 'dbcon.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

  $username = $_POST['username'];
  $password = $_POST['password'];
  $email = $_POST['email'];
  $phone = $_POST['phone'];

  $hashed_password = hash('sha256', $password);

  $sql = "SELECT * FROM user WHERE username='$username'";
  $result = mysqli_query($conn, $sql);

  if (mysqli_num_rows($result) > 0) {
    die('<script>alert("이미 존재하는 아이디 입니다.");location.href="/login.php"</script>');
  } else {
    $sql = "INSERT INTO user (username, password, email, phone) VALUES ('$username', '$hashed_password', '$email', '$phone')";

    if (mysqli_query($conn, $sql)) {
      die('<script>alert("관리자 승인 후 이용 가능합니다.");location.href="/login.php"</script>');
    } else {
      die('<script>alert("알 수 없는 에러가 발생했습니다.");location.href="/login.php"</script>');
    }
  }

  mysqli_close($conn);

  header('Location: login.php');
  exit;
}
?>