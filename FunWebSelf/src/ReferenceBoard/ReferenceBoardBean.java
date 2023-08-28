package ReferenceBoard;

import java.sql.Timestamp;

//VO
public class ReferenceBoardBean {
	
	private int num;				//글번호
	private String name;			//글쓴이
	private String passwd;			//글의 비밀번호
	private String subject;			//글제목
	private String content;			//글내용
	private String filename;		//업로드한 원본 파일명
	private String fileRealName; 	//실제 업로드된 파일명
	private int re_ref;				//부모글과 답변글의 그룹값
	private int re_lev;				//같은 그룹내에서 글의 들여쓰기 정도값
	private int re_seq; 			//같은 그룹내에서 보여줄 글들의 순서값
	private int readcount;			//글 조회수
	private Timestamp date;			//글 작성일
	private String ip; 				//글쓴이의 ip주소
	private String id;				//글쓴이의 아이디
	
	public ReferenceBoardBean() {}
	
	//날짜를 제외한 모든 인스턴스 변수를 초기화 할 생성자
	public ReferenceBoardBean(int num, String name, String passwd, String subject, String content, String filename,
			String fileRealName, int re_ref, int re_lev, int re_seq, int readcount, String ip, String id) {
		super();
		this.num = num;
		this.name = name;
		this.passwd = passwd;
		this.subject = subject;
		this.content = content;
		this.filename = filename;
		this.fileRealName = fileRealName;
		this.re_ref = re_ref;
		this.re_lev = re_lev;
		this.re_seq = re_seq;
		this.readcount = readcount;
		this.ip = ip;
		this.id = id;
	}

	//객체 생성 시 모든 인스턴스 변수의 값 초기화 하는 생성자
	public ReferenceBoardBean(int num, String name, String passwd, String subject, String content, String filename,
			String fileRealName, int re_ref, int re_lev, int re_seq, int readcount, Timestamp date, String ip, String id) {
		super();
		this.num = num;
		this.name = name;
		this.passwd = passwd;
		this.subject = subject;
		this.content = content;
		this.filename = filename;
		this.fileRealName = fileRealName;
		this.re_ref = re_ref;
		this.re_lev = re_lev;
		this.re_seq = re_seq;
		this.readcount = readcount;
		this.date = date;
		this.ip = ip;
		this.id = id;
	}
	
	
	//getter, setter 메소드
	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getFilename() {
		return filename;
	}

	public void setFilename(String filename) {
		this.filename = filename;
	}

	public String getFileRealName() {
		return fileRealName;
	}

	public void setFileRealName(String fileRealName) {
		this.fileRealName = fileRealName;
	}

	public int getRe_ref() {
		return re_ref;
	}

	public void setRe_ref(int re_ref) {
		this.re_ref = re_ref;
	}

	public int getRe_lev() {
		return re_lev;
	}

	public void setRe_lev(int re_lev) {
		this.re_lev = re_lev;
	}

	public int getRe_seq() {
		return re_seq;
	}

	public void setRe_seq(int re_seq) {
		this.re_seq = re_seq;
	}

	public int getReadcount() {
		return readcount;
	}

	public void setReadcount(int readcount) {
		this.readcount = readcount;
	}

	public Timestamp getDate() {
		return date;
	}

	public void setDate(Timestamp date) {
		this.date = date;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	
	
}
