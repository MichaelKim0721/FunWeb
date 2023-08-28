<%@page import="member.MemberDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@page import="java.util.Vector"%>
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
		 
		 <script type="text/javascript">
		 	
		 	
		 </script>
	</head>
	<body>
		<div id="wrap">
			<!-- 헤더들어가는 곳 -->
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
<%
		//content.jsp페이지에서 글 수정버튼 클릭 시 수정할 글의 번호를 request에 담아서 전송
		
		//1. 한글처리
		request.setCharacterEncoding("UTF-8");

		//2. 요청한 값 얻기(글 수정 버튼 눌렀을 때 수정할 글 번호 얻기)
		int num = Integer.parseInt( request.getParameter("num") );
		
		//3. 웹브라우저로 응답할 값 생성(수정할 글번호 num이용하여 DB의 board테이블에서 글 정보 조회)
		BoardDAO dao = new BoardDAO(); //DB와 연결 후 DB와의 작업할 객체 생성
		
		//3.1  글 번호에 해당하는 글 조회(SELECT구문 작업)
		BoardBean boardBean = dao.getBoard(num);
%>
			<article>
				<h1>글 수정 화면</h1>
				
				<%-- 글 수정 요청을 updatePro.jsp로 요청 → 수정할 글 번호와 수정한 글정보들을 함께 request에 담아 전달 --%>
				<form action="updatePro.jsp" method="post">
				<input type="hidden" name="num" value="<%=boardBean.getNum()%>">
					<table id="notice">
						<tr>
							<td width="15%">글번호</td>
							<td width="35%"><%=boardBean.getNum() %></td>
							<td width="15%">글 조회수</td>
							<td width="35%"><%=boardBean.getCount() %></td>
						</tr>
						<tr>
							<td>작성자</td>
							<td><%=boardBean.getName() %></td>
							<td>작성(수정)일</td>
							<td><%=new SimpleDateFormat("yyyy.MM.dd hh:mm:ss").format( boardBean.getRegdate() ) %></td>
						</tr>
						<tr>
							<td>글 제목</td>
							<td colspan="3"><input type="text" name="subject" value="<%=boardBean.getSubject() %>"></td>
						</tr>
						<tr>
							<td>글 내용</td>
<%
						//조회된 글 내용 문자열이 있으면
						if(boardBean.getContent() != null) {
							//글 내용 작성 시 엔터키 처리한 부분을 replace메소드를 이용하여 변경 후 반환
%>
							<td colspan="3">
								<textarea name="content" rows="13" cols="40">
									<%=boardBean.getContent()%>
<%-- 									<pre><%=boardBean.getContent() %></pre> --%>
<%-- 									<div style="white-space: pre-wrap;"><%=boardBean.getContent() %></div> --%>
								</textarea>
							</td>
<%
						}
%>
						</tr>
					</table>
					<div id="table_search">
<%
					//로그인한 사람은 글을 수정, 삭제 및 답글 작성, 글 목록 보기 버튼이 보이게 디자인
					//미로그인한 사람은 글 목록보기 버튼만 보이게 디자인
					//session영역에 로그인한 사람의 id가 저장되어 있느냐 없느냐로 판단
					String id = (String)session.getAttribute("id");
					
					if(id != null) { //세션에 아이디가 저장되어 있으면(로그인 했으면)
%>						
						<input type="submit" value="글 수정" class="btn">
						<input type="button" value="글 삭제" class="btn">
						<input type="button" value="답글 작성" class="btn">
<%						
					} else { //세션에 아이디가 저장되어 있지 않으면(로그인 안했으면)
%>
						<input type="button" value="글 목록" class="btn">
<%				
					}
%>
					</div>
				</form>
				<div class="clear"></div>
				<div id="page_control"></div>
			</article>
			<!-- 게시판 -->
			<!-- 본문들어가는 곳 -->
			<div class="clear"></div>
			<!-- 푸터들어가는 곳 -->
			<jsp:include page="../inc/bottom.jsp" />
			<!-- 푸터들어가는 곳 -->
		</div>
	</body>
</html>