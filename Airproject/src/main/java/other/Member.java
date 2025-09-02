package other;

public class Member {
	private String id;
	private String pwd;
	private String name;
	private int mileage;
	
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getMileage() {
		return mileage;
	}
	public void setMileage(int mileage) {
		this.mileage = mileage;
	}
	
	
	@Override
	public String toString() {
		return "Member [id=" + id + ", pwd=" + pwd + ", name=" + name + "]";
	}
	public Member() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Member(String id, String pwd, String name) {
		super();
		this.id = id;
		this.pwd = pwd;
		this.name = name;
	}
	public Member(String id, String pwd, String name, int mileage) {
		super();
		this.id = id;
		this.pwd = pwd;
		this.name = name;
		this.mileage = mileage;
	}
}
