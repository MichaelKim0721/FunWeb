<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<link href="../css/default.css" rel="stylesheet" type="text/css">
		<link href="../css/subpage.css" rel="stylesheet" type="text/css">
		<!--[if lt IE 9]>
		<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/IE9.js" type="text/javascript"></script>
		<script src="http://ie7-js.googlecode.com/svn/version/2.1(beta4)/ie7-squish.js" type="text/javascript"></script>
		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
		<![endif]-->
		<!--[if IE 6]>
		 <script src="../script/DD_belatedPNG_0.0.8a.js"></script>
		 <script>
		   /* EXAMPLE */
		   DD_belatedPNG.fix('#wrap');
		   DD_belatedPNG.fix('#main_img');   
		
		 </script>
		 <![endif]-->
	</head>
	<body>
		<div id="wrap">
			<!-- 헤더들어가는 곳 -->
			<%-- <%@ include file="../inc/top.jsp" %> --%>
			<jsp:include page="../inc/top.jsp" />
			<!-- 헤더들어가는 곳 -->
	
			<!-- 본문들어가는 곳 -->
			<!-- 본문메인이미지 -->
			<div id="sub_img_member"></div>
			<!-- 본문메인이미지 -->
			<!-- 왼쪽메뉴 -->
			<nav id="sub_menu">
				<ul>
					<li><a href="#">Join us</a></li>
					<li><a href="#">Privacy policy</a></li>
				</ul>
			</nav>
			<!-- 왼쪽메뉴 -->
			<!-- 본문내용 -->
			<article>
				<h1>Join Us</h1>
				<form action="joinPro.jsp" id="join" name="fr" method="post">
					<fieldset>
						<legend>Basic Info</legend>
						<label>User ID</label> <input type="text" name="id" class="id" onkeyup="mySend()"> 
						<span id="result"></span>
						<span id="resultOk" style="color: lightgreen;"></span><br>
						<label>Password</label> <input type="password" name="passwd" onkeyup="validatePw()">
						<span id="upasswd" style="color: red"></span><br>
						<label>Retype Password</label> <input type="password" name="passwd2" onkeyup="validatePwc()"><br>
						<label>Name</label> <input type="text" name="name" onkeyup="validateName()"><br>
						<label>Age</label> <input type="text" name="age"><br>
						<label>Gender</label> 남자<input type="radio" name="gender" id="s1" value="남자" onchange="validateSex()"/>
                							    여자<input type="radio" name="gender" id="s2" value="여자" onchange="validateSex()"/> &nbsp;
                							  <br>
                							  <br>
						<label>E-Mail</label> <input type="email" name="email"><br>
					</fieldset>
	
					<fieldset>
						<legend>Optional</legend>
						<label>Tel</label> <input type="text" name="tel"><br>
						<label>Mtel</label> <input type="text" name="mtel"><br>
						<label>Address</label> <input type="text" id="sample4_postcode" placeholder="우편번호" name="postnum"> 
											   <input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
						<label></label>		   <input type="text" id="sample4_roadAddress" placeholder="도로명주소" name="address"><br>
						<label></label>		   <input type="text" id="sample4_jibunAddress" placeholder="지번주소">
									   		   <input type="text" id="sample4_extraAddress" placeholder="참고항목">
											   <span id="guide" style="color:#999; display:none"></span> <br>
						<label></label>		   <input type="text" id="sample4_detailAddress" placeholder="상세주소" name="address_detail"><br>
						
					</fieldset>
					<div class="clear"></div>
					<div id="buttons">
						<input type="submit" value="가입" class="submit"> 
						<input type="reset" value="취소" class="cancel">
					</div>
				</form>
			</article>
			<!-- 본문내용 -->
			<!-- 본문들어가는 곳 -->
	
			<div class="clear"></div>
			<!-- 푸터들어가는 곳 -->
			<%-- <%@ include file="../inc/bottom.jsp" %> --%>
			<jsp:include page="../inc/bottom.jsp" />			
			<!-- 푸터들어가는 곳 -->
		</div>
		
		
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script>
			
			// (?=.*?[A-Z]) : A부터 Z까지 있는지 보는 정규식
			// .{8,10} : 8자 이상 10자 이하
			// ^ : 이걸로 시작해서  $ : 로 끝나..
	
			// A-Z, a-z, 0-9 특수문자가 포함되어 있는지, 8자 이상
			let reg = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[~?!@#$%^&*_-]).{8,}$/
	
			// 같은 문자 연속 4번 있는지
			let reg2 = /(\w)\1\1\1/
	
			// 정규식.test() : 정규식이 맞는지 아닌지 true나 false로 반환
			reg.test("값");
			
			const passwd = document.fr.passwd;
			
			
			//아이디 입력<input>에 키를 눌렀다가 뗐을 때 아이디 중복체크 역할
			function mySend() {
				//입력한 아이디를 얻어 변수에 저장
				var fidValue = document.fr.id.value;
				//입력할 수 있는 <input>태그 얻어 변수에 저장
				var fidInput = document.fr.id;
				
				//아이디를 입력하지 않았을 경우 "아이디 입력하세요" 경고 메세지 창띄우기
				if(fidValue  == ""){
					//아이디를 입력하지 않으면 경고 메세지 창 띄우기 
					result.innerText = "아이디를 입력하세요.";
					//아이디 입력할수 있는 <input>태그에  포커스 강제로 적용
					fidInput.focus();
					return; //winopen()함수를 빠져나감!
				}
				
				
			
			  // AJAX-- 이용해  아이디 중복 체크 
			  
				//XMLHttpRequest객체를 저장할 javascript변수 xhttp를 선언한다
				var xhttp;
				
				//XMLHttpRequest객체를 생성하여  xhttp변수에 저장하는 역할의 함수 
				xhttp = new XMLHttpRequest();
			
				
				//createHttpRequest()함수를 호출하여 XMLHttpRequest객체를 생성하고,
				//POST방식으로 톰캣서버에 만들어 놓은 join_IDcheck.jsp내용을 비동기방식으로 요청합니다.
				//function mySend(){
					//서버의 응답을 처리하기 위해서는  onreadystatechange프로퍼티에서는
					//readyState반환값에 따라 자동으로 callFuntion함수를 설정 한다.
					xhttp.onreadystatechange = callFunction;
					
					var sendString = "userid="+fidValue;
					xhttp.open("POST","join_IDcheck.jsp", true); //POST방식
			
					//POST방식은 한글을 제대로 전송하기 위해서는 setRequestHeader()메소드를 이용하여
					//요청하는 데이터의 MIME-TYPE 설정
					xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
					
					xhttp.send(sendString);//위 POST방식으로 서버에 요청시 데이터를 전달해 요청한다.		
				//}
				
				//서버와 클라이언트간의 통신이 모두 성공적으로 완료된 시점이 readyState는 4이고,
				//status는 200이다. 따라서 2개의 값으로 조건검사를 하고 
				//응답 데이터 형식은 responseText프로퍼티를 이용한 일반텍스트형식으로 데이터를 받는다.
				
				function callFunction(){
					if(xhttp.readyState == 4){
						if(xhttp.status == 200){ 
							//응답데이터 형식은 responseText프로퍼티를 호출해서 (jsp파일데이터를 응답받는다.)
							var responseData = xhttp.responseText;
							
							//웹브라우저 F12 console탭에서 로그메세지로 확인 
							//console.log(responseData);
							
							//id속성값이 result인 아래의 <span id="result"></span>태그를 선택해서 innerHTML속성에 응답받은 데이터를 넣어 보여준다.
							document.getElementById("result").innerHTML = responseData;	
						}
					}
					
				}
				
			}		
		
    	    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    	    function sample4_execDaumPostcode() {
    	        new daum.Postcode({
    	            oncomplete: function(data) {
    	            	// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

    	                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
    	                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
    	                var roadAddr = data.roadAddress; // 도로명 주소 변수
    	                var extraRoadAddr = ''; // 참고 항목 변수

    	                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
    	                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
    	                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
    	                    extraRoadAddr += data.bname;
    	                }
    	                // 건물명이 있고, 공동주택일 경우 추가한다.
    	                if(data.buildingName !== '' && data.apartment === 'Y'){
    	                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
    	                }
    	                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
    	                if(extraRoadAddr !== ''){
    	                    extraRoadAddr = ' (' + extraRoadAddr + ')';
    	                }

    	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
    	                document.getElementById('sample4_postcode').value = data.zonecode;
    	                document.getElementById("sample4_roadAddress").value = roadAddr;
    	                document.getElementById("sample4_jibunAddress").value = data.jibunAddress;
    	                
    	                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
    	                if(roadAddr !== ''){
    	                    document.getElementById("sample4_extraAddress").value = extraRoadAddr;
    	                } else {
    	                    document.getElementById("sample4_extraAddress").value = '';
    	                }

    	                var guideTextBox = document.getElementById("guide");
    	                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
    	                if(data.autoRoadAddress) {
    	                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
    	                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
    	                    guideTextBox.style.display = 'block';

    	                } else if(data.autoJibunAddress) {
    	                    var expJibunAddr = data.autoJibunAddress;
    	                    guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
    	                    guideTextBox.style.display = 'block';
    	                } else {
    	                    guideTextBox.innerHTML = '';
    	                    guideTextBox.style.display = 'none';
    	                }
    	            }
    	        
    	        }).open();
    	    }
    	</script>
	</body>
</html>