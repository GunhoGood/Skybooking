package other;

public class Sb_air {
	private String air_num;
	private String air_name;
	private String depart;
	private String arrive;
	private String date;
	private int price;
	private int seatCnt;
	
	public String getAir_num() {
		return air_num;
	}
	public void setAir_num(String air_num) {
		this.air_num = air_num;
	}
	public String getAir_name() {
		return air_name;
	}
	public void setAir_name(String air_name) {
		this.air_name = air_name;
	}
	public String getDepart() {
		return depart;
	}
	public void setDepart(String depart) {
		this.depart = depart;
	}
	public String getArrive() {
		return arrive;
	}
	public void setArrive(String arrive) {
		this.arrive = arrive;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getSeatCnt() {
		return seatCnt;
	}
	public void setSeatCnt(int seatCnt) {
		this.seatCnt = seatCnt;
	}
	
	@Override
	public String toString() {
		return "Sb_air [air_num=" + air_num + ", air_name=" + air_name + ", depart=" + depart + ", arrive=" + arrive
				+ ", date=" + date + ", price=" + price + ", seatCnt=" + seatCnt + "]";
	}
	
	public Sb_air() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public Sb_air(String depart, String arrive, String date, int price, int seatCnt) {
		super();
		this.depart = depart;
		this.arrive = arrive;
		this.date = date;
		this.price = price;
		this.seatCnt = seatCnt;
	}
}
