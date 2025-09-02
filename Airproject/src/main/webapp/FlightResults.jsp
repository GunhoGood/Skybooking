<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>항공편 검색 결과 - SkyBooking</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/mainmain.css">
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
        
        .results-container {
            max-width: 1200px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        .results-container h2 {
            text-align: center;
            color: #2563eb;
            margin-bottom: 10px;
            font-size: 28px;
            font-weight: bold;
        }
        
        .search-summary {
            background: linear-gradient(135deg, #f8f9ff 0%, #e3f2fd 100%);
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
            border-left: 5px solid #2563eb;
        }
        
        .search-summary::before {
            content: '✈️';
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 24px;
            opacity: 0.3;
        }
        
        .search-summary h3 {
            color: #1565c0;
            margin-bottom: 15px;
            font-size: 20px;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .summary-item {
            background: white;
            padding: 12px 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .summary-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 3px;
            text-transform: uppercase;
        }
        
        .summary-value {
            font-weight: bold;
            color: #2563eb;
            font-size: 14px;
        }
        
        .flight-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            font-size: 24px;
            color: #2563eb;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #2563eb;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .outbound-title::before { content: '🛫'; }
        .return-title::before { content: '🛬'; }
        
        .flight-card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .flight-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(to bottom, #2563eb, #1e40af);
        }
        
        .flight-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.15);
        }
        
        .flight-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .airline-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .airline-name {
            font-weight: bold;
            font-size: 18px;
            color: #2563eb;
        }
        
        .flight-number {
            font-size: 14px;
            color: #666;
            background: #f0f0f0;
            padding: 4px 8px;
            border-radius: 12px;
        }
        
        .seats-info {
            text-align: right;
            font-size: 14px;
            color: #666;
        }
        
        .available-seats {
            font-weight: bold;
            color: #4caf50;
        }
        
        .flight-details {
            display: grid;
            grid-template-columns: 1fr auto 1fr auto;
            gap: 20px;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .departure, .arrival {
            text-align: center;
        }
        
        .time {
            font-size: 24px;
            font-weight: bold;
            color: #2563eb;
            margin-bottom: 5px;
        }
        
        .city {
            font-size: 14px;
            color: #666;
            margin-bottom: 3px;
        }
        
        .date {
            font-size: 12px;
            color: #999;
        }
        
        .flight-arrow {
            text-align: center;
            color: #2563eb;
            font-size: 14px;
        }
        
        .flight-arrow::before {
            content: '✈️';
            display: block;
            font-size: 20px;
            margin-bottom: 5px;
        }
        
        .duration {
            font-size: 12px;
            color: #666;
        }
        
        .price-section {
            text-align: right;
        }
        
        .price {
            font-size: 20px;
            font-weight: bold;
            color: #e74c3c;
            margin-bottom: 10px;
        }
        
        .select-btn {
            background: linear-gradient(135deg, #2563eb, #1e40af);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(37, 99, 235, 0.3);
        }
        
        .select-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.4);
            background: linear-gradient(135deg, #1e40af, #1e3a8a);
        }
        
        .no-flights {
            text-align: center;
            padding: 60px 20px;
            background: linear-gradient(135deg, #fff3e0, #ffecb3);
            border-radius: 10px;
            border-left: 5px solid #ff9800;
        }
        
        .no-flights h3 {
            color: #ef6c00;
            margin-bottom: 10px;
            font-size: 20px;
        }
        
        .no-flights p {
            color: #666;
            margin-bottom: 20px;
        }
        
        .search-again-btn {
            background: linear-gradient(135deg, #ff9800, #f57c00);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .search-again-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 152, 0, 0.4);
        }
        
        .back-to-search {
            text-align: center;
            margin-top: 30px;
        }
        
        .back-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .results-container {
                margin: 20px;
                padding: 20px;
            }
            
            .flight-details {
                grid-template-columns: 1fr;
                gap: 15px;
                text-align: center;
            }
            
            .flight-arrow {
                transform: rotate(90deg);
            }
            
            .flight-header {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }
            
            .summary-grid {
                grid-template-columns: 1fr;
            }
            
            .price-section {
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <%@ include file="Navi.jsp" %>
    
    <div class="results-container">
        <h2>항공편 검색 결과</h2>
        
        <!-- 검색 조건 요약 -->
        <div class="search-summary">
            <h3>🔍 검색 조건</h3>
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-label">경로</div>
                    <div class="summary-value">
                        ${searchCriteria.departureCity} → ${searchCriteria.arrivalCity}
                        <br>한글: ${searchCriteria.getCityName(searchCriteria.departureCity)} → 
                        ${searchCriteria.getCityName(searchCriteria.arrivalCity)}
                    </div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">출발일</div>
                    <div class="summary-value">${searchCriteria.departureDate}</div>
                </div>
                <c:if test="${tripType == 'round' && !empty searchCriteria.returnDate}">
                    <div class="summary-item">
                        <div class="summary-label">귀국일</div>
                        <div class="summary-value">${searchCriteria.returnDate}</div>
                    </div>
                </c:if>
                <div class="summary-item">
                    <div class="summary-label">승객</div>
                    <div class="summary-value">
                        ${searchCriteria.totalPassengers}명
                        (성인 ${searchCriteria.adults}명
                        <c:if test="${searchCriteria.children > 0}">, 소아 ${searchCriteria.children}명</c:if>
                        <c:if test="${searchCriteria.infants > 0}">, 유아 ${searchCriteria.infants}명</c:if>)
                    </div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">좌석등급</div>
                    <div class="summary-value">${searchCriteria.getSeatClassName()}</div>
                </div>
            </div>
        </div>

        <!-- 가는 편 항공편 -->
        <div class="flight-section">
            <h3 class="section-title outbound-title">가는 편</h3>
            <c:choose>
                <c:when test="${empty outboundFlights}">
                    <div class="no-flights">
                        <h3>검색 결과가 없습니다</h3>
                        <p>선택하신 조건에 맞는 항공편이 없습니다.<br>다른 조건으로 다시 검색해보세요.</p>
                        <a href="Main.jsp" class="search-again-btn">다시 검색하기</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="flight" items="${outboundFlights}">
                        <div class="flight-card">
                            <div class="flight-header">
                                <div class="airline-info">
                                    <div class="airline-name">${flight.airline}</div>
                                    <div class="flight-number">${flight.flightId}</div>
                                </div>
                                <div class="seats-info">
                                    잔여석: <span class="available-seats">${flight.availableSeats}석</span>
                                </div>
                            </div>
                            
                            <div class="flight-details">
                                <div class="departure">
                                    <div class="time">${flight.departureTime}</div>
                                    <div class="city">${searchCriteria.getCityName(flight.departureCity)}</div>
                                    <div class="date">${flight.flightDate}</div>
                                </div>
                                
                                <div class="flight-arrow">
                                    <div class="duration">${flight.getFlightDuration()}</div> <%-- DTO에서 계산된 값 사용 --%>
                                </div>
                                
                                <div class="arrival">
                                    <div class="time">${flight.arrivalTime}</div>
                                    <div class="city">${searchCriteria.getCityName(flight.arrivalCity)}</div>
                                    <div class="date">${flight.flightDate}</div>
                                </div>
                                
                                <div class="price-section">
                                    <button class="select-btn" onclick="selectFlight('${flight.flightId}', 'outbound')">
                                        좌석 선택
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 돌아오는 편 항공편 (왕복인 경우만) -->
        <c:if test="${tripType == 'round'}">
            <div class="flight-section">
                <h3 class="section-title return-title">돌아오는 편</h3>
                <c:choose>
                    <c:when test="${empty returnFlights}">
                        <div class="no-flights">
                            <h3>돌아오는 편이 없습니다</h3>
                            <p>선택하신 귀국일에 운항하는 항공편이 없습니다.<br>다른 날짜를 선택해보세요.</p>
                            <a href="Main.jsp" class="search-again-btn">다시 검색하기</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="flight" items="${returnFlights}">
                            <div class="flight-card">
                                <div class="flight-header">
                                    <div class="airline-info">
                                        <div class="airline-name">${flight.airline}</div>
                                        <div class="flight-number">${flight.flightId}</div>
                                    </div>
                                    <div class="seats-info">
                                        잔여석: <span class="available-seats">${flight.availableSeats}석</span>
                                    </div>
                                </div>
                                
                                <div class="flight-details">
                                    <div class="departure">
                                        <div class="time">${flight.departureTime}</div>
                                        <div class="city">${searchCriteria.getCityName(flight.departureCity)}</div>
                                        <div class="date">${flight.flightDate}</div>
                                    </div>
                                    
                                    <div class="flight-arrow">
                                    	<div class="duration">${flight.getFlightDuration()}</div>
                                	</div>
                                    
                                    <div class="arrival">
                                        <div class="time">${flight.arrivalTime}</div>
                                        <div class="city">${searchCriteria.getCityName(flight.arrivalCity)}</div>
                                        <div class="date">${flight.flightDate}</div>
                                    </div>
                                    
                                    <div class="price-section">
                                        <div class="price">
                                        <button class="select-btn" onclick="selectFlight('${flight.flightId}', 'return')">
                                            좌석 선택
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <!-- 다시 검색하기 버튼 -->
        <div class="back-to-search">
            <a href="Main.jsp" class="back-btn">다시 검색하기</a>
        </div>
    </div>
    <%@ include file="Footer.jsp" %>
    <script>
        function selectFlight(flightId, type) {
            // 좌석 선택 페이지로 이동 (승객 수 정보도 함께 전달)
            const passengerCount = ${searchCriteria.totalPassengers};
            console.log('좌석 선택 버튼 클릭:', flightId, type, passengerCount); // 디버깅
            
            const url = '${pageContext.request.contextPath}/reservation?flightId=' + flightId + 
            '&type=' + type + 
            '&passengerCount=' + passengerCount;
            
            console.log('이동할 URL:', url); // 디버깅
            window.location.href = url;
        }
        
        // 페이지 로드 시 애니메이션 효과
        document.addEventListener('DOMContentLoaded', function() {
            console.log('FlightResults.jsp 로드 완료'); // 디버깅
            
            const cards = document.querySelectorAll('.flight-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
    
    
</body>
</html>