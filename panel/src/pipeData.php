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
    <div class="col-lg-4" id="pipe-unit-a1">
      <div class="card h-100" id="pipe-background-a1">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="Pipe Unit 1">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit a1</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="a1">
              <input type="checkbox" id="check-a1" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-a2">
      <div class="card h-100" id="pipe-background-a2">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 2">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit a2</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="a2">
              <input type="checkbox" id="check-a2" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <!-- 중간 생략 -->

    <div class="col-lg-4" id="pipe-unit-a3">
      <div class="card h-100" id="pipe-background-a3">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit a3</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="a3">
              <input type="checkbox" id="check-a3" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>
    
    <div class="col-lg-4" id="pipe-unit-a4">
      <div class="card h-100" id="pipe-background-a4">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit a4</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="a4">
              <input type="checkbox" id="check-a4" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-a5">
      <div class="card h-100" id="pipe-background-a5">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit a5</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="a5">
              <input type="checkbox" id="check-a5" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-b1">
      <div class="card h-100" id="pipe-background-b1">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit b1</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="b1">
              <input type="checkbox" id="check-b1" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-b2">
      <div class="card h-100" id="pipe-background-b2">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit b2</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="b2">
              <input type="checkbox" id="check-b2" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-b3">
      <div class="card h-100" id="pipe-background-b3">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit b3</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="b3">
              <input type="checkbox" id="check-b3" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-b4">
      <div class="card h-100" id="pipe-background-b4">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit b4</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="b4">
              <input type="checkbox" id="check-b4" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-b5">
      <div class="card h-100" id="pipe-background-b5">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit b5</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="b5">
              <input type="checkbox" id="check-b5" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-c1">
      <div class="card h-100" id="pipe-background-c1">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit c1</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="c1">
              <input type="checkbox" id="check-c1" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-c2">
      <div class="card h-100" id="pipe-background-c2">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit c2</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="c2">
              <input type="checkbox" id="check-c2" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-c3">
      <div class="card h-100" id="pipe-background-c3">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit c3</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="c3">
              <input type="checkbox" id="check-c3" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-c4">
      <div class="card h-100" id="pipe-background-c4">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">Pipe Unit c4</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="c4">
              <input type="checkbox" id="check-c4" checked disabled>
              <span class="slider round"></span>
            </label>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-4" id="pipe-unit-c5">
      <div class="card h-100" id="pipe-background-c5">
        <!-- 냉각기 이미지 -->
        <img src="pipe.png" class="card-img-top" alt="pipe Unit 14">
        <div class="card-body">
          <h5 class="card-title">pipe Unit c5</h5>
          <div class="d-flex justify-content-between align-items-center">
            <label class="switch mb-0" id="c5">
              <input type="checkbox" id="check-c5" checked disabled>
              <span class="slider round"></span>
            </label>
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
const baseUrl = '/proxy.php?url=http://172.26.0.6/pipeToggle.php?id=';
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
    xhr.open('GET', '/proxy.php?url=http://172.26.0.6/pipeApi.php');
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