<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Press Release - Article</title>
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
                    <li class="border-l-4 border-red-600 pl-2">
                        <a href="#" class="text-red-600">
                            <?php 
                                $c = $_GET['c'];
                                if($c == 'N') {
                                    echo "공지사항";
                                } else if($c == 'Q') {
                                    echo "Q&A";
                                }
                            ?>  
                        </a>
                    </li>
                </ul>
            </aside>

            <!-- Main Section -->
            <?php

                $idx = $_GET['idx'];
                $c = $_GET['c'];
                if(isset($idx) && $c == 'N') {
                    $stmt = $dbconn->prepare("SELECT * FROM notice WHERE id = ?");
                } else if(isset($idx) && $c == 'Q') {
                    $stmt = $dbconn->prepare("SELECT * FROM QnA WHERE id = ?");
                } else {
                    echo "잘못된 접근입니다.";
                    exit;
                }
                $stmt->bind_param("i", $idx);
                $stmt->execute();
                $result = $stmt->get_result();
                if ($result->num_rows < 0) {
                    exit;
                }
                $row = $result->fetch_assoc();

            ?>
            <section class="w-3/4 bg-white p-6 shadow-md">
                <h1 class="text-2xl font-bold mb-4"><?php echo $row["title"] ?></h1>
                <div class="text-gray-600 mb-4"><?php echo $row['created_at']?></div>
                <?php
                    $sentences = preg_split('/(?<=[.?!])\s+(?=[a-zA-Z])/', $row['content']);
                    foreach ($sentences as $sentence) {
                        echo '<p class="text-gray-800 leading-relaxed mb-4">'.$sentence .'</p>';
                    }
                ?>
            </section>
        </div>
    </main>

    <?php
        include 'config/footer.php';
    ?>

</body>
</html>