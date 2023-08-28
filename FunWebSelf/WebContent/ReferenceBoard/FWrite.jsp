<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	request.setCharacterEncoding("UTF-8");
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
			<article>
				<h1>File Reference Notice Write</h1>
				<form action="FWritePro.jsp" method="post" enctype="multipart/form-data" name="fr">
					<table id="notice">
						<tr> <td>비밀번호</td> <td><input type="password" name="passwd"></td> </tr>
						<tr> <td>글 제목</td> <td><input type="text" name="subject"></td> </tr>
						<tr> <td>파일</td> <td><input type="file" name="file"></td> </tr>
						<tr> <td>글 내용</td> <td><textarea name="content" rows="13" cols="60"></textarea></td> </tr>
					</table>
					<div id="table_search">
						<input type="submit" value="글쓰기" class="btn"> 
						<input type="reset" value="다시 작성" class="btn"> 
						<input type="button" value="목록보기" class="btn" onclick="location.href='ReferenceNotice.jsp'"> 
					</div>
				</form>
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
			<jsp:include page="../inc/bottom.jsp" />
			<!-- 푸터들어가는 곳 -->
		</div>
	</body>
</html>