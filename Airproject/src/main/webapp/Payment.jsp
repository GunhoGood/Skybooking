<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제하기 - SkyBooking</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f7fa;
            line-height: 1.6;
            color: #333;
        }

        .payment-container {
            max-width: 1200px;
            margin: 50px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        /* 메인 결제 영역 */
        .payment-main {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .payment-header {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            padding: 25px 30px;
            text-align: center;
        }

        .payment-header h1 {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .payment-header p {
            opacity: 0.9;
            font-size: 16px;
        }

        .payment-content {
            padding: 30px;
        }

        /* 예약 정보 카드 */
        .booking-info {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
        }

        .booking-info h3 {
            color: #1e293b;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .booking-info h3::before {
            content: '✈️';
            font-size: 24px;
        }

        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .detail-item:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: #64748b;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-value {
            font-weight: 500;
            color: #1e293b;
        }

        /* 결제 방법 선택 */
        .payment-method {
            margin-bottom: 30px;
        }

        .payment-method h3 {
            color: #1e293b;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .payment-method h3::before {
            content: '💳';
            font-size: 24px;
        }

        .payment-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }

        .payment-option {
            position: relative;
        }

        .payment-option input[type="radio"] {
            display: none;
        }

        .payment-option label {
            display: block;
            padding: 20px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
        }

        .payment-option label:hover {
            border-color: #3b82f6;
            background: #f8fafc;
        }

        .payment-option input[type="radio"]:checked + label {
            border-color: #3b82f6;
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            color: #1e40af;
        }

        .payment-option .method-icon {
            font-size: 32px;
            margin-bottom: 8px;
            display: block;
        }
        
        .payment-option .method-name {
            font-weight: 600;
            font-size: 14px;
        }

        /* 카드 정보 입력 */
        .card-info {
            display: none;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 25px;
            margin-top: 20px;
        }

        .card-info.active {
            display: block;
        }

        .form-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #374151;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #3b82f6;
        }

        /* 약관 동의 */
        .terms-agreement {
            margin-bottom: 30px;
        }

        .terms-agreement h3 {
            color: #1e293b;
            font-size: 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .terms-agreement h3::before {
            content: '📋';
            font-size: 24px;
        }

        .terms-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .terms-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
        }

        .terms-item label {
            flex: 1;
            cursor: pointer;
            font-weight: 500;
        }

        .terms-link {
            color: #3b82f6;
            text-decoration: none;
            font-size: 14px;
        }

        .terms-link:hover {
            text-decoration: underline;
        }

        /* 사이드바 - 결제 요약 */
        .payment-summary {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 30px;
        }

        .summary-header {
            text-align: center;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e2e8f0;
        }

        .summary-header h3 {
            color: #1e293b;
            font-size: 22px;
            margin-bottom: 8px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-label {
            color: #64748b;
            font-weight: 500;
        }

        .summary-value {
            font-weight: 600;
            color: #1e293b;
        }

        .total-amount {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin: 20px 0;
            text-align: center;
        }

        .total-amount .amount {
            font-size: 28px;
            font-weight: bold;
        }

        .total-amount .label {
            font-size: 14px;
            opacity: 0.9;
            margin-bottom: 5px;
        }

        /* 결제 버튼 */
        .payment-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-btn:hover {
            background: linear-gradient(135deg, #1d4ed8, #1e40af);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
        }

        .payment-btn:disabled {
            background: #9ca3af;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .security-info {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 15px;
            color: #64748b;
            font-size: 14px;
        }

        .security-info::before {
            content: '🔒';
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .payment-container {
                grid-template-columns: 1fr;
                margin: 20px auto;
                padding: 0 15px;
            }

            .payment-content {
                padding: 20px;
            }

            .booking-details {
                grid-template-columns: 1fr;
            }

            .payment-options {
                grid-template-columns: repeat(2, 1fr);
            }

            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="Navi.jsp" %>
    
    <%
        // 예약 결과에서 전달받은 데이터 처리
        String flightId = request.getParameter("flightId");
        String airline = request.getParameter("airline");
        String departureCity = request.getParameter("departureCity");
        String arrivalCity = request.getParameter("arrivalCity");
        String flightDate = request.getParameter("flightDate");
        String departureTime = request.getParameter("departureTime");
        String arrivalTime = request.getParameter("arrivalTime");
        
        // 가격 정보
        String totalPriceStr = request.getParameter("totalPrice");
        String basePriceStr = request.getParameter("basePrice");
        String taxAndFeeStr = request.getParameter("taxAndFee");
        String airportFeeStr = request.getParameter("airportFee");
        String seatInfoJson = request.getParameter("seatInfo");
        
        int totalPrice = totalPriceStr != null ? Integer.parseInt(totalPriceStr) : 0;
        int basePrice = basePriceStr != null ? Integer.parseInt(basePriceStr) : 0;
        int taxAndFee = taxAndFeeStr != null ? Integer.parseInt(taxAndFeeStr) : 0;
        int airportFee = airportFeeStr != null ? Integer.parseInt(airportFeeStr) : 0;
        
        // 좌석 정보 파싱 (간단한 문자열 처리)
        String seatDisplay = "";
        if (seatInfoJson != null && !seatInfoJson.isEmpty()) {
            // JSON 파싱 대신 간단한 문자열 처리
            seatDisplay = seatInfoJson.replaceAll("[\\[\\]{}\":]", "")
                                    .replaceAll("seatNumber", "")
                                    .replaceAll("seatClass", "")
                                    .replaceAll("price", "")
                                    .replaceAll(",", " ");
        }
    %>
    
    <div class="payment-container">
        <!-- 메인 결제 영역 -->
        <div class="payment-main">
            <div class="payment-header">
                <h1>항공권 결제</h1>
                <p>안전하고 빠른 결제로 여행을 시작하세요</p>
            </div>
            
            <div class="payment-content">
                <!-- 예약 정보 -->
                <div class="booking-info">
                    <h3>예약 정보</h3>
                    <div class="booking-details">
                        <div>
                            <div class="detail-item">
                                <span class="detail-label">✈️ 항공편</span>
                                <span class="detail-value"><%= flightId != null ? flightId : "N/A" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">🏢 항공사</span>
                                <span class="detail-value"><%= airline != null ? airline : "N/A" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">🛫 출발</span>
                                <span class="detail-value"><%= departureCity != null ? departureCity : "N/A" %> → <%= arrivalCity != null ? arrivalCity : "N/A" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">📅 출발일</span>
                                <span class="detail-value"><%= flightDate != null ? flightDate : "N/A" %></span>
                            </div>
                        </div>
                        <div>
                            <div class="detail-item">
                                <span class="detail-label">🕐 출발시간</span>
                                <span class="detail-value"><%= departureTime != null ? departureTime : "N/A" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">🕑 도착시간</span>
                                <span class="detail-value"><%= arrivalTime != null ? arrivalTime : "N/A" %></span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">👤 승객</span>
                                <span class="detail-value">${sessionScope.user.name}</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">💺 선택 좌석</span>
                                <span class="detail-value"><%= seatDisplay %></span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 결제 방법 선택 -->
                <div class="payment-method">
                    <h3>결제 방법</h3>
                    <div class="payment-options">
                        <div class="payment-option">
                            <input type="radio" id="card" name="paymentMethod" value="card" checked>
                            <label for="card">
                                <span class="method-icon">💳</span>
                                <span class="method-name">신용/체크카드</span>
                            </label>
                        </div>
                        <div class="payment-option">
                            <input type="radio" id="bank" name="paymentMethod" value="bank">
                            <label for="bank">
                                <span class="method-icon">🏦</span>
                                <span class="method-name">무통장입금</span>
                            </label>
                        </div>
                        <div class="payment-option">
                            <input type="radio" id="kakao" name="paymentMethod" value="kakao">
                            <label for="kakao">
                                <span class="method-icon">
				                    <img src="img/kakao.png" alt="카카오페이" style="width:45px; height:45px; vertical-align:middle;">
				                </span>
                                <span class="method-name">카카오페이</span>
                            </label>
                        </div>
                        <div class="payment-option">
                            <input type="radio" id="naver" name="paymentMethod" value="naver">
                            <label for="naver">
                                <span class="method-icon">
				                    <img src="img/naver.png" alt="네이버페이" style="width:45px; height:45px; vertical-align:middle;">
				                </span>
                                <span class="method-name">네이버페이</span>
                            </label>
                        </div>
                    </div>

                    <!-- 카드 정보 입력 -->
                    <div class="card-info active" id="cardInfo">
                        <div class="form-group">
                            <label>카드번호</label>
                            <input type="text" placeholder="0000-0000-0000-0000" maxlength="19">
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>유효기간</label>
                                <input type="text" placeholder="MM/YY" maxlength="5">
                            </div>
                            <div class="form-group">
                                <label>CVC</label>
                                <input type="password" placeholder="000" maxlength="3">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>카드 소유자명</label>
                            <input type="text" placeholder="카드에 표시된 이름을 입력하세요">
                        </div>
                    </div>
                </div>

                <!-- 약관 동의 -->
                <div class="terms-agreement">
                    <h3>약관 동의</h3>
                    <div class="terms-item">
                        <input type="checkbox" id="terms1" required>
                        <label for="terms1">항공 운송 약관에 동의합니다 (필수)</label>
                        <a href="#" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <input type="checkbox" id="terms2" required>
                        <label for="terms2">개인정보 수집 및 이용에 동의합니다 (필수)</label>
                        <a href="#" class="terms-link">보기</a>
                    </div>
                    <div class="terms-item">
                        <input type="checkbox" id="terms3">
                        <label for="terms3">마케팅 정보 수신에 동의합니다 (선택)</label>
                        <a href="#" class="terms-link">보기</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 결제 요약 사이드바 -->
        <div class="payment-summary">
            <div class="summary-header">
                <h3>💰 결제 요약</h3>
            </div>
            
            <div class="summary-item">
                <span class="summary-label">항공료</span>
                <span class="summary-value">
                    ₩<%= String.format("%,d", basePrice) %>
                </span>
            </div>
            <div class="summary-item">
                <span class="summary-label">세금 및 수수료</span>
                <span class="summary-value">
                    ₩<%= String.format("%,d", taxAndFee) %>
                </span>
            </div>
            <div class="summary-item">
                <span class="summary-label">공항 시설 이용료</span>
                <span class="summary-value">
                    ₩<%= String.format("%,d", airportFee) %>
                </span>
            </div>

            <div class="total-amount">
                <div class="label">총 결제금액</div>
                <div class="amount">
                    ₩<%= String.format("%,d", totalPrice) %>
                </div>
            </div>

            <form action="paymentProcess.jsp" method="post" id="paymentForm">
                <input type="hidden" name="flightId" value="<%= flightId %>">
                <input type="hidden" name="seatInfo" value="<%= seatInfoJson %>">
                <input type="hidden" name="totalPrice" value="<%= totalPrice %>">
                <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="card">
                
                <button type="submit" class="payment-btn" id="payBtn" disabled>
                    ₩<%= String.format("%,d", totalPrice) %> 결제하기
                </button>
            </form>

            <div class="security-info">
                SSL 보안 결제가 적용됩니다
            </div>
        </div>
    </div>

    <script>
        // 카드번호 자동 하이픈 추가
        document.querySelector('input[placeholder="0000-0000-0000-0000"]').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            value = value.replace(/(\d{4})(?=\d)/g, '$1-');
            e.target.value = value;
        });

        // 유효기간 자동 슬래시 추가
        document.querySelector('input[placeholder="MM/YY"]').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            e.target.value = value;
        });

        // 결제 방법 변경 시 카드 정보 표시/숨김
        document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const cardInfo = document.getElementById('cardInfo');
                const selectedMethod = document.getElementById('selectedPaymentMethod');
                
                if (this.value === 'card') {
                    cardInfo.classList.add('active');
                } else {
                    cardInfo.classList.remove('active');
                }
                
                selectedMethod.value = this.value;
                checkFormValidity();
            });
        });

        // 약관 동의 체크 및 결제 버튼 활성화
        function checkFormValidity() {
            const terms1 = document.getElementById('terms1').checked;
            const terms2 = document.getElementById('terms2').checked;
            const payBtn = document.getElementById('payBtn');
            
            if (terms1 && terms2) {
                payBtn.disabled = false;
            } else {
                payBtn.disabled = true;
            }
        }

        // 약관 체크박스 이벤트
        document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', checkFormValidity);
        });

        // 결제 폼 제출
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
            
            if (paymentMethod === 'card') {
                // 카드 정보 검증
                const cardNumber = document.querySelector('input[placeholder="0000-0000-0000-0000"]').value;
                const expiry = document.querySelector('input[placeholder="MM/YY"]').value;
                const cvc = document.querySelector('input[placeholder="000"]').value;
                const cardHolder = document.querySelector('input[placeholder="카드에 표시된 이름을 입력하세요"]').value;
                
                if (!cardNumber || !expiry || !cvc || !cardHolder) {
                    alert('카드 정보를 모두 입력해주세요.');
                    return;
                }
            }
            
            if (confirm('결제를 진행하시겠습니까?')) {
                // 결제 처리
                this.submit();
            }
        });

        // 초기 상태 확인
        checkFormValidity();
    </script>

    <%@ include file="Footer.jsp" %>
</body>
</html>