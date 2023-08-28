<%@page import="ReferenceBoard.ReferenceBoardDAO"%>
<%@page import="ReferenceBoard.ReferenceBoardBean"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	//1. 한글처리
	request.setCharacterEncoding("UTF-8");
	
	//3. 실제 업로드 할 폴더(upload) 위치 얻기
	String path = application.getRealPath("/upload/");
	// C:\myJSP\workspace2\FunWeb\WebContent\ upload \
	
	//3.1 한번 업로드할 파일 크기 설정 1GB (1024 - KB, 1024 * 1024 - MB, 1024 * 1024 * 1024 - GB)
	int maxSize = 1024 * 1024 * 1024;
	 
	//3.2 cos.jar라이브러리에서 제공해주는 MultipartRequest클래스의 객체 생성 시 생성자로 업로드할 정보를 넘겨주면
	//    지정한 upload폴더 위치에 파일이 업로드 됨
	MultipartRequest multipartRequest = new MultipartRequest( request, path, maxSize, "UTF-8", new DefaultFileRenamePolicy() );
	
	//4. 입력한 글의 내용들은 위 MultipartRequest객체 메모리에 저장되어 있으므로
	//   꺼내와서 ReferenceBoardBean 객체 생성 후 인스턴스 변수에 각각 저장
	String content = multipartRequest.getParameter("content"); //입력한 글 내용 얻기
	String passwd = multipartRequest.getParameter("passwd"); //글의 비밀번호 얻기
	String subject = multipartRequest.getParameter("subject"); //글의 제목 얻기
	String fileName = multipartRequest.getOriginalFileName("file"); //글에 첨부한 파일의 원본파일명 얻기
	String fileRealName = multipartRequest.getFilesystemName("file"); //실제 업로드 된 파일명 얻기
	String ip = request.getRemoteAddr(); //글쓴이의 IP주소 얻기
	//2. 로그인한 글 작성자 ID값을 session에서 얻기
	String id = (String)session.getAttribute("id");
	
	ReferenceBoardBean rbb = new ReferenceBoardBean();
	rbb.setContent(content);
	rbb.setPasswd(passwd);
	rbb.setSubject(subject);
	rbb.setFilename(fileName);
	rbb.setFileRealName(fileRealName);
	rbb.setIp(ip);
	rbb.setId(id);
	
	//5. 비즈니스 로직(DB와 연결해서 작업)을 하기 위해 DAO객체 생성 후 메소드 호출
	new ReferenceBoardDAO().insertBoard(rbb); //새 글 정보 insert작업
	
	//6. 글 추가에 성공하면 ReferenceNotice.jsp목록화면을 재요청(포워딩)
	response.sendRedirect("ReferenceNotice.jsp");
	
	
	
	
	
	
	
%>