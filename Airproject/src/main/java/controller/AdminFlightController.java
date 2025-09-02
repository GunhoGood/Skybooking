package controller;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.FlightDAO;
import dao.Seatdao;
import dto.FlightDTO;
import dto.Users;

@WebServlet("/AdminFlight")
public class AdminFlightController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		
		// 관리자 권한 체크
		if (!isAdmin(request, response)) {
			return;
		}
		
		FlightDAO flightDAO = new FlightDAO(getServletContext());
		
		try {
			// 항공편 목록 조회
			ArrayList<FlightDTO> flightList = flightDAO.getAllFlights();
			request.setAttribute("flightList", flightList);
			
			// JSP로 포워딩
			request.getRequestDispatcher("/adminflight.jsp").forward(request, response);
			
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "항공편 목록을 불러오는 중 오류가 발생했습니다.");
			request.getRequestDispatcher("/adminflight.jsp").forward(request, response);
		} finally {
			flightDAO.close();
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		
		// 관리자 권한 체크
		if (!isAdmin(request, response)) {
			return;
		}
		
		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");
		
		try {
			switch (action) {
				case "insert":
					insertFlight(request, response);
					break;
				case "update":
					updateFlight(request, response);
					break;
				case "delete":
					deleteFlight(request, response);
					break;
				default:
					response.sendRedirect("AdminFlight");
					break;
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "작업 처리 중 오류가 발생했습니다: " + e.getMessage());
			doGet(request, response);
		}
	}
	
	private void insertFlight(HttpServletRequest request, HttpServletResponse response) 
			throws Exception {
		
		// 파라미터 받기
		String flightId = request.getParameter("flightId");
		String airline = request.getParameter("airline");
		String departureCity = request.getParameter("departureCity");
		String arrivalCity = request.getParameter("arrivalCity");
		String departureTime = request.getParameter("departureTime");
		String arrivalTime = request.getParameter("arrivalTime");
		String flightDate = request.getParameter("flightDate");
		
		// 유효성 검증
		if (flightId == null || flightId.trim().isEmpty() ||
			airline == null || airline.trim().isEmpty() ||
			departureCity == null || departureCity.trim().isEmpty() ||
			arrivalCity == null || arrivalCity.trim().isEmpty() ||
			departureTime == null || arrivalTime == null ||
			flightDate == null) {
			
			request.setAttribute("error", "모든 필수 항목을 입력해주세요.");
			doGet(request, response);
			return;
		}
		
		// 출발지와 도착지가 같은지 확인
		if (departureCity.equals(arrivalCity)) {
			request.setAttribute("error", "출발지와 도착지는 같을 수 없습니다.");
			doGet(request, response);
			return;
		}
		
		FlightDAO flightDAO = new FlightDAO(getServletContext());
		Seatdao seatDAO = new Seatdao(getServletContext());
		
		try {
			// 중복 항공편 ID 체크
			if (flightDAO.isFlightIdExists(flightId.trim().toUpperCase())) {
				request.setAttribute("error", "이미 존재하는 항공편 번호입니다.");
				doGet(request, response);
				return;
			}
			
			// 시간 형식 검증
			if (!isValidTimeFormat(departureTime) || !isValidTimeFormat(arrivalTime)) {
				request.setAttribute("error", "올바른 시간 형식을 입력해주세요.");
				doGet(request, response);
				return;
			}
			
			// 시간 순서 체크 (간단한 문자열 비교)
			if (departureTime.compareTo(arrivalTime) >= 0) {
				request.setAttribute("error", "도착시간은 출발시간보다 늦어야 합니다.");
				doGet(request, response);
				return;
			}
			
			// FlightDTO 객체 생성
			FlightDTO flight = new FlightDTO();
			flight.setFlightId(flightId.trim().toUpperCase());
			flight.setAirline(airline);
			flight.setDepartureCity(departureCity);
			flight.setArrivalCity(arrivalCity);
			flight.setDepartureTime(departureTime + ":00");
			flight.setArrivalTime(arrivalTime + ":00");
			flight.setFlightDate(flightDate);
			flight.setAvailableSeats(20);
			
			// 항공편 추가
			int result = flightDAO.insertFlight(flight);
			
			if (result > 0) {
				// 좌석 자동 생성
				boolean seatResult = createSeatsForFlight(seatDAO, flightId.trim().toUpperCase());
				
				if (seatResult) {
					request.setAttribute("message", "항공편과 좌석이 성공적으로 추가되었습니다.");
				} else {
					request.setAttribute("message", "항공편은 추가되었지만 좌석 생성에 실패했습니다.");
				}
			} else {
				request.setAttribute("error", "항공편 추가에 실패했습니다.");
			}
			
		} catch (Exception e) {
			request.setAttribute("error", "항공편 추가 중 오류가 발생했습니다: " + e.getMessage());
			e.printStackTrace();
		} finally {
			flightDAO.close();
			seatDAO.close();
		}
		
		doGet(request, response);
	}
	
	private void updateFlight(HttpServletRequest request, HttpServletResponse response) 
			throws Exception {
		
		// 파라미터 받기
		String flightId = request.getParameter("flightId");
		String airline = request.getParameter("airline");
		String departureCity = request.getParameter("departureCity");
		String arrivalCity = request.getParameter("arrivalCity");
		String departureTime = request.getParameter("departureTime");
		String arrivalTime = request.getParameter("arrivalTime");
		String flightDate = request.getParameter("flightDate");
		
		System.out.println("=== 항공편 수정 요청 ===");
		System.out.println("Flight ID: " + flightId);
		System.out.println("Airline: " + airline);
		System.out.println("Departure: " + departureCity + " -> " + arrivalCity);
		System.out.println("Time: " + departureTime + " -> " + arrivalTime);
		System.out.println("Date: " + flightDate);
		
		// 유효성 검증
		if (flightId == null || flightId.trim().isEmpty()) {
			request.setAttribute("error", "항공편 번호가 없습니다.");
			doGet(request, response);
			return;
		}
		
		if (airline == null || airline.trim().isEmpty() ||
			departureCity == null || departureCity.trim().isEmpty() ||
			arrivalCity == null || arrivalCity.trim().isEmpty() ||
			departureTime == null || departureTime.trim().isEmpty() ||
			arrivalTime == null || arrivalTime.trim().isEmpty() ||
			flightDate == null || flightDate.trim().isEmpty()) {
			
			request.setAttribute("error", "모든 필수 항목을 입력해주세요.");
			doGet(request, response);
			return;
		}
		
		// 출발지와 도착지가 같은지 확인
		if (departureCity.equals(arrivalCity)) {
			request.setAttribute("error", "출발지와 도착지는 같을 수 없습니다.");
			doGet(request, response);
			return;
		}
		
		// 시간 형식 검증
		if (!isValidTimeFormat(departureTime) || !isValidTimeFormat(arrivalTime)) {
			System.out.println("시간 형식 검증 실패:");
			System.out.println("출발시간: '" + departureTime + "'");
			System.out.println("도착시간: '" + arrivalTime + "'");
			request.setAttribute("error", "올바른 시간 형식을 입력해주세요. 현재 입력: 출발(" + departureTime + "), 도착(" + arrivalTime + ")");
			doGet(request, response);
			return;
		}
		
		// 시간 순서 체크
		if (departureTime.compareTo(arrivalTime) >= 0) {
			request.setAttribute("error", "도착시간은 출발시간보다 늦어야 합니다.");
			doGet(request, response);
			return;
		}
		
		FlightDAO flightDAO = new FlightDAO(getServletContext());
		
		try {
			// 기존 항공편 정보 가져오기 (존재하는지 확인)
			FlightDTO existingFlight = flightDAO.getFlightById(flightId);
			if (existingFlight == null) {
				request.setAttribute("error", "존재하지 않는 항공편입니다.");
				doGet(request, response);
				return;
			}
			
			System.out.println("기존 항공편 찾음: " + existingFlight.getFlightId());
			
			// FlightDTO 객체 생성 (기본 정보만 설정)
			FlightDTO flight = new FlightDTO();
			flight.setFlightId(flightId.trim());
			flight.setAirline(airline.trim());
			flight.setDepartureCity(departureCity.trim());
			flight.setArrivalCity(arrivalCity.trim());
			
			// 시간 형식 처리 (:00 추가)
			String formattedDepartureTime = formatTimeForDB(departureTime);
			String formattedArrivalTime = formatTimeForDB(arrivalTime);
				
			flight.setDepartureTime(formattedDepartureTime);
			flight.setArrivalTime(formattedArrivalTime);
			flight.setFlightDate(flightDate.trim());
			
			System.out.println("수정할 데이터 준비 완료");
			
			// 항공편 수정 (available_seats는 기존 값 유지)
			int result = flightDAO.updateFlight(flight);
			
			System.out.println("수정 결과: " + result);
			
			if (result > 0) {
				request.setAttribute("message", "항공편이 성공적으로 수정되었습니다.");
				System.out.println("수정 성공!");
			} else {
				request.setAttribute("error", "항공편 수정에 실패했습니다. 데이터베이스에서 업데이트되지 않았습니다.");
				System.out.println("수정 실패: 업데이트된 행이 없음");
			}
			
		} catch (Exception e) {
			String errorMsg = "항공편 수정 중 오류가 발생했습니다: " + e.getMessage();
			request.setAttribute("error", errorMsg);
			System.out.println("수정 중 예외 발생: " + errorMsg);
			e.printStackTrace();
		} finally {
			flightDAO.close();
		}
		
		doGet(request, response);
	}
	
	private void deleteFlight(HttpServletRequest request, HttpServletResponse response) 
			throws Exception {
		
		String flightId = request.getParameter("flightId");
		
		if (flightId == null || flightId.trim().isEmpty()) {
			request.setAttribute("error", "항공편 번호가 없습니다.");
			doGet(request, response);
			return;
		}
		
		FlightDAO flightDAO = new FlightDAO(getServletContext());
		Seatdao seatDAO = new Seatdao(getServletContext());
		
		try {
			System.out.println("항공편 삭제 시작: " + flightId);
			
			
			
			// 좌석 먼저 삭제
			seatDAO.deleteSeatsByFlightId(flightId);
			System.out.println("좌석 삭제 완료");
			
			// 항공편 삭제
			int result = flightDAO.deleteFlight(flightId);
			
			if (result > 0) {
				request.setAttribute("message", "항공편이 성공적으로 삭제되었습니다.");
				System.out.println("항공편 삭제 성공");
			} else {
				request.setAttribute("error", "항공편 삭제에 실패했습니다.");
				System.out.println("항공편 삭제 실패");
			}
			
		} catch (Exception e) {
			request.setAttribute("error", "항공편 삭제 중 오류가 발생했습니다: " + e.getMessage());
			System.out.println("삭제 중 예외 발생: " + e.getMessage());
			e.printStackTrace();
		} finally {
			flightDAO.close();
			seatDAO.close();
		}
		
		doGet(request, response);
	}
	
	/**
	 * 항공편용 좌석 생성 (20개)
	 */
	private boolean createSeatsForFlight(Seatdao seatDAO, String flightId) {
		try {
			// First Class (A1-A4) - 50만원
			for (int i = 1; i <= 4; i++) {
				seatDAO.insertSeat("A" + i, "First", flightId, 500000.00);
			}
			
			// Business Class (B1-B8) - 30만원
			for (int i = 1; i <= 8; i++) {
				seatDAO.insertSeat("B" + i, "Business", flightId, 300000.00);
			}
			
			// Economy Class (C1-C8) - 15만원
			for (int i = 1; i <= 8; i++) {
				seatDAO.insertSeat("C" + i, "Economy", flightId, 150000.00);
			}
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 시간 형식을 데이터베이스용으로 변환 (HH:mm:ss)
	 */
	private String formatTimeForDB(String time) {
		if (time == null || time.trim().isEmpty()) {
			return time;
		}
		
		time = time.trim();
		String[] parts = time.split(":");
		
		if (parts.length == 2) {
			// HH:mm -> HH:mm:ss
			return time + ":00";
		} else if (parts.length == 3) {
			// 이미 HH:mm:ss 형식
			return time;
		} else {
			// 잘못된 형식이지만 그대로 반환
			return time;
		}
	}
	
	/**
	 * 시간 형식 검증 (HH:mm 또는 HH:mm:ss)
	 */
	private boolean isValidTimeFormat(String time) {
		if (time == null || time.trim().isEmpty()) {
			System.out.println("시간이 null이거나 비어있음: " + time);
			return false;
		}
		
		time = time.trim();
		System.out.println("검증할 시간: '" + time + "', 길이: " + time.length());
		
		try {
			String[] parts = time.split(":");
			
			// HH:mm 또는 HH:mm:ss 형식 허용
			if (parts.length < 2 || parts.length > 3) {
				System.out.println("콜론으로 분리된 부분이 잘못됨: " + parts.length);
				return false;
			}
			
			int hour = Integer.parseInt(parts[0]);
			int minute = Integer.parseInt(parts[1]);
			
			// 초는 있어도 되고 없어도 됨
			int second = 0;
			if (parts.length == 3) {
				second = Integer.parseInt(parts[2]);
			}
			
			boolean valid = hour >= 0 && hour <= 23 && 
							minute >= 0 && minute <= 59 && 
							second >= 0 && second <= 59;
			
			System.out.println("시간 검증 결과: " + hour + ":" + minute + 
							  (parts.length == 3 ? ":" + second : "") + " = " + valid);
			
			return valid;
		} catch (NumberFormatException e) {
			System.out.println("숫자 형식 오류: " + e.getMessage());
			return false;
		}
	}
	
	/**
	 * 관리자 권한 체크
	 */
	private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("id");
		Users loginUser = (Users) session.getAttribute("user");
		
		if (userId == null || loginUser == null || loginUser.getAdmin() != 1) {
			response.sendRedirect("main");
			return false;
		}
		
		return true;
	}
}