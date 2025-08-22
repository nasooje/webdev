<?php
	include 'session_check.php';
?>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<script type="text/javascript" src="./ckeditor/ckeditor.js"></script>
<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css'>
<script type="text/javascript">


//<![CDATA[
function LoadPage() {
    CKEDITOR.replace('contents');
}

function FormSubmit(f) {
    CKEDITOR.instances.contents.updateElement();
    if(f.contents.value == "") {
        alert("내용을 입력해 주세요.");
        return false;
    }
}
//]]>
</script>
</head>
<body onload="LoadPage();">
<form id="EditorForm" name="EditorForm" onsubmit="return FormSubmit(this);" action="/write_ok.php" method="post">
<div>
    <label for="title"><h3>제목<h3></label>
    <input type="text" id="title" name="title" size="40" />
</div>
<br>
<div>
    <textarea id="contents" name="contents"></textarea>
</div>
<div>
<br>
<button type="submit" class="btn btn-secondary">글쓰기</button>
</form>
</body>
</html>