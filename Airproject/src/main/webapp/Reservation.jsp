<%@page import="java.util.ArrayList"%>
<%@page import="dao.Seatdao"%>
<%@page import="dao.FlightDAO"%>
<%@page import="dto.Seatdto"%>
<%@page import="dto.FlightDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>좌석 선택 - SkyBooking</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
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
        
        .seat-container {
            max-width: 900px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            position: relative;
        }
        
        .seat-container h2 {
            text-align: center;
            color: #2563eb;
            margin-bottom: 10px;
            font-size: 28px;
            font-weight: bold;
        }
        
        .flight-info {
            background: linear-gradient(135deg, #f8f9ff 0%, #e3f2fd 100%);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 5px solid #2563eb;
            position: relative;
            overflow: hidden;
        }
        
        .flight-info::before {
            content: '✈️';
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 24px;
            opacity: 0.3;
        }
        
        .flight-info h3 {
            color: #1565c0;
            margin-bottom: 15px;
            font-size: 18px;
        }
        
        .flight-details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .flight-detail-item {
            background: white;
            padding: 12px 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
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
        
        .passenger-info {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            background: #fff3e0;
            padding: 15px;
            border-radius: 8px;
            border-left: 5px solid #ff9800;
        }
        
        .airplane-layout {
            background: linear-gradient(135deg, #f8f9ff 0%, #e3f2fd 100%);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }
        
        .airplane-layout::before {
            content: '✈️';
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 24px;
            opacity: 0.3;
        }
        
        .seat-legend {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 15px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            font-size: 14px;
            font-weight: 500;
        }
        
        .legend-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
        }
        
        .legend-dot.available { background-color: #4CAF50; }
        .legend-dot.reserved { background-color: #f44336; }
        .legend-dot.selected { background-color: #2563eb; }
        
        /* 좌석 미리보기 툴팁 스타일 */
        .seat-preview-tooltip {
            position: absolute;
            background: white;
            border: 3px solid #2563eb;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
            pointer-events: none;
            min-width: 300px;
            max-width: 350px;
        }
        
        .seat-preview-tooltip.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(-5px);
        }
        
        .seat-preview-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .seat-preview-title {
            font-weight: bold;
            color: #2563eb;
            font-size: 18px;
        }
        
        .seat-preview-class {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .seat-preview-image {
            width: 100%;
            height: 180px;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 14px;
            position: relative;
            overflow: hidden;
            border: 2px solid #e0e0e0;
        }
        
        .seat-preview-image img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 8px;
        }
        
        .seat-preview-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            font-size: 13px;
        }
        
        .seat-preview-detail {
            background: #f8f9ff;
            padding: 8px 12px;
            border-radius: 8px;
            display: flex;
            flex-direction: column;
            gap: 3px;
        }
        
        .seat-preview-detail-label {
            color: #666;
            font-size: 11px;
            text-transform: uppercase;
            font-weight: 600;
        }
        
        .seat-preview-detail-value {
            font-weight: bold;
            color: #2563eb;
            font-size: 14px;
        }
        
        .seat-preview-arrow {
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 0;
            height: 0;
            border-left: 10px solid transparent;
            border-right: 10px solid transparent;
            border-top: 10px solid #2563eb;
        }
        
        .seat-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 8px;
            margin: 0 auto;
        }
        
        .seat-table th {
            background: linear-gradient(135deg, #2563eb, #1e40af);
            color: white;
            padding: 15px;
            text-align: center;
            border-radius: 8px;
            font-weight: bold;
            box-shadow: 0 2px 10px rgba(37, 99, 235, 0.3);
        }
        
        .seat-table td {
            padding: 15px;
            text-align: center;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .seat-table tr:hover td {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .seat-number {
            font-weight: bold;
            color: #2563eb;
            font-size: 16px;
            cursor: pointer;
            position: relative;
            padding: 5px 10px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        
        .seat-number:hover {
            background: rgba(37, 99, 235, 0.1);
            transform: scale(1.05);
        }
        
        .seat-class {
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }
        
        .seat-class.economy {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .seat-class.business {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        
        .seat-class.first {
            background: #fff3e0;
            color: #f57c00;
        }
        
        .seat-price {
            font-size: 12px;
            color: #e74c3c;
            font-weight: bold;
            margin-top: 3px;
        }
        
        .seat-status {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .status-reserved {
            color: #f44336;
            font-weight: bold;
            padding: 8px 15px;
            background: #ffebee;
            border-radius: 20px;
            border: 2px solid #ffcdd2;
        }
        
        .status-available {
            color: #4CAF50;
            font-weight: 500;
        }
        
        .seat-checkbox {
            appearance: none;
            width: 20px;
            height: 20px;
            border: 2px solid #ddd;
            border-radius: 4px;
            margin-right: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .seat-checkbox:checked {
            border-color: #2563eb;
            background: #2563eb;
        }
        
        .seat-checkbox:checked::after {
            content: '✓';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 12px;
            font-weight: bold;
        }
        
        .seat-checkbox:hover {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .submit-container {
            text-align: center;
            margin-top: 30px;
        }
        
        .reserve-btn {
            background: linear-gradient(135deg, #2563eb, #1e40af);
            color: white;
            padding: 15px 40px;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 200px;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
        }
        
        .reserve-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
            background: linear-gradient(135deg, #1e40af, #1e3a8a);
        }
        
        .reserve-btn:active {
            transform: translateY(0);
        }
        
        .selected-info {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            font-weight: bold;
            color: #1565c0;
            display: none;
        }
        
        .back-btn {
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 15px;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }
        
        .error-message {
            text-align: center;
            color: #f44336;
            background: #ffebee;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            border-left: 5px solid #f44336;
        }
        
        @media (max-width: 768px) {
            .seat-container {
                margin: 20px;
                padding: 20px;
            }
            
            .seat-table {
                font-size: 14px;
            }
            
            .seat-table th,
            .seat-table td {
                padding: 10px 5px;
            }
            
            .seat-legend {
                gap: 15px;
            }
            
            .legend-item {
                font-size: 12px;
                padding: 6px 10px;
            }
            
            .flight-details-grid {
                grid-template-columns: 1fr;
            }
            
            .seat-preview-tooltip {
                min-width: 250px;
                max-width: 280px;
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="Navi.jsp" %>
    
    <div class="seat-container">
        <h2>좌석 선택</h2>
        
        <!-- 좌석 미리보기 툴팁 -->
        <div class="seat-preview-tooltip" id="seatPreviewTooltip">
            <div class="seat-preview-header">
                <span class="seat-preview-title" id="previewSeatNumber">1A</span>
                <span class="seat-preview-class" id="previewSeatClass">이코노미</span>
            </div>
            <div class="seat-preview-image" id="previewSeatImage">
                <!-- 여기에 좌석 배치도 이미지가 표시됩니다 -->
                <img src="./img/seat.png" alt="좌석 배치도" />
            </div>
            <div class="seat-preview-details">
                <div class="seat-preview-detail">
                    <span class="seat-preview-detail-label">좌석 위치</span>
                    <span class="seat-preview-detail-value" id="previewSeatPosition">창가</span>
                </div>
                <div class="seat-preview-detail">
                    <span class="seat-preview-detail-label">추가 요금</span>
                    <span class="seat-preview-detail-value" id="previewSeatPrice">₩0</span>
                </div>
                <div class="seat-preview-detail">
                    <span class="seat-preview-detail-label">좌석 폭</span>
                    <span class="seat-preview-detail-value" id="previewSeatWidth">45cm</span>
                </div>
                <div class="seat-preview-detail">
                    <span class="seat-preview-detail-label">시트 피치</span>
                    <span class="seat-preview-detail-value" id="previewSeatPitch">79cm</span>
                </div>
            </div>
            <div class="seat-preview-arrow"></div>
        </div>
        
        <%
            // 파라미터 받기
            String flightId = request.getParameter("flightId");
            String passengerCountParam = request.getParameter("passengerCount");
            String type = request.getParameter("type");
            
            int passengerCount = 1;
            if (passengerCountParam != null && !passengerCountParam.isEmpty()) {
                try {
                    passengerCount = Integer.parseInt(passengerCountParam);
                } catch (NumberFormatException e) {
                    passengerCount = 1;
                }
            }
            
            // 항공편 ID가 없으면 오류 처리
            if (flightId == null || flightId.trim().isEmpty()) {
        %>
                <div class="error-message">
                    <h3>잘못된 접근입니다</h3>
                    <p>항공편 정보가 없습니다. 다시 검색해주세요.</p>
                    <a href="Main.jsp" class="back-btn">검색 페이지로 돌아가기</a>
                </div>
        <%
            } else {
                // 항공편 정보 조회
                FlightDAO flightDAO = new FlightDAO(application);
                FlightDTO flight = flightDAO.getFlightById(flightId);
                flightDAO.close();
                
                if (flight == null) {
        %>
                    <div class="error-message">
                        <h3>항공편을 찾을 수 없습니다</h3>
                        <p>해당 항공편이 존재하지 않거나 운항이 중단되었습니다.</p>
                        <a href="Main.jsp" class="back-btn">검색 페이지로 돌아가기</a>
                    </div>
        <%
                } else {
                    // 해당 항공편의 좌석 조회
                    Seatdao seatDAO = new Seatdao(application);
                    ArrayList<Seatdto> seats = seatDAO.selectByFlight(flightId);
                    seatDAO.close();
        %>
        
        <!-- 항공편 정보 -->
        <div class="flight-info">
            <h3>🛫 선택하신 항공편</h3>
            <div class="flight-details-grid">
                <div class="flight-detail-item">
                    <div class="detail-label">항공편</div>
                    <div class="detail-value"><%= flight.getAirline() %> <%= flight.getFlightId() %></div>
                </div>
                <div class="flight-detail-item">
                    <div class="detail-label">경로</div>
                    <div class="detail-value"><%= flight.getDepartureCity() %> → <%= flight.getArrivalCity() %></div>
                </div>
                <div class="flight-detail-item">
                    <div class="detail-label">출발</div>
                    <div class="detail-value"><%= flight.getFlightDate() %> <%= flight.getDepartureTime() %></div>
                </div>
                <div class="flight-detail-item">
                    <div class="detail-label">도착</div>
                    <div class="detail-value"><%= flight.getFlightDate() %> <%= flight.getArrivalTime() %></div>
                </div>
                <div class="flight-detail-item">
                    <div class="detail-label">잔여석</div>
                    <div class="detail-value"><%= flight.getAvailableSeats() %>석</div>
                </div>
            </div>
        </div>
        
        <div class="passenger-info">
            <strong>승객 <%= passengerCount %>명</strong>의 좌석을 선택해 주세요
            <% if (type != null && !type.isEmpty()) { %>
                <span style="margin-left: 15px; color: #2563eb;">
                    (<%= "outbound".equals(type) ? "가는 편" : "돌아오는 편" %>)
                </span>
            <% } %>
        </div>
        
        <div class="airplane-layout">
            <div class="seat-legend">
                <div class="legend-item">
                    <div class="legend-dot available"></div>
                    <span>예약 가능</span>
                </div>
                <div class="legend-item">
                    <div class="legend-dot reserved"></div>
                    <span>예약 완료</span>
                </div>
                <div class="legend-item">
                    <div class="legend-dot selected"></div>
                    <span>선택됨</span>
                </div>
            </div>
            
            <% if (seats.isEmpty()) { %>
                <div class="error-message">
                    <h3>좌석 정보가 없습니다</h3>
                    <p>해당 항공편의 좌석이 설정되지 않았습니다.</p>
                    <a href="Main.jsp" class="back-btn">검색 페이지로 돌아가기</a>
                </div>
            <% } else { %>
            
            <form action="reserveseat" method="post" id="seatForm">
                <input type="hidden" name="flightId" value="<%= flightId %>" />
                <input type="hidden" name="passengerCount" value="<%= passengerCount %>" />
                <input type="hidden" name="type" value="<%= type != null ? type : "" %>" />
                
                <table class="seat-table">
                    <thead>
                        <tr>
                            <th>좌석번호</th>
                            <th>등급</th>
                            <th>가격</th>
                            <th>예약상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Seatdto seat : seats) {
                                String classStyle = "";
                                String seatClass = seat.getSeatClass().toLowerCase();
                                if (seatClass.contains("economy")) classStyle = "economy";
                                else if (seatClass.contains("business")) classStyle = "business";
                                else if (seatClass.contains("first")) classStyle = "first";
                        %>
                            <tr>
                                <td>
                                    <span class="seat-number" 
                                          data-seat-number="<%= seat.getSeatNumber() %>"
                                          data-seat-class="<%= seat.getSeatClass() %>"
                                          data-seat-price="<%= seat.getPrice() > 0 ? (int)seat.getPrice() : 100000 %>"
                                          onmouseenter="showSeatPreview(this, event)"
                                          onmouseleave="hideSeatPreview()">
                                        <%= seat.getSeatNumber() %>
                                    </span>
                                </td>
                                <td>
                                    <span class="seat-class <%= classStyle %>"><%= seat.getSeatClass() %></span>
                                </td>
                                <td>
                                    <% if (seat.getPrice() > 0) { %>
                                        <div class="seat-price">₩<%= String.format("%,d", (int)seat.getPrice()) %></div>
                                    <% } else { %>
                                        <div class="seat-price">₩100,000</div>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="seat-status">
                                        <% if (seat.isReserved()) { %>
                                            <span class="status-reserved">예약 완료</span>
                                        <% } else { %>
                                            <input type="checkbox" 
                                                   name="seatNumbers" 
                                                   value="<%= seat.getSeatNumber() %>" 
                                                   class="seat-checkbox"
                                                   onchange="updateSelection()" />
                                            <span class="status-available">예약 가능</span>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <div class="selected-info" id="selectedInfo">
                    선택된 좌석: <span id="selectedSeats"></span>
                    <br><span id="selectionCount">0</span>/<%= passengerCount %>명 선택됨
                    <br>총 요금: <span id="totalPrice">₩0</span>
                </div>
                
                <div class="submit-container">
                    <a href="javascript:history.back()" class="back-btn">이전으로</a>
                    <button type="submit" class="reserve-btn" id="reserveBtn" disabled>
                        좌석 예약하기
                    </button>
                </div>
            </form>
            
            <% } %>
        </div>
        
        <% } %>
    <% } %>
    </div>
    
    <script>
        const passengerCount = <%= passengerCount %>;
        let tooltipTimeout;
        
        // 좌석 미리보기 표시 함수
        function showSeatPreview(element, event) {
            clearTimeout(tooltipTimeout);
            
            const tooltip = document.getElementById('seatPreviewTooltip');
            const seatNumber = element.getAttribute('data-seat-number');
            const seatClass = element.getAttribute('data-seat-class');
            const seatPrice = parseInt(element.getAttribute('data-seat-price'));
            
            // 툴팁 내용 업데이트
            document.getElementById('previewSeatNumber').textContent = seatNumber;
            document.getElementById('previewSeatClass').textContent = seatClass;
            document.getElementById('previewSeatPrice').textContent = '₩' + seatPrice.toLocaleString();
            
            // 좌석 위치 정보 (A, F는 창가, B, E는 통로측, C, D는 가운데)
            const seatLetter = seatNumber.slice(-1);
            let seatPosition = '가운데';
            if (seatLetter === 'A' || seatLetter === 'F') {
                seatPosition = '창가';
            } else if (seatLetter === 'B' || seatLetter === 'E') {
                seatPosition = '통로측';
            }
            document.getElementById('previewSeatPosition').textContent = seatPosition;
            
            // 좌석 등급별 사양 정보
            let seatWidth = '45cm';
            let seatPitch = '79cm';
            
            const classLower = seatClass.toLowerCase();
            if (classLower.includes('business')) {
                seatWidth = '55cm';
                seatPitch = '127cm';
            } else if (classLower.includes('first')) {
                seatWidth = '65cm';
                seatPitch = '152cm';
            }
            
            document.getElementById('previewSeatWidth').textContent = seatWidth;
            document.getElementById('previewSeatPitch').textContent = seatPitch;
            
            // 툴팁 위치 조정 및 표시
            updateTooltipPosition(event);
            tooltip.classList.add('show');
        }
        
        // 좌석 미리보기 숨김 함수
        function hideSeatPreview() {
            tooltipTimeout = setTimeout(() => {
                const tooltip = document.getElementById('seatPreviewTooltip');
                tooltip.classList.remove('show');
            }, 200);
        }
        
        // 툴팁 위치 업데이트 함수
        function updateTooltipPosition(event) {
            const tooltip = document.getElementById('seatPreviewTooltip');
            const container = document.querySelector('.seat-container');
            const containerRect = container.getBoundingClientRect();
            
            // 마우스 위치 기준으로 툴팁 위치 계산
            let left = event.clientX - containerRect.left;
            let top = event.clientY - containerRect.top - tooltip.offsetHeight - 20;
            
            // 화면 경계 체크 및 조정
            if (left + tooltip.offsetWidth > containerRect.width) {
                left = containerRect.width - tooltip.offsetWidth - 20;
            }
            if (left < 20) {
                left = 20;
            }
            if (top < 20) {
                top = event.clientY - containerRect.top + 20;
            }
            
            tooltip.style.left = left + 'px';
            tooltip.style.top = top + 'px';
        }
        
        function updateSelection() {
            const selectedCheckboxes = document.querySelectorAll('input[name="seatNumbers"]:checked');
            const selectedInfo = document.getElementById('selectedInfo');
            const selectedSeats = document.getElementById('selectedSeats');
            const selectionCount = document.getElementById('selectionCount');
            const totalPriceElement = document.getElementById('totalPrice');
            const reserveBtn = document.getElementById('reserveBtn');
            
            const selectedSeatNumbers = Array.from(selectedCheckboxes).map(cb => cb.value);
            
            // 총 가격 계산
            let totalPrice = 0;
            selectedCheckboxes.forEach(cb => {
                const row = cb.closest('tr');
                const priceText = row.querySelector('.seat-price').textContent;
                const price = parseInt(priceText.replace(/[₩,]/g, ''));
                totalPrice += price;
            });
            
            selectedSeats.textContent = selectedSeatNumbers.join(', ') || '없음';
            selectionCount.textContent = selectedSeatNumbers.length;
            totalPriceElement.textContent = '₩' + totalPrice.toLocaleString();
            
            if (selectedSeatNumbers.length > 0) {
                selectedInfo.style.display = 'block';
            } else {
                selectedInfo.style.display = 'none';
            }
            
            // 선택된 좌석 수가 승객 수와 일치할 때만 예약 버튼 활성화
            if (selectedSeatNumbers.length === passengerCount) {
                reserveBtn.disabled = false;
                reserveBtn.style.opacity = '1';
                reserveBtn.style.cursor = 'pointer';
                reserveBtn.style.background = 'linear-gradient(135deg, #2563eb, #1e40af)';
            } else {
                reserveBtn.disabled = true;
                reserveBtn.style.opacity = '0.6';
                reserveBtn.style.cursor = 'not-allowed';
                reserveBtn.style.background = '#ccc';
            }
            
            // 최대 선택 수 제한
            const allCheckboxes = document.querySelectorAll('input[name="seatNumbers"]:not(:checked)');
            if (selectedSeatNumbers.length >= passengerCount) {
                allCheckboxes.forEach(cb => cb.disabled = true);
            } else {
                allCheckboxes.forEach(cb => cb.disabled = false);
            }
        }
        
        // 마우스 이동 시 툴팁 위치 업데이트
        document.addEventListener('mousemove', function(event) {
            const tooltip = document.getElementById('seatPreviewTooltip');
            if (tooltip.classList.contains('show')) {
                updateTooltipPosition(event);
            }
        });
        
        // 툴팁 영역에 마우스가 올라가면 사라지지 않도록
        document.getElementById('seatPreviewTooltip').addEventListener('mouseenter', function() {
            clearTimeout(tooltipTimeout);
        });
        
        document.getElementById('seatPreviewTooltip').addEventListener('mouseleave', function() {
            hideSeatPreview();
        });
        
        // 폼 제출 시 확인
        document.getElementById('seatForm') && document.getElementById('seatForm').addEventListener('submit', function(e) {
            const selectedSeats = document.querySelectorAll('input[name="seatNumbers"]:checked');
            
            if (selectedSeats.length === 0) {
                e.preventDefault();
                alert('좌석을 선택해 주세요.');
                return false;
            }
            
            if (selectedSeats.length !== passengerCount) {
                e.preventDefault();
                alert(`승객 ${passengerCount}명의 좌석을 모두 선택해 주세요. (현재 ${selectedSeats.length}개 선택됨)`);
                return false;
            }
            
            const seatList = Array.from(selectedSeats).map(s => s.value).join(', ');
            if (!confirm(`선택하신 좌석 ${seatList}을(를) 예약하시겠습니까?`)) {
                e.preventDefault();
                return false;
            }
        });
        
        // 초기 버튼 스타일 설정
        document.addEventListener('DOMContentLoaded', function() {
            const reserveBtn = document.getElementById('reserveBtn');
            if (reserveBtn) {
                reserveBtn.style.opacity = '0.6';
                reserveBtn.style.cursor = 'not-allowed';
                reserveBtn.style.background = '#ccc';
            }
        });
    </script>
    
    <%@ include file="Footer.jsp" %>
</body>
</html>