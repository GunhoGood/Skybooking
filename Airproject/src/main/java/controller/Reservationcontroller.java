package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/reservation")
public class Reservationcontroller extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		System.out.println(">> reservation 서블릿 도착");

		req.setAttribute("flightId", req.getParameter("flightId"));
		req.setAttribute("type", req.getParameter("type"));
		req.setAttribute("passengerCount", req.getParameter("passengerCount"));

		// 경로를 루트 기준으로 정확히 지정
		req.getRequestDispatcher("/Reservation.jsp").forward(req, resp);
	}
}
