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
	
	//[1]. 페이징 처리를 위한 변수 선언
	int totalRecord = 0; //게시판(board테이블)에 저장된 전체 글의 갯수 → [2]가서 구함 ----------
	int numPerPage = 5; //한 페이지 당 보여질 글의 갯수
	int pagePerBlock = 3; //한 블럭 당 묶여질 페이지 번호의 개수
	/* 
		pagePerBlock변수 설명
			게시판 하단 부분을 보면 이전 3개 ◀  1  2  3  4  5  ▶ 다음 3개  화면이 존재
			이전 3개 ◀ 영역 또는 ▶ 다음 3개 영역을 클릭했을 때 게시판의 글이 많을 경우 한 페이지 번호 단위로 이동해서 화면을 보여주는 것은 매우 갑갑함
			그럴 때, 여러 페이지 번호를 하나로 묶어서 하나의 블럭 단위로 이동해서 화면을 보여주는 메뉴가 존재
			몇 개의 페이지 번호를 하나로 묶어서 이전 또는 다음 영역을 클릭했을 때, 조금 더 빠르게 그 다음 블럭에 위치한 페이지 번호의 화면을 보여주고 싶을 때
			몇 개의 페이지 번호를 하나의 블럭 단위로 만들것인지에 대한 한 블럭 당 묶여지는 페이지 갯수를 의미
	*/
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
	/* 
		설명
			게시판에 저장된 전체 글의 개수가 26개라고 가정했을 때
			게시판의 전체 페이지 번호 개수는 → 하나의 페이지 번호당 5개의 글을 보여준다면
			전체 글 갯수(26)를 한 페이지당 보여질 글 갯수(5)로 나눈 몫 → 5개의 페이지번호가 나오고
			나머지 1개의 글이 있기 때문에 보여주기 위한 1개의 페이지가 더 필요하므로 총 6개의 페이지 번호가 생성되어야 함
			
		(double)totalRecord / numPerPage 계산 시 실수값이 나오게 됨
					   26.0 / 5 = 5.2 
		1개의 페이지가 더 필요하므로 실수 5.2를 소수점 첫째자리에서 올림처리하여 6.0으로 만듦
		6.0은 int totalPage변수에 저장할 수 없기 때문에 6으로 만들어주기 위해 (int)로 형변환한 후 변수에 저장하여 6페이지로 만들어 줌
	*/		
	totalPage = (int) Math.ceil( (double)totalRecord / numPerPage );
	//totalPage = totalRecord / numPerPage + ( totalRecord%numPerPage == 0 ? 0 : 1 );
	
	//[9] 전체 블럭위치값 개수 구하기 = 전체 페이지수 / 한 블럭당 묶여질 페이지 번호 개수
	totalBlock = (int) Math.ceil( (double)totalPage / pagePerBlock );
	
	
	//[7] 현재 페이지 번호 구하기
	/* 
		설명
			게시판 하단 부분에 1  2  3 페이지 번호가 존재하고
			이 중 1페이지 번호를 클릭하면 현재 서버페이지인 notice.jsp를 포워딩하면
			클릭한 1페이지 번호를 구해서 nowPage변수에 저장
		
		조건식: 만약 클릭한 페이지 번호가 존재하면
	*/
	if(request.getParameter("nowPage") != null) {
		//1  2  3 페이지 번호 중에서 클릭한 하나의 페이지 번호를 request에서 얻어 저장
		nowPage = Integer.parseInt( request.getParameter("nowPage") );
	} 
	
	//[8] 현재 페이지 번호가 속한 블럭 위치값 구하기
	/* 
		설명
			게시판 하단 부분에 < 4  5  6 > 화면이 존재하고
			이 중 만약 > 버튼을 클릭한다면 request에 담은 블럭위치값을 구해와서
			nowBlock변수에 저장
	*/
	if(request.getParameter("nowBlock") != null) {
		nowBlock = Integer.parseInt( request.getParameter("nowBlock") );
	}
	
	//[10] 각 페이지 번호클 클릭할때 마다  가장 위에 보여지는 조회된 첫번째 시작글의 정보를 저장하고 있는 new BoardBean객체의  Vector배열의 index번호 구하기
	//공식 ->  현재 보여지는 페이지번호 * 한페이지당 보여질 글의 갯수
	
	//"select * from board order by num desc"; 로  글번호 num열의 값을 기준으로 내림차순 으로 검색 했을때...
	//Vector배열에  BoardBean객체들이 추가 된 모습  아래와 같다.
	//[  
	//   new BoardBean(), 13번글   0  index  
	//   new BoardBean(), 12번글   1  index
	//   new BoardBean(), 11번글   2  index
	//   new BoardBean(), 10번글   3  index
	//   new BoardBean(), 9번글     4  index
	//   new BoardBean(), 8번글     5  index
	//   new BoardBean(), 7번글     6  index
	//   new BoardBean(), 6번글     7  index
	//   new BoardBean(), 5번글     8  index
	//   new BoardBean(), 4번글     9  index
	//   new BoardBean(), 3번글     10 index
	//   new BoardBean()  2번글     11 index
	//   new BoardBean()  1번글     12 index	
	//]
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
			<jsp:include page="../inc/left.jsp" />
			<!-- 왼쪽메뉴 -->
	
			<!-- 게시판 -->
			<article>
							 <%-- [3] 게시판에 저장된 전체 글 수 출력 --%>			 <%-- [5] 전체 페이지 번호 수 출력 --%>				  <%-- [6] 현재 페이지 번호 출력 --%>			
				<h3>전체 글 수: <%=totalRecord%> &nbsp;&nbsp;&nbsp; 전체 페이지 수: <%=totalPage %> &nbsp;&nbsp;&nbsp; 현재 페이지: <%=nowPage + 1 %></h3>
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
					
					//[11] 한 개의 페이지 당 보여질 글 목록 출력
					//Vector배열에 저장된 BoardBean 객체의 갯수만큼 반복하여
					//각 페이지마다 첫번째로 보여질 
						  //cnt=첫번째로 보이는 시작글번호; 	cnt<(첫번째로 보이는 시작글번호 + 한페이지당 보여질 글 수);
					for(int cnt=beginPerPage; 		  	cnt<(beginPerPage+numPerPage); cnt++){
						
						//만약 cnt변수에 저장된 데이터 총 글의 개수와 같아지면 필요없는 반복을 하지 않기 위해 for문을 벗어나기
						if(cnt == totalRecord) {
							break;
						}
						
						BoardBean bean = (BoardBean)vector.get(cnt);
						
						int depth = bean.getDepth();//조회된 글의 들여쓰기 정도값 얻기
%>
					<tr>
						<td><%=bean.getNum() %></td>
<%-- 						<td class="left"><%= boardDAO.useDepth(depth)%><a href="content.jsp?num=<%=bean.getNum()%>&pos=<%=bean.getPos() %>" style="text-decoration: none; color: black;"><%=bean.getSubject() %></a></td> --%>
						<td class="left">
							<%
								int width = 0; //답변글에 대한 들여쓰기 값을 저장할 변수
								
								//주글이 아닌 답변글에 대한 들여쓰기 정도 값 depth열의 값이 0보다 크다면
								if( bean.getDepth() > 0 ) {
									//들여쓰기 정도값 구함
									width = bean.getDepth() * 10;
								
							%>
							<img src="../images/center/level.gif" width="<%=width%>" height="15">
							<img src='../images/center/re.gif'>
							<%
								}
							%>
							<a href="content.jsp?num=<%=bean.getNum()%>&pos=<%=bean.getPos() %>" style="text-decoration: none; color: black;"><%=bean.getSubject() %></a>
							
						</td>
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
<%
					//[15] 게시판에 글이 하나라도 존재하고, 현재 블럭의 위치가 적어도 0보다 크다면(이전으로 이동할 블럭 위치가 존재)
					//<<< 이전 <a>태그가 화면에 보이게 설정
					if(totalBlock > 0 && nowBlock > 0) {
%>
						<%-- 이전을 누르면 이전 블럭 위치 값과 이전 블럭위치의 시작페이지 번호를 notice.jsp로 요청시 전달 --%>
						<a href="notice.jsp?nowBlock=<%=nowBlock-1 %>&nowPage=<%=(nowBlock-1) * pagePerBlock%>">
							이전 <
						</a>
<%	
					}
%>
					<%-- [12-1] ~ [12-5] 게시판 하단 부분에 페이지 번호 출력 --%>
<%
					/* 
						한 블럭 당 몇 개의 페이지 번호를 출력할 것인지 기준을 잡아야 하는데
						위 int pagePerBlock = 3;변수의 값을 3으로 저장 해놨기 때문에
						한 블럭 당 3개의 페이지 번호를 묶어서 보여줘야 함
						예)
							1  2  3		← 0블럭
							4  5  6		← 1블럭
							7  8  9		← 2블럭
						위와 같이 한 블럭 당 3개의 페이지 번호씩 출력되게 하면 됨
					*/
					//[12-1] 한 블럭 당 3개의 페이지 번호를 보여줘야 하므로 한 블럭당 묶여질 페이지 번호 개수만큼 반복해서 페이지 번호 출력
					for(int cnt=0; cnt<pagePerBlock; cnt++) { //3번 반복
						
						//[12-5] 현재 보여질 페이지 번호가 전체 페이지 개수와 같아지면 3번반복하지 않고 for 반복문을 빠져나감
						if( (nowBlock * pagePerBlock) + cnt == totalPage ) {
							break;
						}
					//1페이지 번호를 클릭하면 nowPage=0&nowBlock=0 을 request에 담아서 notice.jsp로 전송요청
						
%>						
						<%-- 
							[12-3] 페이지 번호 중 하나 클릭 시 클릭 한 페이지 번호가 속한 블럭위치 값과 클릭한 페이지 번호를 
							현재 notice.jsp서버페이지로 request에 담아서 요청
							참고. 요청하는 클릭한 실제 페이지 번호가 1이면 0블럭의 위치값이 같이 전달됨
						 --%>
						<a href="notice.jsp?nowPage=<%=(nowBlock * pagePerBlock) + cnt%>&nowBlock=<%=nowBlock%>">
						<%-- 
							[12-2]
									1  2  3		← 0블럭
								  3>
									4  5  6		← 1블럭
								  3>
									7  8  9		← 2블럭
									
							위 그림과 같이 3>이라는 간격은 블럭 당 묶여질 페이지 개수를 의미 
							현재 위치블럭 * 한 블럭당 묶여질 페이지 수를 계산하여 블럭번호 0부터 시작하므로
							1부터 시작하기 위해서 + 1을 해주고 1페이지를 2 또는 3으로 증가하기 위해서는 +cnt값을 for반복문을 돌면서 증가시켜서 구함
							1  2  3
							(현재블럭위치	* 한블럭당 묶여질 페이지 수) + 1 + cnt
							(    0    	*        3          ) + 1 +  0  = 1  
							(    0    	*        3          ) + 1 +  1  = 2  
							(    0    	*        3          ) + 1 +  2  = 3  
							그러므로 for 반복문을 돌면서 1 2 3 페이지 번호를 0블럭 위치에서 출력 가능
						 --%>
							<%=(nowBlock * pagePerBlock) + 1 + cnt  %>
						</a>
						
						<%-- 
							[12-4] 한 블럭 당 1 2 3 .... 한 블럭 당 4 5 6 .... 묶여질 수 있는데
							총 글의 개수를 생각해본다면 마지막 하나의 블럭에는 글의 갯수에 따라 < 7    과같이 1개의 페이지 번호만 한 블럭에 묶여질 수도 있음 
						--%>
<%						
						//조건식:	마지막 글(총 글의 개수)만큼 반복했을 경우, for문에서 3번 반복하지 않아도 되므로
						//      총 글의 개수가 게시판 테이블에 저장된 전체 글의 개수와 같아진다면 
						if( ( (nowBlock * pagePerBlock) + 1 + cnt ) == totalRecord ) {
							break;
						}
						
					}//for반복문
					
					
					//[13] 이동할 블럭이 더 있다면 >>> 다음 3개 	← <a>링크 화면에 표시	
					//조건식: 전체블럭 위치 개수가 현재 블럭 위치 값보다 더 크면 (다음 이동 할 블럭이 있다면)
					if(totalBlock > nowBlock + 1) {
%>
						<%-- [14] >>>다음 3개 링크를 클릭 시 그 다음 블럭위치 번호와 그다음 블럭의 시작페이지 번호를 notice.jsp로 요청하여 전달  --%>
						<a href="notice.jsp?nowBlock=<%=nowBlock + 1 %>&nowPage=<%=(nowBlock + 1) * pagePerBlock %>">
							 > 다음
						</a>
<%
					}
					if(request.getParameter("nowPage") == null && request.getParameter("nowBlock") == null) {
						nowPage = 0;
						nowBlock = 0;
					}
					
%>
					
					
					
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