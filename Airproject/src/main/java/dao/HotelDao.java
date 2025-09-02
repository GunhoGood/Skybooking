package dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import dto.Hotel;
import util.JDBConnect;

public class HotelDao extends JDBConnect {
    
    public HotelDao() {
        super();
    }
    
    public HotelDao(ServletContext application) {
        super(application);
    }
    
    /**
     * 모든 국내 호텔 조회
     */
    public List<Hotel> getDomesticHotels() {
        List<Hotel> hotelList = new ArrayList<>();
        try {
            String sql = "SELECT * FROM hotels ORDER BY rating DESC, like_count DESC";
            psmt = con.prepareStatement(sql);
            rs = psmt.executeQuery();
            
            while (rs.next()) {
                Hotel hotel = new Hotel();
                hotel.setId(rs.getInt("id"));
                hotel.setName(rs.getString("name"));
                hotel.setLocation(rs.getString("location"));
                hotel.setRegion(rs.getString("region"));
                hotel.setDescription(rs.getString("description"));
                hotel.setPrice(rs.getInt("price"));
                hotel.setStarRating(rs.getInt("star_rating"));
                hotel.setRating(rs.getDouble("rating"));
                hotel.setImageUrl(rs.getString("image_url"));
                hotel.setCategory(rs.getString("category"));
                hotel.setAmenitiesStr(rs.getString("amenities"));
                hotel.setCreateDate(rs.getTimestamp("create_date"));
                hotel.setLikeCount(rs.getInt("like_count"));
                
                hotelList.add(hotel);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotelList;
    }
    
    /**
     * 지역별 호텔 조회
     */
    public List<Hotel> getHotelsByRegion(String region) {
        List<Hotel> hotelList = new ArrayList<>();
        try {
            String sql = "SELECT * FROM hotels WHERE region = ? ORDER BY rating DESC";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, region);
            rs = psmt.executeQuery();
            
            while (rs.next()) {
                Hotel hotel = mapResultSetToHotel(rs);
                hotelList.add(hotel);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotelList;
    }
    
    /**
     * 필터링된 호텔 조회
     */
    public List<Hotel> getFilteredHotels(String region, Integer starRating, Integer minPrice, Integer maxPrice, String sortBy) {
        List<Hotel> hotelList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM hotels WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // 필터 조건 추가
        if (region != null && !region.isEmpty()) {
            sql.append(" AND region = ?");
            params.add(region);
        }
        
        if (starRating != null) {
            sql.append(" AND star_rating = ?");
            params.add(starRating);
        }
        
        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }
        
        // 정렬 조건 추가
        if (sortBy != null) {
            switch (sortBy) {
                case "price_low":
                    sql.append(" ORDER BY price ASC");
                    break;
                case "price_high":
                    sql.append(" ORDER BY price DESC");
                    break;
                case "rating":
                    sql.append(" ORDER BY rating DESC");
                    break;
                case "review":
                    sql.append(" ORDER BY like_count DESC");
                    break;
                default:
                    sql.append(" ORDER BY rating DESC, like_count DESC");
            }
        } else {
            sql.append(" ORDER BY rating DESC, like_count DESC");
        }
        
        try {
            psmt = con.prepareStatement(sql.toString());
            
            // 파라미터 설정
            for (int i = 0; i < params.size(); i++) {
                psmt.setObject(i + 1, params.get(i));
            }
            
            rs = psmt.executeQuery();
            
            while (rs.next()) {
                Hotel hotel = mapResultSetToHotel(rs);
                hotelList.add(hotel);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return hotelList;
    }
    
    /**
     * 호텔 ID로 단일 호텔 조회 (수정용)
     */
    public Hotel getHotelById(int id) {
        Hotel hotel = null;
        try {
            String sql = "SELECT * FROM hotels WHERE id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, id);
            rs = psmt.executeQuery();
            
            if (rs.next()) {
                hotel = mapResultSetToHotel(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotel;
    }
    
    /**
     * 호텔 검색 (이름, 위치 기준)
     */
    public List<Hotel> searchHotels(String keyword) {
        List<Hotel> hotelList = new ArrayList<>();
        try {
            String sql = "SELECT * FROM hotels WHERE name LIKE ? OR location LIKE ? ORDER BY rating DESC";
            psmt = con.prepareStatement(sql);
            String searchKeyword = "%" + keyword + "%";
            psmt.setString(1, searchKeyword);
            psmt.setString(2, searchKeyword);
            rs = psmt.executeQuery();
            
            while (rs.next()) {
                Hotel hotel = mapResultSetToHotel(rs);
                hotelList.add(hotel);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotelList;
    }
    
    /**
     * 좋아요 수 증가
     */
    public boolean increaseLikeCount(int hotelId) {
        try {
            String sql = "UPDATE hotels SET like_count = like_count + 1 WHERE id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, hotelId);
            int result = psmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 좋아요 수 감소
     */
    public boolean decreaseLikeCount(int hotelId) {
        try {
            String sql = "UPDATE hotels SET like_count = like_count - 1 WHERE id = ? AND like_count > 0";
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, hotelId);
            int result = psmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ==================== 관리자 전용 메서드 ====================
    
    /**
     * 호텔 추가 (관리자 전용)
     */
    public boolean insertHotel(Hotel hotel) {
        try {
            String sql = "INSERT INTO hotels (name, location, region, description, price, star_rating, " +
                        "rating, image_url, category, amenities) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, hotel.getName());
            psmt.setString(2, hotel.getLocation());
            psmt.setString(3, hotel.getRegion());
            psmt.setString(4, hotel.getDescription());
            psmt.setInt(5, hotel.getPrice());
            psmt.setInt(6, hotel.getStarRating());
            psmt.setDouble(7, hotel.getRating());
            psmt.setString(8, hotel.getImageUrl());
            psmt.setString(9, hotel.getCategory());
            psmt.setString(10, hotel.getAmenitiesStr());
            
            int result = psmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 호텔 정보 수정 (관리자 전용)
     */
    public boolean updateHotel(Hotel hotel) {
        try {
            String sql = "UPDATE hotels SET name = ?, location = ?, region = ?, description = ?, " +
                        "price = ?, star_rating = ?, rating = ?, image_url = ?, category = ?, amenities = ? " +
                        "WHERE id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, hotel.getName());
            psmt.setString(2, hotel.getLocation());
            psmt.setString(3, hotel.getRegion());
            psmt.setString(4, hotel.getDescription());
            psmt.setInt(5, hotel.getPrice());
            psmt.setInt(6, hotel.getStarRating());
            psmt.setDouble(7, hotel.getRating());
            psmt.setString(8, hotel.getImageUrl());
            psmt.setString(9, hotel.getCategory());
            psmt.setString(10, hotel.getAmenitiesStr());
            psmt.setInt(11, hotel.getId());
            
            int result = psmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 호텔 삭제 (관리자 전용)
     */
    public boolean deleteHotel(int hotelId) {
        try {
            String sql = "DELETE FROM hotels WHERE id = ?";
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, hotelId);
            int result = psmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * 전체 호텔 수 조회 (관리자 전용)
     */
    public int getTotalHotelCount() {
        try {
            String sql = "SELECT COUNT(*) FROM hotels";
            psmt = con.prepareStatement(sql);
            rs = psmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * 지역별 호텔 수 조회 (관리자 전용)
     */
    public int getRegionCount() {
        try {
            String sql = "SELECT COUNT(DISTINCT region) FROM hotels";
            psmt = con.prepareStatement(sql);
            rs = psmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ==================== 공통 유틸리티 메서드 ====================
    
    /**
     * ResultSet을 Hotel 객체로 매핑
     */
    private Hotel mapResultSetToHotel(java.sql.ResultSet rs) throws SQLException {
        Hotel hotel = new Hotel();
        hotel.setId(rs.getInt("id"));
        hotel.setName(rs.getString("name"));
        hotel.setLocation(rs.getString("location"));
        hotel.setRegion(rs.getString("region"));
        hotel.setDescription(rs.getString("description"));
        hotel.setPrice(rs.getInt("price"));
        hotel.setStarRating(rs.getInt("star_rating"));
        hotel.setRating(rs.getDouble("rating"));
        hotel.setImageUrl(rs.getString("image_url"));
        hotel.setCategory(rs.getString("category"));
        hotel.setAmenitiesStr(rs.getString("amenities"));
        hotel.setCreateDate(rs.getTimestamp("create_date"));
        hotel.setLikeCount(rs.getInt("like_count"));
        return hotel;
    }
}