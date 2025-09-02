package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import dao.Usersdao;
import dto.Result;
import dto.Users;

@WebServlet("/findId")
public class Findidcontroller extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/Findid.jsp").forward(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		
		Usersdao dao = new Usersdao(req.getServletContext());
		String maskedId = dao.findId(email, name);
	    dao.close();
	    
	    Result findResult;
	    
	    if (maskedId != null) {
	    	findResult = new Result(true, "아이디를 찾았습니다!", "회원님의 아이디를 성공적으로 찾았습니다.", maskedId);
	    } else {
	    	findResult = new Result(false, "아이디를 찾을 수 없습니다", "입력하신 이름과 이메일을 다시 확인해 주세요.", null); // foundId는 null
	    }

	    req.setAttribute("findResult", findResult);
		
	    req.getRequestDispatcher("/Findid.jsp").forward(req, resp);
	}
}
