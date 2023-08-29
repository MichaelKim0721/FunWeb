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
			<jsp:include page="../inc/left.jsp" />
			<!-- 왼쪽메뉴 -->
<% 
				//session메모리영역에 로그인한 사람의 id를 받아옴
				String id = (String)session.getAttribute("id");
				//session메모리영역에 로그인한 사람의 id가 없으면 login.jsp재요청
				 if(id == null) {
					 response.sendRedirect("../member/login.jsp");
				 }
				
			//주글(부모글)에 대한 답변글 작성 내용을 DB의 테이블에 insert하기 위해
			//주글(부모글)에 대한 정보 중에서 부모글 제목, 부모글 내용, 부모글 pos, 부모글 depth을 조회해서 가져오기
			
			//1. 한글처리
			request.setCharacterEncoding("UTF-8");
			
			//2. 요청한 값 얻기
			int num = Integer.parseInt( request.getParameter("num") );
			
			//3. 답변글을 작성하기 전에 부모글의 내용을 아래의 화면에 보여주기 위해 조회해서 가져오기
			BoardBean boardBean = new BoardDAO().getBoard(num);
			
%>
			<!-- 게시판 -->
			<article>
				<h1>답변 글 쓰기 화면</h1>
				<form action="reWritePro.jsp" method="post">
					<%-- 부모글의 글번호 전달 --%>
					<input type="hidden" name="num" value="<%=boardBean.getNum()%>">
					<%-- 부모글의 pos, depth열에 저장된 값 전달 --%>
					<input type="hidden" name="pos" value="<%=boardBean.getPos()%>">
					<input type="hidden" name="depth" value="<%=boardBean.getDepth()%>">
					
					<table id="notice">
						<tr>
							<td>글작성자 ID</td>
							<td><input type="text" name="id" value="<%=id%>" readonly></td>
						</tr>
						<tr>
							<td>글 비밀번호</td>
							<td><input type="password" name="passwd"></td>
						</tr>
						<tr>
							<td>글 제목</td>
							<td><input type="text" name="subject" value="<%=boardBean.getSubject()%>의 답글"></td>
						</tr>
						<tr>
							<td>글 내용</td>
							<td><textarea name="content" rows="20" cols="70"><%=boardBean.getContent() %></textarea></td>
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