package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.Usersdao;
import dto.Result;

@WebServlet("/findPwd")
public class Findpwdcontroller extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.getRequestDispatcher("/Findpwd.jsp").forward(req, resp);
	}
	@Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8"); // 요청 인코딩 설정
        HttpSession session = req.getSession();
        
        // 폼에서 전송된 숨겨진 resetToken 값 확인.
        // 2단계 폼에서만 이 값이 전송될 것이므로, 이를 통해 현재 요청이 몇 단계인지 구분합니다.
        String hiddenResetToken = req.getParameter("resetToken"); 

        // 2단계: 새 비밀번호 설정 (resetToken이 존재할 때)
        // resetToken이 hidden 필드에 있으면 2단계 처리로 간주합니다.
        if (hiddenResetToken != null && !hiddenResetToken.isEmpty()) {
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            
            // 세션에 저장된 실제 resetToken (사용자 ID)을 가져옵니다.
            String sessionResetToken = (String) session.getAttribute("resetToken"); 

            // 세션 토큰이 없거나, hidden 필드의 토큰과 일치하지 않으면 유효하지 않은 접근으로 간주
            if (sessionResetToken == null || sessionResetToken.isEmpty() || !sessionResetToken.equals(hiddenResetToken)) {
                req.setAttribute("findResult", new Result(false, "잘못된 접근", "비밀번호 재설정 정보가 유효하지 않습니다. 다시 시도해 주세요.", null));
                session.removeAttribute("resetToken"); // 세션 토큰 제거
                req.getRequestDispatcher("/Findpwd.jsp").forward(req, resp);
                return;
            }

            // 비밀번호 유효성 검사 (서버 측 재확인)
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("findResult", new Result(false, "비밀번호 불일치", "새 비밀번호와 비밀번호 확인이 일치하지 않습니다.", null));
                req.setAttribute("resetToken", sessionResetToken); // 2단계 폼을 유지하기 위해 토큰 다시 전달
                req.getRequestDispatcher("/Findpwd.jsp").forward(req, resp);
                return;
            }
            
            // 비밀번호 복잡성 검사 (정규식: 8~16자, 대소문자, 숫자, 특수문자 포함)
            String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,16}$";
            if (!newPassword.matches(passwordRegex)) {
                req.setAttribute("findResult", new Result(false, "비밀번호 정책 위반", "비밀번호는 8-16자의 영문 대소문자, 숫자, 특수문자를 포함해야 합니다.", null));
                req.setAttribute("resetToken", sessionResetToken); // 2단계 폼을 유지하기 위해 토큰 다시 전달
                req.getRequestDispatcher("/Findpwd.jsp").forward(req, resp);
                return;
            }

            // 모든 검증 통과 시 비밀번호 업데이트
            Usersdao dao = new Usersdao(req.getServletContext());
            // **중요:** 실제 서비스에서는 newPassword를 **해싱**하여 저장해야 합니다. (예: BCrypt.hashpw(newPassword, BCrypt.gensalt()))
            boolean success = dao.updatePassword(sessionResetToken, newPassword); // 세션 토큰(ID)과 새 비밀번호로 업데이트
            dao.close();

            if (success) {
                session.removeAttribute("resetToken"); // 비밀번호 재설정 성공 시 세션 토큰 제거
                req.setAttribute("findResult", new Result(true, "비밀번호 변경 성공!", "새로운 비밀번호로 변경되었습니다. 로그인 페이지로 이동합니다.", null));
                // 3초 후 로그인 페이지로 자동 이동
                resp.setHeader("Refresh", "3;url=" + req.getContextPath() + "/login"); 
            } else {
                req.setAttribute("findResult", new Result(false, "비밀번호 변경 실패", "비밀번호 변경 중 오류가 발생했습니다. 다시 시도해 주세요.", null));
                req.setAttribute("resetToken", sessionResetToken); // 실패 시 2단계 폼 유지
            }
            req.getRequestDispatcher("/Findpwd.jsp").forward(req, resp);

        } 
        // 1단계: 사용자 정보 확인 (resetToken이 없을 때)
        else { 
            String id = req.getParameter("id");
            String name = req.getParameter("name");
            String email = req.getParameter("email");

            // 필수 입력값 검사
            if (id == null || id.isEmpty() || name == null || name.isEmpty() || email == null || email.isEmpty()) {
                req.setAttribute("findResult", new Result(false, "입력 오류", "아이디, 이름, 이메일은 필수 입력 사항입니다.", null));
                req.getRequestDispatcher("/Findpwd.jsp").forward(req, resp);
                return;
            }

            Usersdao dao = new Usersdao(req.getServletContext());
            boolean userExists = dao.verifyPassword(id, name, email); // DAO 메소드 호출
            dao.close(); // DAO 리소스 닫기

            if (userExists) {
                // 사용자 정보가 확인되면, 비밀번호 재설정을 위한 토큰(여기서는 아이디)을 세션에 저장
                // **보안 강화 필요**: 실제 서비스에서는 UUID.randomUUID().toString() 등으로 안전한 토큰 생성 후 DB에 저장하고, 해당 토큰을 사용해야 합니다.
                session.setAttribute("resetToken", id); // 사용자 ID를 임시 토큰으로 사용
                
                req.setAttribute("findResult", new Result(true, "정보 확인 성공!", "새로운 비밀번호를 설정해 주세요.", null));
                req.setAttribute("resetToken", id); // JSP에서 2단계 폼으로 전환하도록 resetToken 전달
            } else {
                // 사용자 정보가 일치하지 않는 경우
                session.removeAttribute("resetToken"); // 기존 토큰이 있다면 제거
                req.setAttribute("findResult", new Result(false, "정보 확인 실패", "입력하신 아이디, 이름, 이메일과 일치하는 계정을 찾을 수 없습니다.", null));
            }
            req.getRequestDispatcher("/Findpwd.jsp").forward(req, resp);
        }
    }
}
