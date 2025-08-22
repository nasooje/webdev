<?php
include 'dbcon.php';

session_start();

if (isset($_SESSION['user_id'])) {
  header('Location: notice.php');
  exit();
}

if (isset($_POST['login'])) {

  $stmt = mysqli_prepare($conn, 'SELECT id, username, password FROM user WHERE username = ? and is_ready = 1');
  mysqli_stmt_bind_param($stmt, 's', $_POST['username']);
  mysqli_stmt_execute($stmt);
  mysqli_stmt_bind_result($stmt, $user_id, $username, $hashed_password);
  mysqli_stmt_fetch($stmt);
  if (hash('sha256', $_POST['password']) === $hashed_password) {
    $_SESSION['user_id'] = $user_id;
    $_SESSION['username'] = $username;
    header('Location: notice.php');
    exit();
  } else {
    $error_message = '아이디 또는 비밀번호sdas가 다릅니다.!';
  }
  mysqli_stmt_close($stmt);
  mysqli_close($conn);
}
?>

<!DOCTYPE html>
<html lang="ko-KR"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=1">
        
        <meta http-equiv="cache-control" content="no-cache,no-store">
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="expires" content="-1">

        
        <link rel="stylesheet" type="text/css" href="./login.css"><style>.illustrationClass {background-image:url(./illustration.jpg);}</style>

    </head>
    <body dir="ltr" class="body" style="">
    <script type="text/javascript" language="JavaScript">
         document.getElementById("noScript").style.display = "none";
    </script>
    <div id="fullPage">
        <div id="brandingWrapper" class="float">
            <div id="branding" class="illustrationClass"></div>
        </div>
        <div id="contentWrapper" class="float">
            <div id="content">
                <div id="header">
                    <img class="logoImage" id="companyLogo" src="./logo.png" style="width:350px; height:65px">
                </div>

                <main>
                    <div id="workArea">   
    <div id="authArea" class="groupMargin">
        
        

    <div id="loginArea">        
        <h1>로그인</h1>
        <?php if (isset($error_message)) { ?>
        <p><?php echo $error_message; ?></p>
      <?php } ?>
        <form method="post" id="loginForm" autocomplete="off" novalidate="novalidate" onkeypress="if (event && event.keyCode == 13) loginForm.submit()" action="">
            <div id="error" class="fieldMargin error smallText" style="display: none;">
                <span id="errorText" for="" aria-live="assertive" role="alert"></span>
            </div>

            <div id="formsAuthenticationArea">
                <div id="userNameArea">
                    <label id="userNameInputLabel" for="userNameInput" class="hidden">사용자 계정</label>
                    <input id="userNameInput" name="username" placeholder="아이디" type="text" tabindex="1" class="text fullWidth" spellcheck="false" autocomplete="off" control-id="ControlID-1">
                </div>

                <div id="passwordArea">
                    <label id="passwordInputLabel" for="passwordInput" class="hidden">비밀번호</label>
                    <input id="passwordInput" name="password" type="password" tabindex="2" class="text fullWidth" placeholder="비밀번호" autocomplete="off" control-id="ControlID-2">
                </div>
                <input name="login" type="hidden" value="login">
                <div id="submissionArea" class="submitMargin">
                    <span id="submitButton" class="submit" tabindex="4" role="button" onclick="loginForm.submit()">로그인</span>
                    <span id="submitButton" class="submit" tabindex="4" role="button" onclick="location.href='register.php'">회원가입</span>
                </div>
            </div>
        </form>
      </div>


    
 

