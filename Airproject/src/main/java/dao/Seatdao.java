package dao;

import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.ServletContext;
import dto.Seatdto;
import util.JDBConnect;

public class Seatdao extends JDBConnect {

	public Seatdao(ServletContext application) {
		super(application);
	}

	// ========== 기존 메서드들 (그대로 유지) ==========

	public ArrayList<Seatdto> selectAll() {
		ArrayList<Seatdto> dtos = new ArrayList<Seatdto>();
		try {
			String sql = "SELECT id, seat_number, seat_class, is_reserved, flight_id, price FROM seats ORDER BY seat_number ASC";
			psmt = con.prepareStatement(sql);
			rs = psmt.executeQuery();
			while (rs.next()) {
				Seatdto dto = new Seatdto();
				dto.setId(rs.getInt("id"));
				dto.setSeatNumber(rs.getString("seat_number"));
				dto.setSeatClass(rs.getString("seat_class"));
				dto.setReserved(rs.getBoolean("is_reserved"));
				// 새 필드들 (null일 수 있음)
				dto.setFlightId(rs.getString("flight_id"));
				dto.setPrice(rs.getDouble("price"));
				dtos.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dtos;
	}

	public Seatdto select(String seatNumber) {
		Seatdto dto = null;
		try {
			String sql = "SELECT id, seat_number, seat_class, is_reserved, flight_id, price FROM seats WHERE seat_number = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, seatNumber);
			rs = psmt.executeQuery();
			if (rs.next()) {
				dto = new Seatdto();
				dto.setId(rs.getInt("id"));
				dto.setSeatNumber(rs.getString("seat_number"));
				dto.setSeatClass(rs.getString("seat_class"));
				dto.setReserved(rs.getBoolean("is_reserved"));
				dto.setFlightId(rs.getString("flight_id"));
				dto.setPrice(rs.getDouble("price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dto;
	}

	public int reserve(String seatNumber) {
		int res = 0;
		try {
			String sql = "UPDATE seats SET is_reserved = TRUE WHERE seat_number = ? AND is_reserved = FALSE";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, seatNumber);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return res;
	}

	public int cancelReservation(String seatNumber) {
		int res = 0;
		try {
			String sql = "UPDATE seats SET is_reserved = FALSE WHERE seat_number = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, seatNumber);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return res;
	}

	public Seatdto selectBySeatNumberAndFlight(String flightId, String seatNumber) {
		Seatdto dto = null;
		try {
			String sql = "SELECT id, seat_number, seat_class, is_reserved, flight_id, price FROM seats WHERE flight_id = ? AND seat_number = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			psmt.setString(2, seatNumber);
			rs = psmt.executeQuery();
			if (rs.next()) {
				dto = new Seatdto();
				dto.setId(rs.getInt("id"));
				dto.setSeatNumber(rs.getString("seat_number"));
				dto.setSeatClass(rs.getString("seat_class"));
				dto.setReserved(rs.getBoolean("is_reserved"));
				dto.setFlightId(rs.getString("flight_id"));
				dto.setPrice(rs.getDouble("price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dto;
	}

	/**
	 * 특정 항공편의 좌석 목록 조회
	 */
	public ArrayList<Seatdto> selectByFlight(String flightId) {
		ArrayList<Seatdto> dtos = new ArrayList<Seatdto>();
		try {
			String sql = "SELECT id, seat_number, seat_class, is_reserved, flight_id, price "
					+ "FROM seats WHERE flight_id = ? ORDER BY seat_number ASC";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			rs = psmt.executeQuery();
			while (rs.next()) {
				Seatdto dto = new Seatdto();
				dto.setId(rs.getInt("id"));
				dto.setSeatNumber(rs.getString("seat_number"));
				dto.setSeatClass(rs.getString("seat_class"));
				dto.setReserved(rs.getBoolean("is_reserved"));
				dto.setFlightId(rs.getString("flight_id"));
				dto.setPrice(rs.getDouble("price"));
				dtos.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dtos;
	}

	/**
	 * 특정 항공편의 예약 가능한 좌석만 조회
	 */
	public ArrayList<Seatdto> selectAvailableByFlight(String flightId) {
		ArrayList<Seatdto> dtos = new ArrayList<Seatdto>();
		try {
			String sql = "SELECT id, seat_number, seat_class, is_reserved, flight_id, price "
					+ "FROM seats WHERE flight_id = ? AND is_reserved = FALSE ORDER BY seat_number ASC";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			rs = psmt.executeQuery();
			while (rs.next()) {
				Seatdto dto = new Seatdto();
				dto.setId(rs.getInt("id"));
				dto.setSeatNumber(rs.getString("seat_number"));
				dto.setSeatClass(rs.getString("seat_class"));
				dto.setReserved(rs.getBoolean("is_reserved"));
				dto.setFlightId(rs.getString("flight_id"));
				dto.setPrice(rs.getDouble("price"));
				dtos.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dtos;
	}

	/**
	 * 좌석에 항공편 연결 및 가격 설정
	 */
	public int assignFlightToSeat(String seatNumber, String flightId, double price) {
		int res = 0;
		try {
			String sql = "UPDATE seats SET flight_id = ?, price = ? WHERE seat_number = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			psmt.setDouble(2, price);
			psmt.setString(3, seatNumber);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return res;
	}

	/**
	 * 여러 좌석에 한 번에 항공편 연결
	 */
	public int assignFlightToMultipleSeats(String[] seatNumbers, String flightId, double price) {
		int totalRes = 0;
		try {
			con.setAutoCommit(false); // 트랜잭션 시작

			String sql = "UPDATE seats SET flight_id = ?, price = ? WHERE seat_number = ?";
			psmt = con.prepareStatement(sql);

			for (String seatNumber : seatNumbers) {
				psmt.setString(1, flightId);
				psmt.setDouble(2, price);
				psmt.setString(3, seatNumber);
				totalRes += psmt.executeUpdate();
			}

			con.commit(); // 커밋
			con.setAutoCommit(true);
		} catch (SQLException e) {
			try {
				con.rollback(); // 롤백
				con.setAutoCommit(true);
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
			e.printStackTrace();
		}
		return totalRes;
	}

	/**
	 * 특정 항공편의 좌석 등급별 개수 조회
	 */
	public java.util.Map<String, Integer> getSeatCountByClass(String flightId) {
		java.util.Map<String, Integer> countMap = new java.util.HashMap<>();
		try {
			String sql = "SELECT seat_class, COUNT(*) as count " + "FROM seats WHERE flight_id = ? GROUP BY seat_class";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			rs = psmt.executeQuery();
			while (rs.next()) {
				countMap.put(rs.getString("seat_class"), rs.getInt("count"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return countMap;
	}

	/**
	 * 특정 항공편의 예약 가능한 좌석 수 조회
	 */
	public int getAvailableSeatCount(String flightId) {
		int count = 0;
		try {
			String sql = "SELECT COUNT(*) as count FROM seats WHERE flight_id = ? AND is_reserved = FALSE";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			rs = psmt.executeQuery();
			if (rs.next()) {
				count = rs.getInt("count");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return count;
	}

	/**
	 * 좌석에서 항공편 연결 해제
	 */
	public int removeFlightFromSeat(String seatNumber) {
		int res = 0;
		try {
			String sql = "UPDATE seats SET flight_id = NULL, price = 0 WHERE seat_number = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, seatNumber);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return res;
	}

	// ========== 항공편별 예약 처리 메서드들 (새로 추가) ==========

	/**
	 * 특정 항공편의 특정 좌석 예약
	 */
	public int reserveFlightSeat(String flightId, String seatNumber) {
		int res = 0;
		try {
			String sql = "UPDATE seats SET is_reserved = TRUE "
					+ "WHERE flight_id = ? AND seat_number = ? AND is_reserved = FALSE";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			psmt.setString(2, seatNumber);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return res;
	}

	/**
	 * 특정 항공편의 여러 좌석을 한 번에 예약 (트랜잭션 처리)
	 */
	public int reserveMultipleFlightSeats(String flightId, String[] seatNumbers) {
		int totalRes = 0;
		try {
			con.setAutoCommit(false); // 트랜잭션 시작

			String sql = "UPDATE seats SET is_reserved = TRUE "
					+ "WHERE flight_id = ? AND seat_number = ? AND is_reserved = FALSE";
			psmt = con.prepareStatement(sql);

			for (String seatNumber : seatNumbers) {
				psmt.setString(1, flightId);
				psmt.setString(2, seatNumber);
				int result = psmt.executeUpdate();
				if (result > 0) {
					totalRes++;
				} else {
					// 하나라도 실패하면 롤백
					con.rollback();
					con.setAutoCommit(true);
					return 0;
				}
			}

			con.commit(); // 모든 예약이 성공하면 커밋
			con.setAutoCommit(true);
		} catch (SQLException e) {
			try {
				con.rollback(); // 오류 발생 시 롤백
				con.setAutoCommit(true);
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
			e.printStackTrace();
			return 0;
		}
		return totalRes;
	}

	/**
	 * 특정 항공편의 특정 좌석 정보 조회
	 */
	public Seatdto getSeatByFlightAndNumber(String flightId, String seatNumber) {
		Seatdto dto = null;
		try {
			String sql = "SELECT id, seat_number, seat_class, is_reserved, flight_id, price "
					+ "FROM seats WHERE flight_id = ? AND seat_number = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			psmt.setString(2, seatNumber);
			rs = psmt.executeQuery();
			if (rs.next()) {
				dto = new Seatdto();
				dto.setId(rs.getInt("id"));
				dto.setSeatNumber(rs.getString("seat_number"));
				dto.setSeatClass(rs.getString("seat_class"));
				dto.setReserved(rs.getBoolean("is_reserved"));
				dto.setFlightId(rs.getString("flight_id"));
				dto.setPrice(rs.getDouble("price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dto;
	}

	/**
	 * 특정 항공편의 좌석 예약 취소
	 */
	public int cancelFlightSeatReservation(String flightId, String seatNumber) {
		int res = 0;
		try {
			String sql = "UPDATE seats SET is_reserved = FALSE "
					+ "WHERE flight_id = ? AND seat_number = ? AND is_reserved = TRUE";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			psmt.setString(2, seatNumber);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return res;
	}

	/**
	 * 특정 항공편의 여러 좌석 예약 취소
	 */
	public int cancelMultipleFlightSeats(String flightId, String[] seatNumbers) {
		int totalRes = 0;
		try {
			con.setAutoCommit(false); // 트랜잭션 시작

			String sql = "UPDATE seats SET is_reserved = FALSE "
					+ "WHERE flight_id = ? AND seat_number = ? AND is_reserved = TRUE";
			psmt = con.prepareStatement(sql);

			for (String seatNumber : seatNumbers) {
				psmt.setString(1, flightId);
				psmt.setString(2, seatNumber);
				totalRes += psmt.executeUpdate();
			}

			con.commit(); // 커밋
			con.setAutoCommit(true);
		} catch (SQLException e) {
			try {
				con.rollback(); // 롤백
				con.setAutoCommit(true);
			} catch (SQLException rollbackEx) {
				rollbackEx.printStackTrace();
			}
			e.printStackTrace();
		}
		return totalRes;
	}

	/**
	 * 특정 항공편의 좌석 상태 확인 (예약 가능한지)
	 */
	public boolean isSeatAvailable(String flightId, String seatNumber) {
		boolean available = false;
		try {
			String sql = "SELECT is_reserved FROM seats WHERE flight_id = ? AND seat_number = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			psmt.setString(2, seatNumber);
			rs = psmt.executeQuery();

			if (rs.next()) {
				available = !rs.getBoolean("is_reserved");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return available;
	}

	/**
	 * 특정 항공편의 좌석 가격 조회
	 */
	public double getSeatPrice(String flightId, String seatNumber) {
		double price = 0.0;
		try {
			String sql = "SELECT price FROM seats WHERE flight_id = ? AND seat_number = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			psmt.setString(2, seatNumber);
			rs = psmt.executeQuery();

			if (rs.next()) {
				price = rs.getDouble("price");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return price;
	}

	/**
	 * 특정 항공편의 여러 좌석 가격 일괄 조회
	 */
	public java.util.Map<String, Double> getMultipleSeatPrices(String flightId, String[] seatNumbers) {
		java.util.Map<String, Double> priceMap = new java.util.HashMap<>();

		if (seatNumbers == null || seatNumbers.length == 0) {
			return priceMap;
		}

		try {
			StringBuilder sql = new StringBuilder(
					"SELECT seat_number, price FROM seats WHERE flight_id = ? AND seat_number IN (");
			for (int i = 0; i < seatNumbers.length; i++) {
				if (i > 0)
					sql.append(",");
				sql.append("?");
			}
			sql.append(")");

			psmt = con.prepareStatement(sql.toString());
			psmt.setString(1, flightId);
			for (int i = 0; i < seatNumbers.length; i++) {
				psmt.setString(i + 2, seatNumbers[i]);
			}

			rs = psmt.executeQuery();
			while (rs.next()) {
				priceMap.put(rs.getString("seat_number"), rs.getDouble("price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return priceMap;
	}

	/**
	 * 특정 항공편의 좌석 예약 상태 일괄 확인
	 */
	public java.util.Map<String, Boolean> checkMultipleSeatAvailability(String flightId, String[] seatNumbers) {
		java.util.Map<String, Boolean> availabilityMap = new java.util.HashMap<>();

		if (seatNumbers == null || seatNumbers.length == 0) {
			return availabilityMap;
		}

		try {
			StringBuilder sql = new StringBuilder(
					"SELECT seat_number, is_reserved FROM seats WHERE flight_id = ? AND seat_number IN (");
			for (int i = 0; i < seatNumbers.length; i++) {
				if (i > 0)
					sql.append(",");
				sql.append("?");
			}
			sql.append(")");

			psmt = con.prepareStatement(sql.toString());
			psmt.setString(1, flightId);
			for (int i = 0; i < seatNumbers.length; i++) {
				psmt.setString(i + 2, seatNumbers[i]);
			}

			rs = psmt.executeQuery();
			while (rs.next()) {
				availabilityMap.put(rs.getString("seat_number"), !rs.getBoolean("is_reserved"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return availabilityMap;
	}

	/**
	 * 특정 항공편의 예약 현황 통계
	 */
	public java.util.Map<String, Object> getFlightSeatStatistics(String flightId) {
		java.util.Map<String, Object> stats = new java.util.HashMap<>();
		try {
			String sql = "SELECT " + "COUNT(*) as total_seats, "
					+ "SUM(CASE WHEN is_reserved = FALSE THEN 1 ELSE 0 END) as available_seats, "
					+ "SUM(CASE WHEN is_reserved = TRUE THEN 1 ELSE 0 END) as reserved_seats, "
					+ "AVG(price) as average_price, " + "MIN(price) as min_price, " + "MAX(price) as max_price "
					+ "FROM seats WHERE flight_id = ?";

			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			rs = psmt.executeQuery();

			if (rs.next()) {
				stats.put("totalSeats", rs.getInt("total_seats"));
				stats.put("availableSeats", rs.getInt("available_seats"));
				stats.put("reservedSeats", rs.getInt("reserved_seats"));
				stats.put("averagePrice", rs.getDouble("average_price"));
				stats.put("minPrice", rs.getDouble("min_price"));
				stats.put("maxPrice", rs.getDouble("max_price"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return stats;
	}

	public void close() {
		try {
			if (rs != null)
				rs.close();
			if (psmt != null)
				psmt.close();
			if (con != null)
				con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 새 좌석 추가 (항공편 관리자용)
	 */
	public int insertSeat(String seatNumber, String seatClass, String flightId, double price) {
		int result = 0;
		try {
			String sql = "INSERT INTO seats (seat_number, seat_class, is_reserved, flight_id, price) VALUES (?, ?, 0, ?, ?)";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, seatNumber);
			psmt.setString(2, seatClass);
			psmt.setString(3, flightId);
			psmt.setDouble(4, price);
			result = psmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 특정 항공편의 모든 좌석 삭제 (항공편 삭제시 사용)
	 */
	public int deleteSeatsByFlightId(String flightId) {
		int result = 0;
		try {
			String sql = "DELETE FROM seats WHERE flight_id = ?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, flightId);
			result = psmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}

}