package dao;

import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletContext;
import dto.FlightDTO;
import util.JDBConnect;

public class FlightDAO extends JDBConnect {
    
    public FlightDAO(ServletContext application) {
        super(application);
    }
    
    /**
     * 항공편 검색 (메인 검색 기능)
     */
    public ArrayList<FlightDTO> searchFlights(String departureCity, String arrivalCity, String flightDate) {
        ArrayList<FlightDTO> flights = new ArrayList<FlightDTO>();
        try {
            System.out.println("=== DAO 검색 시작 ===");
            System.out.println("검색 조건: " + departureCity + ", " + arrivalCity + ", " + flightDate);
            
            String sql = "SELECT flight_id, airline, departure_city, arrival_city, " +
                        "departure_time, arrival_time, flight_date, available_seats " +
                        "FROM flights WHERE departure_city = ? AND arrival_city = ? " +
                        "AND flight_date = ? AND available_seats > 0 " +
                        "ORDER BY departure_time ASC";
            
            psmt = con.prepareStatement(sql);
            psmt.setString(1, departureCity);
            psmt.setString(2, arrivalCity);
            psmt.setString(3, flightDate);
            
            System.out.println("SQL 실행: " + sql);
            rs = psmt.executeQuery();
            
            int count = 0;
            while (rs.next()) {
                count++;
                FlightDTO flight = new FlightDTO();
                flight.setFlightId(rs.getString("flight_id"));
                flight.setAirline(rs.getString("airline"));
                flight.setDepartureCity(rs.getString("departure_city"));
                flight.setArrivalCity(rs.getString("arrival_city"));
                flight.setDepartureTime(rs.getString("departure_time"));
                flight.setArrivalTime(rs.getString("arrival_time"));
                flight.setFlightDate(rs.getString("flight_date"));
                flight.setAvailableSeats(rs.getInt("available_seats"));
                flights.add(flight);
                
                System.out.println("찾은 항공편 " + count + ": " + flight.getFlightId());
            }
            System.out.println("총 " + count + "개 항공편 발견");
            
        } catch (SQLException e) {
            System.out.println("SQL 오류: " + e.getMessage());
            e.printStackTrace();
        }
        return flights;
    }
    
    /**
     * 특정 항공편 정보 조회
     */
    public FlightDTO getFlightById(String flightId) {
        FlightDTO flight = null;
        try {
            String sql = "SELECT flight_id, airline, departure_city, arrival_city, " +
                        "departure_time, arrival_time, flight_date, available_seats " +
                        "FROM flights WHERE flight_id = ?";
            
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flightId);
            rs = psmt.executeQuery();
            
            if (rs.next()) {
                flight = new FlightDTO();
                flight.setFlightId(rs.getString("flight_id"));
                flight.setAirline(rs.getString("airline"));
                flight.setDepartureCity(rs.getString("departure_city"));
                flight.setArrivalCity(rs.getString("arrival_city"));
                flight.setDepartureTime(rs.getString("departure_time"));
                flight.setArrivalTime(rs.getString("arrival_time"));
                flight.setFlightDate(rs.getString("flight_date"));
                flight.setAvailableSeats(rs.getInt("available_seats"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flight;
    }
    
    /**
     * 모든 항공편 조회 (관리용)
     */
    public ArrayList<FlightDTO> getAllFlights() {
        ArrayList<FlightDTO> flights = new ArrayList<FlightDTO>();
        try {
            String sql = "SELECT flight_id, airline, departure_city, arrival_city, " +
                        "departure_time, arrival_time, flight_date, available_seats " +
                        "FROM flights ORDER BY flight_date ASC, departure_time ASC";
            
            psmt = con.prepareStatement(sql);
            rs = psmt.executeQuery();
            
            while (rs.next()) {
                FlightDTO flight = new FlightDTO();
                flight.setFlightId(rs.getString("flight_id"));
                flight.setAirline(rs.getString("airline"));
                flight.setDepartureCity(rs.getString("departure_city"));
                flight.setArrivalCity(rs.getString("arrival_city"));
                flight.setDepartureTime(rs.getString("departure_time"));
                flight.setArrivalTime(rs.getString("arrival_time"));
                flight.setFlightDate(rs.getString("flight_date"));
                flight.setAvailableSeats(rs.getInt("available_seats"));
                flights.add(flight);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flights;
    }
    
    /**
     * 특정 날짜의 항공편 조회
     */
    public ArrayList<FlightDTO> getFlightsByDate(String flightDate) {
        ArrayList<FlightDTO> flights = new ArrayList<FlightDTO>();
        try {
            String sql = "SELECT flight_id, airline, departure_city, arrival_city, " +
                        "departure_time, arrival_time, flight_date, available_seats " +
                        "FROM flights WHERE flight_date = ? " +
                        "ORDER BY departure_time ASC";
            
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flightDate);
            rs = psmt.executeQuery();
            
            while (rs.next()) {
                FlightDTO flight = new FlightDTO();
                flight.setFlightId(rs.getString("flight_id"));
                flight.setAirline(rs.getString("airline"));
                flight.setDepartureCity(rs.getString("departure_city"));
                flight.setArrivalCity(rs.getString("arrival_city"));
                flight.setDepartureTime(rs.getString("departure_time"));
                flight.setArrivalTime(rs.getString("arrival_time"));
                flight.setFlightDate(rs.getString("flight_date"));
                flight.setAvailableSeats(rs.getInt("available_seats"));
                flights.add(flight);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flights;
    }
    
    /**
     * 항공편 남은 좌석 수 업데이트
     */
    public int updateAvailableSeats(String flightId, int seatChange) {
        int res = 0;
        try {
            String sql = "UPDATE flights SET available_seats = available_seats + ? WHERE flight_id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, seatChange);
            psmt.setString(2, flightId);
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }
    
    /**
     * 새 항공편 추가
     */
    public int insertFlight(FlightDTO flight) {
        int res = 0;
        try {
            String sql = "INSERT INTO flights (flight_id, airline, departure_city, arrival_city, " +
                        "departure_time, arrival_time, flight_date, available_seats) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flight.getFlightId());
            psmt.setString(2, flight.getAirline());
            psmt.setString(3, flight.getDepartureCity());
            psmt.setString(4, flight.getArrivalCity());
            psmt.setString(5, flight.getDepartureTime());
            psmt.setString(6, flight.getArrivalTime());
            psmt.setString(7, flight.getFlightDate());
            psmt.setInt(8, flight.getAvailableSeats());
            
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("항공편 추가 실패: " + e.getMessage());
            e.printStackTrace();
        }
        return res;
    }
    
    /**
     * 항공편 정보 수정 (available_seats 제외)
     */
    public int updateFlight(FlightDTO flight) {
        int res = 0;
        try {
            // available_seats는 수정하지 않고 기본 정보만 수정
            String sql = "UPDATE flights SET airline = ?, departure_city = ?, arrival_city = ?, " +
                        "departure_time = ?, arrival_time = ?, flight_date = ? " +
                        "WHERE flight_id = ?";
            
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flight.getAirline());
            psmt.setString(2, flight.getDepartureCity());
            psmt.setString(3, flight.getArrivalCity());
            psmt.setString(4, flight.getDepartureTime());
            psmt.setString(5, flight.getArrivalTime());
            psmt.setString(6, flight.getFlightDate());
            psmt.setString(7, flight.getFlightId());
            
            System.out.println("항공편 수정 SQL 실행: " + sql);
            System.out.println("수정할 항공편 ID: " + flight.getFlightId());
            
            res = psmt.executeUpdate();
            System.out.println("수정 결과: " + res + "개 행이 영향받음");
            
        } catch (SQLException e) {
            System.out.println("항공편 수정 실패: " + e.getMessage());
            e.printStackTrace();
        }
        return res;
    }
    
    /**
     * 항공편 정보 수정 (available_seats 포함)
     */
    public int updateFlightWithSeats(FlightDTO flight) {
        int res = 0;
        try {
            String sql = "UPDATE flights SET airline = ?, departure_city = ?, arrival_city = ?, " +
                        "departure_time = ?, arrival_time = ?, flight_date = ?, available_seats = ? " +
                        "WHERE flight_id = ?";
            
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flight.getAirline());
            psmt.setString(2, flight.getDepartureCity());
            psmt.setString(3, flight.getArrivalCity());
            psmt.setString(4, flight.getDepartureTime());
            psmt.setString(5, flight.getArrivalTime());
            psmt.setString(6, flight.getFlightDate());
            psmt.setInt(7, flight.getAvailableSeats());
            psmt.setString(8, flight.getFlightId());
            
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("항공편 수정 실패: " + e.getMessage());
            e.printStackTrace();
        }
        return res;
    }
    
    /**
     * 항공편 삭제
     */
    public int deleteFlight(String flightId) {
        int res = 0;
        try {
            String sql = "DELETE FROM flights WHERE flight_id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flightId);
            res = psmt.executeUpdate();
            
            System.out.println("항공편 삭제 결과: " + res + "개 행이 삭제됨");
            
        } catch (SQLException e) {
            System.out.println("항공편 삭제 실패: " + e.getMessage());
            e.printStackTrace();
        }
        return res;
    }
    
    /**
     * 특정 출발지에서 출발하는 모든 항공편
     */
    public ArrayList<FlightDTO> getFlightsByDepartureCity(String departureCity) {
        ArrayList<FlightDTO> flights = new ArrayList<FlightDTO>();
        try {
            String sql = "SELECT flight_id, airline, departure_city, arrival_city, " +
                        "departure_time, arrival_time, flight_date, available_seats " +
                        "FROM flights WHERE departure_city = ? " +
                        "ORDER BY flight_date ASC, departure_time ASC";
            
            psmt = con.prepareStatement(sql);
            psmt.setString(1, departureCity);
            rs = psmt.executeQuery();
            
            while (rs.next()) {
                FlightDTO flight = new FlightDTO();
                flight.setFlightId(rs.getString("flight_id"));
                flight.setAirline(rs.getString("airline"));
                flight.setDepartureCity(rs.getString("departure_city"));
                flight.setArrivalCity(rs.getString("arrival_city"));
                flight.setDepartureTime(rs.getString("departure_time"));
                flight.setArrivalTime(rs.getString("arrival_time"));
                flight.setFlightDate(rs.getString("flight_date"));
                flight.setAvailableSeats(rs.getInt("available_seats"));
                flights.add(flight);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flights;
    }
    
    /**
     * 항공편 ID 중복 확인
     */
    public boolean isFlightIdExists(String flightId) {
        boolean exists = false;
        try {
            String sql = "SELECT COUNT(*) as count FROM flights WHERE flight_id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flightId);
            rs = psmt.executeQuery();
            
            if (rs.next()) {
                exists = rs.getInt("count") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exists;
    }
    
    /**
     * 예약 성공 시 잔여석을 1 감소시키는 메서드
     */
    public int decreaseAvailableSeats(String flightId) {
        int result = 0;
        try {
            String sql = "UPDATE flights SET available_seats = available_seats - 1 WHERE flight_id = ? AND available_seats > 0";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flightId);
            result = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    /**
     * 예약 취소 시 잔여석을 1 증가시키는 메서드
     */
    public int increaseAvailableSeats(String flightId) {
        int result = 0;
        try {
            String sql = "UPDATE flights SET available_seats = available_seats + 1 WHERE flight_id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, flightId);
            result = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public void close() {
        try {
            if (rs != null) rs.close();
            if (psmt != null) psmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}