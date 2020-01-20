var winObj;



function popup(){						// 팝업 객채 생성
            var url = "popup.html";
            var name = "popup test";
            var option = "width = 500, height = 500, top = 100, left = 200, location = no, scrollbals = no, directories = no"
            winObj = window.open(url, name, option);
	

	var chkClosePop = setInterval(function() {			// 팝업 닫힘 확인
   		if(winObj.closed) {  
        		clearInterval(chkClosePop);  
        		deleteBt1();
		addBt2();

    }  
}, 1000); 

        }


bt_print.addEventListener('click', function(){			// 버튼 액션리스너 등록
	popup();
    })



function deleteBt1(){						// 버튼 생성
	var bt_print = document.getElementById('bt_print');		// bt print 지정
	var tr = bt_print.parentNode;				// bt print 부모노드 - tr 생성
     	tr.parentNode.removeChild(tr);				// tr 부모의 자식 (=본인 노드 제거)

}

function addBt2(){	
	var div = document.createElement('button');
	div.innerHTML = '완료';
	div.id = 'bt_commit';
	document.getElementById('commit').appendChild(div);
	bt_commit.addEventListener('click', function(){			// 버튼 생성 후 이벤트 리스너 등록
		window.location.href = 'https://www.kospo.co.kr';
	})
}
