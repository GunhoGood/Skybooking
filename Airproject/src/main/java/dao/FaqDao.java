package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import dto.FaqDto;

public class FaqDao {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/air";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "87938260";
    
    // 데이터베이스 연결 메소드
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL 드라이버를 찾을 수 없습니다.", e);
        }
    }
    
    // 모든 FAQ 조회 (활성화된 것만)
    public List<FaqDto> getAllFaqs() {
        List<FaqDto> faqs = new ArrayList<>();
        String sql = "SELECT * FROM faq WHERE is_active = 1 ORDER BY sort_order, faq_id";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                FaqDto faq = new FaqDto();
                faq.setFaqId(rs.getInt("faq_id"));
                faq.setCategory(rs.getString("category"));
                faq.setQuestion(rs.getString("question"));
                faq.setAnswer(rs.getString("answer"));
                faq.setCreatedDate(rs.getTimestamp("created_date"));
                faq.setUpdatedDate(rs.getTimestamp("updated_date"));
                faq.setActive(rs.getBoolean("is_active"));
                faq.setSortOrder(rs.getInt("sort_order"));
                faqs.add(faq);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return faqs;
    }
    
    // 카테고리별 FAQ 조회
    public List<FaqDto> getFaqsByCategory(String category) {
        List<FaqDto> faqs = new ArrayList<>();
        String sql = "SELECT * FROM faq WHERE category = ? AND is_active = 1 ORDER BY sort_order, faq_id";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, category);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    FaqDto faq = new FaqDto();
                    faq.setFaqId(rs.getInt("faq_id"));
                    faq.setCategory(rs.getString("category"));
                    faq.setQuestion(rs.getString("question"));
                    faq.setAnswer(rs.getString("answer"));
                    faq.setCreatedDate(rs.getTimestamp("created_date"));
                    faq.setUpdatedDate(rs.getTimestamp("updated_date"));
                    faq.setActive(rs.getBoolean("is_active"));
                    faq.setSortOrder(rs.getInt("sort_order"));
                    faqs.add(faq);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return faqs;
    }
    
    // FAQ 검색
    public List<FaqDto> searchFaqs(String keyword) {
        List<FaqDto> faqs = new ArrayList<>();
        String sql = "SELECT * FROM faq WHERE (question LIKE ? OR answer LIKE ?) AND is_active = 1 ORDER BY sort_order, faq_id";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchKeyword = "%" + keyword + "%";
            pstmt.setString(1, searchKeyword);
            pstmt.setString(2, searchKeyword);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    FaqDto faq = new FaqDto();
                    faq.setFaqId(rs.getInt("faq_id"));
                    faq.setCategory(rs.getString("category"));
                    faq.setQuestion(rs.getString("question"));
                    faq.setAnswer(rs.getString("answer"));
                    faq.setCreatedDate(rs.getTimestamp("created_date"));
                    faq.setUpdatedDate(rs.getTimestamp("updated_date"));
                    faq.setActive(rs.getBoolean("is_active"));
                    faq.setSortOrder(rs.getInt("sort_order"));
                    faqs.add(faq);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return faqs;
    }
    
    // FAQ 추가
    public boolean insertFaq(FaqDto faq) {
        String sql = "INSERT INTO faq (category, question, answer, sort_order) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, faq.getCategory());
            pstmt.setString(2, faq.getQuestion());
            pstmt.setString(3, faq.getAnswer());
            pstmt.setInt(4, getNextSortOrder());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // FAQ 수정
    public boolean updateFaq(FaqDto faq) {
        String sql = "UPDATE faq SET category = ?, question = ?, answer = ? WHERE faq_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, faq.getCategory());
            pstmt.setString(2, faq.getQuestion());
            pstmt.setString(3, faq.getAnswer());
            pstmt.setInt(4, faq.getFaqId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // FAQ 삭제 (실제로는 is_active를 false로 변경)
    public boolean deleteFaq(int faqId) {
        String sql = "UPDATE faq SET is_active = 0 WHERE faq_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, faqId);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 특정 FAQ 조회
    public FaqDto getFaqById(int faqId) {
        String sql = "SELECT * FROM faq WHERE faq_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, faqId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    FaqDto faq = new FaqDto();
                    faq.setFaqId(rs.getInt("faq_id"));
                    faq.setCategory(rs.getString("category"));
                    faq.setQuestion(rs.getString("question"));
                    faq.setAnswer(rs.getString("answer"));
                    faq.setCreatedDate(rs.getTimestamp("created_date"));
                    faq.setUpdatedDate(rs.getTimestamp("updated_date"));
                    faq.setActive(rs.getBoolean("is_active"));
                    faq.setSortOrder(rs.getInt("sort_order"));
                    return faq;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // 다음 정렬 순서 번호 가져오기
    private int getNextSortOrder() {
        String sql = "SELECT COALESCE(MAX(sort_order), 0) + 1 FROM faq";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 1;
    }
    
    // 전체 FAQ 개수 조회
    public int getTotalFaqCount() {
        String sql = "SELECT COUNT(*) FROM faq WHERE is_active = 1";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // 카테고리별 개수 조회
    public int getCategoryCount() {
        String sql = "SELECT COUNT(DISTINCT category) FROM faq WHERE is_active = 1";
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}