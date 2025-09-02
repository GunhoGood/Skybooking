package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.FaqDao;
import dto.FaqDto;

@WebServlet("/faq")
public class FaqController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FaqDao faqDao;
    
    @Override
    public void init() throws ServletException {
        System.out.println("=== FaqController 초기화 시작 ===");
        try {
            faqDao = new FaqDao();
            System.out.println("FaqDao 초기화 성공");
        } catch (Exception e) {
            System.out.println("FaqDao 초기화 실패: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("=== FaqController 초기화 완료 ===");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== doGet 메소드 호출됨 ===");
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        System.out.println("action 파라미터: " + action);
        
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    showFaqList(request, response);
                    break;
                case "admin":
                    showAdminPage(request, response);
                    break;
                case "search":
                    searchFaq(request, response);
                    break;
                case "category":
                    showFaqByCategory(request, response);
                    break;
                case "get":
                    getFaqById(request, response);
                    break;
                case "test":
                    testPage(request, response);
                    break;
                default:
                    showFaqList(request, response);
            }
        } catch (Exception e) {
            System.out.println("doGet에서 예외 발생: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== doPost 메소드 호출됨 ===");
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        System.out.println("POST action: " + action);
        
        // 파라미터 디버깅
        System.out.println("=== 모든 파라미터 출력 ===");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            System.out.println(paramName + " = " + paramValue);
        }
        System.out.println("=== 파라미터 출력 끝 ===");
        
        // action이 null인 경우 처리
        if (action == null || action.trim().isEmpty()) {
            System.out.println("ERROR: action 파라미터가 null이거나 비어있습니다.");
            response.sendRedirect("/Airproject/faq?action=admin&error=no_action");
            return;
        }
        
        try {
            switch (action.trim()) {
                case "insert":
                    insertFaq(request, response);
                    break;
                case "update":
                    updateFaq(request, response);
                    break;
                case "delete":
                    deleteFaq(request, response);
                    break;
                default:
                    response.sendRedirect("/Airproject/faq?action=admin&error=invalid_action");
            }
        } catch (Exception e) {
            System.out.println("doPost에서 예외 발생: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("/Airproject/faq?action=admin&error=server_error");
        }
    }
    
    // 테스트용 페이지
    private void testPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== 테스트 페이지 실행 ===");
        
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>FAQ 컨트롤러 테스트</title></head>");
        out.println("<body style='font-family: Arial; margin: 40px;'>");
        out.println("<h1>FAQ 컨트롤러 테스트 페이지</h1>");
        
        // 데이터베이스 연결 테스트
        try {
            if (faqDao != null) {
                out.println("<p style='color: green;'>✅ FaqDao 객체 생성 성공</p>");
                
                List<FaqDto> faqList = faqDao.getAllFaqs();
                out.println("<p style='color: green;'>✅ 데이터베이스 연결 성공</p>");
                out.println("<p><strong>FAQ 개수: " + faqList.size() + "개</strong></p>");
                
                if (faqList.size() > 0) {
                    out.println("<h3>FAQ 목록:</h3>");
                    out.println("<ul>");
                    for (FaqDto faq : faqList) {
                        out.println("<li><strong>" + faq.getQuestion() + "</strong> (카테고리: " + faq.getCategoryDisplayName() + ")</li>");
                    }
                    out.println("</ul>");
                } else {
                    out.println("<p style='color: orange;'>⚠️ 데이터베이스에 FAQ 데이터가 없습니다</p>");
                }
            } else {
                out.println("<p style='color: red;'>❌ FaqDao 객체가 null입니다</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ 데이터베이스 연결 실패: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
        
        out.println("<hr>");
        out.println("<h3>테스트 링크:</h3>");
        out.println("<p><a href='/Airproject/faq'>일반 FAQ 페이지 (컨트롤러 통해서)</a></p>");
        out.println("<p><a href='/Airproject/Faq.jsp'>FAQ JSP 직접 접속</a></p>");
        out.println("<p><a href='/Airproject/faq?action=admin'>Admin 페이지</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
    
    // 일반 FAQ 목록 페이지
    private void showFaqList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== showFaqList 메소드 실행 ===");
        
        try {
            List<FaqDto> faqList = faqDao.getAllFaqs();
            System.out.println("FAQ 리스트 조회 성공, 개수: " + faqList.size());
            
            request.setAttribute("faqList", faqList);
            request.setAttribute("totalCount", faqDao.getTotalFaqCount());
            
            // 메시지 처리
            String message = request.getParameter("message");
            if (message != null) {
                switch (message) {
                    case "added":
                        request.setAttribute("successMessage", "FAQ가 성공적으로 추가되었습니다.");
                        break;
                    case "updated":
                        request.setAttribute("successMessage", "FAQ가 성공적으로 수정되었습니다.");
                        break;
                    case "deleted":
                        request.setAttribute("successMessage", "FAQ가 성공적으로 삭제되었습니다.");
                        break;
                }
            }
            
            System.out.println("JSP로 포워딩 시도: /Faq.jsp");
            request.getRequestDispatcher("/Faq.jsp").forward(request, response);
            System.out.println("JSP 포워딩 완료");
            
        } catch (Exception e) {
            System.out.println("showFaqList에서 예외 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    // 관리자 FAQ 관리 페이지
    private void showAdminPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== showAdminPage 실행 ===");
        
        // 관리자 권한 체크 (일단 주석 처리)
        /*
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }
        */
        
        List<FaqDto> faqList = faqDao.getAllFaqs();
        request.setAttribute("faqList", faqList);
        request.setAttribute("totalFaqs", faqDao.getTotalFaqCount());
        request.setAttribute("categoryCount", faqDao.getCategoryCount());
        
        request.getRequestDispatcher("/faqAdmin.jsp").forward(request, response);
    }
    
    // FAQ 검색
    private void searchFaq(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            showFaqList(request, response);
            return;
        }
        
        List<FaqDto> faqList = faqDao.searchFaqs(keyword.trim());
        request.setAttribute("faqList", faqList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("searchResultCount", faqList.size());
        
        request.getRequestDispatcher("/Faq.jsp").forward(request, response);
    }
    
    // 카테고리별 FAQ 조회
    private void showFaqByCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("category");
        if (category == null || category.trim().isEmpty()) {
            showFaqList(request, response);
            return;
        }
        
        List<FaqDto> faqList = faqDao.getFaqsByCategory(category);
        request.setAttribute("faqList", faqList);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("categoryResultCount", faqList.size());
        
        request.getRequestDispatcher("/Faq.jsp").forward(request, response);
    }
    
    // 특정 FAQ 조회 (AJAX용)
    private void getFaqById(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json; charset=UTF-8");

        try {
            int faqId = Integer.parseInt(request.getParameter("id"));
            FaqDto faq = faqDao.getFaqById(faqId);

            if (faq != null) {
                // Gson 사용
                com.google.gson.Gson gson = new com.google.gson.Gson();
                String jsonResponse = gson.toJson(faq);
                response.getWriter().write(jsonResponse);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"FAQ를 찾을 수 없습니다.\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"유효하지 않은 FAQ ID입니다.\"}");
        }
    }

    
    // FAQ 추가
    private void insertFaq(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("category");
        String question = request.getParameter("question");
        String answer = request.getParameter("answer");
        
        System.out.println("Insert FAQ - category: " + category + ", question: " + question);
        
        // 입력값 검증
        if (category == null || category.trim().isEmpty() ||
            question == null || question.trim().isEmpty() ||
            answer == null || answer.trim().isEmpty()) {
            
            response.sendRedirect("/Airproject/faq?action=admin&error=missing_fields");
            return;
        }
        
        FaqDto faq = new FaqDto(category.trim(), question.trim(), answer.trim());
        
        if (faqDao.insertFaq(faq)) {
            response.sendRedirect("/Airproject/faq?action=admin&message=added");
        } else {
            response.sendRedirect("/Airproject/faq?action=admin&error=insert_failed");
        }
    }
    
    // FAQ 수정
    private void updateFaq(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int faqId = Integer.parseInt(request.getParameter("faqId"));
            String category = request.getParameter("category");
            String question = request.getParameter("question");
            String answer = request.getParameter("answer");
            
            System.out.println("Update FAQ - ID: " + faqId + ", category: " + category);
            
            // 입력값 검증
            if (category == null || category.trim().isEmpty() ||
                question == null || question.trim().isEmpty() ||
                answer == null || answer.trim().isEmpty()) {
                
                response.sendRedirect("/Airproject/faq?action=admin&error=missing_fields");
                return;
            }
            
            FaqDto faq = new FaqDto();
            faq.setFaqId(faqId);
            faq.setCategory(category.trim());
            faq.setQuestion(question.trim());
            faq.setAnswer(answer.trim());
            
            if (faqDao.updateFaq(faq)) {
                response.sendRedirect("/Airproject/faq?action=admin&message=updated");
            } else {
                response.sendRedirect("/Airproject/faq?action=admin&error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("/Airproject/faq?action=admin&error=invalid_id");
        }
    }
    
    // FAQ 삭제
    private void deleteFaq(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int faqId = Integer.parseInt(request.getParameter("faqId"));
            
            System.out.println("Delete FAQ - ID: " + faqId);
            
            if (faqDao.deleteFaq(faqId)) {
                response.sendRedirect("/Airproject/faq?action=admin&message=deleted");
            } else {
                response.sendRedirect("/Airproject/faq?action=admin&error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("/Airproject/faq?action=admin&error=invalid_id");
        }
    }
    
    // 관리자 권한 체크
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        
        String userRole = (String) session.getAttribute("userRole");
        return "ADMIN".equals(userRole);
    }
    
    // JSON 응답 전송 )
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        
        response.setContentType("application/json; charset=UTF-8");
        
        String jsonResponse = String.format(
            "{\"success\":%s,\"message\":\"%s\"}", 
            success, 
            message.replace("\"", "\\\"")
        );
        
        PrintWriter out = response.getWriter();
        out.print(jsonResponse);
        out.flush();
    }
}