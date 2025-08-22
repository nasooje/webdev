<?php
	include 'session_check.php';
?>
<!-- Bootstrap CSS -->
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-toggle/2.2.2/css/bootstrap-toggle.min.css">
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-toggle/2.2.2/js/bootstrap-toggle.min.js"></script>
</head>
<style>
.card {
  width: 100%;
  height: 100%;
}

.card .card-img-top {
  width: 100%;
  height: 65%;
  object-fit: contain;
}

.row {
  height: 33vh; /* 3x3 격자를 만들기 위해 각 row의 높이를 33.33%로 설정합니다. */
}

.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

.switch input {
  display: none;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}
</style>

<!-- 페이지 내용 -->
<div class="container-fluid">

    <div class="row row-cols-9">
        <!-- 냉각기 상태 -->
        <div class="col-lg-4" id="cooling-unit-a1">
            <div class="card h-100" id="cooler-background-a1">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit a1</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-a1"></span></p>
                        <label class="switch mb-0" id="a1">
                            <input type="checkbox" id="check-a1" checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4" id="cooling-unit-a2">
            <div class="card h-100" id="cooler-background-a2">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit a2</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-a2"></span></p>
                        <label class="switch mb-0" id="a2">
                            <input type="checkbox" id="check-a2"  checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- 냉각기 3부터 9까지도 동일한 방식으로 추가 -->
        <div class="col-lg-4" id="cooling-unit-a3">
            <div class="card h-100" id="cooler-background-a3">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit a3</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-a3"></span></p>
                        <label class="switch mb-0" id="a3">
                            <input type="checkbox" id="check-a3" checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4" id="cooling-unit-b1">
            <div class="card h-100" id="cooler-background-b1">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit b1</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-b1"></span></p>
                        <label class="switch mb-0" id="b1">
                            <input type="checkbox" id="check-b1" checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4" id="cooling-unit-b2">
            <div class="card h-100" id="cooler-background-b2">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit b2</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-b2"></span></p>
                        <label class="switch mb-0" id="b2">
                            <input type="checkbox" id="check-b2" checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4" id="cooling-unit-b3">
            <div class="card h-100" id="cooler-background-b3">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit b3</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-b3"></span></p>
                        <label class="switch mb-0" id="b3">
                            <input type="checkbox" id="check-b3" checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4" id="cooling-unit-c1">
            <div class="card h-100" id="cooler-background-c1">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit c1</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-c1"></span></p>
                        <label class="switch mb-0" id="c1">
                            <input type="checkbox" id="check-c1" checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4" id="cooling-unit-c2">
            <div class="card h-100" id="cooler-background-c2">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit c2</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-c2"></span></p>
                        <label class="switch mb-0" id="c2">
                            <input type="checkbox" id="check-c2" checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4" id="cooling-unit-c3">
            <div class="card h-100" id="cooler-background-c3">
                <!-- 냉각기 이미지 -->
                <img src="cooler.png" class="card-img-top" alt="Cooling Unit 1">
                <div class="card-body">
                    <h5 class="card-title">Cooling Unit c3</h5>
                    <div class="d-flex justify-content-between align-items-center">
                        <p class="card-text mb-0">Temperature: <span class="font-weight-bold" id="temp-c3"></span></p>
                        <label class="switch mb-0" id="c3">
                            <input type="checkbox" id="check-c3" checked disabled>
                            <span class="slider round"></span>
                        </label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS와 jQuery -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<!-- 자바스크립트 코드 -->
<script>
const baseUrl = '/proxy.php?url=http://172.26.0.4/coolerToggle.php?id=';
function sendXhrRequest(endpoint) {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', baseUrl + endpoint);
    xhr.onload = function() {
    if (xhr.status === 200) {
    } else {
    }
    };
    xhr.send();
}
const buttons = document.querySelectorAll('.switch');
buttons.forEach(button => {
    button.addEventListener('click', function(event) {
        const endpoint = button.id;
        sendXhrRequest(endpoint);
    });
});
function fetchData() {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', '/proxy.php?url=http://172.26.0.4/coolerApi.php');
    xhr.onload = function() {
    if (xhr.status === 200) {
        const data = JSON.parse(xhr.responseText);
        const container = document.getElementById('container');
        Object.keys(data).forEach(function(key) {
          var element = document.getElementById('temp-' + key);
          var element2 = document.getElementById('cooler-background-' + key)
          var element3 = document.getElementById('check-' + key)
          const value = data[key];
          if (value > 200) {
            element.style.color = "yellow";
            element2.style.backgroundColor = "red";
            element3.removeAttribute('checked');
          }
          else {
            element.style.color = "green";
            element2.style.backgroundColor = "white";
            element3.setAttribute('checked', null);
          }
          element.innerHTML = `${value}`;
        });
    } else {
    }
    };
    xhr.send();
}
fetchData();
  setInterval(function() {
    fetchData();
  }, 10000);


</script>