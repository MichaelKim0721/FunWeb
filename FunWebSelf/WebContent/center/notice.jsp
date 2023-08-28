<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
	//입력한 검색어와 검색기준값을 저장할 전역 변수 선언
	String keyWord, keyField;
	Vector vector;
%>

<%
	//1. 한글처리(입력한 검색어와 검색기준값에 한글 문자 처리)
	request.setCharacterEncoding("UTF-8");
	
	//2. 조건: 검색어가 입력이 되었다면 선택한 검색기준값 + 입력한 검색어를 request에서 받아오기
	//요약:	  요청한 값 얻기
	if(request.getParameter("keyWord") != null){
		//검색 기준값(이름, 제목, 내용 중에 select option에서 선택한 하나의 값)
		keyField = request.getParameter("keyField"); //이름 = name, 제목 = subject, 내용 = content 중 하나
		//입력한 검색어 얻기
		keyWord = request.getParameter("keyWord");
	}
	
	//3. BoardDAO객체의 getBoardList메소드 호출 시 선택한 검색기준값과 검색어를 매개변수로 전달해 DB에서 조회해옴
	vector = new BoardDAO().getBoardList(keyField, keyWord);
	
	//날짜와 시간정보 포맷 형식을 우리 개발자가 정한 날짜 포맷 형식으로 변환해주는 클래스 → SimpleDateFormat
	//SimpleDateFormat클래스의 format메소드 호출 시 원하는 날짜시간데이터가 저장된 TimeStamp객체를 전달
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>

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
		 
		 <script type="text/javascript">
		 	//검색어를 입력하지 않고 검색버튼을 눌렀을 때 유효성 검사
		 	//검색어를 입력했으면 <form action="notice.jsp" name="search">...</form> 태그 전송이벤트 발생
		 	function check() {
				
		 		//검색어 입력하지 않았다면
		 		if(document.search.keyWord.value == "") {
		 			alert("검색어를 입력하세요");
		 			document.search.keyWord.focus();
		 			return; //check함수 벗어나기
		 		}
		 		
		 		//검색어를 입력했다면
		 		document.search.submit(); //form태그의 action속성에 작성한 notice.jsp로 검색요청시
		 								  //입력한 검색어 + 선택한 검색기준값 + hidden값까지 모두 request에 담아서 전송
			}
		 	
		 	
		 </script>
	</head>
	<body>
		<div id="wrap">
			<!-- 헤더들어가는 곳 -->
			<%-- <%@ include file="../inc/top.jsp" %> --%>
			<jsp:include page="../inc/top.jsp" />
			<!-- 헤더들어가는 곳 -->
	
			<!-- 본문들어가는 곳 -->
			<!-- 메인이미지 -->
			<div id="sub_img_center"></div>
			<!-- 메인이미지 -->
	
			<!-- 왼쪽메뉴 -->
			<nav id="sub_menu">
				<ul>
					<li><a href="#">Notice</a></li>
					<li><a href="#">Public News</a></li>
					<li><a href="#">Driver Download</a></li>
					<li><a href="#">Service Policy</a></li>
				</ul>
			</nav>
			<!-- 왼쪽메뉴 -->
	
			<!-- 게시판 -->
			<article>
				<h1>자유게시판 - 전체 글 수: <%=vector.size()%></h1>
				<table id="notice">
					<tr>
						<th class="tno" align="center">번호</th>
						<th class="ttitle" align="center">제목</th>
						<th class="twrite" align="center">작성자</th>
						<th class="tdate" align="center">작성일</th>
						<th class="tread" align="center">조회수</th>
					</tr>
					

					
<%
				//Vector배열(모든글을 조회한 정보가 저장되어 있는 배열)에 저장된 BoardBean객체가 없다면
 				if(vector.isEmpty()) { //조회된 글 정보가 없다면
%>
					<tr>
						<td colspan="5">등록된 글이 없습니다.</td>
					</tr>
<%
				//Vector배열에 저장된 BoardBean객체가 저장되어 있다면
				} else { //조회된 글 정보가 있다면
					//Vector배열에 저장된 BoardBean 객체의 갯수만큼 반복하여 
					for(int cnt=0; cnt<vector.size(); cnt++){
						//0 index ~ 끝 index위치에 저장된 BoardBean객체를 get메소드를 이용하여 차례로 얻기
						BoardBean bean = (BoardBean)vector.get(cnt);
%>
					<tr>
						<td><%=bean.getNum() %></td>
						<td><a href="content.jsp?num=<%=bean.getNum()%>" style="text-decoration: none; color: black;"><%=bean.getSubject() %></a></td>
						<td><%=bean.getName() %></td>
						<td><%=sdf.format(bean.getRegdate()) %></td>
						<td><%=bean.getCount() %></td>
					</tr>
<%
					}
				}
%>
				</table>

				<div id="table_search">
					<form action="notice.jsp" name="search" method="post">
						<input type="hidden" name="page" value="0" />
						<table border="0" align="right">
							<tr>
								<td align="right">
									<select name="keyField">
										<option value="name">이름</option>
										<option value="subject">제목</option>
										<option value="content">내용</option>
									</select>
									<!-- 검색어 입력하는 곳 -->
									<input type="text" name="keyWord" class="input_box"> 
									<!-- 검색 버튼 -->
									<input type="button" value="찾기" class="btn" onclick="check()">
<%
								//각각의 페이지에서 로그인 후 재요청 후 현재페이지로 올 때 session에 값이 저장되어 있으면
								//[검색어입력하는곳][찾기]버튼과 [글쓰기]버튼이 같이 보이게 화면을 구성하고
								//session값이 저장되어 있지 않으면(미로그인 상태)
								//[검색어입력하는곳][찾기]버튼만 보이게 화면을 구성
								String id = (String)session.getAttribute("id");
								
								if(id != null){
%>
									<!-- 글쓰기 버튼 -->
									<input type="button" value="글쓰기" class="btn" onclick="location.href='write.jsp'">
<%								
								}
%>
									
								</td>
							</tr>
						</table>
					</form>
				</div>
				<div class="clear"></div>
				<div id="page_control">
					<a href="#">Prev</a> <a href="#">1</a><a href="#">2</a><a href="#">3</a>
					<a href="#">4</a><a href="#">5</a><a href="#">6</a> <a href="#">7</a><a
						href="#">8</a><a href="#">9</a> <a href="#">10</a> <a href="#">Next</a>
				</div>
			</article>
			<!-- 게시판 -->
			<!-- 본문들어가는 곳 -->
			<div class="clear"></div>
			<!-- 푸터들어가는 곳 -->
			<%-- <%@ include file="../inc/bottom.jsp" %> --%>
			<jsp:include page="../inc/bottom.jsp" />
			<!-- 푸터들어가는 곳 -->
		</div>
	</body>
</html>