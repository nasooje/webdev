<?php
    require 'vendor/autoload.php';
    include 'config/db.php';

    $title = $_POST['title'];
    $author = $_POST['author'];
    $content = $_POST['content'];
    $pw = $_POST['password'];

    if($title == "" || $author == "" || $content == ""){
        echo "모든 항목을 입력해주세요.";
        exit;
    }

    if($pw == ""){
        $stmt = $dbconn->prepare("INSERT INTO QnA (title, content, author) VALUES (?, ?, ?)");
        $stmt->bind_param("sss", $title, $content, $author);
    } else {
        $stmt = $dbconn->prepare("INSERT INTO QnA (title, content, author, password) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $title, $content, $author, $pw);
    }

    $stmt->execute();
    if($stmt->affected_rows > 0){
        $smarty = new Smarty();
        $smarty->setCompileDir('/tmp/templates_c/');
        $smarty->display('string:'.$title.'이 성공적으로 등록되었습니다.');
        echo "<script>location.href='QnA.php';</script>";
    } else {
        echo "레코드 생성에 실패했습니다.";
    }
?>
