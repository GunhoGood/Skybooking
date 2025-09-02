package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.Usersdao;
import dto.Users;
import util.JSFunction;

@WebServlet("/signup")
public class Registercontroller extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/Register.jsp").forward(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id = req.getParameter("id");
		String pwd = req.getParameter("pwd");
		String name = req.getParameter("name");
		String email = req.getParameter("email");
		String phone = req.getParameter("phone");
	    String gender = req.getParameter("gender");
	    String addrNum = req.getParameter("addrNum");
	    String address = req.getParameter("address");
	    String detailAddress = req.getParameter("detailAddress");
	    String birthStr = req.getParameter("birth");
	    String totalAddress = address + " " + detailAddress;
	    
	    // 유효성 검사
	    if (id == null || id.length() < 4 || id.length() > 20) {
	        JSFunction.alertBack("아이디는 4~20자 사이여야 합니다.", resp);
	        return;
	    }

	    if (pwd == null || !pwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,20}$")) {
	        JSFunction.alertBack("비밀번호는 8~16자 영문 대소문자, 숫자, 특수문자를 포함해야 합니다.", resp);
	        return;
	    }

	    if (!pwd.equals(req.getParameter("cpwd"))) {
	        JSFunction.alertBack("비밀번호 확인이 일치하지 않습니다.", resp);
	        return;
	    }

	    if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
	        JSFunction.alertBack("올바른 이메일 형식을 입력하세요.", resp);
	        return;
	    }

	    if (phone == null || !phone.matches("^\\d{11}$")) {
	        JSFunction.alertBack("휴대폰 번호는 11자리 숫자만 입력 가능합니다.", resp);
	        return;
	    }
	    
	    java.sql.Date birth = null;
	    if (birthStr != null && !birthStr.isEmpty()) {
	        birth = java.sql.Date.valueOf(birthStr);
	    }
	    Usersdao dao = new Usersdao(req.getServletContext()); 
		Users u = new Users(id, pwd, email, name, phone, addrNum, totalAddress, birth, gender);
		
		int res = dao.insert(u);
		if(res == 1) {
			JSFunction.alertLocation("회원가입에 성공하셨습니다.", "login", resp);
		} else if(res == -1) {
			req.setAttribute("errorMsg", "이미 사용 중인 아이디입니다. 다시 시도해주세요.");
			req.getRequestDispatcher("/Register.jsp").forward(req, resp);
		} else {
			req.getRequestDispatcher("/Register.jsp?registerError=error").forward(req, resp);
		}
		dao.close();
	}
}
