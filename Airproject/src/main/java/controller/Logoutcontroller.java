package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.rowset.serial.SerialException;

@WebServlet("/logout")
public class Logoutcontroller extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false); // 세션 있으면 가져오고, 없으면 null
        if (session != null) {
            session.invalidate(); // 로그아웃
        }

        // 현재 페이지를 가리키는 referer 헤더 얻기
        String referer = req.getHeader("referer");

        if (referer != null && !referer.contains("/login") && !referer.contains("/signup")) {
            resp.sendRedirect(referer); // 기존 페이지로 이동
        } else {
            resp.sendRedirect("main"); // fallback
        }
	}
}
