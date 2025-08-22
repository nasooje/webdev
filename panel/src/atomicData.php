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
  <div class="row row-cols-5">
    <!-- 냉각기 상태 -->
    <div class="col-lg-4" id="atomic-unit-a">
      <div class="card h-100" id="atomic-background-a">
        <!-- 냉각기 이미지 -->
        <img src="atomic.png" class="card-img-top" alt="atomic Unit 1">
        <div class="card-body">
          <h5 class="card-title">Atomic Unit a</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="a">
              <input type="checkbox" id="check-a" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="atomic-unit-b">
      <div class="card h-100" id="atomic-background-b">
        <!-- 냉각기 이미지 -->
        <img src="atomic.png" class="card-img-top" alt="atomic Unit 2">
        <div class="card-body">
          <h5 class="card-title">Atomic Unit b</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="b">
              <input type="checkbox" id="check-b" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <!-- 중간 생략 -->

    <div class="col-lg-4" id="atomic-unit-c">
      <div class="card h-100" id="atomic-background-c">
        <!-- 냉각기 이미지 -->
        <img src="atomic.png" class="card-img-top" alt="atomic Unit 14">
        <div class="card-body">
          <h5 class="card-title">Atomic Unit c</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="c">
              <input type="checkbox" id="check-c" checked disabled>
              <span class="slider round"></span>
            </label>
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
const baseUrl = '/proxy.php?url=http://172.26.0.8/atomicToggle.php?id=';
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
    xhr.open('GET', '/proxy.php?url=http://172.26.0.8/atomicApi.php');
    xhr.onload = function() {
    if (xhr.status === 200) {
        const data = JSON.parse(xhr.responseText);
        const container = document.getElementById('container');
        Object.keys(data).forEach(function(key) {
          var element = document.getElementById('check-' + key)
          const value = data[key];
          if (value == "OFF") {
            element.removeAttribute('checked');
          }
          else {
            element.setAttribute('checked', null);
          }
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