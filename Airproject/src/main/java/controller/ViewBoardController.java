package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.BoardDao;
import dto.Board;
import dto.Users; // Users DTO 임포트

@WebServlet("/viewBoard") // URL 매핑
public class ViewBoardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String boardIdStr = request.getParameter("board_id");
        int boardId = 0;
        Board board = null;

        if (boardIdStr != null && !boardIdStr.isEmpty()) {
            try {
                boardId = Integer.parseInt(boardIdStr);
                // BoardDao 객체 생성 시 ServletContext 전달
                BoardDao boardDao = new BoardDao(getServletContext());
                board = boardDao.selectById(boardId);

                // 권한 체크: 로그인한 사용자의 ID와 글 작성자 ID가 일치하는지 확인
                HttpSession session = request.getSession();
                Users loggedInUser = (Users) session.getAttribute("user"); // Users 객체로 정확히 캐스팅

                String loggedInUserId = null;
                if (loggedInUser != null) {
                    loggedInUserId = loggedInUser.getId(); // Users 객체에서 ID 가져오기
                }

                if (board != null && loggedInUserId != null && !loggedInUserId.equals(board.getWriterId())) {
                    // 권한이 없으면 접근 거부
                    response.sendRedirect("myposts?error=unauthorized");
                    return;
                }

            } catch (NumberFormatException e) {
                // board_id가 숫자가 아님
                response.sendRedirect("myposts?error=invalid_id");
                return;
            } catch (Exception e) {
                // 기타 예외 처리 (DB 연결 오류 등)
                e.printStackTrace();
                response.sendRedirect("error.jsp?msg=An unexpected error occurred.");
                return;
            }
        }

        // board 객체를 request 속성에 저장하여 JSP로 전달
        request.setAttribute("board", board);

        // view.jsp로 포워딩 (forward는 URL이 변경되지 않음)
        request.getRequestDispatcher("/view.jsp").forward(request, response);
    }
}