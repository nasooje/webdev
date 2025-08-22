<?php
	include 'session_check.php';
?>
<?php
if (isset($_GET["url"])) {
    $url = $_GET["url"];
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    
    $response = curl_exec($ch);
    
    if(curl_errno($ch)) {
        echo '알 수 없는 에러가 발생했습니다.';
    } else {
        echo $response;
    }

    curl_close($ch);
}

?>