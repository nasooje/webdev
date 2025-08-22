<?php
	include 'session_check.php';
?>
<?php
include 'dbcon.php';

$post_id = $_GET['id'];

$sql = "SELECT * FROM notice WHERE id='$post_id'";
$result = mysqli_query($conn, $sql);

if (mysqli_num_rows($result) == 0) {
  die('<script>alert("글이 존재하지 않습니다.");window.parent.location.href="/notice.php"</script>');
} else {
  $post = mysqli_fetch_assoc($result);
  ?>
  <link rel="stylesheet" href="bootstrap.css">
<div class="container my-3">
<h2 class="border-bottom py-2">
  <?php
  echo $post['title'];
  ?>
      </h2>
    <div class="card my-3">
        <div class="card-body">
            <div class="card-text" style="white-space: pre-line;">
  <?php
  echo $post['content'];
  ?>
  </div>
  <div class="d-flex justify-content-end">
                <div class="badge badge-light p-2">
                    작성자: 
  <?php
  echo $post['author'];
  ?>
  </div>
    <div class="badge badge-light p-2">
  <?php
  echo $post['created_at'];
  ?>
                  </div>
            </div>
        </div>
    </div>
</div>
  <?php
}
?>