<?php
    $servername = "172.26.0.7";
    $username = "pipe";
    $password = "vkdlvm1357!#%&";
    $dbname = "pipe";

    try {
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
        $name = $_GET['id'];
    
        $stmt = $conn->prepare("SELECT is_run FROM status WHERE name = :name");
        $stmt->bindParam(':name', $name);
        $stmt->execute();
    
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $is_run = $row["is_run"];
        $new_is_run = $is_run ? 0 : 1;
    
        $stmt = $conn->prepare("UPDATE status SET is_run = :new_is_run WHERE name = :name");
        $stmt->bindParam(':name', $name);
        $stmt->bindParam(':new_is_run', $new_is_run);
        $stmt->execute();
    
        echo "성공적으로 상태가 변경되었습니다.";
    } catch(PDOException $e) {
        http_response_code(500);
        echo "데이터베이스 연결에 실패했습니다. 관리자에게 문의해주세요: " . $e->getMessage();
    }
    
    $conn = null;
?>