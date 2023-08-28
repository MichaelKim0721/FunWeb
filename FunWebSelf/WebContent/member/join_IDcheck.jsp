<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>아이디 중복체크시 사용할 팝업창(자식창)</title>
	</head>
	<body>
		<%
			//1. 문자처리방식 UTF-8설정
			request.setCharacterEncoding("UTF-8");
		
			//2.1 join.jsp페이지에서 가입을 위해 입력한 아이디 얻기
			//2.2 join_IDcheck.jsp페이지의 가장 아래쪽의 form태그에서 DB에 가입할 아이디가 저장되어 있는지 판단하기 위해 입력한 아이디를
			//	  request객체로부터 얻기
			String id = request.getParameter("userid");
			//id값이 넘어가지 않았음
			//System.out.println(id);
			//3. 입력한 아이디가 DB에 저장되어 있는지 SELECT조회해서 있으면 아이디 중복이므로 1을 반환받고 없으면 0을 반환받을
			//	 MemberDAO객체의 idCheck메소드 호출 시 매개변수로 우리가 입력한 아이디를 전달해서 DB작업
			int checkResult = new MemberDAO().idCheck(id);
			
			//4. checkResult변수에 저장된 값이 1이면 아이디중복(DB에 입력한 아이디 저장되어 있음)
			if(checkResult == 1) {
				out.print("이미 사용 중인 아이디입니다.");
			} else {
				out.print("사용 가능한 아이디입니다.");
			}
		%>
	</body>
</html>