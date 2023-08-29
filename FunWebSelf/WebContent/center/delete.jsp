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
			<jsp:include page="../inc/left.jsp" />
			<!-- 왼쪽메뉴 -->
	
			<!-- 게시판 -->
<%
		//content.jsp페이지에서 글 삭제버튼 클릭 시 삭제할 글의 번호를 request에 담아서 전송
		
		//1. 한글처리
		request.setCharacterEncoding("UTF-8");

		//2. 요청한 값 얻기(글 수정 버튼 눌렀을 때 삭제할 글 번호 얻기)
		int num = Integer.parseInt( request.getParameter("num") );
		
		//3. 웹브라우저로 응답할 값 생성(삭제할 글번호 num이용하여 DB의 board테이블에서 글 정보 조회)
		BoardDAO dao = new BoardDAO(); //DB와 연결 후 DB와의 작업할 객체 생성
		
		//3.1  삭제할 글 번호에 해당하는 글 조회(SELECT구문 작업)
		BoardBean boardBean = dao.getBoard(num);
%>
			<article>
				<h1>글 삭제 화면</h1>
				
				<%-- 글 삭제 deletePro.jsp로 요청 --%>
				<form action="deletePro.jsp" method="post">
				<%-- 삭제할 글 번호 전달 --%>
				<input type="hidden" name="num" value="<%=boardBean.getNum()%>">
					<table id="notice">
						<tr>
							<td>비밀번호</td>
							<td><input type="password" name="passwd"></td>
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
						<input type="hidden" name="id" value=<%=id %>> <%-- 글을 작성하고 로그인한 사람의 ID 전달 --%>
						<input type="submit" value="글 삭제" class="btn" onclick="confirm('정말로 글을 삭제하시겠습니까?')">
<%						
					} else { //세션에 아이디가 저장되어 있지 않으면(로그인 안했으면)
%>
						<script type="text/javascript">
							alert("글을 삭제할 권한이 없습니다. \n로그인 상태를 확인해주세요.");
						</script>
						<input type="button" value="글 목록" class="btn" onclick="location.href='notice.jsp'">
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