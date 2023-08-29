<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	//1. 한글처리 (삭제 요청 시 입력한 글의 비밀번호, 삭제할 글 번호, 글을 작성한 사람의 id 중 한글이 존재한다면 문자처리방식 UTF-8 설정)
	request.setCharacterEncoding("UTF-8");
	
	//2. 요청한 값 얻기
	int num = Integer.parseInt( request.getParameter("num") ); //삭제할 글 번호
	String passwd = request.getParameter("passwd"); //글 삭제를 위해 입력한 글의 비밀번호
	//입력한 글의 비밀번호를 얻는 이유 → DB의 테이블에 저장된 삭제할 글의 비밀번호와 입력한 비밀번호를 비교해서 동일하면 글을 DB에서 삭제시키기 위함
	String id = request.getParameter("id");
	
	//3. 비즈니스 로직 처리(응답할 값을 마련해서 응답) → 글삭제(DB작업)
	new BoardDAO().deleteBoard(num, passwd, id);
	
	//4. 게시판 목록 화면인 notice.jsp를 포워딩(재요청)해서 조회된 정보 보여주기
	response.sendRedirect("notice.jsp");
%>
