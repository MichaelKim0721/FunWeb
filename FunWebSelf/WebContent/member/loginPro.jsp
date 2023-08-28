<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="member.MemberDAO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. 요청한 값 한글처리 (request객체 메모리에 한글문자 처리방식 UTF-8로 설정)
	request.setCharacterEncoding("UTF-8");

	//2. 요청한 값 얻기 (입력받은 아이디,비밀번호를 request객체 메모리에서 꺼내와 얻기)
	String id = request.getParameter("id");
	String passwd = request.getParameter("passwd");
	
	Context ctx = new InitialContext();
	DataSource ds = (DataSource)ctx.lookup("java:comp/env/jdbc/jspbeginner");
	Connection con = ds.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	pstmt = con.prepareStatement( "select id, passwd from member where id=?" ); 
	
	pstmt.setString(1, id);
	rs = pstmt.executeQuery();
	
	//3. 요청한 값을 이용해 웹브라우저로 응답할 값을 마련 (DB에 입력한 아이디,비밀번호가 저장되어 있는지 조회후 결과값)
	//DB에 저장된 ID -> "master" ,   DB에저장된 비밀번호 -> "1111"  값이라고 가정하고 시작!
	if(rs.next()){
		if(rs.getString("passwd").equals(passwd)){			
			//session객체 메모리에 로그인 인증값 저장
			session.setAttribute("id", id);
			//홈페이지의 main화면(index.jsp) 재요청해서 로그인된 화면 보여주자.
%>
			<script>
				history.go(-2);
			</script>
<%
		}else{
%>			
			<script type="text/javascript">
				window.alert("비밀번호가 틀렸습니다.");
				//이전페이지(login.jsp)를 재요청해서 이동
				history.back();
			</script>
<%		
		}		
	}else{//DB에 저장된 ID와 로그인을 위해 입력한 아이디가 다를때~
%>		
			<script type="text/javascript">
				window.alert("아이디가 틀렸습니다.");
				history.back();
			</script>	
<%		
	}
%>




