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
<body class="bg-gray-100">

    <!-- Header -->
    <?php include 'config/header.php'; ?>
    <?php include 'config/db.php'; ?>

    <!-- Main Content -->
    <main class="container mx-auto py-8 px-6">
        <div class="flex space-x-4">
            <!-- Sidebar -->
            <aside class="w-1/5">
                <ul class="space-y-2">
                    <li class="border-l-4 border-red-600 pl-2"><a href="#" class="text-red-600">공지사항</a></li>
                    <!-- <li class="pl-2"><a href="#" class="text-gray-600">채용공고</a></li> -->
                </ul>
            </aside>

            <!-- Main Section -->
            <section class="w-3/4 bg-white p-6 shadow-md">
                <h3 class="text-2xl font-bold mb-4">공지사항</h3>
                <!-- <h2 class="text-xl text-red-600 mb-8">PRESS RELEASE</h2> -->
                <div class="flex justify-between items-center mt-4">
                    <!-- <div></div>
                    <div class="flex items-center space-x-2">
                        <select class="border px-2 py-1">
                            <option>제목</option>
                        </select>
                        <input type="text" class="border px-2 py-1" placeholder="검색어 입력">
                        <button class="bg-gray-800 text-white px-4 py-2">검색</button>
                    </div> -->
                </div>
                <table class="w-full table-auto">
                    <thead>
                        <tr class="bg-gray-200">
                            <th class="px-4 py-2">번호</th>
                            <th class="px-4 py-2">제목</th>
                            <th class="px-4 py-2">작성자</th>
                            <th class="px-4 py-2">등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php 
                        $query = "SELECT * FROM notice";
                        $result = $dbconn->query($query);

                        if ($result->num_rows > 0) {
                            while ($row = $result->fetch_assoc()) {
                                echo '<tr>
                                
                                        <td class="border px-4 py-2">'.$row["id"].'</td>
                                        <td class="border px-4 py-2"><a href="read.php?idx='.$row["id"].'&c=N">'.$row["title"].'</a></td>
                                        <td class="border px-4 py-2">'.$row["author"].'</td>
                                        <td class="border px-4 py-2">'.$row["created_at"].'</td>
                                    </tr>';
                            }
                        } else {
                            echo "0개의 결과를 찾았습니다.";
                        }
                    ?>
                    </tbody>
                </table>
            </section>
        </div>
    </main>

    <!-- Footer -->
    <?php include 'config/footer.php'; ?>

</body>
</html>
