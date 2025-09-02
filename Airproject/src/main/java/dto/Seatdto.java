package dto;

public class Seatdto {
    
    private int id;
    private String seatNumber;
    private String seatClass;
    private boolean isReserved;
    private String flightId;        // 항공편 ID (기본값: null)
    private double price;           // 좌석 가격 (기본값: 0.0)
    public Seatdto() {
        this.flightId = null;
        this.price = 0.0;
    }
    
    // ========== 새로운 생성자 (항공편 연동용) ==========
    public Seatdto(int id, String seatNumber, String seatClass, boolean isReserved, 
                   String flightId, double price) {
        this.id = id;
        this.seatNumber = seatNumber;
        this.seatClass = seatClass;
        this.isReserved = isReserved;
        this.flightId = flightId;
        this.price = price;
    }
    
    // ========== 기존 Getter 메서드들 (그대로 유지) ==========
    public int getId() {
        return id;
    }
    
    public String getSeatNumber() {
        return seatNumber;
    }
    
    public String getSeatClass() {
        return seatClass;
    }
    
    public boolean isReserved() {
        return isReserved;
    }
    
    // ========== 기존 Setter 메서드들 (그대로 유지) ==========
    public void setId(int id) {
        this.id = id;
    }
    
    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }
    
    public void setSeatClass(String seatClass) {
        this.seatClass = seatClass;
    }
    
    public void setReserved(boolean isReserved) {
        this.isReserved = isReserved;
    }
    
    // ========== 새로 추가하는 Getter 메서드들 ==========
    public String getFlightId() {
        return flightId;
    }
    
    public double getPrice() {
        return price;
    }
    
    // ========== 새로 추가하는 Setter 메서드들 ==========
    public void setFlightId(String flightId) {
        this.flightId = flightId;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    // ========== 편의 메서드들 ==========
    
    /**
     * 특정 항공편의 좌석인지 확인
     */
    public boolean belongsToFlight(String flightId) {
        return this.flightId != null && this.flightId.equals(flightId);
    }
    
    /**
     * 항공편이 연결된 좌석인지 확인
     */
    public boolean hasFlightAssigned() {
        return this.flightId != null && !this.flightId.trim().isEmpty();
    }
    
    /**
     * 가격이 설정된 좌석인지 확인
     */
    public boolean hasPriceSet() {
        return this.price > 0;
    }
    
    /**
     * 좌석 등급에 따른 기본 가격 설정 (편의 메서드)
     */
    public void setDefaultPriceByClass() {
        String lowerClass = this.seatClass != null ? this.seatClass.toLowerCase() : "";
        
        if (lowerClass.contains("first")) {
            this.price = 300000.0;
        } else if (lowerClass.contains("business")) {
            this.price = 200000.0;
        } else if (lowerClass.contains("economy")) {
            this.price = 100000.0;
        } else {
            this.price = 100000.0; // 기본값
        }
    }
    
    // ========== toString 메서드 (확장) ==========
    @Override
    public String toString() {
        return "Seatdto{" +
                "id=" + id +
                ", seatNumber='" + seatNumber + '\'' +
                ", seatClass='" + seatClass + '\'' +
                ", isReserved=" + isReserved +
                ", flightId='" + flightId + '\'' +
                ", price=" + price +
                '}';
    }
}
