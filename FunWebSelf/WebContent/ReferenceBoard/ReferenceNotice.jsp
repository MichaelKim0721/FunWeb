<%@page import="board.BoardDAO"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ReferenceBoard.ReferenceBoardBean"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ReferenceBoard.ReferenceBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 

<% 
	request.setCharacterEncoding("UTF-8"); 
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
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
		//게시판 글목록 조회해서 보여주기
		
		//1. 게시판 글 개수 조회
		ReferenceBoardDAO dao = new ReferenceBoardDAO();
					int count = dao.getBoardCount();
		
		//한개의 페이지번호 당 몇 개의 글 목록을 보여줄 것인지 설정(3개)
		int pageSize = 5;
		
		//아래의 1  2  3 중 하나의 페이지 번호를 클릭 시 요청받는 페이지 번호 얻기
		String pageNum = request.getParameter("pageNum");
		
		//ReferenceNotice.jsp페이지를 처음 요청했을 때 클릭한 페이지번호가 없다면
		//처음 보여주는 화면을 1페이지로 설정하여 1페이지의 글목록 몇 개만 보여주기
		if(pageNum == null) {
			pageNum = "1"; //1페이지번호 설정
		}
		
		//아래의 1  2  3 중에서 클릭한 페이지번호가 문자열 "1"이기 때문에 정수로 변환하여 저장
		int currentPage = Integer.parseInt(pageNum);
		
		//각 페이지 번호를 선택해서 보여지는 화면마다 가장 첫번째로 보여질 시작 글번호 구하기
		//공식:			(현재 클릭한 페이지번호 - 1) * 한 페이지 당 보여줄 글의 개수
		int startRow = (currentPage - 1) * pageSize;
		//참고. 위 startRow변수에 저장된 값은 나중에 SELECT 절의 limit구문에서 ?값으로 설정될 것
		
		//게시판에서 조회한 글 목록정보를 저장할 ArrayList배열의 참조변수 선언
		List<ReferenceBoardBean> list = null;
		
		//만약 조회한 게시글의 갯수가 0보다 크다면(조회한 게시글이 있다면)
		if( count > 0 ) {
			
			//글 목록DB에서 조회해서 가져오기
			list = dao.getBoardList(startRow, pageSize); //각 페이지번호마다 보여지는 첫번재 글의 시작글 번호, 한 개의 페이지번호당 보여줄 글 개수 3
			
		}
		
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
				<h1>Reference Notice[전체 글: <%=count %>개]</h1>
				<table id="notice">
					<tr>
						<th class="tno" align="center">No.</th>
						<th class="ttitle" align="center">Title</th>
						<th class="twrite" align="center">Writer</th>
						<th class="tdate" align="center">Date</th>
						<th class="tread" align="center">Read</th>
					</tr>
		<%
			//조회된 갯수가 존재하면?
			if(count > 0) {
				//ArrayList배열에 저장된 ReferenceBoardBean객체의 갯수만큼 반복해서 얻어 정보 출력
				for( ReferenceBoardBean bean : list ) {
		%>		
				<%-- 상세 볼 글에 대한 내용을 조회하기 위해 글번호, 글이 목록에 보여지고 있는 페이지 전달 --%>
					<tr onclick="location.href='Fcontent.jsp?num=<%=bean.getNum()%>&pageNum=<%=pageNum%>'">
						<td><%=bean.getNum() %></td>
						<td class="left"><%=bean.getSubject() %></td>
						<td><%=bean.getName() %></td>
						<td><%=sdf.format(bean.getDate()) %></td>
						<td><%=bean.getReadcount() %></td>
					</tr>
		<%		
				}//for
			} else { //조회된 글이 없다면
		%>		
					<tr>
						<td colspan="5">조회된 글 정보가 없습니다.</td>
					</tr>
		<%		
			}//else
		%>
				</table>
				<div id="table_search">
				<% 
					String id = (String)session.getAttribute("id");
				
					if(id != null) { //세션영역에 세션아이디값이 저장되어 있는 로그인된 상태라면
				%>
						<input type="button" value="파일글쓰기" class="btn" onclick="location.href='FWrite.jsp'">
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