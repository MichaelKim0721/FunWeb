<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	//1. 한글처리
	request.setCharacterEncoding("UTF-8");

	//2. 요청한 값 얻기(작성한 답변글 정보 + 부모글의 글번호)
	int num = Integer.parseInt( request.getParameter("num") ); //부모글번호
	
	int pos = Integer.parseInt( request.getParameter("pos") ); //부모글의 pos열 값
	int depth = Integer.parseInt( request.getParameter("depth") ); //부모글의 depth 들여쓰기 정도 값
	
	String passwd = request.getParameter("passwd"); //답변글 작성 시 입력한 비밀번호
	String subject = request.getParameter("subject"); //답변글 추가 시  입력되어 있던 부모글의 글제목
	String content = request.getParameter("content"); //답변글 내용
	String id = request.getParameter("id"); //답변글 작성자 아이디
	
	//2.1 BoardBean객체 생성하여 요청한 값 저장
	BoardBean boardBean = new BoardBean();
			  boardBean.setNum(num); //부모글번호
			  boardBean.setPos(pos); //부모글의 pos
			  boardBean.setDepth(depth); //부모글의 depth
			  boardBean.setPasswd(passwd); //작성하는 답변글의 비밀번호
			  boardBean.setSubject(subject); //작성하는 답변글의 제목
			  boardBean.setContent(content); //작성하는 답변글의 내용
			  boardBean.setId(id); //답변글 작성자 아이디
	
	//3. 답글 DB에 추가
	BoardDAO boardDAO = new BoardDAO();

	//답글 insert 규칙
	//1. 부모글(주글)보다 큰 pos값을 가진 부모글들의 pos를 1증가
	boardDAO.replyUpPos(pos);
	
	//2. 답변글을 insert할 때 부모글의 pos열의 값에 1 더한 값을 insert
	//3. 답변글을 insert할 때 부모글의 depth열의 값에 1 더한 값을 insert
	boardDAO.replyBoard(boardBean);
	
	//4. 답글을 DB에 insert 성공 시 notice.jsp를 재요청하여 조회된 글 목록 화면을 보여주기
	response.sendRedirect("notice.jsp");
	
	
	
	
%>