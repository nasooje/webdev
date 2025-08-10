<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial="1.0">
    <title>Nuclear Power Plant</title>
    <link href="https://unpkg.com/tailwindcss@^2.0/dist/tailwind.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
        }
    </style>
</head>
<body>
    <?php include 'config/header.php'; ?>
    <main class="text-center py-12">
        <h1 class="text-3xl font-bold mb-4">최첨단 원자력 기술과 맞춤형 솔루션으로<br> 안전하고 신뢰할 수 있는 에너지 공급을 보장합니다</h1>
        <h2 class="text-2xl mb-6">금강 원자력 발전소</h2>
        <button class="bg-black text-white px-4 py-2 mb-6" onclick="location.href='/intro.php'">자세히 보기</button>
        <br><br>
        <div class="relative">
            <img src="./main.png" alt="Nuclear Power Plant Image" class="mx-auto" width="800" height="400">
        </div>
    </main>
    <br><br><br>
    <?php include 'config/footer.php'; ?>
</body>
</html>