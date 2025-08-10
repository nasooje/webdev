<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hanbit Nuclear Power Plant</title>
    <link href="https://unpkg.com/tailwindcss@^2.0/dist/tailwind.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Arial', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-100">
    <?php include 'config/header.php'; ?>
    <main class="container mx-auto py-8 px-6">
        <div class="flex space-x-4">
            <!-- Sidebar -->
            <aside class="w-1/5">
                <ul class="space-y-2">
                    <?php 
                        if (!$_GET['page']) {
                            echo '<li class="border-l-4 border-red-600 pl-2"><a href="?page=" class="text-red-600">금강 원자력 발전소 소개</a></li>
                            <li class="pl-2"><a href="?page=tech" class="text-gray-600">기술 및 안전</a></li>
                            <li class="pl-2"><a href="?page=env" class="text-gray-600">환경 보호</a></li>
                            <li class="pl-2"><a href="?page=community" class="text-gray-600">지역 사회</a></li>';
                        } else if($_GET['page'] == 'tech'){
                            echo '<li class=" pl-2"><a href="?page=" class="text-gray-600">금강 원자력 발전소 소개</a></li>
                            <li class="border-l-4 border-red-600 pl-2"><a href="?page=tech" class="text-red-600">기술 및 안전</a></li>
                            <li class="pl-2"><a href="?page=env" class="text-gray-600">환경 보호</a></li>
                            <li class="pl-2"><a href="?page=community" class="text-gray-600">지역 사회</a></li>';
                        } else if($_GET['page'] =="env"){
                            echo '<li class=" pl-2"><a href="?page=" class="text-gray-600">금강 원자력 발전소 소개</a></li>
                            <li class="pl-2"><a href="?page=tech" class="text-gray-600">기술 및 안전</a></li>
                            <li class="border-l-4 border-red-600 pl-2"><a href="?page=env" class="text-red-600">환경 보호</a></li>
                            <li class="pl-2"><a href="?page=community" class="text-gray-600">지역 사회</a></li>';
                        } else if($_GET['page'] == 'community'){
                            echo '<li class=" pl-2"><a href="?page=" class="text-gray-600">금강 원자력 발전소 소개</a></li>
                            <li class="pl-2"><a href="?page=tech" class="text-gray-600">기술 및 안전</a></li>
                            <li class="pl-2"><a href="?page=env" class="text-gray-600">환경 보호</a></li>
                            <li class="border-l-4 border-red-600 pl-2"><a href="?page=community" class="text-red-600">지역 사회</a></li>';
                        } else {
                            echo '<li class="pl-2"><a href="?page=" class="text-gray-600">금강 원자력 발전소 소개</a></li>
                            <li class="pl-2"><a href="?page=tech" class="text-gray-600">기술 및 안전</a></li>
                            <li class="pl-2"><a href="?page=env" class="text-gray-600">환경 보호</a></li>
                            <li class="pl-2"><a href="?page=community" class="text-gray-600">지역 사회</a></li>';
                        }
                    ?>
                    
                </ul>
            </aside>
            <section class="w-3/4 bg-white p-6 shadow-md">
                <?php 
                if(!$_GET['page']){
                    echo '<h3 class="text-2xl font-bold mb-4">금강 원자력 발전소 소개</h3>
                    <img src="https://img.lovepik.com/photo/40016/1249.jpg_wh860.jpg" alt="">';
                } else if($_GET['page'] == 'tech'){
                    echo '<h3 class="text-2xl font-bold mb-4">기술 및 안전</h3>
                    <div class="flex flex-col lg:flex-row">
                        <div class="lg:w-4/4">
                            <p class="mb-2">
                                금강 원자력 발전소는 최첨단 원자력 기술과 철저한 안전 관리로, 지속 가능한 에너지를 공급하고 있습니다.<br>
                                우리의 기술은 높은 효율성과 안정성을 자랑하며, 안전을 최우선으로 합니다. <br>
                                철저한 안전 관리 시스템과 지속적인 기술 혁신을 통해, 원자력 에너지의 안전성과 신뢰성을 높이고 있습니다.
                            </p><br>
                            <p class="font-bold">
                                주요 기술
                            </p>
                            <li>최첨단 원자로 기술</li>
                            <li>안전 관리 시스템</li>
                            <li>지속 가능한 에너지 솔루션</li>
                            <br>
                            <p class="font-bold">
                                주요 기능
                            </p>
                            <li>실시간 모니터링 시스템</li>
                            <li>자동화된 안전 점검</li>
                            <li>비상 대응 시스템</li>
                        </div>
                    </div>';
                } else if($_GET['page'] == 'env'){
                    echo '<h3 class="text-2xl font-bold mb-4">환경 보호</h3>
                    <div class="flex flex-col lg:flex-row">
                        <div class="lg:w-4/4">
                            <p class="mb-2">
                            금강 원자력 발전소는 환경 보호를 위해 다양한 노력을 기울이고 있습니다. <br>
                            우리는 친환경적인 에너지 생산을 목표로 하며, 환경에 미치는 영향을 최소화하기 위해 지속적으로 개선하고 있습니다.<br>
                            에너지 효율성을 높이고, 환경 보호 기술을 도입하여 지속 가능한 발전을 이루고 있습니다.
                            </p><br>
                            <p class="font-bold">
                                주요 활동
                            </p>
                            <li>환경 모니터링</li>
                            <li>탄소 배출 감소</li>
                            <li>친환경 기술 도입</li>
                            <br>
                            <p class="font-bold">
                                주요 성과
                            </p>
                            <li>탄소 배출 저감</li>
                            <li>환경 인증 획득</li>
                            <li>지속 가능한 발전 실현</li>
                        </div>
                    </div>';
                    
                } else if($_GET['page'] == 'community'){
                    echo '<h3 class="text-2xl font-bold mb-4">지역 사회</h3>
                    <div class="flex flex-col lg:flex-row">
                        <div class="lg:w-4/4">
                            <p class="mb-2">
                            금강 원자력 발전소는 지역 사회와의 협력을 중요시하며, 다양한 사회 공헌 활동을 통해 지역 사회에 기여하고 있습니다.<br>
                            우리는 지역 주민들과의 소통을 강화하고, 지역 경제 발전을 위해 다양한 지원을 아끼지 않고 있습니다.<br>
                            지역 사회와의 상생을 통해 더 나은 미래를 만들어가고자 합니다.
                            </p><br>
                            <p class="font-bold">
                                주요 활동
                            </p>
                            <li>지역 사회 지원 프로그램</li>
                            <li>교육 및 훈련 제공</li>
                            <li>지역 경제 발전 기여</li>
                            <br>
                            <p class="font-bold">
                                주요 성과
                            </p>
                            <li>지역 사회와의 협력 강화</li>
                            <li>사회 공헌 활동 확대</li>
                            <li>지역 경제 발전 지원</li>
                        </div>
                    </div>';
                } else {
                    $page = $_GET['page'];
                    if(preg_match("/.php/", $page) === 0){
                        $page .= ".php";
                    }
                    include $page;
                }
                
                ?>
            </section>
        </div>
    </main>
    
    <?php include 'config/footer.php'; ?>
</body>
</html>