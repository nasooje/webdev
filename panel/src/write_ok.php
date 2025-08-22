<?php
	include 'session_check.php';
?>
<?php
    include 'dbcon.php';
    $title = $_POST['title'];
    $content = $_POST['contents'];
    $author = $_SESSION["user_id"];
    #$created_at = $_POST['created_at'];

    $author = "admin";
    $created_at = date('Y-m-d H:i:s');

    $sql = "INSERT INTO notice (title, content, author, created_at) VALUES ('$title', '$content', '$author', '$created_at')";

    if (mysqli_query($conn, $sql)) {
        echo "<script>window.parent.location.href ='/notice.php'</script>";
    } else {
        echo "Error: " . $sql . "<br>" . mysqli_error($conn);
    }

?>