package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dto.Hotel;
import dao.HotelDao;

@WebServlet("/likeHotel")
public class likecontroller extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/plain; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // 세션에서 사용자 ID 확인
            HttpSession session = request.getSession();
            String userId = (String) session.getAttribute("id");
            
            if (userId == null) {
                out.print("ERROR:로그인이 필요합니다.");
                return;
            }
            
            // 파라미터 받기
            String hotelIdStr = request.getParameter("hotelId");
            String action = request.getParameter("action");
            
            if (hotelIdStr == null || action == null) {
                out.print("ERROR:필수 파라미터가 누락되었습니다.");
                return;
            }
            
            int hotelId = Integer.parseInt(hotelIdStr);
            
            HotelDao hotelDao = new HotelDao();
            boolean success = false;
            
            if ("like".equals(action)) {
                // 좋아요 추가
                success = hotelDao.increaseLikeCount(hotelId);
            } else if ("unlike".equals(action)) {
                // 좋아요 취소
                success = hotelDao.decreaseLikeCount(hotelId);
            }
            if (success) {
                // 성공: 현재 좋아요 수 반환
                dto.Hotel hotel = hotelDao.getHotelById(hotelId);
                int currentLikeCount = (hotel != null) ? hotel.getLikeCount() : 0;
                out.print("SUCCESS:" + currentLikeCount);
            } else {
                out.print("ERROR:좋아요 처리 중 오류가 발생했습니다.");
            }
            
        } catch (NumberFormatException e) {
            out.print("ERROR:잘못된 호텔 ID입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("ERROR:서버 오류가 발생했습니다.");
        } finally {
            out.flush();
        }
    }
}