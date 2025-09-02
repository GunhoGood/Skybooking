package other;

public class Reserve_info {
	private String r_num;
	private String id;
	private String air_num;
	private int payment;
	private int use_point;
	
	public String getR_num() {
		return r_num;
	}
	public void setR_num(String r_num) {
		this.r_num = r_num;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getAir_num() {
		return air_num;
	}
	public void setAir_num(String air_num) {
		this.air_num = air_num;
	}
	public int getPayment() {
		return payment;
	}
	public void setPayment(int payment) {
		this.payment = payment;
	}
	public int getUse_point() {
		return use_point;
	}
	public void setUse_point(int use_point) {
		this.use_point = use_point;
	}
	
	public Reserve_info() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public String toString() {
		return "Reserve_info [r_num=" + r_num + ", id=" + id + ", air_num=" + air_num + ", payment=" + payment
				+ ", use_point=" + use_point + "]";
	}
	
	
	public Reserve_info(String id, int payment, int use_point) {
		super();
		this.id = id;
		this.payment = payment;
		this.use_point = use_point;
	}
}
