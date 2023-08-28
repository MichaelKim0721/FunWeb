<%@page import="member.MemberBean"%>
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
<% 
				//session메모리영역에 로그인한 사람의 id를 받아옴
				String id = (String)session.getAttribute("id");
				//session메모리영역에 로그인한 사람의 id가 없으면 login.jsp재요청
				 if(id == null) {
					 response.sendRedirect("../member/login.jsp");
					 
				 }
				
%>
			<!-- 게시판 -->
			<article>
				<h1>글쓰기 화면</h1>
				<form action="writePro.jsp" method="post">
					<table id="notice">
						<tr>
							<td>글작성자 ID</td>
							<td><input type="text" name="id" value="<%=id%>" readonly></td>
						</tr>
						<tr>
							<td>새 글 비밀번호</td>
							<td><input type="password" name="passwd"></td>
						</tr>
						<tr>
							<td>새 글 제목</td>
							<td><input type="text" name="subject" ></td>
						</tr>
						<tr>
							<td>새 글 내용</td>
							<td><textarea name="content" rows="20" cols="70"></textarea></td>
						</tr>
						<div id="table_search">
							<input type="submit" value="글쓰기" class="btn">
							<input type="reset" value="다시쓰기" class="btn">
							<input type="button" value="글목록" class="btn" onclick="location.href='notice.jsp'">
						</div>
					</table>
				</form>
				<div class="clear"></div>
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