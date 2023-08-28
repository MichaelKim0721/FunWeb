package ReferenceBoard;


import java.sql.*;
import java.util.*;

import javax.naming.*;
import javax.sql.*;

import board.BoardBean;



//DAO역할(DB연결 후 DB작업하는 클래스)
public class ReferenceBoardDAO {
	
	//DB작업에 쓰일 객체들을 저장할 변수들
	private DataSource ds;	//커넥션풀 DataSource 저장할 변수
	private Connection con;	
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	//커넥션풀(DataSource)얻는 기능의 생성자
	public ReferenceBoardDAO() {
		try {
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
			
			
		} catch (Exception e) {
			System.out.println("ReferenceBoardDAO의 생성자 내부에서 커넥션풀 얻기 실패: " + e);
		}		 
	}//생성자 끝
	
	//DB연결 후 작업하는 객체들 사용 후 자원해제할 공통으로 쓰이는 메소드
	public void freeResource() {
		try {
			if(pstmt != null) pstmt.close();
			if(rs != null) rs.close();
			if(con != null) con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//새글 정보(첨부한 원본파일명, 실제 업로드된 파일명 포함)를 jspbeginner데이터베이스의 ReferenceBoard에 추가시키는 기능의 메소드
	public void insertBoard(ReferenceBoardBean rbb) {
		
		try {
			
			//1. DataSource커넥션풀에서 Connection객체 얻기
			//   DB연결
			con = ds.getConnection();
			
			//2. 새 글(주글) 정보 INSERT SQL문 작성
			String sql = "insert into ReferenceBoard(name, passwd, subject, content, filename, fileRealName, re_ref, re_lev, re_seq, readcount, ip, id) "
					   + "values ( (select name from member where id=?), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) ";
			
			//3. INSERT문 실행할 PreparedStatement실행객체 얻기
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, rbb.getId()); //로그인을 하고 글을 작성하는 사람의 이름을 조회하기 위해 아이디 설정
			pstmt.setString(2, rbb.getPasswd());
			pstmt.setString(3, rbb.getSubject());
			pstmt.setString(4, rbb.getContent());
			pstmt.setString(5, rbb.getFilename()); //업로드 하기위해 첨부한 원본파일명
			pstmt.setString(6, rbb.getFileRealName()); //업로드한 실제 파일명
			pstmt.setInt(7, 0); //주글과 답변글을 묶어서 다른 주글과 답변글들을 파악하기 위한 그룹값
			pstmt.setInt(8, 0); //주글의 들여쓰기 정도 레벨 값
			pstmt.setInt(9, 0); //같은 그룹 내에 보여질 글들의 순서값
			pstmt.setInt(10, 0); //새 글 조회수
			pstmt.setString(11, rbb.getIp()); //새글 작성자의 IP주소
			pstmt.setString(12, rbb.getId()); //새글 작성자의 id값
			
			//4. INSERT문장 DB의 테이블에 전송해서 실행
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("ReferenceBoardDAO내부의 insertBoard에서 쿼리문 실행 오류: " + e);
		} finally {
			//DB와 관련 작업하는 객체 메모리를 사용 후 자원 해제
			freeResource();
		}
		
	}
	
	//게시판에 저장된 전체 글 개수를 조회해서 반환하는 메소드
	public int getBoardCount() {
		
		//조회한 글(행)의 개수를 저장할 변수
		int count = 0;
		
		try {
			con = ds.getConnection();
			
			String sql = "select count(*) from referenceboard";
			
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				count = rs.getInt(1);
			}
			
		} catch (Exception e) {
			System.out.println("ReferenceBoardDAO내부의 getBoardCount에서 쿼리문 실행 오류: " + e);
		} finally {
			//DB와 관련 작업하는 객체 메모리를 사용 후 자원 해제
			freeResource();
		}
		
		return count;
	}
	
	//jspbeginner DB의 ReferenceBoard 게시판테이블에 저장된
	//지정한 갯수만큼 글목록을 조회하여 반환하는 메소드
	public List<ReferenceBoardBean> getBoardList(int startRow, int pageSize) {
		
		List<ReferenceBoardBean> boardList = new ArrayList<ReferenceBoardBean>(); //배열
		
		try {
			//DB연결
			con = ds.getConnection();
			//SELECT구문 만들기
			//참고. SELECT구문의 limit 구문
			//      SELECT limit 구문은 테이블에 저장된 일부 정보만 선택해서 조회해 올 때 사용
			//      예) select * from referenceboard; ← 저장된 전체 행(레코드) 조회
			//      예) select * from referenceboard limit 0, 3; ← 저장된 전체 행(레코드)중에서 0번째 index부터 3개의 레코드를 잘라서 조회
			String sql = "select * from referenceboard order by re_ref desc, re_seq asc limit ?, ?"; //페이지번호 1을 클릭하거나 게시판 화면을 처음 요청 시
																									 //startRow = 0, pageSize = 3
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, pageSize);
			
			rs = pstmt.executeQuery();
			
			while ( rs.next() ) {
				//ResultSet에서 꺼내와 ReferenceBoardBean객체에 한줄 단위로 저장
				String content = rs.getString("content"); //조회한 글 내용
				Timestamp date = rs.getTimestamp("date"); //조회한 글 작성날짜
				String fileName = rs.getString("filename"); //조회한 글 작성 시 첨부했던 원본파일명
				String fileRealName = rs.getString("fileRealName"); //조회한 글 작성 시 업로드한 실제 파일명
				String ip = rs.getString("ip"); //조회한 글 작성자의 ip주소
				String name = rs.getString("name"); //조회한 글 작성자명
				int num = rs.getInt("num"); //조회한 글 번호
				String passwd = rs.getString("passwd"); //조회한 글의 비밀번호
				int re_lev = rs.getInt("re_lev"); //조회한 글의 들여쓰기 정도 값
				int re_ref = rs.getInt("re_ref"); //조회한 글의 그룹값
				int re_seq = rs.getInt("re_seq"); //조회한 글의 그룹 내에서의 순서값
				int readCount = rs.getInt("readCount"); //조회한 글의 조회수
				String subject = rs.getString("subject"); //조회한 글 제목
				String id = rs.getString("id"); //조회한 글의 작성자 id
				
				ReferenceBoardBean rbb = new ReferenceBoardBean(num, name, passwd, subject, content, fileName, fileRealName, re_ref, re_lev, re_seq, readCount, date, ip, id);
				
				boardList.add(rbb); //ArrayList배열에 추가
				
			} //while
			
		} catch (Exception e) {
			System.out.println("ReferenceBoardDAO내부의 getBoardList에서 쿼리문 실행 오류: " + e);
		} finally {
			//DB와 관련 작업하는 객체 메모리를 사용 후 자원 해제
			freeResource();
		}
		
		return boardList; //ReferenceNotice.jsp페이지에 ArrayList배열 반환
	}
	
	//글 목록 화면에서 하나의 글 행을 클릭 시 조회할 글 번호를 매개변수로 전달 받아 글 번호에 해당하는 글의 조회수 1증가 시키는 메소드
	public void updateReadCount(int num) {
		
		try {
			//DB연결
			con = ds.getConnection();
			//매개변수로 전달받는 글 번호에 해당하는 글의 조회수(readCount열의 값)를 1 증가하여 UPDATE하는 SQL문
			String sql = "update referenceboard set readCount = readCount + 1 where num = ?";
			//update문 실행할 PreparedStatement객체 얻기
			pstmt = con.prepareStatement(sql);
			//? 설정
			pstmt.setInt(1, num);
			//완성된 UPDATE구문 실행
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("ReferenceBoardDAO내부의 updateReadCount에서 쿼리문 실행 오류: " + e);
		} finally {
			//DB와 관련 작업하는 객체 메모리를 사용 후 자원 해제
			freeResource();
		}
		
		
	}
	
	//글번호 하나를 매개변수로 전달받아 글번호에 대한 글정보 조회 하여 반환하는 메소드
	public ReferenceBoardBean getBoard(int number) {
		
		
		ReferenceBoardBean boardBean = null;
		
		try {
			//1. 커넥션풀(DataSource)에서 DB와 미리 연결 맺은 접속정보를 갖고있는 커넥션 객체 빌려오기
			//DB와의 연결
			con = ds.getConnection();
			//2. SELECT문장을 만들어 PreparedStatement실행객체에 로드 후 얻기
			//SELECT문장 → 글번호에 해당하는 글을 조회하는 SELECT문장 만들기
			pstmt = con.prepareStatement("select * from referenceboard where num=?");
			//3. ?값을 매개변수 num으로 설정
			pstmt.setInt(1, number);
			//4. PreparedStatement실행객체메모리에 설정된 전체 select문장을 DB의 board테이블에 전송해서 실행
			//   실행 후 조회된 결과 데이터들을 ResultSet임시객체메모리에 담아 ResultSet객체 메모리 반환
			rs = pstmt.executeQuery();
			//5. ResultSet객체에 저장된 조회된 글의 레코드 정보를 꺼내와 BoardBean객체 생성 후 각 변수에 저장
			rs.next(); //커서 위치를 조회된 레코드 행으로 내려주고
			
			//ResultSet에서 꺼내와 ReferenceBoardBean객체에 한줄 단위로 저장
			String content = rs.getString("content"); //조회한 글 내용
			Timestamp date = rs.getTimestamp("date"); //조회한 글 작성날짜
			String fileName = rs.getString("filename"); //조회한 글 작성 시 첨부했던 원본파일명
			String fileRealName = rs.getString("fileRealName"); //조회한 글 작성 시 업로드한 실제 파일명
			String ip = rs.getString("ip"); //조회한 글 작성자의 ip주소
			String name = rs.getString("name"); //조회한 글 작성자명
			int num = rs.getInt("num"); //조회한 글 번호
			String passwd = rs.getString("passwd"); //조회한 글의 비밀번호
			int re_lev = rs.getInt("re_lev"); //조회한 글의 들여쓰기 정도 값
			int re_ref = rs.getInt("re_ref"); //조회한 글의 그룹값
			int re_seq = rs.getInt("re_seq"); //조회한 글의 그룹 내에서의 순서값
			int readCount = rs.getInt("readCount"); //조회한 글의 조회수
			String subject = rs.getString("subject"); //조회한 글 제목
			String id = rs.getString("id"); //조회한 글의 작성자 id
			
			boardBean = new ReferenceBoardBean(num, name, passwd, subject, content, fileName, fileRealName, re_ref, re_lev, re_seq, readCount, date, ip, id);
			
			
		} catch (Exception e) {
			System.out.println("ReferenceBoardDAO내부의 getBoard메소드 내부에서 쿼리문 실행 오류: " + e);
		} finally {
			freeResource();
		}
		
		return boardBean; //Fcontent.jsp로 조회된 글 하나의 정보가 저장된 ReferenceBoardBean객체를 반환
	}
	
	//수정할 글번호에 해당되는 글의 비밀번호를 조회해서 수정시 입력한 비밀번호와 비교 후 같으면 UPDATE
	//UPDATE 성공시 1 반환받아 check변수에 저장, 실패시
	public int updateBoard(ReferenceBoardBean bean) {
		
		int check = 0;
		
		String sql = ""; 
		
		try {
			//DB연결
			con = ds.getConnection();
			
			//수정할 글번호에 해당되는 글의 비밀번호 조회SELECT
			sql = "select passwd from referenceboard where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bean.getNum());
			rs = pstmt.executeQuery();
			
			if(rs.next()) { //수정할 글 번호에 해당되는 비밀번호가 조회되면
				
				//수정시 입력한 비밀번호와 DB에서 조회한 수정할 글의 비밀번호가 같은지 비교
				if( bean.getPasswd().equals( rs.getString("passwd") ) ) {
					check = 1;
					
					//UPDATE문 작성
					sql = "update referenceboard set subject=?, content=?, fileName=?, fileRealName=? WHERE num=?";
					//UPDATE문 실행할 PreparedStatement객체 얻기
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, bean.getSubject());
					pstmt.setString(2, bean.getContent());
					pstmt.setString(3, bean.getFilename());
					pstmt.setString(4, bean.getFileRealName());
					pstmt.setInt(5, bean.getNum());
					//UPDATE문 DB에 전송하여 실행
					pstmt.executeUpdate();
					
				} else {
					check = 0;
				}
					
			}
			
		} catch (Exception e) {
			System.out.println("ReferenceBoardDAO내부의 updatetBoard메소드 내부에서 쿼리문 실행 오류: " + e);
		} finally {
			freeResource();
		}
		
		return check;
	}
	
}
