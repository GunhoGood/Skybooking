package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.ReservationDao;
import dao.Usersdao;
import dto.ReservationDto;
import dto.Users;
import util.JSFunction;

@WebServlet("/mypage")
public class Mypagecontroller extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    HttpSession session = req.getSession();
	    String userId = (String) session.getAttribute("id");

	    if (userId == null) {
	        JSFunction.alertLocation("잘못된 접근입니다.", "main", resp);
	        return;
	    }

	    int page = 1;
	    int limit = 5;

	    String pageParam = req.getParameter("page");
	    if (pageParam != null && !pageParam.isEmpty()) {
	        try {
	            page = Integer.parseInt(pageParam);
	        } catch (NumberFormatException e) {
	            page = 1;
	        }
	    }

	    int offset = (page - 1) * limit;

	    ReservationDao rdao = new ReservationDao(getServletContext());
	    int totalCount = rdao.getReservationCountByUser(userId);
	    List<ReservationDto> reservations = rdao.getReservationsByUserPaging(userId, offset, limit);
	    int totalPage = (int) Math.ceil((double) totalCount / limit);

	    req.setAttribute("reservations", reservations);
	    req.setAttribute("currentPage", page);
	    req.setAttribute("totalPage", totalPage);

	    req.getRequestDispatcher("/mypage.jsp").forward(req, resp);
	}
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String id = (String) session.getAttribute("id");

		if (id == null) {
			JSFunction.alertLocation("로그인이 필요합니다.", "main", resp);
			return;
		}

		// 어떤 종류의 요청인지 hidden input 필드(actionType)로 구분
		String actionType = req.getParameter("actionType");

		if (actionType == null || actionType.isEmpty()) {
			// actionType이 없는 경우, 기본 처리 (예: 잘못된 요청으로 간주)
			JSFunction.alertBack("잘못된 요청입니다.", resp);
			return;
		}

		Usersdao dao = new Usersdao(req.getServletContext());
		Users selectU = dao.select(id); // 현재 사용자 정보 (패스워드 비교를 위해 필요)

		if (selectU == null) {
			JSFunction.alertLocation("사용자 정보를 찾을 수 없습니다. 다시 로그인해주세요.", "main", resp);
			return;
		}

		switch (actionType) {
			case "updateProfile":
				// --- 회원 정보 수정 로직 ---
				String name = req.getParameter("name");
				String email = req.getParameter("email");
				String phone = req.getParameter("phone");
				String address = req.getParameter("address");
				String birthStr = req.getParameter("birth");
				String gender = req.getParameter("gender");

				// 이메일 유효성 검사
				if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
					JSFunction.alertBack("올바른 이메일 형식을 입력하세요.", resp);
					return;
				}

				// 휴대폰 번호 유효성 검사 (11자리 숫자)
				if (phone == null || !phone.matches("^\\d{11}$")) {
					JSFunction.alertBack("휴대폰 번호는 11자리 숫자만 입력 가능합니다.", resp);
					return;
				}

				java.sql.Date birth = null;
				if (birthStr != null && !birthStr.isEmpty()) {
					birth = java.sql.Date.valueOf(birthStr);
				}

				Users update = new Users(email, name, phone, address, birth, gender);
				update.setId(id); // ID는 세션에서 가져온 현재 사용자 ID로 설정

				int res = dao.update(update); // DB 업데이트

				if(res == 1) {
					// 세션의 사용자 정보도 업데이트
					// 로그인 시 Users 객체를 세션에 저장했다고 가정
					// (현재 JSP에서 sessionScope.user를 사용하므로 이 부분이 중요)
					session.setAttribute("user", update);
					JSFunction.alertLocation("회원 정보 수정 완료하였습니다!", "mypage", resp);
				} else {
					JSFunction.alertBack("회원 정보 수정에 실패하셨습니다. 잠시 후 다시 시도해주세요.", resp);
				}
				break;

			case "changePassword":
				// --- 비밀번호 변경 로직 ---
				String pwd = req.getParameter("pwd");
				String nPwd = req.getParameter("nPwd");
				String cnPwd = req.getParameter("cnPwd");

				// 1. 현재 비밀번호 일치 여부 확인
				// 실제 애플리케이션에서는 암호화된 비밀번호를 비교해야 합니다.
				// 예를 들어, DAO에서 selectUserByIdAndPassword(id, currentPassword) 같은 메서드를 사용하거나
				// Users 객체에 암호화된 비밀번호가 있다면 PasswordEncoder 등을 사용해야 합니다.
				if (selectU.getPwd() == null || !selectU.getPwd().equals(pwd)) { // getPass()는 Users DTO의 비밀번호 필드라고 가정
					JSFunction.alertBack("현재 비밀번호가 올바르지 않습니다.", resp);
					return;
				}

				// 2. 새 비밀번호 유효성 검사 (길이, 특수문자 등 추가 가능)
				if (nPwd == null || nPwd.length() < 8) { // 최소 길이 예시
					JSFunction.alertBack("새 비밀번호는 8자 이상이어야 합니다.", resp);
					return;
				}
				if (nPwd == null || !nPwd.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,20}$")) {
			        JSFunction.alertBack("비밀번호는 8~16자 영문 대소문자, 숫자, 특수문자를 포함해야 합니다.", resp);
			        return;
			    }
				if (!nPwd.equals(cnPwd)) {
					JSFunction.alertBack("새 비밀번호와 확인 비밀번호가 일치하지 않습니다.", resp);
					return;
				}

				// 3. 비밀번호 업데이트
				// Users 객체에 새 비밀번호 설정 (실제로는 암호화하여 저장)
				Users userToUpdatePassword = new Users();
				userToUpdatePassword.setId(id);
				userToUpdatePassword.setPwd(nPwd); // 실제로는 암호화된 비밀번호를 setPass() 해야 함
				int passwordUpdateRes = dao.updatePwd(userToUpdatePassword); // DAO에 updatePwd 메서드 추가 필요

				if (passwordUpdateRes == 1) {
					JSFunction.alertLocation("비밀번호 변경 완료하였습니다! 보안을 위해 재로그인 해주세요.", "logout", resp); // 비밀번호 변경 후 로그아웃 권장
					// 또는, 단순히 성공 메시지 후 마이페이지 유지: JSFunction.alertLocation("비밀번호 변경 완료하였습니다!", "mypage", resp);
				} else {
					JSFunction.alertBack("비밀번호 변경에 실패하였습니다. 잠시 후 다시 시도해주세요.", resp);
				}
				break;

			case "withdraw":
				// --- 회원 탈퇴 로직 ---
				// 실제 탈퇴 전 비밀번호 재확인 등의 절차가 필요할 수 있습니다.
				int deleteRes = dao.delete(id); // DAO에 deleteUser 메서드 추가 필요

				if (deleteRes == 1) {
					session.invalidate(); // 세션 무효화 (로그아웃 처리)
					JSFunction.alertLocation("회원 탈퇴가 완료되었습니다. 그동안 이용해주셔서 감사합니다.", "main", resp);
				} else {
					JSFunction.alertBack("회원 탈퇴에 실패하였습니다. 관리자에게 문의해주세요.", resp);
				}
				break;

			default:
				// 알 수 없는 actionType 처리
				JSFunction.alertBack("알 수 없는 요청입니다.", resp);
				break;
		}
	}
}
