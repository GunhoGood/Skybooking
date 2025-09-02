package dto;

import java.util.Date;

public class Users {
	private String id;
	private String pwd;
	private String email;
	private String name;
	private String phone;
	private String addrNum;
	private String address;
	private java.sql.Date birth;
	private String gender;
	private Date createDate;
	private int admin;
	
	public Users(String email, String name, String phone, String address, java.sql.Date birth, String gender) {
		super();
		this.email = email;
		this.name = name;
		this.phone = phone;
		this.address = address;
		this.birth = birth;
		this.gender = gender;
	}

	public Users(String id, String pwd, String email, String name, String phone, String addrNum, String address,
			java.sql.Date birth, String gender) {
		super();
		this.id = id;
		this.pwd = pwd;
		this.email = email;
		this.name = name;
		this.phone = phone;
		this.addrNum = addrNum;
		this.address = address;
		this.birth = birth;
		this.gender = gender;
	}
	
	public Users(String id, String pwd, String email, String name, String phone, String addrNum, String address,
			java.sql.Date birth, String gender, int admin) {
		super();
		this.id = id;
		this.pwd = pwd;
		this.email = email;
		this.name = name;
		this.phone = phone;
		this.addrNum = addrNum;
		this.address = address;
		this.birth = birth;
		this.gender = gender;
		this.admin = admin;
	}
	public Users() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public int getAdmin() {
		return admin;
	}
	public void setAdmin(int admin) {
		this.admin = admin;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getAddrNum() {
		return addrNum;
	}
	public void setAddrNum(String addrNum) {
		this.addrNum = addrNum;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public java.sql.Date getBirth() {
		return birth;
	}
	public void setBirth(java.sql.Date birth) {
		this.birth = birth;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	@Override
	public String toString() {
		return "Users [id=" + id + ", pwd=" + pwd + ", email=" + email + ", name=" + name + ", phone=" + phone
				+ ", addrNum=" + addrNum + ", address=" + address + ", birth=" + birth + ", gender=" + gender
				+ ", createDate=" + createDate + ", admin=" + admin + "]";
	}
	
}
