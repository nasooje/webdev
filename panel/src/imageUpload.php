<?php
	include 'session_check.php';
?>

<?php
try {
    $doc_root = $_SERVER['DOCUMENT_ROOT'];

    $default_dir = '/uploads/ckeditor/'.date('Ymd').'/';
    $upload_dir = $doc_root.$default_dir;
    if (!is_dir($upload_dir)) $result = mkdir($upload_dir, 0707);
    $files = $_FILES['upload'];
    if ($files['tmp_name']) {

        $tmp_name = $tmp_file = array();
        $exp_name = pathinfo($files['name']);

        $tmp_file['name'] = preg_replace('/\s+/', '', strtolower($exp_name['filename']));
        $tmp_file['ext'] = strtolower($exp_name['extension']);
        $tmp_file['size'] = $files['size'];

        $allowed_content_types = array(
            'image/jpeg',
            'image/jpg',
            'image/png',
            'image/gif'
        );

        $file_content_type = $files['type'];
        if (!in_array($file_content_type, $allowed_content_types)) {
            throw new Exception('올바른 파일 형식이 아닙니다.');
        }

        $upload_name = uniqid().'_'.time() .'.'.$tmp_file['ext'];
        if (is_file($upload_dir.$upload_name)) {
            while (!is_file($upload_dir.$upload_name)) {
                $upload_name = uniqid().'_'.time() .'.'.$tmp_file['ext'];
            }
        }

        $data = array(
            'ori_name'    => $tmp_file['name'].'.'.$tmp_file['ext'],
            'tmp_name'    => $files['tmp_name'],
            'up_name'     => $upload_name,
            'error'       => $files['error'],
            'size'        => $files['size'],
            'path'        => $default_dir,
            'type'        => $files['type'],
            'img'         => $default_dir.$upload_name,
            'my_thumb_id' => explode('.',$upload_name)[0],
        );

        $result = move_uploaded_file($data['tmp_name'], $upload_dir.$data['up_name']);
        echo '{"filename" : "'.$data['up_name'].'", "uploaded" : 1, "url":"'.$default_dir.$data['up_name'].'"}';
    } else {
        throw new Exception('업로드된 파일이 없습니다.');
    }
} catch (Exception $e) {
    echo '{"uploaded": 0, "error": {"message": "'.$e->getMessage().'"}}';
}
?>