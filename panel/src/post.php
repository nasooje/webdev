<?php
	include 'session_check.php';
?>
<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'><link rel="stylesheet" href="./style.css">

</head>
<body>
<nav class="mnb navbar navbar-default navbar-fixed-top">
  <div class="container-fluid">
    <div id="navbar" class="navbar-collapse collapse">
      <ul class="nav navbar-nav navbar-right">
        <li><a href="/logout.php">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>
<div class="msb" id="msb">
		<nav class="navbar navbar-default" role="navigation">
			<div class="navbar-header">
				<div class="brand-wrapper">
					<div class="brand-name-wrapper">
						<a class="navbar-brand">
							원자력 발전 관리 시스템
						</a>
					</div>

				</div>

			</div>

			<div class="side-menu-container">
				<ul class="nav navbar-nav">

					<li><a href="/notice.php"></i> 공지사항</a></li>
          <li><a href="/coolerControler.php"></i> 냉각기 작동 현황</a></li>
					<li><a href="/pipeControler.php"></i> 파이프 작동 현황</a></li>

					<li><a href="/atomicControler.php"></i> 원자로 작동 현황</a></li>
				</ul>
			</div>
		</nav>  
</div>
<div class="mcw">
  <div class="cv">
    <iframe src="read.php?id=<?php echo $_GET['id']; ?>" frameborder="0" style="display:block; width:100%; height: 90vh">
  </div>
</div>
  <script src='https://code.jquery.com/jquery-3.1.1.min.js'></script>
<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js'></script><script src="./script.js"></script>

</body>
</html>
