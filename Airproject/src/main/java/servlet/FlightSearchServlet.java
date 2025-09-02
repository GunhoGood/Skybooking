package servlet;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.FlightDAO;
import dto.FlightDTO;
import dto.SearchCriteria;  // ← 추가된 import
import util.JSFunction;

@WebServlet("/flight/search")
public class FlightSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    	HttpSession session = request.getSession();
	    String userId = (String) session.getAttribute("id");

	    if (userId == null) {
	        JSFunction.alertBack("로그인 후 이용해주세요.", response);
	        return;
	    }
    	
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        // 검색 조건 받기
        String departureCity = request.getParameter("departureCity");
        String arrivalCity = request.getParameter("arrivalCity");
        String departureDate = request.getParameter("departureDate");
        String returnDate = request.getParameter("returnDate");
        String tripType = request.getParameter("tripType");
        String seatClass = request.getParameter("seatClass");
        String passengersParam = request.getParameter("passengers");
        
        // 승객 정보 파싱 (예: "2-1-0" → 성인2명, 소아1명, 유아0명)
        String[] passengerInfo = passengersParam.split("-");
        int adults = Integer.parseInt(passengerInfo[0]);
        int children = Integer.parseInt(passengerInfo[1]);
        int infants = Integer.parseInt(passengerInfo[2]);
        int totalPassengers = adults + children + infants;
        
        // 유효성 검사
        if (departureCity == null || arrivalCity == null || departureDate == null ||
            departureCity.trim().isEmpty() || arrivalCity.trim().isEmpty() || departureDate.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "출발지, 도착지, 출발일을 모두 입력해주세요.");
            request.getRequestDispatcher("/Main.jsp").forward(request, response);
            return;
        }
        
        // 출발지와 도착지가 같은지 확인
        if (departureCity.equals(arrivalCity)) {
            request.setAttribute("errorMessage", "출발지와 도착지가 같을 수 없습니다.");
            request.getRequestDispatcher("/Main.jsp").forward(request, response);
            return;
        }
        
        try {
            System.out.println("=== 디버깅 시작 ===");
            System.out.println("검색 조건: " + departureCity + " -> " + arrivalCity + " (" + departureDate + ")");
            
            FlightDAO flightDAO = new FlightDAO(getServletContext());
            System.out.println("FlightDAO 생성 완료");
            
            // 가는 편 항공편 검색
            ArrayList<FlightDTO> outboundFlights = flightDAO.searchFlights(
                departureCity, arrivalCity, departureDate
            );
            System.out.println("검색 결과: " + outboundFlights.size() + "개 항공편 발견");
            
            for (FlightDTO flight : outboundFlights) {
                System.out.println("- " + flight.getAirline() + " " + flight.getFlightId());
            }
            
            ArrayList<FlightDTO> returnFlights = new ArrayList<>();
            
            // 왕복의 경우 돌아오는 편도 검색
            if ("round".equals(tripType) && returnDate != null && !returnDate.trim().isEmpty()) {
                returnFlights = flightDAO.searchFlights(
                    arrivalCity, departureCity, returnDate
                );
            }
            
            flightDAO.close();
            
            // 검색 결과 및 조건을 request에 저장
            request.setAttribute("outboundFlights", outboundFlights);
            request.setAttribute("returnFlights", returnFlights);
            request.setAttribute("tripType", tripType);
            
            // 검색 조건 정보
            SearchCriteria searchCriteria = new SearchCriteria();
            searchCriteria.setDepartureCity(departureCity);
            searchCriteria.setArrivalCity(arrivalCity);
            searchCriteria.setDepartureDate(departureDate);
            searchCriteria.setReturnDate(returnDate != null ? returnDate : "");
            searchCriteria.setSeatClass(seatClass);
            searchCriteria.setTotalPassengers(totalPassengers);
            searchCriteria.setAdults(adults);
            searchCriteria.setChildren(children);
            searchCriteria.setInfants(infants);
            
            request.setAttribute("searchCriteria", searchCriteria);
            
            // 검색 결과가 없는 경우 메시지 설정
            if (outboundFlights.isEmpty()) {
                request.setAttribute("noFlightsMessage", "검색 조건에 맞는 항공편이 없습니다.");
            }
            
            if ("round".equals(tripType) && returnFlights.isEmpty() && returnDate != null && !returnDate.trim().isEmpty()) {
                request.setAttribute("noReturnFlightsMessage", "검색 조건에 맞는 돌아오는 편이 없습니다.");
            }
            
            // 검색 결과 페이지로 포워딩
            request.getRequestDispatcher("/FlightResults.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("=== 오류 발생 ===");
            System.out.println("오류 메시지: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "항공편 검색 중 오류가 발생했습니다. 다시 시도해주세요.");
            request.getRequestDispatcher("/Main.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // GET 요청은 메인페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/Main.jsp");
    }
}

