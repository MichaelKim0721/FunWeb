<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ReferenceBoard.ReferenceBoardBean"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ReferenceBoard.ReferenceBoardDAO"%>
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
<%
		//하나의 글정보 DB에서 조회해서 가져와 보여주는 화면
		
		ReferenceBoardDAO dao = new ReferenceBoardDAO();
		
		//1. 한글처리
		request.setCharacterEncoding("UTF-8");
		
		//2. ReferenceNotice.jsp에서 하나의 글 행을 클릭하여 요청한 값 얻기 글번호, 글이 보여지고 있는 페이지 번호
		int num = Integer.parseInt( request.getParameter("num") );
		String pageNum = request.getParameter("pageNum");
		
		//3. 클릭한 행의 글 조회수 1 증가시키기 (DB UPDATE작업)
		dao.updateReadCount(num);
		
		//4. 조회할 글 번호를 getBoard메소드 호출시 매개변수로 전달하여 글번호에 해당하는 글을 조회(DB SELECT작업)
		ReferenceBoardBean boardBean = dao.getBoard(num); 
		
		//조회된 글 하나의 정보는 ReferenceBoard객체에 저장되어 있으므로 꺼내어서 아래의 디자인에 출력
		int DBNum = boardBean.getNum(); //글번호
		int DBReadCount = boardBean.getReadcount(); //조회수
		String DBName = boardBean.getName(); //글작성자명
		Timestamp DBDate = boardBean.getDate(); //글 작성일
		String DBSubject = boardBean.getSubject(); //글 제목
		String DBContent = ""; //글 내용 저장될 변수
		String DBFilRealeName = boardBean.getFileRealName(); //업로드한 실제 파일명
		String DBFileName = boardBean.getFilename(); //업로드한 원본 파일명
		
		//조건식: 조회한 글 내용이 있으면 글쓰기 당시 엔터처리 해서 줄바꿈 한 데이터들 모두 <br>태그로 변경해서 보여주기
		if(boardBean.getContent() != null) {
			DBContent = boardBean.getContent().replace("\r\n", "<br>");
		}
		
		//답변글 작성 시 사용될 값 3개
		int DBRe_ref = boardBean.getRe_ref(); //그룹값
		int DBRe_lev = boardBean.getRe_lev(); //같은 그룹 내에서 글의 들여쓰기 레벨(정도)
		int DBRe_seq = boardBean.getRe_seq(); //같은 그룹 내에서 보여줄 글들의 순서값
		
		
%>
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
				<table id="notice">
					<tr>
						<td width="15%" style="border-right: 1px dotted gray">글번호</td>
						<td width="35%" style="text-align: left; padding-left: 10px;"><%=DBNum %></td>
						<td width="15%" style="border-right: 1px dotted gray">조회수</td>
						<td width="35%" style="text-align: left; padding-left: 10px;"><%=DBReadCount %></td>
					</tr>
					<tr>
						<td style="border-right: 1px dotted gray">작성자</td>
						<td style="text-align: left; padding-left: 10px;"><%=DBName %></td>
						<td style="border-right: 1px dotted gray">작성(수정)일</td>
						<td style="text-align: left; padding-left: 10px;"><%=new SimpleDateFormat("yyyy.MM.dd hh:mm:ss").format(DBDate) %></td>
					</tr>
					<tr>
						<td style="border-right: 1px dotted gray">글 제목</td>
						<td colspan="3" style="text-align: left; padding-left: 10px;"><%=DBSubject %></td>
					</tr>
					<tr>
						<td style="border-right: 1px dotted gray">파일</td>
						<td colspan="3" style="text-align: left; padding-left: 10px;"><%=DBFileName %></td>
					</tr>
					<tr>
						<td style="border-right: 1px dotted gray">글 내용</td>
						<td colspan="3" style="text-align: left; padding-left: 10px;">
							<div style="white-space: pre-wrap;"><%=DBContent %></div>
						</td>
				</table>
				<div id="table_search">
				<% 
					String id = (String)session.getAttribute("id");
				
					if(id != null) { //세션영역에 세션아이디값이 저장되어 있는 로그인된 상태라면
				%>
						<input type="button" value="글수정" class="btn" onclick="location.href='update.jsp?pageNum=<%=pageNum%>&num=<%=DBNum%>'">
						<input type="button" value="글삭제" class="btn" onclick="location.href='delete.jsp?pageNum=<%=pageNum%>&num=<%=DBNum%>'">
						<input type="button" value="답글쓰기" class="btn" 
							   onclick="location.href='reWrite.jsp?num=<%=DBNum%>&re_ref=<%=DBRe_ref%>&re_lev=<%=DBRe_lev%>&re_seq=<%=DBRe_seq%>'">
				<%
					}
				%>
				</div>
				<div class="clear"></div>
				<div id="page_control">
					
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