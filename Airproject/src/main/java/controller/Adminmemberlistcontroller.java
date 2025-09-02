package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.Usersdao;
import dto.Users;

@WebServlet("/memberList")
public class Adminmemberlistcontroller extends HttpServlet {
	 @Override
	    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	        HttpSession session = req.getSession();
	        Users loginUser = (Users) session.getAttribute("user");
	        
	        if (loginUser == null || loginUser.getAdmin() != 1) {
	        	session.setAttribute("errorMessage", "잘못된 접근입니다. 관리자만 접근할 수 있습니다.");
	            resp.sendRedirect(req.getContextPath() + "/main");
	            return;
	        }

	        Usersdao dao = new Usersdao(req.getServletContext());
	        List<Users> list = dao.selectList();
	        dao.close();

	        req.setAttribute("memberList", list);
	        req.getRequestDispatcher("/AdminMemberList.jsp").forward(req, resp);
	    }
}
