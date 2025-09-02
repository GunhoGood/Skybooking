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

import java.io.IOException;

@WebServlet("/qnaView")
public class QnaViewController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // 관리자 권한 체크
        if (user == null || user.getAdmin() != 1) {
            response.sendRedirect("main");
            return;
        }

        String boardIdStr = request.getParameter("board_id");
        int boardId = 0;
        Board b = null;

        if (boardIdStr != null && !boardIdStr.isEmpty()) {
            try {
                boardId = Integer.parseInt(boardIdStr);
                BoardDao dao = new BoardDao(request.getServletContext());
                b = dao.selectById(boardId);
            } catch (NumberFormatException e) {
                // board_id가 숫자가 아님
            }
        }
        
        request.setAttribute("board", b);
        request.getRequestDispatcher("/qnaView.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 요청 인코딩 설정

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        // 관리자 권한 체크
        if (user == null || user.getAdmin() != 1) {
            response.sendRedirect("main");
            return;
        }

        String boardIdStr = request.getParameter("board_id");
        String answer = request.getParameter("answer");

        if (boardIdStr != null && !boardIdStr.isEmpty() && answer != null) {
            try {
                int boardId = Integer.parseInt(boardIdStr);
                BoardDao dao = new BoardDao(request.getServletContext());
                int result = dao.updateAnswer(boardId, answer); // 답변 업데이트

                if (result > 0) {
                    response.sendRedirect("qnaView?board_id=" + boardId + "&msg=answerSuccess"); // 성공 시 상세 페이지로 리다이렉트
                } else {
                    request.setAttribute("error", "답변 작성에 실패했습니다.");
                    doGet(request, response); // 실패 시 현재 페이지 다시 보여주기
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "잘못된 게시글 ID입니다.");
                doGet(request, response);
            }
        } else {
            request.setAttribute("error", "모든 필드를 채워주세요.");
            doGet(request, response);
        }
    }
}