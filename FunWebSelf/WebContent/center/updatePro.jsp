<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	//1. 한글 처리(수정할 글 제목 또는 글 내용에 한글이 존재하면 request에서 꺼내올 때 한글이 깨져서 얻어와지기 때문)
	request.setCharacterEncoding("UTF-8");

	//2. 요청한 값 얻기(수정시 입력한 글 제목, 글 내용, 수정할 글 번호)
	//수정할 글번호 얻기
	int num = Integer.parseInt( request.getParameter("num") );
	//수정시 입력한 글 제목 얻기
	String subject = request.getParameter("subject");
	//수정시 입력한 글 내용 얻기
	String content = request.getParameter("content");
	
	//2.1  수정할 내용을 BoardBean객체의 변수에 저장
	BoardBean boardBean = new BoardBean();
			  boardBean.setNum(num);		 //setter호출해 수정할 글 번호 저장
			  boardBean.setSubject(subject); //setter호출해 수정을 위해 입력한 글 제목 저장
			  boardBean.setContent(content); //setter호출해 수정을 위해 입력한 글 내용 저장
	
	//3. DB작업(UPDATE 글 수정작업)
	BoardDAO boardDAO = new BoardDAO();
			 boardDAO.updateBoard(boardBean);
	
	//4. notice.jsp 재요청해서 글 목록 조회 후 보여주기
%>
	<script type="text/javascript">
		alert("수정되었습니다.");	
	</script>
<%
	response.sendRedirect("notice.jsp");
	
%>