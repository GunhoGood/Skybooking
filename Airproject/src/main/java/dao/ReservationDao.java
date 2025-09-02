package dao;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import dto.ReservationDto;
import util.JDBConnect;

public class ReservationDao extends JDBConnect {

    public ReservationDao(ServletContext application) {
        super(application);
    }

    public List<ReservationDto> getReservationsByUser(String userId) {
        List<ReservationDto> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations WHERE user_id = ? ORDER BY reservation_date DESC";

        try {
            psmt = con.prepareStatement(sql);
            psmt.setString(1, userId);
            rs = psmt.executeQuery();

            while (rs.next()) {
            	ReservationDto dto = new ReservationDto();
                dto.setReservationId(rs.getString("reservation_id"));
                dto.setUserId(rs.getString("user_id"));
                dto.setFlightId(rs.getString("flight_id"));
                dto.setSeatNumber(rs.getString("seat_number"));
                dto.setTotalPrice(rs.getInt("total_price"));
                dto.setStatus(rs.getString("status"));
                dto.setReservationDate(rs.getTimestamp("reservation_date").toLocalDateTime());
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public int saveReservation(ReservationDto dto) {
        int result = 0;
        String sql = "INSERT INTO reservations (reservation_id, user_id, flight_id, seat_number, total_price, status, reservation_date) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            psmt = con.prepareStatement(sql);
            psmt.setString(1, dto.getReservationId());
            psmt.setString(2, dto.getUserId());
            psmt.setString(3, dto.getFlightId());
            psmt.setString(4, dto.getSeatNumber());
            psmt.setInt(5, dto.getTotalPrice());
            psmt.setString(6, dto.getStatus());
            psmt.setTimestamp(7, java.sql.Timestamp.valueOf(dto.getReservationDate()));
            result = psmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
    
    // 예약 개수 조회
    public int getReservationCountByUser(String userId) {
        int count = 0;
        try {
            String sql = "SELECT COUNT(*) FROM reservations WHERE user_id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, userId);
            rs = psmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    // 페이지별 예약 목록 조회
    public List<ReservationDto> getReservationsByUserPaging(String userId, int offset, int limit) {
        List<ReservationDto> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM reservations WHERE user_id = ? ORDER BY reservation_date DESC LIMIT ?, ?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, userId);
            psmt.setInt(2, offset);
            psmt.setInt(3, limit);
            rs = psmt.executeQuery();
            while (rs.next()) {
            	ReservationDto r = new ReservationDto();
                r.setReservationId(rs.getString("reservation_id"));
                r.setUserId(rs.getString("user_id"));
                r.setFlightId(rs.getString("flight_id"));
                r.setSeatNumber(rs.getString("seat_number"));
                r.setTotalPrice(rs.getInt("total_price"));
                r.setStatus(rs.getString("status"));
                Timestamp ts = rs.getTimestamp("reservation_date");
                if (ts != null) {
                    r.setReservationDate(ts.toLocalDateTime());
                }
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}