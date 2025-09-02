package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.FlightDAO;
import dao.Seatdao;
import dto.FlightDTO;
import dto.Seatdto;

@WebServlet("/reserveseat")
public class Reserveseatcontroller extends HttpServlet {
	
	@Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println(">> reserveseat POST 컨트롤러 도착");

        String flightId = req.getParameter("flightId");
        String[] seatNumbers = req.getParameterValues("seatNumbers");
        String passengerCountStr = req.getParameter("passengerCount");
        String type = req.getParameter("type");

        int totalPrice = 0;
        List<Seatdto> selectedSeats = new ArrayList<>();

        if (seatNumbers != null && flightId != null) {
            Seatdao seatDao = new Seatdao(getServletContext());
            for (String seatNumber : seatNumbers) {
                Seatdto seat = seatDao.selectBySeatNumberAndFlight(flightId, seatNumber);
                if (seat != null) {
                    selectedSeats.add(seat);
                    totalPrice += seat.getPrice() > 0 ? (int) seat.getPrice() : 100000;
                }
            }
            seatDao.close();
        }

        FlightDAO flightDao = new FlightDAO(getServletContext());
        FlightDTO flight = flightDao.getFlightById(flightId);
        flightDao.close();

        // JSP에 넘길 데이터 설정
        req.setAttribute("flight", flight);
        req.setAttribute("selectedSeats", selectedSeats);
        req.setAttribute("totalPrice", totalPrice);
        req.setAttribute("passengerCount", passengerCountStr);
        req.setAttribute("type", type);

        req.getRequestDispatcher("/Reserveseat.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println(">> reserveseat 컨트롤러 도착");
        req.getRequestDispatcher("/Reserveseat.jsp").forward(req, resp);
    }
}
