package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/payment")
public class Paymentcontroller extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 예시: 전달된 항공편 결제 관련 데이터 꺼내기
		String flightNo = request.getParameter("flightNo");
		String seatNo = request.getParameter("seatNo");
		String price = request.getParameter("price");

		// 결제 처리 로직 또는 페이지 이동
		request.setAttribute("flightNo", flightNo);
		request.setAttribute("seatNo", seatNo);
		request.setAttribute("price", price);

		// 결제 페이지로 포워딩
		request.getRequestDispatcher("/Payment.jsp").forward(request, response);
	}
}
