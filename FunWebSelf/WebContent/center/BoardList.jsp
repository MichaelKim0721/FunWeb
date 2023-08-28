<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.BoardBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Vector"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
	//입력한 검색어와 검색기준값을 저장할 전역 변수 선언
	String keyWord, keyField;
	Vector vector;
%>

<%
	//한글처리
	request.setCharacterEncoding("UTF-8");

	//날짜와 시간정보 포맷 형식을 우리 개발자가 정한 날짜 포맷 형식으로 변환해주는 클래스 → SimpleDateFormat
	//SimpleDateFormat클래스의 format메소드 호출 시 원하는 날짜시간데이터가 저장된 TimeStamp객체를 전달
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
<%
//1. DB에서 전체 글목록 읽어서 가져오기 위해 BoardDAO객체 생성
BoardDAO dao = new BoardDAO();
//2. DB에 글이 있는지 확인 후 있으면 글 모두 가져오고 없으면 가져오지 않게 처리
int cnt = dao.getBoardCount();

//3. 게시판 글의 수를 화면에 데이터 출력
//게시판 총 글의 개수 : cnt개
//4. getBoardList() 메소드 생성
System.out.println( dao.getBoardList() );

ArrayList boardList = dao.getBoardList();

System.out.println(cnt);

//5. 게시판 내용을 화면에 출력
%>
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
				<h1>자유게시판 - 전체 글 수: <%=cnt%></h1>
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
 				if(boardList.isEmpty()) { //조회된 글 정보가 없다면
%>
					<tr>
						<td colspan="5">등록된 글이 없습니다.</td>
					</tr>
<%
				//Vector배열에 저장된 BoardBean객체가 저장되어 있다면
				} else { //조회된 글 정보가 있다면
					//Vector배열에 저장된 BoardBean 객체의 갯수만큼 반복하여 
					for(int i=0; i<boardList.size(); i++){
						//0 index ~ 끝 index위치에 저장된 BoardBean객체를 get메소드를 이용하여 차례로 얻기
						BoardBean bean = (BoardBean)boardList.get(i);
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
<%
//6. 페이징 처리
//6.1  한 페이지에서 보여줄 글의 개수 설정(변경가능)
int pageSize = 10;
//6.2  현재 페이지 확인
String pageNum = request.getParameter("pageNum");
//6.3  페이지번호 정보가 없을 경우 내가 보는 페이지가 첫 페이지가 되도록 설정
if(pageNum == null) {
	pageNum = "1";
}
//6.4  시작행 번호 계산
//	   10개씩 컬럼 나누고 2페이지에서 시작행이 11, 3페이지에서 시작행이 21이 되도록 설정
int currentPage = Integer.parseInt(pageNum);
int startRow = (currentPage - 1) * pageSize + 1;
//currentPage가 2인 경우 (2-1) * 10 + 1 = 11
//currentPage가 3인 경우 (3-1) * 10 + 1 = 21

//6.5  끝 행 번호 계산
int endRow = currentPage * pageSize;

//7. 페이지 이동 버튼
if(cnt != 0) {
	//7.1  페이지 갯수 처리
	//전체 페이지 50개이고 화면에 10개씩 출력 → 5페이지만 있으면 됨
	//전체 페이지 57개이고 화면에 10개씩 출력 → 6페이지만 있으면 됨
	//삼항 연산자 처리
	int pageCount = cnt/pageSize + (cnt%pageSize == 0? 0:1);
	
	//7.2  화면에 보여줄 페이지 번호의 갯수(페이지 블럭)
	int pageBlock = 3; //페이지에 10개 페이지 갯수 출력
	
	//7.3  페이지 블럭의 시작페이지 번호
	//현재 11페이지면, (11-1)/10 * 10 + 1 = 11
	int startPage = ((currentPage-1)/pageBlock) * pageBlock + 1;
	
	//7.4  페이지 블럭의 끝 페이지 번호
	int endPage = startPage + pageBlock - 1;
	if(endPage > pageCount) {
		endPage = pageCount;
	}
	
	//7.5  이전, 숫자, 다음처리
	//이전
%>	
			<div id="pageBlock">
<%
				if(startPage > pageBlock) {
%>
					<a href="boardList.jsp?pageNum=<%=startPage-pageBlock%>">이전</a>
<%
				}
				//숫자
				for(int i=startPage; i<=endPage; i++) {
%>
					<a href="boardList.jsp?pageNum=<%=i%>"><%=i %></a>
<%				
				}
				//다음
				if(endPage < pageCount) {
%>
					<a href="boardList.jsp?pageNum=<%=startPage+pageBlock%>">다음</a>
<%					
				}
%>
			</div>
<%	
}
%>
	</body>
</html>