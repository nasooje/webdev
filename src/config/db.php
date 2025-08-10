<?php

    //$servername = "localhost:3308";
    $servername = "mysql-php:3306";
    $user = "root";
    //$password = "admin";
    $password = "password";
    $dbname = "geumgang";

    $dbconn = new mysqli($servername, $user, $password, $dbname);

    if($dbconn->connect_error){
	    die($conn->connect_error);
    }

    $result = $dbconn->query('set names utf8');
    $result = $dbconn->query('set session character_set_connection=utf8');
    $result = $dbconn->query('set session character_set_results=utf8');
    $result = $dbconn->query('set session character_set_client=utf8');
    mysqli_set_charset($dbconn, 'utf8');
    if(!$result){
        die($dbconn->error);
    }


?>
