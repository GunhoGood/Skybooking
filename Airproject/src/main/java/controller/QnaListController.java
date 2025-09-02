package controller;
import dao.BoardDao;
import dto.Board;
import dto.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/qnaList")
public class QnaListController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user"); // 세션에서 사용자 객체 가져오기

        // 관리자 권한 체크
        if (user == null || user.getAdmin() != 1) { // UserDto에 getAdmin() 메서드가 있다고 가정
            response.sendRedirect("main"); // 권한 없으면 메인 페이지로
            return;
        }

        BoardDao dao = new BoardDao(request.getServletContext());
        List<Board> allPosts = dao.selectAll(); // 모든 글 가져오기
        request.setAttribute("allPosts", allPosts);

        request.getRequestDispatcher("/qnaList.jsp").forward(request, response);
    }
}
