<h1>Password Check</h1>
<form action="/password.php" method='post'>
    <input type="text" hidden name='idx' value=<?php echo $_GET['idx'];?>>
    <input type="password" id='password' name='password'>
    <input type="submit" value="확인">
</form>



<?php
    include 'config/db.php';
    if(isset($_POST['password']) && isset($_POST['idx'])){
        $idx = $_POST['idx'];
        $password = $_POST['password'];

        $stmt = $dbconn->prepare("SELECT password FROM QnA where id = ?");
        $stmt->bind_param("i", $idx);

        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();

        if($row['password'] == $password){
            echo "<script>location.href='read.php?idx=".$idx."&c=Q&pw=".$password."'</script>";
        } else {
            echo "<script>history.go(-1)</script>";
        }
    }
?>