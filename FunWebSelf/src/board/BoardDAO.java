package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

//DAO역할(DB연결 후 DB작업하는 클래스)
public class BoardDAO implements IBoardDAO {
	
	//DB작업에 쓰일 객체들을 저장할 변수들
	private DataSource ds;	//커넥션풀 DataSource 저장할 변수
	private Connection con;	
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	//커넥션풀(DataSource)얻는 기능의 생성자
	public BoardDAO() {
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
			System.out.println("BoardDAO의 생성자 내부에서 커넥션풀 얻기 실패: " + e);
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
	
	
	//선택한 검색기준값과 입력한 검색어를 매개변수로 전달 받아 DB의 board테이블에 저장된 글목록정보 조회해서 반환하는 메소드
	@Override
	public Vector getBoardList(String keyField, String keyWord) {
		
		//Vector가변길이 배열 생성
		Vector vector = new Vector();	//BoardBean객체(글 하나하나)의 정보들을 하나씩 저장하는 용도의 벡터배열
		
		//SELECT문을 만들어 저장할 변수
		String sql = "";
		
		//BoardBean객체 생성할 변수
		BoardBean bean = null;
		
		try {
			//1. DataSource커넥션풀 메모리에서 DB와 미리 연결을 맺은 접속정보를 가지고 있는 Connection객체를 빌려오기
			//DB와의 접속
			con = ds.getConnection();
			//2. 검색어를 입력했을 경우와 검색어를 입력하지 않았을 경우 각각 SELECT문장 다르게 만들기
			if(keyWord == null || keyWord.isEmpty()) { //검색어를 입력하지 않았을 경우
				//DB의 board 테이블에 저장되어 있는 모든 글의 정보 조회하되 가장최신글은 가장 위로 올라오게 글번호를 기준으로 내림차순 정렬하여 조회하는 SELECT문
				sql = "select * from board order by num desc";
			} else { //검색어를 입력했을 경우
				//selecet * : 모든 열(컬럼)의 데이터를 선택해서 조회
				//from board : board테이블에서 조회
				//where "keyField" like '%"keyWord"%' : where적을 사용하여 조건에 맞는 레코드를 조회해오는데,
				//									    keyField열의 값 중 keyWord가 포함된 문자열을 조회
				
				//board 테이블의 keyField(검색조건값)열의 값이 keyWord(검색어) 문자열을 포함하고 있으면
				//포함하고 있는 글을 레코드(행)단위로 조회하되, 글번호를 기준으로 내림차순 정렬 후 최종 조회
				sql = "select * from board where " + keyField + " like '%" + keyWord + "%' order by num desc";
				//sql = "select * from board where " + keyField + " like ? order by num desc";
			}
			
			//3. PreparedStatement 실행 객체 얻기
			//pstmt.setString(1, "%" + keyWord + "%"); → 위 ? 기호로 설정 시 이렇게 작성하기
			pstmt = con.prepareStatement(sql);
			
			//4. 조회된 결과데이터들을 ResultSet에 담아 반환
			rs = pstmt.executeQuery();
			
			//5. 조회된 결과데이터들은 ResultSet에 저장되어 있으므로 커서가 위치한 행(레코드)단위의 정보씩 꺼내와서
			//   BoardBean객체 생성 후  저장하며, BoardBean객체들을 차례로 Vector배열에 추가하여 저장
			while(rs.next()) {
				//BoardBean객체 생성
				bean = new BoardBean();
				//ResultSet객체의 커서가 위치한 조회한 행의 정보를 꺼내어 BoardBean객체의 인스턴스변수에 각각 저장
				bean.setNum( rs.getInt("num") );
				bean.setName( rs.getString("name") );
				bean.setPasswd( rs.getString("passwd") );
				bean.setSubject( rs.getString("subject") );
				bean.setContent( rs.getString("content") );
				bean.setPos( rs.getInt("pos") );
				bean.setDepth( rs.getInt("depth") );
				bean.setCount( rs.getInt(8) );
				bean.setIp( rs.getString("ip") );
				bean.setRegdate( rs.getTimestamp("regdate") );
				bean.setId( rs.getString(11) );
				
				//Vector가변으로 늘어나는 배열에 추가
				vector.add(bean);
				// [ new BoardBean(),	1 index
				//	 new BoardBean(),	2 index 
				//	 new BoardBean(), 	3 index
				//	 new BoardBean(), 	4 index
				//	 new BoardBean(), 	5 index
				//	 new BoardBean(), 	6 index
				//	 new BoardBean(), 	7 index
				//	 new BoardBean(), 	8 index
				//	 new BoardBean(), 	9 index
				//	 new BoardBean(), 	10 index
				//	 new BoardBean(), 	11 index
				//	 new BoardBean(), 	12 index
				//	 new BoardBean(), 	13 index
				//	 new BoardBean(), 	14 index
				//	 new BoardBean(), 	15 index
				//	 new BoardBean(), 	16 index
				//	 new BoardBean(), 	17 index
				//	 new BoardBean(), 	18 index
				//	 new BoardBean() ] 	19 index
			}
			
		} catch (Exception e) {
			System.out.println("BoardDAO의 getBoardList메소드 호출 시 쿼리문 실행 오류: " + e);
		} finally {
			//자원해제
			freeResource();
		}
		
		return vector;
	}
	
	//글 번호 하나를 매개변수 int num으로 전달받아 글번호에 해당하는 글의 레코드정보를 조회, 반환하는 메소드
	@Override
	public BoardBean getBoard(int num) { //content.jsp에서 호출한 메소드
		
		BoardBean boardBean = null;
		
		try {
			//1. 커넥션풀(DataSource)에서 DB와 미리 연결 맺은 접속정보를 갖고있는 커넥션 객체 빌려오기
			//DB와의 연결
			con = ds.getConnection();
			//2. SELECT문장을 만들어 PreparedStatement실행객체에 로드 후 얻기
			//SELECT문장 → 글번호에 해당하는 글을 조회하는 SELECT문장 만들기
			pstmt = con.prepareStatement("select * from board where num=?");
			//3. ?값을 매개변수 num으로 설정
			pstmt.setInt(1, num);
			//4. PreparedStatement실행객체메모리에 설정된 전체 select문장을 DB의 board테이블에 전송해서 실행
			//   실행 후 조회된 결과 데이터들을 ResultSet임시객체메모리에 담아 ResultSet객체 메모리 반환
			rs = pstmt.executeQuery();
			//5. ResultSet객체에 저장된 조회된 글의 레코드 정보를 꺼내와 BoardBean객체 생성 후 각 변수에 저장
			rs.next(); //커서 위치를 조회된 레코드 행으로 내려주고
			
			int searchNum = rs.getInt("num"); //조회된 글 번호
			int searchCount = rs.getInt("count"); //조회된 글 조회수
			String searchName = rs.getString("name"); //조회된 작성자명
			Timestamp searchRegdate = rs.getTimestamp("regdate"); //조회된 글 작성일
			String searchSubject = rs.getString("subject"); //조회된 글 제목
			String searchContent = rs.getString("content"); //조회된 글 내용
			
			boardBean = new BoardBean();
			boardBean.setNum(searchNum); //조회된 글번호 저장
			boardBean.setCount(searchCount); //조회된 글 조회수 저장
			boardBean.setName(searchName); //조회된 작성자명 저장
			boardBean.setRegdate(searchRegdate); //조회된 글 작성날짜 정보 저장
			boardBean.setSubject(searchSubject); //조회된 글 제목 저장
			boardBean.setContent(searchContent); //조회된 글 내용 저장
			
			
		} catch (Exception e) {
			System.out.println("BoardDAO내부의 getBoard메소드 내부에서 쿼리문 실행 오류: " + e);
		} finally {
			freeResource();
		}
		
		return boardBean; //글제목 클릭 시 전달한 글번호에 해당되는 글의 정보를 BoardBean객체에 담아서 BoardBean객체 자체를 반환
	}

	//게시판의 새 글 정보를 DB의 board테이블에 추가하는 기능의 메소드
	@Override
	public void insertBoard(BoardBean boardBean) {
		
		String sql = "";
		int num = 0;	//추가할 새 글의 글번호를 구해서 저장할 변수
		
		try {
			//1. 커넥션풀에서 커넥션 객체 빌려오기
			con = ds.getConnection();
			//2. DB에 저장된 최신 글번호를 조회해서 얻는 SELECT문 생성
			sql = "select max(num) from board";
			//3. PreparedStatement 실행객체 얻기
			pstmt = con.prepareStatement(sql);
			//4. 위 select문 실행 후 결과 데이터를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			/*
				ResultSet객체 메모리 모습
				→	max(num)
					20
			*/
			//5. 만약 조회된 최신 글번호 12가 있다면
			if(rs.next()) {
				//조회된 최신 글번호 + 1한 값을 추가할 새글번호로 사용하기 위해 변수에 저장
				num = rs.getInt(1) + 1;
			} else {
				num = 1; //조회된 최신 글번호가 없을 때(DB의 board테이블에 글이 없을 때)
						 //추가할 새 글번호를 1로 설정하기 위해 변수에 저장
			}
			/*
			//로그인 후 글을 작성하는 회원 아이디에 해당하는 회원이름을 member테이블에서 조회
			//→ 아래의 insert문장에 글쓴이의 이름을 ?값대신 설정하기 위해서
			sql = "select name from member where id=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, boardBean.getId());
			rs = pstmt.executeQuery();
			rs.next();
			String name = rs.getString("name");
			*/
			//6. Insert문장 만들기
			sql = "insert into board(num, name, id, passwd, subject, content, pos, depth, count, ip, regdate) " + 
							 "values(?, (select name from member where id=?), ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			//7. PreparedStatement 객체 얻기
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.setString(2, boardBean.getId());	//로그인하고 글작성하는 사람의 이름을 select절에서 조회하기 위해 ?값을 member테이블의 id로 설정
			pstmt.setString(3, boardBean.getId());	//글을 작성하는 사람의 id로 설정
			pstmt.setString(4, boardBean.getPasswd());
			pstmt.setString(5, boardBean.getSubject());
			pstmt.setString(6, boardBean.getContent());
			pstmt.setInt(7, 0);	//pos	: 주글과 답변글을 묶어서 관리하게 될 그룹값
			pstmt.setInt(8, 0);	//depth	: 주글의 들여쓰기 정도값
			pstmt.setInt(9, 0);	//count	: 글조회수
			pstmt.setString(10, boardBean.getIp());	//ip : 글작성자 IP주소
			pstmt.setTimestamp(11, boardBean.getRegdate());	//regdate : 글을 작성한 날짜와 시간정보
			
			//8. insert문 실행
			pstmt.executeUpdate();
			
			
		} catch (Exception e) {
			System.out.println("BoardDAO의 insertBoard메소드 내부에서 쿼리문 실행오류: " + e.toString());
		} finally {
			//자원해제
			freeResource();
		}
		
	}//insertBoard메소드 끝
	
	//notice.jsp에서 글 제목 클릭 시 클릭한 글 정보 중 글 조회수 1 증가 시키는 기능의 메소드
	public void updateReadCount(int num) { //content.jsp페이지에서 호출하는 메소드
		String sql = ""; //update구문을 생성하여 저장할 변수
		
		try {
			//1. 커넥션풀에서 커넥션 객체 빌려오기
			//DB 접속
			con = ds.getConnection();
			//2. UPDATE 쿼리문 작성
			//→ 매개변수 int num으로 전달받는 글번호에 해당하는 글의 정보 중 글 조회수가 저장되는 count열에 대한 값을 1누적
			sql = "update board set count=count+1 where num=?";
			//3. PreparedStatement UPDATE문 실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			//3.1  ?기호에 대응되는 값 설정
			pstmt.setInt(1, num);
			//4. UPDATE문 DB의 board테이블에 전송해서 실행
			pstmt.executeUpdate();
			
			
		} catch (Exception e) {
			System.out.println("BoardDAO클래스 내부에 만든 updateReadCount내부에서 쿼리문 실행 오류: " + e);
		} finally {
			freeResource();
		}
	}

	//updatePro.jsp에서 호출하는 메소드
	//수정을 위해 입력한 글 제목 + 글 내용 + 수정할 글 번호가 저장된 BoardBean객체를 매개변수로 받아 
	//UPDATE구문 완성 후 글의 정보를 수정
	@Override
	public void updateBoard(BoardBean boardBean) {
		
		try {
			//1. 커넥션풀에서 커넥션 객체 빌려오기
			//DB와의 접속
			con = ds.getConnection();
			//2. UPDATE문 만들기
			//→ 매개변수로 전달받은 BoardBean객체에 저장된 num 변수의 수정할 글 번호에 해당되는 글 수정을 위해 입력한
			//  글 제목, 글 내용을 수정하는 UPDATE구문 만들기
			String sql = "UPDATE BOARD SET subject=?, content=? WHERE num=?";
			//3. PreparedStatement실행객체 얻기
			pstmt = con.prepareStatement(sql);
			//3.1  ?에 대응되는 값 설정
			pstmt.setString(1, boardBean.getSubject()); //글 제목
			pstmt.setString(2, boardBean.getContent()); //글 내용
			pstmt.setInt(3, boardBean.getNum()); //글 번호
			//4. UPDATE문 실행
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("BoardDAO내부의 updateBoard 메소드 내부에서 쿼리문 실행 오류: " + e);
		} finally {
			//자원해제
			freeResource();
		}
		
	}

	//deletePro.jsp페이지에서 호출하는 메소드
		//삭제할 글번호, 삭제를 위해 입력한 비밀번호, 글을 작성한 사람의 아이디를 매개변수로 전달받아
		//삭제를 위해 입력한 비밀번호가 DB에 저장된 글의 비밀번호가 일치하면 글을 작성한 사람의 id + 삭제할 글번호에 해당하는 글 정보 하나를 삭제하는 기능의 메소드
		@Override
		public void deleteBoard(int num, String passwd, String id) {
			
			String sql = "";
			
			try {
				//1. DB와의 연결(커넥션풀에서 커넥션객체 빌려오기)
				con = ds.getConnection();
				//2. 매개변수 int num으로 전달받은 삭제할 글번호에 해당하는 글의 비밀번호를 조회
				//   삭제를 위해 입력한 글의 비밀번호와 비교하기 위해 조회
				sql = "select passwd from board where num=?";
				//3. PreparedStatement 실행객체 얻기
				pstmt = con.prepareStatement(sql);
				//3.1  ?에 대응되는 값 매개변수로 받은 글번호로 설정
				pstmt.setInt(1, num);
				//4. select문 실행 후 삭제할 글번호에 해당되는 글의 비밀번호 조회 후 ResultSet에 담아 얻기
				rs = pstmt.executeQuery();
				//5. ResultSet에서 조회된 비밀번호가 있다면
				if(rs.next()) {
					//조회된 삭제할 비밀번호 문자열과 우리가 입력한 비밀번호와 비교해서 맞으면
					if( passwd.equals( rs.getString("passwd") ) ) {
						//매개변수로 전달 받는 삭제할 글 번호와 작성자 아이디에 해당하는 글 정보를 삭제
						sql = "delete from board where num=? and id=?";
						//PreparedStatement 실행객체 얻기
						pstmt = con.prepareStatement(sql);
						//?값 설정
						pstmt.setInt(1, num);
						pstmt.setString(2, id);
						//delete문 전체 DB에 전송해서 실행
						pstmt.executeUpdate();
					}
				}
				
			} catch (Exception e) {
				System.out.println("BoardDAO의 deleteBoard내부에서 쿼리문 실행 오류: " + e);
			} finally {
				//자원해제
				freeResource();
			}
			
		}

	@Override
	public void replyBoard(BoardBean boardBean) {
		// TODO Auto-generated method stub
		
	}
	
	public int getBoardCount() {
		int count = 0;
		
		try {
			//1. 커넥션 객체 얻기
			con = ds.getConnection();
			//2. sql 작성 후 PreparedStatement 실행객체 불러오기
			pstmt = con.prepareStatement("select * from board");
			//3. SQL문 실행하여 ResultSet객체에 저장
			rs = pstmt.executeQuery();
			//4. 데이터 처리
			while(rs.next()) {
				count = rs.getInt(1);
				System.out.println("게시판 글 갯수 확인: " + count);
			}
			
			
			
		} catch (Exception e) {
			System.out.println("BoardDAO의 getBoardCount에서 SQL문 실행 오류: " + e);
		} finally {
			//자원해제
			freeResource();
		}
		
		return count;
	}
	
	public ArrayList getBoardList() {
		
		//ArrayList 가변길이 배열 생성
		ArrayList boardList = new ArrayList();
		
		//SELECT문을 만들어 저장할 변수
		String sql = "";
		
		//BoardBean객체 생성할 변수
		BoardBean bean = null;
		
		try {
			//1. DataSource커넥션풀 메모리에서 DB와 미리 연결을 맺은 접속정보를 가지고 있는 Connection객체를 빌려오기
			//DB와의 접속
			con = ds.getConnection();
			//2. SQL문 작성
			sql = "select * from board order by num desc";
			
			//3. PreparedStatement 실행 객체 얻기
			//pstmt.setString(1, "%" + keyWord + "%"); → 위 ? 기호로 설정 시 이렇게 작성하기
			pstmt = con.prepareStatement(sql);
			
			//4. 조회된 결과데이터들을 ResultSet에 담아 반환
			rs = pstmt.executeQuery();
			
			//5. 조회된 결과데이터들은 ResultSet에 저장되어 있으므로 커서가 위치한 행(레코드)단위의 정보씩 꺼내와서
			//   BoardBean객체 생성 후  저장하며, BoardBean객체들을 차례로 Vector배열에 추가하여 저장
			while(rs.next()) {
				//BoardBean객체 생성
				bean = new BoardBean();
				//ResultSet객체의 커서가 위치한 조회한 행의 정보를 꺼내어 BoardBean객체의 인스턴스변수에 각각 저장
				bean.setNum( rs.getInt("num") );
				bean.setName( rs.getString("name") );
				bean.setPasswd( rs.getString("passwd") );
				bean.setSubject( rs.getString("subject") );
				bean.setContent( rs.getString("content") );
				bean.setPos( rs.getInt("pos") );
				bean.setDepth( rs.getInt("depth") );
				bean.setCount( rs.getInt(8) );
				bean.setIp( rs.getString("ip") );
				bean.setRegdate( rs.getTimestamp("regdate") );
				bean.setId( rs.getString(11) );
				
				//가변으로 늘어나는 배열에 추가
				boardList.add(bean);
			}
			
		} catch (Exception e) {
			System.out.println("BoardDAO의 getBoardList메소드 호출 시 쿼리문 실행 오류: " + e);
		} finally {
			//자원해제
			freeResource();
		}
		
		return boardList;
	}
	
	public ArrayList getBoardList(int startRow, int pageSize) {
		//가변길이 배열 생성
		ArrayList boardList = new ArrayList();
		
		String sql = "";
		BoardBean bean = null;
		try {
			//1. DataSource커넥션풀 메모리에서 DB와 미리 연결을 맺은 접속정보를 가지고 있는 Connection객체를 빌려오기
			//DB와의 접속
			con = ds.getConnection();
			//2. SQL문 작성
			sql = "select * from board order by num desc";
			
			//3. PreparedStatement 실행 객체 얻기
			//pstmt.setString(1, "%" + keyWord + "%"); → 위 ? 기호로 설정 시 이렇게 작성하기
			pstmt = con.prepareStatement(sql);
			
			//4. 조회된 결과데이터들을 ResultSet에 담아 반환
			rs = pstmt.executeQuery();
			
			//5. 조회된 결과데이터들은 ResultSet에 저장되어 있으므로 커서가 위치한 행(레코드)단위의 정보씩 꺼내와서
			//   BoardBean객체 생성 후  저장하며, BoardBean객체들을 차례로 Vector배열에 추가하여 저장
			while(rs.next()) {
				//BoardBean객체 생성
				bean = new BoardBean();
				//ResultSet객체의 커서가 위치한 조회한 행의 정보를 꺼내어 BoardBean객체의 인스턴스변수에 각각 저장
				bean.setNum( rs.getInt("num") );
				bean.setName( rs.getString("name") );
				bean.setPasswd( rs.getString("passwd") );
				bean.setSubject( rs.getString("subject") );
				bean.setContent( rs.getString("content") );
				bean.setPos( rs.getInt("pos") );
				bean.setDepth( rs.getInt("depth") );
				bean.setCount( rs.getInt(8) );
				bean.setIp( rs.getString("ip") );
				bean.setRegdate( rs.getTimestamp("regdate") );
				bean.setId( rs.getString(11) );
				
				//가변으로 늘어나는 배열에 추가
				boardList.add(bean);
			}
			
		} catch (Exception e) {
			System.out.println("BoardDAO의 getBoardList메소드 호출 시 쿼리문 실행 오류: " + e);
		} finally {
			//자원해제
			freeResource();
		}
		
		return boardList;
	}
}
