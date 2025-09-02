package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.BoardDao;
import dto.Board;
import dto.Users;
import util.JSFunction;

import java.io.IOException;

@WebServlet("/inquiryWrite") // JSP의 form action과 일치
public class InquiryWriteController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	req.getRequestDispatcher("/inquiryPage.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 요청 인코딩 설정

        HttpSession session = request.getSession();
        // 세션에서 "user" 속성을 dto.Users 타입으로 가져옵니다.
        Users loggedInUser = (Users) session.getAttribute("user");

        // 로그인 여부 확인은 Users 객체가 null인지로 판단해야 합니다.
        if (loggedInUser == null) {
            // 로그인되어 있지 않다면 로그인 페이지로 이동시키고 경고창을 띄웁니다.
            JSFunction.alertLocation("로그인 후 이용해주세요.", "login", response); // "login" 대신 "login.jsp"가 더 명확합니다.
            return;
        }

     // 로그인된 사용자 ID를 Users 객체에서 가져옵니다.
        String writerId = loggedInUser.getId(); // loggedInUser 객체에서 ID를 가져옵니다.

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // 입력 유효성 검사 (제목과 내용이 비어있는지 확인)
        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            JSFunction.alertLocation("제목과 내용을 모두 입력해주세요.", "inquiryPage.jsp", response); // "inquiryPage" 대신 "inquiryPage.jsp"가 더 명확합니다.
            return;
        }
        
        Board board = new Board(); // dto.Board 객체 생성
        board.setWriterId(writerId);
        board.setTitle(title);
        board.setContent(content);

        BoardDao boardDao = new BoardDao(request.getServletContext()); // dao.BoardDao 객체 생성
        int result = boardDao.insertQuestion(board);

        if (result > 0) {
            // 문의글 작성 성공 시 내 글 목록으로 리다이렉트합니다.
            response.sendRedirect("myposts?msg=writeSuccess");
        } else {
            // 문의글 작성 실패 시 에러 메시지를 설정하고 inquiryPage.jsp로 포워딩합니다.
            request.setAttribute("error", "문의글 작성에 실패했습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/inquiryPage.jsp").forward(request, response);
        }
    }
}