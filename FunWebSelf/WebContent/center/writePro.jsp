<%@page import="board.BoardDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
	</head>
	<body>
		<h1>writePro.jsp</h1>
		
		<%--
			입력한 새 글 정보를 모두 request객체에서 꺼내와서
			BoardBean객체 생성 후 각 변수에 저장
			조건: BoardBean의 변수명과 write.jsp의 <input>의 name속성의 값 이름이 동일해야함
		--%>
		<jsp:useBean id="bean" class="board.BoardBean" />
		<jsp:setProperty name="bean" property="*" />
		
<%
		
		//추가로 글 쓴 현재 날짜정보 BoardBean객체의 변수에 저장
		bean.setRegdate(new Timestamp(System.currentTimeMillis()));
		//추가로 글 쓴 사람의 PC IP정보를 구해 BoardBean객체의 변수에 저장
		bean.setIp( request.getRemoteAddr() );
		
		//BoardDAO객체 생성 후 BoardBean객체에 저장된 정보(입력한 새 글의 정보)를 DB의 board테이블에 Insert
		new BoardDAO().insertBoard(bean);
		
		//새글 정보를 DB의 INSERT에 성공하면 이 코드가 실행되어 notice.jsp를 재요청해서 보여줌
		response.sendRedirect("notice.jsp");
%>
		
		
		
		
	</body>
</html>