package controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.Usersdao;
import dto.Users;

@WebServlet("/login")
public class Logincontroller extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/Login.jsp").forward(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id = req.getParameter("id");
		String pwd = req.getParameter("pwd");
		String rememberid = req.getParameter("rememberid");
		String url = req.getParameter("url");
		url = url == null || "".equals(url) ? "main" : url;
		Usersdao dao = new Usersdao(req.getServletContext());
		Users u = dao.select(id);
		
		if(u != null && u.getId().equals(id) && (u.getPwd().equals(pwd))) {
			if(rememberid != null) {
				Cookie cookie = new Cookie("id", id);
				cookie.setPath(req.getContextPath());
				cookie.setMaxAge(60*60);
				resp.addCookie(cookie);
			} else {
				Cookie cookie = new Cookie("id", "");
				cookie.setPath(req.getContextPath());
				cookie.setMaxAge(0);
				resp.addCookie(cookie);
			}
			HttpSession session = req.getSession();
			session.setAttribute("user", u);
			session.setAttribute("id", id);
			
			LocalDateTime loginTime = LocalDateTime.now(); // 현재 시간 localdatetime 타입으로 가져옴
			String loginTimeStr = loginTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")); // 현재 시간을 String 타입으로 포맷
			session.setAttribute("loginTime", loginTimeStr); // String 타입의 현재시간을 세션 객체 생성
			session.setMaxInactiveInterval(1800); // 세션 유지 시간을 30분으로 설정
			resp.sendRedirect(url);
		} else {
			req.getRequestDispatcher("/Login.jsp?loginError=error").forward(req, resp);
		}
		
	}
}
