
var xhr = new XMLHttpRequest(); 				// XML 요청 객체 생성
var url = 'https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?key=4b203564429385c2367fbd331c6daa7d&targetDt=20200101'; 

//var svcKey = 'fz1ZkMwseMv%2BjR6FwlU7PRGLggkeUFsNFpkcvQc4R4UfrxGalhkIwa7yx4%2BzMgxgJcxeTsvJ%2B6nJuKqNDODH9A%3D%3D';



// API open

xhr.open('GET', url);


xhr.onreadystatechange = function () {
    if (this.readyState == 4) {
	
	myFunction();
    }
};

xhr.send('');




// 파싱된 xml 리드
function myFunction() {
	
			var xmlDoc = xhr.responseXML;
			console.log(xmlDoc);

			var rank = xmlDoc.getElementsByTagName("rank"); 
			var movieNm = xmlDoc.getElementsByTagName("movieNm"); 
			var audiAcc = xmlDoc.getElementsByTagName("audiAcc"); 
			var str = "박스오피스 순위" + "<br><br>";
			
	for(i=0; i < rank.length; i++) {
		str += "순   위  :" + rank[i].childNodes[0].nodeValue + "===== <br>";
		str += "영 화 명  : " + movieNm[i].childNodes[0].nodeValue + "<br>";
		str += "누적관객수  : " + audiAcc[i].childNodes[0].nodeValue + "<br><br>";
		
	}
	
	document.getElementById("data_list").innerHTML = str;
}