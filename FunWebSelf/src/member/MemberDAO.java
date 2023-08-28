package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//DAO는 데이터베이스 연결을 맺은 후 DB작업하는 자바빈클래스 종류중 하나!

public class MemberDAO {

	//데이터베이스 작업관련 객체들을 저장할 변수들
	DataSource ds;//커넥션풀 역할을 하는 DataSouce객체의 주소를 저장할 변수 
	Connection con; //커넥션풀에 미리 만들어 놓고 DB와의 접속이 필요하면 빌려와서 사용할 DB접속정보를 가지고 있는 Connection객체의 주소를 저장할 변수 
	PreparedStatement pstmt;//생성한 SQL문을 DB에 전송해서 실행할 역할을하는 PreparedStatement실행객체의 주소를 저장할 변수 
	ResultSet rs;//DB의 테이블에 저장된 정보를 조회한 결과를 임시로 얻기 위한 ResultSet객체 메모리의 주소를 저장할 변수 
	
	//커넥션풀 생성 및 커넥션 객체를 얻어 커넥션객체자체를 반환 하는  기능의 메소드 
	private Connection getConnection() throws Exception {
		
		//1. InitialContext객체 생성
		//생성하는 이유는  자바의 네이밍 서비스(JNDI)에서 이름과 실제 객체를 연결해주는 개념이 Context이며,
		//InitialContext객체는 네이밍 서비스를 이용하기위한 시작점입니다.
		Context initCtx = new InitialContext();
		//2. "java:comp/env"라는 주소를 전달하여  Context객체를 얻었습니다.
		//"java:comp/env" 주소는 현재 웹 애플리케이션의 루트 디렉터리 라고 생각 하면됩니다.
		//즉! 현재 웹애플리케이션이 사용할수 있는 모든 자원은 "java:comp/env"아래에 위치합니다.(<Context></Context/>이위치를 말합니다.)
		Context ctx = (Context)initCtx.lookup("java:comp/env");
		//3. "java:comp/env 경로 아래에 위치한  "jdbc/jspbeginner" Recource태그의  DataSource커넥션풀을 얻는다
		ds = (DataSource)ctx.lookup("jdbc/jspbeginner");		 
		//4. 마지막으로 커넥션풀(DataSouce)객체 메모리 에 저장된 Connection객체를 반환받아 사용
		con = ds.getConnection();
		return con;
	}
	
	//jspbeginner데이터베이스의 member테이블에 새 회원을 추가 하는 기능의 메소드 
	public int insertMember(MemberBean memberbean){
		
		int result = 0; // insert에 성공하면 1을 저장, 실패하면 0을 저장 
		String sql = ""; // insert 쿼리문 저장할 변수 
		
		try {
			//1.커넥션풀에서 커넥션 객체 얻기 (DB와 MemberDAO.java와 연결을 맺은 정보를 가지고 있는 Connection객체 얻기)
			//  요약 : DB와의 연결
			con = getConnection();
			//2. insert 쿼리문(SQL문) 만들기
			sql = "insert into member(id,passwd,name,gender,email,address,tel,mtel,age,reg_date)" +
							  "values(?,   ?,    ?,    ?,     ?,    ?,     ?,   ?,  ?,    ?)";
			//3. PreparedStatement insert 쿼리문 실행할 객체 얻기 
			pstmt = con.prepareStatement(sql);
			//3.1  ? 기호에 대응되게 insert할 값들을 설정 (순서대로)
			pstmt.setString(1, memberbean.getId());
			pstmt.setString(2, memberbean.getPasswd());
			pstmt.setString(3, memberbean.getName());
			pstmt.setString(4, memberbean.getGender());
			pstmt.setString(5, memberbean.getEmail());
			pstmt.setString(6, memberbean.getAddress());
			pstmt.setString(7, memberbean.getTel());
			pstmt.setString(8, memberbean.getMtel());
			pstmt.setInt(9, memberbean.getAge());
			pstmt.setTimestamp(10, memberbean.getReg_date());
			//4. 완성된 insert 쿼리문 DB의 member테이블에 전송해 실행합니다.
			// excuteUpdate메소드는 insert, update, delete 문을 실행하는 메소드로  성공하면 1을 반환 실패하면 0을 반환 하는 메소드임.
			result = pstmt.executeUpdate();
		
		} catch (Exception e) {
			System.out.println("MemberDAO클래스의 insertMember메소드 내부에서  insert문장 실행 예외발생 : " + e.toString());
		} finally {
			//6.자원해제
			try {
				if(pstmt != null) {
					pstmt.close();
				}
				if(rs != null) {
					rs.close();
				}
				if(con != null) {
					con.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	
		//5.   joinPro.jsp페이지에 insertMember메소드 호출구문을 작성한 줄로  1 또는 0을 반환
		return result;
	}
	
	//회원가입을 위해 입력한 아이디를 매개변수로 id로 전달받아
	//DB의 테이블에 저장되어 있는지 유무를 검사하는 메소드
	//만약 입력한 아이디가 DB에 저장되어 있으면 1을 check변수에 저장하여 반환하고
	//만약 입력한 아이디가 DB에 저장되어 있지 않으면 0을 check변수에 저장하여 반환
	public int idCheck(String id) {
		
		int check = 0;
		
		String sql = "";
		
		try {
			//1.커넥션풀에서 커넥션 객체 얻기 (DB와 MemberDAO.java와 연결을 맺은 정보를 가지고 있는 Connection객체 얻기)
			//  요약 : DB와의 연결
			con = getConnection();
			//2. 입력한 아이디에 해당하는 회원레코드 조회 SELECT 쿼리문 만들기
			sql = "select * from member where id='"+id+"'";
			//3. PreparedStatement실행객체 얻기
			pstmt = con.prepareStatement(sql);
			//4. select문장 DB에 전송해서 실행 후 조회 결과를 ResultSet으로 반환받기
			rs = pstmt.executeQuery();
			//5. 입력한 아이디에 해당하는 회원 레코드가 조회 되면(아이디 중복)
			if(rs.next()) {
				check = 1;
			} else {
				check = 0;
			}
			
		} catch (Exception e) {
			System.out.println("MemeberDAO의 idCheck메소드 내부에서 SQL 실행오류: " + e);
		} finally {
			//7. 자원반납(커넥션풀에 Connection객체 사용 후 반납)
			try {
				if(pstmt != null) {
					pstmt.close();
				}
				if(rs != null) {
					rs.close();
				}
				if(con != null) {
					con.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		//6. join_IDcheck.jsp로 반환
		return check;
	}
	
	
}






