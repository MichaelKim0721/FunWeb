package member;

import java.sql.Timestamp;

//VO역할을 하는 자바빈 클래스
//가입하는 한 사람의 회원정보를 임시로 변수에 저장시킬수도 있고
//DB의 member테이블에 저장된 한 사람의 정보를 조회 후 저장할 변수를 가지고 있는 클래스
public class MemberBean {
	//멤버변수(인스턴스변수)
	//private으로 은닉보호되게 생성
	private String id, passwd, name, gender, email, address, tel, mtel;
	private int age;
	private Timestamp reg_date;
	
	//생성자
	public MemberBean() {}

	//필수항목 변수들만 초기화 할 생성자
	public MemberBean(String id, String passwd, String name, String gender, String email, int age, Timestamp reg_date) {
		super();
		this.id = id;
		this.passwd = passwd;
		this.name = name;
		this.gender = gender;
		this.email = email;
		this.age = age;
		this.reg_date = reg_date;
	}
	
	//각 옵션 항목에 대한 변수 초기화 생성자들
	public MemberBean(String address, String tel, String mtel) {
		super();
		this.address = address;
		this.tel = tel;
		this.mtel = mtel;
	}
	
	//전체 변수들을 초기화할 생성자
	public MemberBean(String id, String passwd, String name, String gender, String email, String address, String tel,
			String mtel, int age, Timestamp reg_date) {
		super();
		this.id = id;
		this.passwd = passwd;
		this.name = name;
		this.gender = gender;
		this.email = email;
		this.address = address;
		this.tel = tel;
		this.mtel = mtel;
		this.age = age;
		this.reg_date = reg_date;
	}
	

	//getter, setter 메소드
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getMtel() {
		return mtel;
	}
	public void setMtel(String mtel) {
		this.mtel = mtel;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public Timestamp getReg_date() {
		return reg_date;
	}
	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}
	
	
	
}
