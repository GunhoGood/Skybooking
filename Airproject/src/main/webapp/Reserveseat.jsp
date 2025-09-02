<%@page import="dto.Seatdto"%>
<%@page import="dto.ReservationDto"%>
<%@page import="dao.ReservationDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.Seatdao"%>
<%@ page import="dao.FlightDAO"%>
<%@ page import="dto.FlightDTO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 결과 - SkyBooking</title>
<link rel="icon" type="image/png"
	href="${pageContext.request.contextPath}/img/fabicon.png">
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Arial', sans-serif;
	background-color: #f5f5f5;
	line-height: 1.6;
}

.result-container {
	max-width: 800px;
	margin: 50px auto;
	background: white;
	padding: 40px;
	border-radius: 10px;
	box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
	text-align: center;
}

.result-header {
	margin-bottom: 30px;
}

.result-header h2 {
	color: #2563eb;
	margin-bottom: 10px;
	font-size: 28px;
	font-weight: bold;
}

.result-icon {
	font-size: 80px;
	margin-bottom: 20px;
	display: block;
}

.success-icon {
	color: #4CAF50;
}

.error-icon {
	color: #f44336;
}

.warning-icon {
	color: #ff9800;
}

.result-message {
	background: linear-gradient(135deg, #f8f9ff 0%, #e3f2fd 100%);
	border-radius: 10px;
	padding: 30px;
	margin-bottom: 30px;
	position: relative;
	overflow: hidden;
}

.result-message::before {
	content: '✈️';
	position: absolute;
	top: 15px;
	right: 20px;
	font-size: 24px;
	opacity: 0.3;
}

.success-message {
	border-left: 5px solid #4CAF50;
	background: linear-gradient(135deg, #f1f8e9 0%, #e8f5e8 100%);
}

.error-message {
	border-left: 5px solid #f44336;
	background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
}

.warning-message {
	border-left: 5px solid #ff9800;
	background: linear-gradient(135deg, #fff8e1 0%, #ffecb3 100%);
}

.message-text {
	font-size: 18px;
	font-weight: 500;
	color: #333;
	margin-bottom: 15px;
}

.flight-info {
	background: linear-gradient(135deg, #e3f2fd, #bbdefb);
	padding: 20px;
	border-radius: 10px;
	margin-bottom: 20px;
	border-left: 5px solid #2563eb;
}

.flight-info h3 {
	color: #1565c0;
	margin-bottom: 15px;
	font-size: 18px;
}

.flight-details-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
	gap: 15px;
}

.flight-detail-item {
	background: white;
	padding: 12px 15px;
	border-radius: 8px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.detail-label {
	font-size: 12px;
	color: #666;
	margin-bottom: 3px;
	text-transform: uppercase;
}

.detail-value {
	font-weight: bold;
	color: #2563eb;
	font-size: 14px;
}

.seat-info {
	background: white;
	padding: 20px;
	border-radius: 8px;
	margin-top: 15px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.seat-info h4 {
	color: #2563eb;
	margin-bottom: 15px;
	font-size: 16px;
}

.seat-list {
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	gap: 10px;
	margin-top: 10px;
}

.seat-item {
	background: #2563eb;
	color: white;
	padding: 8px 15px;
	border-radius: 20px;
	font-weight: bold;
	font-size: 14px;
	display: flex;
	flex-direction: column;
	align-items: center;
	min-width: 80px;
}

.seat-item-number {
	font-size: 16px;
	margin-bottom: 2px;
}

.seat-item-price {
	font-size: 11px;
	opacity: 0.9;
}

.success-seat {
	background: #4CAF50;
}

.error-seat {
	background: #f44336;
}

.booking-summary {
	background: linear-gradient(135deg, #e8f5e8, #c8e6c8);
	padding: 20px;
	border-radius: 10px;
	margin-bottom: 20px;
	border-left: 5px solid #4CAF50;
}

.booking-summary h3 {
	color: #2e7d32;
	margin-bottom: 15px;
	font-size: 20px;
}

.summary-item {
	display: flex;
	justify-content: space-between;
	margin-bottom: 8px;
	font-size: 16px;
}

.summary-label {
	font-weight: 500;
	color: #388e3c;
}

.summary-value {
	font-weight: bold;
	color: #1b5e20;
}

.total-price {
	border-top: 2px solid #4CAF50;
	padding-top: 10px;
	margin-top: 10px;
	font-size: 18px;
}

.total-price .summary-label {
	font-size: 18px;
	color: #2e7d32;
}

.total-price .summary-value {
	font-size: 20px;
	color: #1b5e20;
}

.button-container {
	display: flex;
	justify-content: center;
	gap: 20px;
	margin-top: 30px;
	flex-wrap: wrap;
}

.btn {
	padding: 15px 30px;
	font-size: 16px;
	font-weight: bold;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-block;
	min-width: 150px;
}

.btn-primary {
	background: linear-gradient(135deg, #2563eb, #1e40af);
	color: white;
	box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
}

.btn-primary:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
	background: linear-gradient(135deg, #1e40af, #1e3a8a);
}

.btn-secondary {
	background: #6c757d;
	color: white;
	box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
}

.btn-secondary:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
	background: #5a6268;
}

.btn-success {
	background: linear-gradient(135deg, #28a745, #20c997);
	color: white;
	box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
}

.btn-success:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
	background: linear-gradient(135deg, #20c997, #17a2b8);
}

/* 결제 정보 전달을 위한 숨김 폼 */
.payment-form {
	display: none;
}

@media ( max-width : 768px) {
	.result-container {
		margin: 20px;
		padding: 20px;
	}
	.result-icon {
		font-size: 60px;
	}
	.message-text {
		font-size: 16px;
	}
	.button-container {
		flex-direction: column;
		align-items: center;
	}
	.btn {
		width: 100%;
		margin-bottom: 10px;
	}
	.seat-list {
		gap: 8px;
	}
	.seat-item {
		font-size: 12px;
		padding: 6px 12px;
		min-width: 70px;
	}
	.flight-details-grid {
		grid-template-columns: 1fr;
	}
}
</style>
</head>
<body>
	<%@ include file="Navi.jsp"%>

	<div class="result-container">
		<div class="result-header">
			<h2>예약 결과</h2>
		</div>

		<%
		// 파라미터 받기
		String[] seatNumbers = request.getParameterValues("seatNumbers");
		String singleSeat = request.getParameter("seatNumber");
		String flightId = request.getParameter("flightId");
		String passengerCountParam = request.getParameter("passengerCount");
		String type = request.getParameter("type");

		// 단일 좌석 처리 (기존 호환성)
		if (seatNumbers == null && singleSeat != null && !singleSeat.isEmpty()) {
			seatNumbers = new String[]{singleSeat};
		}

		int passengerCount = 1;
		if (passengerCountParam != null && !passengerCountParam.isEmpty()) {
			try {
				passengerCount = Integer.parseInt(passengerCountParam);
			} catch (NumberFormatException e) {
				passengerCount = 1;
			}
		}

		// 항공편 정보 조회
		FlightDTO flight = null;
		if (flightId != null && !flightId.trim().isEmpty()) {
			FlightDAO flightDAO = new FlightDAO(application);
			flight = flightDAO.getFlightById(flightId);
			flightDAO.close();
		}

		// 변수 선언을 페이지 상단으로 이동
		int successCount = 0;
		int errorCount = 0;
		java.util.List<String> successSeats = new java.util.ArrayList<>();
		java.util.List<String> errorSeats = new java.util.ArrayList<>();
		java.util.Map<String, Double> seatPrices = new java.util.HashMap<>();
		java.util.Map<String, String> seatClasses = new java.util.HashMap<>();
		double totalPrice = 0;

		if (seatNumbers != null && seatNumbers.length > 0) {
			Seatdao seatDAO = new Seatdao(application);
			FlightDAO flightDAO = new FlightDAO(application);

			// 각 좌석별로 예약 처리
			for (String seat : seatNumbers) {
				if (seat != null && !seat.trim().isEmpty()) {
			// 특정 항공편의 좌석 예약 시도
			int result = seatDAO.reserveFlightSeat(flightId, seat.trim());

			if (result > 0) {
				successCount++;
				successSeats.add(seat.trim());
				double price = seatDAO.getSeatPrice(flightId, seat.trim());
				// 좌석 클래스 정보 가져오기
				Seatdto seatDto = seatDAO.getSeatByFlightAndNumber(flightId, seat.trim());
				String seatClass = seatDto != null ? seatDto.getSeatClass() : "Economy";

				seatPrices.put(seat.trim(), price);
				seatClasses.put(seat.trim(), seatClass);
				totalPrice += price;
			} else {
				errorCount++;
				errorSeats.add(seat.trim());
			}
				}
			}

			// 예약 성공한 경우에만 DB에 저장하고 잔여석 업데이트
			if (successCount > 0) {
				// 예약 내역 DB에 저장
				String userId = (String) session.getAttribute("id");
				if (userId != null) {
			ReservationDao rdao = new ReservationDao(application);

			for (String seat : successSeats) {
				String reservationId = java.util.UUID.randomUUID().toString().substring(0, 18);
				ReservationDto dto = new ReservationDto();
				dto.setReservationId(reservationId);
				dto.setUserId(userId);
				dto.setFlightId(flightId);
				dto.setSeatNumber(seat);
				dto.setTotalPrice((int) seatPrices.get(seat).doubleValue());
				dto.setStatus("결제 대기");
				dto.setReservationDate(java.time.LocalDateTime.now());

				rdao.saveReservation(dto);
			}
			rdao.close();
				}

				// 항공편 잔여석 업데이트
				if (flightId != null && !flightId.trim().isEmpty()) {
			flightDAO.updateAvailableSeats(flightId, -successCount);
				}
			}

			seatDAO.close();
			flightDAO.close();
		}
		%>

		<%
		if (seatNumbers == null || seatNumbers.length == 0) {
		%>
		<div class="result-icon warning-icon">⚠️</div>
		<div class="result-message warning-message">
			<div class="message-text">좌석을 선택하지 않았습니다.</div>
			<p>예약을 진행하려면 좌석을 선택해주세요.</p>
		</div>
		<%
		} else {
		if (successCount > 0 && errorCount == 0) {
			// 모든 좌석 예약 성공
		%>
		<div class="result-icon success-icon">✅</div>
		<div class="result-message success-message">
			<div class="message-text">예약이 성공적으로 완료되었습니다!</div>

			<%
			if (flight != null) {
			%>
			<!-- 항공편 정보 -->
			<div class="flight-info">
				<h3>🛫 예약된 항공편</h3>
				<div class="flight-details-grid">
					<div class="flight-detail-item">
						<div class="detail-label">항공편</div>
						<div class="detail-value"><%=flight.getAirline()%>
							<%=flight.getFlightId()%></div>
					</div>
					<div class="flight-detail-item">
						<div class="detail-label">경로</div>
						<div class="detail-value"><%=flight.getDepartureCity()%>
							→
							<%=flight.getArrivalCity()%></div>
					</div>
					<div class="flight-detail-item">
						<div class="detail-label">출발</div>
						<div class="detail-value"><%=flight.getFlightDate()%>
							<%=flight.getDepartureTime()%></div>
					</div>
					<div class="flight-detail-item">
						<div class="detail-label">도착</div>
						<div class="detail-value"><%=flight.getFlightDate()%>
							<%=flight.getArrivalTime()%></div>
					</div>
				</div>
			</div>
			<%
			}
			%>

			<div class="booking-summary">
				<h3>🎫 예약 요약</h3>
				<div class="summary-item">
					<span class="summary-label">승객 수:</span> <span
						class="summary-value"><%=passengerCount%>명</span>
				</div>
				<div class="summary-item">
					<span class="summary-label">예약된 좌석 수:</span> <span
						class="summary-value"><%=successCount%>개</span>
				</div>
				<div class="summary-item">
					<span class="summary-label">항공료:</span> <span class="summary-value">₩<%=String.format("%,d", (int) totalPrice)%></span>
				</div>
				<div class="summary-item">
					<span class="summary-label">세금 및 수수료:</span> <span
						class="summary-value">₩<%=String.format("%,d", (int) (totalPrice * 0.1))%></span>
				</div>
				<div class="summary-item">
					<span class="summary-label">공항 이용료:</span> <span
						class="summary-value">₩<%=String.format("%,d", 10000 * successCount)%></span>
				</div>
				<div class="summary-item total-price">
					<span class="summary-label">총 결제금액:</span> <span
						class="summary-value">₩<%=String.format("%,d", (int) (totalPrice + totalPrice * 0.1 + 10000 * successCount))%></span>
				</div>
			</div>

			<div class="seat-info">
				<h4>✈️ 예약 완료된 좌석</h4>
				<h6>30분 내로 결제하지 않으면 자동 취소됩니다.</h6>
				<div class="seat-list">
					<%
					for (String seat : successSeats) {
					%>
					<div class="seat-item success-seat">
						<div class="seat-item-number"><%=seat%></div>
						<div class="seat-item-price"><%=seatClasses.get(seat)%></div>
						<%
						if (seatPrices.containsKey(seat)) {
							double seatPrice = seatPrices.get(seat);
							double seatTax = seatPrice * 0.1; // 세금 및 수수료 (10%)
							int airportFee = 10000; // 공항 이용료
							double finalPrice = seatPrice + seatTax + airportFee;
						%>
						<div class="seat-item-price">
							₩<%=String.format("%,d", (int) finalPrice)%></div>
						<%
						}
						%>
					</div>
					<%
					}
					%>
				</div>
			</div>

			<!-- 결제 정보 전달용 폼 -->
			<form id="paymentForm" action="payment" method="post"
				class="payment-form">
				<input type="hidden" name="flightId" value="<%=flightId%>">
				<input type="hidden" name="airline"
					value="<%=flight != null ? flight.getAirline() : ""%>"> <input
					type="hidden" name="departureCity"
					value="<%=flight != null ? flight.getDepartureCity() : ""%>">
				<input type="hidden" name="arrivalCity"
					value="<%=flight != null ? flight.getArrivalCity() : ""%>">
				<input type="hidden" name="flightDate"
					value="<%=flight != null ? flight.getFlightDate() : ""%>">
				<input type="hidden" name="departureTime"
					value="<%=flight != null ? flight.getDepartureTime() : ""%>">
				<input type="hidden" name="arrivalTime"
					value="<%=flight != null ? flight.getArrivalTime() : ""%>">
				<input type="hidden" name="totalPrice"
					value="<%=(int) (totalPrice + totalPrice * 0.1 + 10000 * successCount)%>">
				<input type="hidden" name="basePrice" value="<%=(int) totalPrice%>">
				<input type="hidden" name="taxAndFee"
					value="<%=(int) (totalPrice * 0.1)%>"> <input type="hidden"
					name="airportFee" value="<%=10000 * successCount%>"> <input
					type="hidden" name="successCount" value="<%=successCount%>">
				<%
				// 좌석 정보를 간단한 문자열로 전달
				StringBuilder seatDisplay = new StringBuilder();
				for (int i = 0; i < successSeats.size(); i++) {
					String seat = successSeats.get(i);
					if (i > 0)
						seatDisplay.append(", ");
					seatDisplay.append(seat).append(" (").append(seatClasses.get(seat)).append(")");
				}
				%>
				<input type="hidden" name="seatInfo"
					value="<%=seatDisplay.toString()%>">
			</form>
		</div>
		<%
		} else if (successCount > 0 && errorCount > 0) {
		// 일부 좌석만 예약 성공
		%>
		<div class="result-icon warning-icon">⚠️</div>
		<div class="result-message warning-message">
			<div class="message-text">일부 좌석만 예약되었습니다.</div>

			<%
			if (flight != null) {
			%>
			<!-- 항공편 정보 -->
			<div class="flight-info">
				<h3>🛫 대상 항공편</h3>
				<div class="flight-details-grid">
					<div class="flight-detail-item">
						<div class="detail-label">항공편</div>
						<div class="detail-value"><%=flight.getAirline()%>
							<%=flight.getFlightId()%></div>
					</div>
					<div class="flight-detail-item">
						<div class="detail-label">경로</div>
						<div class="detail-value"><%=flight.getDepartureCity()%>
							→
							<%=flight.getArrivalCity()%></div>
					</div>
					<div class="flight-detail-item">
						<div class="detail-label">출발</div>
						<div class="detail-value"><%=flight.getFlightDate()%>
							<%=flight.getDepartureTime()%></div>
					</div>
				</div>
			</div>
			<%
			}
			%>

			<div class="booking-summary">
				<h3>🎫 예약 요약</h3>
				<div class="summary-item">
					<span class="summary-label">요청 승객 수:</span> <span
						class="summary-value"><%=passengerCount%>명</span>
				</div>
				<div class="summary-item">
					<span class="summary-label">성공한 예약:</span> <span
						class="summary-value"><%=successCount%>개</span>
				</div>
				<div class="summary-item">
					<span class="summary-label">실패한 예약:</span> <span
						class="summary-value"><%=errorCount%>개</span>
				</div>
				<div class="summary-item total-price">
					<span class="summary-label">총 결제금액:</span> <span
						class="summary-value">₩<%=String.format("%,d", (int) (totalPrice + totalPrice * 0.1 + 10000 * successCount))%></span>
				</div>
			</div>

			<%
			if (!successSeats.isEmpty()) {
			%>
			<div class="seat-info">
				<h4>✅ 예약 완료된 좌석</h4>
				<div class="seat-list">
					<%
					for (String seat : successSeats) {
					%>
					<div class="seat-item success-seat">
						<div class="seat-item-number"><%=seat%></div>
						<div class="seat-item-price"><%=seatClasses.get(seat)%></div>
						<%
						if (seatPrices.containsKey(seat)) {
						%>
						<div class="seat-item-price">
							₩<%=String.format("%,d", seatPrices.get(seat).intValue())%></div>
						<%
						}
						%>
					</div>
					<%
					}
					%>
				</div>
			</div>
			<%
			}
			%>

			<%
			if (!errorSeats.isEmpty()) {
			%>
			<div class="seat-info">
				<h4>❌ 예약 실패한 좌석</h4>
				<div class="seat-list">
					<%
					for (String seat : errorSeats) {
					%>
					<div class="seat-item error-seat">
						<div class="seat-item-number"><%=seat%></div>
						<div class="seat-item-price">실패</div>
					</div>
					<%
					}
					%>
				</div>
				<p style="margin-top: 10px; font-size: 14px; color: #666;">이미
					예약되었거나 오류가 발생했습니다.</p>
			</div>
			<%
			}
			%>

			<!-- 부분 성공 시에도 결제 폼 포함 -->
			<form id="paymentForm" action="payment" method="post"
				class="payment-form">
				<input type="hidden" name="flightId" value="<%=flightId%>">
				<input type="hidden" name="airline"
					value="<%=flight != null ? flight.getAirline() : ""%>"> <input
					type="hidden" name="departureCity"
					value="<%=flight != null ? flight.getDepartureCity() : ""%>">
				<input type="hidden" name="arrivalCity"
					value="<%=flight != null ? flight.getArrivalCity() : ""%>">
				<input type="hidden" name="flightDate"
					value="<%=flight != null ? flight.getFlightDate() : ""%>">
				<input type="hidden" name="departureTime"
					value="<%=flight != null ? flight.getDepartureTime() : ""%>">
				<input type="hidden" name="arrivalTime"
					value="<%=flight != null ? flight.getArrivalTime() : ""%>">
				<input type="hidden" name="totalPrice"
					value="<%=(int) (totalPrice + totalPrice * 0.1 + 10000 * successCount)%>">
				<input type="hidden" name="basePrice" value="<%=(int) totalPrice%>">
				<input type="hidden" name="taxAndFee"
					value="<%=(int) (totalPrice * 0.1)%>"> <input type="hidden"
					name="airportFee" value="<%=10000 * successCount%>"> <input
					type="hidden" name="successCount" value="<%=successCount%>">
				<%
				StringBuilder seatDisplay2 = new StringBuilder();
				for (int i = 0; i < successSeats.size(); i++) {
					String seat = successSeats.get(i);
					if (i > 0)
						seatDisplay2.append(", ");
					seatDisplay2.append(seat).append(" (").append(seatClasses.get(seat)).append(")");
				}
				%>
				<input type="hidden" name="seatInfo"
					value="<%=seatDisplay2.toString()%>">
			</form>
		</div>
		<%
		} else {
		// 모든 좌석 예약 실패
		%>
		<div class="result-icon error-icon">❌</div>
		<div class="result-message error-message">
			<div class="message-text">예약에 실패했습니다.</div>

			<%
			if (flight != null) {
			%>
			<div class="flight-info">
				<h3>🛫 대상 항공편</h3>
				<div class="flight-details-grid">
					<div class="flight-detail-item">
						<div class="detail-label">항공편</div>
						<div class="detail-value"><%=flight.getAirline()%>
							<%=flight.getFlightId()%></div>
					</div>
					<div class="flight-detail-item">
						<div class="detail-label">경로</div>
						<div class="detail-value"><%=flight.getDepartureCity()%>
							→
							<%=flight.getArrivalCity()%></div>
					</div>
				</div>
			</div>
			<%
			}
			%>

			<div class="seat-info">
				<h4>❌ 예약 실패한 좌석</h4>
				<div class="seat-list">
					<%
					for (String seat : errorSeats) {
					%>
					<div class="seat-item error-seat">
						<div class="seat-item-number"><%=seat%></div>
						<div class="seat-item-price">실패</div>
					</div>
					<%
					}
					%>
				</div>
				<p style="margin-top: 15px; color: #666;">
					선택하신 좌석들이 이미 예약되었거나 오류가 발생했습니다.<br> 다른 좌석을 선택해 주세요.
				</p>
			</div>
		</div>
		<%
		}
		}
		%>

		<div class="button-container">
			<%
			if (flightId != null && !flightId.isEmpty()) {
			%>
			<a
				href="reservation?flightId=<%=flightId%>&passengerCount=<%=passengerCount%><%=type != null ? "&type=" + type : ""%>"
				class="btn btn-primary"> 다시 선택하기 </a>
			<%
			} else {
			%>
			<a href="reservation?passengerCount=<%=passengerCount%>"
				class="btn btn-primary"> 다시 선택하기 </a>
			<%
			}
			%>
			<a href="main" class="btn btn-secondary"> 메인으로 돌아가기 </a>
			<%
			// 성공한 예약이 있는 경우에만 결제 버튼 표시 (변수 스코프 문제 해결)
			if (successCount > 0) {
			%>
			<button class="btn btn-success" onclick="goToPayment()">💳
				결제하기</button>
			<%
			}
			%>
		</div>
	</div>

	<script>
		function goToPayment() {
			// 결제 페이지로 이동
			const form = document.getElementById('paymentForm');
			if (form) {
				form.submit();
			} else {
				alert('결제 정보를 찾을 수 없습니다.');
			}
		}
	</script>

	<%@ include file="Footer.jsp"%>
</body>
</html>