package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.Usersdao;
import dto.Users;
import util.JSFunction;

@WebServlet("/deleteUser")
public class Deletecontroller extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		Users loginUser = (Users) session.getAttribute("user");
		
		if (loginUser == null || loginUser.getAdmin() != 1) {
        	session.setAttribute("errorMessage", "잘못된 접근입니다. 관리자만 접근할 수 있습니다.");
            resp.sendRedirect(req.getContextPath() + "/main");
            return;
        }
		
		String id = req.getParameter("id");
        if (id == null || id.trim().isEmpty()) {
            resp.sendRedirect("memberList");
            return;
        }
        
        Usersdao dao = new Usersdao(req.getServletContext());
        int res = dao.adminDelete(id);
        if(res == 1) {
        	JSFunction.alertLocation("삭제가 완료되었습니다.", "memberList", resp);
        } else {
        	JSFunction.alertBack("잠시 후 다시 시도해주세요.", resp);
        }
	}
}
