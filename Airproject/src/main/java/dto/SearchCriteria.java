package dto;

// 검색 조건을 담는 DTO 클래스
public class SearchCriteria {
    private String departureCity;
    private String arrivalCity;
    private String departureDate;
    private String returnDate;
    private String seatClass;
    private int totalPassengers;
    private int adults;
    private int children;
    private int infants;
    
    // 기본 생성자
    public SearchCriteria() {}
    
    // Getter 메서드들
    public String getDepartureCity() { return departureCity; }
    public String getArrivalCity() { return arrivalCity; }
    public String getDepartureDate() { return departureDate; }
    public String getReturnDate() { return returnDate; }
    public String getSeatClass() { return seatClass; }
    public int getTotalPassengers() { return totalPassengers; }
    public int getAdults() { return adults; }
    public int getChildren() { return children; }
    public int getInfants() { return infants; }
    
    // Setter 메서드들
    public void setDepartureCity(String departureCity) { this.departureCity = departureCity; }
    public void setArrivalCity(String arrivalCity) { this.arrivalCity = arrivalCity; }
    public void setDepartureDate(String departureDate) { this.departureDate = departureDate; }
    public void setReturnDate(String returnDate) { this.returnDate = returnDate; }
    public void setSeatClass(String seatClass) { this.seatClass = seatClass; }
    public void setTotalPassengers(int totalPassengers) { this.totalPassengers = totalPassengers; }
    public void setAdults(int adults) { this.adults = adults; }
    public void setChildren(int children) { this.children = children; }
    public void setInfants(int infants) { this.infants = infants; }
    
    // 도시 코드를 한글 이름으로 변환하는 메서드
    public String getCityName(String cityCode) {
        switch (cityCode) {
            case "ICN": return "서울/인천";
            case "GMP": return "서울/김포";
            case "PUS": return "부산";
            case "CJU": return "제주";
            case "TAE": return "대구";
            case "KWJ": return "광주";
            case "NRT": return "도쿄/나리타";
            case "KIX": return "오사카";
            case "PVG": return "상하이";
            case "PEK": return "베이징";
            case "HKG": return "홍콩";
            case "SIN": return "싱가포르";
            case "BKK": return "방콕";
            case "LAX": return "로스앤젤레스";
            case "JFK": return "뉴욕";
            case "LHR": return "런던";
            case "CDG": return "파리";
            default: return cityCode;
        }
    }
    
    // 좌석 등급을 한글로 변환하는 메서드
    public String getSeatClassName() {
        switch (seatClass) {
            case "first": return "퍼스트";
            case "business": return "비즈니스";
            case "premium": return "프리미엄 이코노미";
            case "economy": return "이코노미";
            default: return seatClass;
        }
    }
}