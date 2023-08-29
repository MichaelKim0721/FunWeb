<%@page import="board.BoardDAO"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.ArrayList"%>
<%@page import="ReferenceBoard.ReferenceBoardBean"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="ReferenceBoard.ReferenceBoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
	//입력한 검색어와 검색기준값을 저장할 전역 변수 선언
	String keyWord, keyField;
	Vector vector;
	
	//[1]. 페이징 처리를 위한 변수 선언
	int totalRecord = 0; //게시판(board테이블)에 저장된 전체 글의 갯수 → [2]가서 구함 ----------
	int numPerPage = 5; //한 페이지 당 보여질 글의 갯수
	int pagePerBlock = 3; //한 블럭 당 묶여질 페이지 번호의 개수

	int totalPage = 0; //board테이블에 저장된 전체 글의 갯수에 따라 보여지는 전체 페이지 갯수 → [4]가서 구함 ------------
	
	int totalBlock = 0; //전체 페이지수에 대한 전체 블럭갯수 → [9]가서 구함 --------------------
	
	//┌ [7]가서 구함 --------------
	int nowPage = 0; //현재 보여지는 화면의 페이지 번호(1 2 3페이지 번호 중 1페이지 번호를 클릭했을 때 1페이지 번호값을 구해서) 저장
	
	int nowBlock = 0; //현재 보여지는 페이지 번호가 속한 블럭 위치값 저장 → [8]가서 구함 ---------------
	
	int beginPerPage = 0; //각 페이지 번호 마다 가장 위쪽에 보여지는 글의 시작 글번호 구해서 저장할 변수 → [10] 가서 구함
	
	//============================[1] 끝
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
	BoardDAO boardDAO = new BoardDAO();
	vector = boardDAO.getBoardList(keyField, keyWord);
	
	//[2] 게시판에 저장된 전체글의 갯수를 구해서 저장
	totalRecord = vector.size();
	
	//[4] 전체 페이지번호 개수 구하기 = 게시판에 저장된 전체 글의 개수 / 한 페이지당 보여질 글의 개수
	totalPage = (int) Math.ceil( (double)totalRecord / numPerPage );
	//totalPage = totalRecord / numPerPage + ( totalRecord%numPerPage == 0 ? 0 : 1 );
	
	//[9] 전체 블럭위치값 개수 구하기 = 전체 페이지수 / 한 블럭당 묶여질 페이지 번호 개수
	totalBlock = (int) Math.ceil( (double)totalPage / pagePerBlock );
	
	
	//[7] 현재 페이지 번호 구하기
	if(request.getParameter("nowPage") != null) {
		//1  2  3 페이지 번호 중에서 클릭한 하나의 페이지 번호를 request에서 얻어 저장
		nowPage = Integer.parseInt( request.getParameter("nowPage") );
	} 
	
	//[8] 현재 페이지 번호가 속한 블럭 위치값 구하기
	if(request.getParameter("nowBlock") != null) {
		nowBlock = Integer.parseInt( request.getParameter("nowBlock") );
	}
	
	//[10] 각 페이지 번호클 클릭할때 마다  가장 위에 보여지는 조회된 첫번째 시작글의 정보를 저장하고 있는 new BoardBean객체의  Vector배열의 index번호 구하기
	//공식 ->  현재 보여지는 페이지번호 * 한페이지당 보여질 글의 갯수
	beginPerPage = nowPage * numPerPage;
	
	
	
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
	</head>
	<body>
	
	<%
		//게시판 글목록 조회해서 보여주기
		
		//1. 게시판 글 개수 조회
		ReferenceBoardDAO dao = new ReferenceBoardDAO();
					int count = dao.getBoardCount();
		
		//한개의 페이지번호 당 몇 개의 글 목록을 보여줄 것인지 설정(3개)
		int pageSize = 3;
		
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