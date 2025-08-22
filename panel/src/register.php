<!DOCTYPE html>
<html lang="ko-KR"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script>
    function checkId() {
      var password1 = document.getElementById('passwordInput').value;
      var password2 = document.getElementById('passwordInput2').value;
      if(password1 != password2){
        document.getElementById('id_check').innerHTML = '비밀번호 확인이 틀립니다.';
        return
      }
      var username = document.getElementById('userNameInput').value;
      var xhr = new XMLHttpRequest();
      xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
          if (xhr.status == 200) {
            var response = xhr.responseText;
            if (response == 'exists') {
              document.getElementById('id_check').innerHTML = '이미 존재하는 아이디 입니다.';
            } else {
              document.getElementById('id_check').innerHTML = '';
              loginForm.submit();
            }
          } else {
            document.getElementById('id_check').innerHTML = '알 수 없는 에러가 발생했습니다.';
          }
        }
      };
      xhr.open('GET', 'id_check.php?username=' + encodeURIComponent(username), true);
      xhr.send();
    }
  </script>
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
        <h1>회원가입</h1>
        <span id="id_check"></span>
        <form method="post" id="loginForm" autocomplete="off" novalidate="novalidate" onkeypress="if (event && event.keyCode == 13) checkId()" action="register_ok.php">
            <div id="error" class="fieldMargin error smallText" style="display: none;">
                <span id="errorText" for="" aria-live="assertive" role="alert"></span>
            </div>

            <div id="formsAuthenticationArea">
                <div id="userNameArea">
                    <label id="userNameInputLabel" for="userNameInput" class="hidden">사용자 계정</label>
                    <input id="userNameInput" name="username" placeholder="아이디" type="text" tabindex="1" class="text fullWidth" spellcheck="false" autocomplete="off" control-id="ControlID-1">
                </div>

                <div id="userNameArea">
                    <label id="userNameInputLabel" for="passwordInput" class="hidden">비밀번호</label>
                    <input id="passwordInput" name="password" type="password" tabindex="1" class="text fullWidth" placeholder="비밀번호" autocomplete="off" control-id="ControlID-2">
                </div>
                <div id="userNameArea">
                    <label id="userNameInputLabel" for="passwordInput" class="hidden">비밀번호 확인</label>
                    <input id="passwordInput2" name="password_check" type="password" tabindex="1" class="text fullWidth" placeholder="비밀번호 확인" autocomplete="off" control-id="ControlID-2">
                </div>
                <div id="userNameArea">
                    <label id="userNameInputLabel" for="userNameInput" class="hidden">이메일</label>
                    <input id="emailInput" name="email" placeholder="이메일" type="text" tabindex="1" class="text fullWidth" spellcheck="false" autocomplete="off" control-id="ControlID-1">
                </div>
                <div id="userNameArea">
                    <label id="userNameInputLabel" for="userNameInput" class="hidden">전화번호</label>
                    <input id="phoneInput" name="phone" placeholder="전화번호" type="text" tabindex="1" class="text fullWidth" spellcheck="false" autocomplete="off" control-id="ControlID-1">
                </div>
                <input name="login" type="hidden" value="login">
                <div id="submissionArea" class="submitMargin">
                    <span id="submitButton" class="submit" tabindex="4" role="button" onclick="checkId()">회원가입</span>
                </div>
            </div>
        </form>
      </div>