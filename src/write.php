<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Press Release</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
    </style>
</head>

<?php
    include 'config/header.php';    
?>
<body class="bg-gray-100">
<main class="container mx-auto py-8 px-6">
        <div class="flex space-x-4">
            <!-- Sidebar -->
            <aside class="w-1/5">
                <ul class="space-y-2">
                    <li class="border-l-4 border-red-600 pl-2"><a href="#" class="text-red-600">Q&A</a></li>
                </ul>
            </aside>

            <section class="w-3/4 bg-white p-6 shadow-md">
                <form action="write_process.php" method="post">
                    <div class="flex justify-between items-center mt-4">
                        <div></div>
                        <div class="flex items center space-x-2">
                            <input type="text" name="title" class="border px-2 py-1" placeholder="제목">
                            <input type="text" name="author" class="border px-2 py-1" placeholder="작성자">
                            <input type="password" name="password" class="border px-2 py-1" placeholder="비밀번호">
                        </div>
                    </div>
                    <textarea name="content" class="border w-full h-64 px-2 py-1 mt-4" placeholder="내용을 입력하세요."></textarea>
                    <button type="submit" class="bg-gray-800 text-white px-4 py-2 mt-4">등록</button>
                </form>
            </section>
        </div>
    </main>

</body>


<?php
    include 'config/footer.php';
?>