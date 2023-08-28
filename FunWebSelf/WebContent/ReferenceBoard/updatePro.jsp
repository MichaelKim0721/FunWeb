<%@page import="ReferenceBoard.ReferenceBoardBean"%>
<%@page import="ReferenceBoard.ReferenceBoardDAO"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>updatePro.jsp</title>
	</head>
	<body>
	<%
		//한글처리
		request.setCharacterEncoding("UTF-8");
	
		//실제 수정할 파일이 있는 폴더(upload) 경로 얻기
		String path = application.getRealPath("/upload/");
		
		//실제 수정하여 업로드할 파일의 최대 크기
		int maxSize = 1024 * 1024 * 1024;
		
		//실제 수정시 첨부한 파일 업로드
		MultipartRequest multipartRequest = new MultipartRequest( request, path, maxSize, "UTF-8", new DefaultFileRenamePolicy() );
		
		//실제 수정할 글 내용 얻기
		String pageNum = multipartRequest.getParameter("pageNum"); //글을 조회했을 때의 수정할 글이 보였던 페이지번호
		int num = Integer.parseInt( multipartRequest.getParameter("num") ); //수정할 글번호
		String passwd = multipartRequest.getParameter("passwd"); //수정시 입력한 비밀번호
		String subject = multipartRequest.getParameter("subject"); //수정시 입력한 글 제목
		String fileName = multipartRequest.getOriginalFileName("file"); //수정시 첨부한 파일의 원본이름 얻기
		String fileRealName = multipartRequest.getFilesystemName("file"); //수정시 업로드한 실제 파일명 얻기 
		String content = multipartRequest.getParameter("content"); //수정시 입력한 글 내용 얻기
		String originFileName = multipartRequest.getParameter("fileRealName");
		
		System.out.println(path + originFileName);
		
		File deleteFilePath = new File(path + originFileName);
			 deleteFilePath.delete();
		
		//ReferenceBoardBean객체 생성
		ReferenceBoardBean bean = new ReferenceBoardBean();
						   bean.setNum(num);
						   bean.setPasswd(passwd);
					  	   bean.setSubject(subject);
						   bean.setFilename(fileName);
						   bean.setFileRealName(fileRealName);
						   bean.setContent(content);
		
		//업데이트 전 비밀번호가 DB의 비밀번호와 같은지 확인하기
		
		
		//실제 수정할 글 내용을 DB에 UPDATE
		//수정에 성공하면 1을 반환하여 ReferenceNotice.jsp 포워딩하여 보여주기
		//수정에 실패하면 입력한 비밀번호가 DB의 글 비밀번호랑 다르기때문에 0을 반환하여 다시 update.jsp로 포워딩하여 보여주기
		ReferenceBoardDAO dao = new ReferenceBoardDAO();
		int check = dao.updateBoard(bean);
		
		if(check == 1) {
		%>
			<script type="text/javascript">
				confirm("정말로 수정하시겠습니까?");
				alert("수정성공");
				location.href="ReferenceNotice.jsp?pageNum=<%=pageNum%>"
			</script>
		<%
		} else {
		%>	
			<script type="text/javascript">
				alert("수정에 실패하였습니다.");
				history.back();
			</script>
		<%
		}
		
	%>
	</body>
</html>