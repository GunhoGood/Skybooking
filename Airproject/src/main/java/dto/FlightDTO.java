package dto;

import java.time.Duration;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

public class FlightDTO {
    private String flightId;        // 항공편 ID (예: KE001)
    private String airline;         // 항공사명 (예: 대한항공)
    private String departureCity;   // 출발 도시 코드 (예: ICN)
    private String arrivalCity;     // 도착 도시 코드 (예: NRT)
    private String departureTime;   // 출발 시간 (예: 09:00:00)
    private String arrivalTime;     // 도착 시간 (예: 11:30:00)
    private String flightDate;      // 운항 날짜 (예: 2025-07-10)
    private int availableSeats;     // 남은 좌석 수
    
    public String getFlightDuration() {
        if (departureTime == null || arrivalTime == null) {
            return "시간 정보 없음";
        }

        try {
            LocalTime dep = LocalTime.parse(departureTime);
            LocalTime arr = LocalTime.parse(arrivalTime);

            Duration duration = Duration.between(dep, arr);

            // 도착 시간이 출발 시간보다 빠를 경우 (자정 넘김), 다음 날로 간주하여 24시간 추가
            if (duration.isNegative()) {
                duration = duration.plusDays(1);
            }

            long hours = duration.toHours();
            long minutes = duration.toMinutes() % 60;

            StringBuilder sb = new StringBuilder("약 ");
            if (hours > 0) {
                sb.append(hours).append("시간 ");
            }
            if (minutes > 0) {
                sb.append(minutes).append("분");
            }
            if (hours == 0 && minutes == 0) {
                sb.append("0분");
            }
            return sb.toString().trim(); // 앞뒤 공백 제거
        } catch (DateTimeParseException e) {
            System.err.println("시간 파싱 오류: " + e.getMessage());
            return "시간 계산 오류";
        }
    }
    
    // 기본 생성자
    public FlightDTO() {
    }
    
    // 전체 매개변수 생성자
    public FlightDTO(String flightId, String airline, String departureCity, 
                    String arrivalCity, String departureTime, String arrivalTime, 
                    String flightDate, int availableSeats) {
        this.flightId = flightId;
        this.airline = airline;
        this.departureCity = departureCity;
        this.arrivalCity = arrivalCity;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.flightDate = flightDate;
        this.availableSeats = availableSeats;
    }
    
    // Getter 메서드들
    public String getFlightId() {
        return flightId;
    }
    
    public String getAirline() {
        return airline;
    }
    
    public String getDepartureCity() {
        return departureCity;
    }
    
    public String getArrivalCity() {
        return arrivalCity;
    }
    
    public String getDepartureTime() {
        return departureTime;
    }
    
    public String getArrivalTime() {
        return arrivalTime;
    }
    
    public String getFlightDate() {
        return flightDate;
    }
    
    public int getAvailableSeats() {
        return availableSeats;
    }
    
    // Setter 메서드들
    public void setFlightId(String flightId) {
        this.flightId = flightId;
    }
    
    public void setAirline(String airline) {
        this.airline = airline;
    }
    
    public void setDepartureCity(String departureCity) {
        this.departureCity = departureCity;
    }
    
    public void setArrivalCity(String arrivalCity) {
        this.arrivalCity = arrivalCity;
    }
    
    public void setDepartureTime(String departureTime) {
        this.departureTime = departureTime;
    }
    
    public void setArrivalTime(String arrivalTime) {
        this.arrivalTime = arrivalTime;
    }
    
    public void setFlightDate(String flightDate) {
        this.flightDate = flightDate;
    }
    
    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }
    
    // toString 메서드 (디버깅용)
    @Override
    public String toString() {
        return "FlightDTO{" +
                "flightId='" + flightId + '\'' +
                ", airline='" + airline + '\'' +
                ", departureCity='" + departureCity + '\'' +
                ", arrivalCity='" + arrivalCity + '\'' +
                ", departureTime='" + departureTime + '\'' +
                ", arrivalTime='" + arrivalTime + '\'' +
                ", flightDate='" + flightDate + '\'' +
                ", availableSeats=" + availableSeats +
                '}';
    }
}