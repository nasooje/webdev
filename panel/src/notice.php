<?php
	include 'session_check.php';
  header("Content-Type: text/html; charset=utf-8");
?>
<?php
  include 'dbcon.php';

  $page = isset($_GET['page']) ? $_GET['page'] : 1;

  $noticesPerPage = 15;

  $offset = ($page - 1) * $noticesPerPage;

  $sql = "SELECT * FROM notice ORDER BY id DESC LIMIT $noticesPerPage OFFSET $offset";
  $result = mysqli_query($conn, $sql);  

  $sqlTotal = "SELECT COUNT(*) as total FROM notice";
  $resultTotal = mysqli_query($conn, $sqlTotal);
  $rowTotal = mysqli_fetch_assoc($resultTotal);
  $totalNotices = $rowTotal['total'];

  $totalPages = ceil($totalNotices / $noticesPerPage);
?>
<!DOCTYPE html>
<head>
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
    <div>
     <div class="inbox">
       <div class="inbox-sb">
         
       </div>
       <div class="inbox-bx container-fluid">
         <div class="row">
           <div class="col-md-10">
             <table class="table table-stripped" style="table-layout:fixed">
               <tbody>
               <tr>
                  <td nowrap style="width: 100px">번호</td>
                  <td nowrap style="width: 100px">작성자</td>
                  <td>제목</td>
                  <td nowrap style="width: 100px">작성시간</td>
                </tr>
               <?php
                  if (mysqli_num_rows($result) > 0) {
                      while ($row = mysqli_fetch_assoc($result)) {
                          echo "<tr>";
                          echo "<td nowrap>" . $row["id"] . "</td>";
                          echo "<td nowrap>" . $row["author"] . "</td>";
                          echo "<td><a href=\"post.php?id=" . $row["id"] . "\">" . $row["title"] . "</a></td>";
                          echo "<td nowrap>" . $row["created_at"] . "</td>";
                          echo "</tr>";
                      }
                  } else {
                      echo "공지사항이 없습니다.";
                  }
                ?>
               </tbody>
             </table>
             <button type="button" class="btn btn-secondary" onclick="javascript:location.href='/write.php'">글쓰기</button>
           </div>
         </div>
       </div>
     </div>
    </div>
  </div>
    <nav aria-label="Page navigation example">
    <ul class="pagination">
    <?php  
      if ($totalPages > 1) {
          if ($page > 1) {
            echo "<li class=\"page-item\"><a class=\"page-link\" href=\"?page=" . ($page - 1) . "\">Previous</a>";
        }
          for ($i = 1; $i <= $totalPages; $i++) {
            echo "<li class=\"page-item\"><a class=\"page-link\" href=\"?page=$i\">$i</a>";
        }
        if ($page < $totalPages) {
          echo "<li class=\"page-item\"><a class=\"page-link\" href=\"?page=" . ($page + 1) . "\">Next</a>";
        }
      }
    ?>
    </nav>
</div>
  <script src='https://code.jquery.com/jquery-3.1.1.min.js'></script>
<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js'></script><script  src="./script.js"></script>

</body>
</html>
