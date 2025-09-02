<%@page import="dto.ReservationDto"%>
<%@page import="java.util.List"%>
<%@page import="dao.ReservationDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - SkyBooking</title>
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

        .mypage-container {
            max-width: 1200px;
            margin: 50px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        /* 헤더 */
        .mypage-header {
            background: linear-gradient(135deg, #2563eb, #29B6F6);
            color: white;
            padding: 40px;
            text-align: center;
            position: relative;
        }

        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }

        .profile-name {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 8px;
        }

        .profile-email {
            font-size: 16px;
            opacity: 0.9;
            margin-bottom: 20px;
        }

        .membership-badge {
            display: inline-block;
            padding: 8px 20px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            backdrop-filter: blur(10px);
        }

        /* 탭 네비게이션 */
        .tab-navigation {
            display: flex;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }

        .tab-button {
            flex: 1;
            padding: 20px;
            background: none;
            border: none;
            font-size: 16px;
            font-weight: 600;
            color: #64748b;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }

        .tab-button.active {
            color: #2563eb;
            background: white;
        }

        .tab-button.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: #2563eb;
        }

        .tab-button:hover {
            color: #2563eb;
            background: #f1f5f9;
        }

        /* 탭 콘텐츠 */
        .tab-content {
            display: none;
            padding: 40px;
        }

        .tab-content.active {
            display: block;
        }

        /* 정보 카드 */
        .info-card {
            background: #f8fafc;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            border: 1px solid #e2e8f0;
        }

        .info-card h3 {
            color: #1e293b;
            font-size: 20px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e2e8f0;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #374151;
            min-width: 120px;
        }

        .info-value {
            color: #6b7280;
            text-align: right;
            flex: 1;
        }

        /* 개선된 예약 카드 스타일 */
        .reservation-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .reservation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            border-color: #3b82f6;
        }

        .reservation-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #3b82f6, #06b6d4, #10b981);
        }

        /* 예약 내역 각 항목 스타일링 */
        .reservation-card p {
            margin: 12px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f1f5f9;
            font-size: 15px;
        }

        .reservation-card p:last-child {
            border-bottom: none;
        }

        .reservation-card strong {
            color: #64748b;
            font-weight: 600;
            min-width: 100px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* 각 항목별 아이콘 추가 */
        .reservation-card p:nth-child(1) strong::before {
            content: '🎫';
        }

        .reservation-card p:nth-child(2) strong::before {
            content: '✈️';
        }

        .reservation-card p:nth-child(3) strong::before {
            content: '💺';
        }

        .reservation-card p:nth-child(4) strong::before {
            content: '📅';
        }

        .reservation-card p:nth-child(5) strong::before {
            content: '💰';
        }

        .reservation-card p:nth-child(6) strong::before {
            content: '📊';
        }

        /* 예약번호 강조 */
        .reservation-card p:first-child {
            background: rgba(59, 130, 246, 0.05);
            padding: 15px;
            border-radius: 8px;
            border: 1px solid rgba(59, 130, 246, 0.1);
            font-weight: bold;
            margin-bottom: 20px;
        }

        /* 가격 강조 */
        .reservation-card p:nth-child(5) {
            background: rgba(16, 185, 129, 0.05);
            padding: 15px;
            border-radius: 8px;
            border: 1px solid rgba(16, 185, 129, 0.1);
            font-weight: bold;
        }

        /* 상태 표시 */
        .reservation-card p:last-child {
            background: rgba(99, 102, 241, 0.05);
            padding: 15px;
            border-radius: 8px;
            border: 1px solid rgba(99, 102, 241, 0.1);
            margin-top: 15px;
        }

        /* 페이지네이션 스타일 개선 */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #e2e8f0;
        }

        .pagination-container a, 
        .pagination-container strong {
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .pagination-container a {
            background: #f8fafc;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }

        .pagination-container a:hover {
            background: #e2e8f0;
            color: #374151;
            transform: translateY(-2px);
        }

        .pagination-container strong {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            border: 1px solid #3b82f6;
        }

        /* 빈 상태 스타일 */
        .empty-reservation {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }

        .empty-reservation::before {
            content: '✈️';
            font-size: 64px;
            display: block;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-reservation h4 {
            font-size: 20px;
            color: #374151;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .empty-reservation p {
            color: #64748b;
            font-weight: normal;
            font-size: 14px;
            margin-bottom: 30px;
        }

        /* 버튼 스타일 */
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: #6b7280;
            color: white;
        }

        .btn-secondary:hover {
            background: #4b5563;
            transform: translateY(-1px);
        }

        .btn-danger {
            background: #dc2626;
            color: white;
        }

        .btn-danger:hover {
            background: #b91c1c;
            transform: translateY(-1px);
        }

        /* 폼 스타일 */
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
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2563eb;
        }

        /* 반응형 */
        @media (max-width: 768px) {
            .mypage-container {
                margin: 20px;
            }

            .mypage-header {
                padding: 30px 20px;
            }

            .tab-content {
                padding: 20px;
            }

            .tab-navigation {
                flex-direction: column;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .reservation-card p {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }

            .reservation-card strong {
                min-width: auto;
            }
        }
        /* 내 문의 목록 버튼 고정 위치 스타일 */
	    .fixed-inquiry-button-container {
	        position: fixed; /* 화면에 고정 */
	        bottom: 30px;    /* 하단에서 30px 위로 */
	        right: 30px;     /* 오른쪽에서 30px 안으로 */
	        z-index: 1000;   /* 다른 요소들 위에 표시되도록 z-index 설정 (필요시 조정) */
	        /* 선택 사항: 버튼 자체의 크기나 모양 조정을 위한 추가 스타일 */
	    }
	
	    .fixed-inquiry-button {
	        background-color: #2563eb; /* 버튼 배경색 */
	        color: white;             /* 글자색 */
	        padding: 15px 30px;       /* 패딩 */
	        border: none;             /* 테두리 없음 */
	        border-radius: 50px;      /* 둥근 모서리 (알약 모양) */
	        font-size: 17px;          /* 글자 크기 */
	        font-weight: bold;
	        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2); /* 그림자 효과 */
	        cursor: pointer;          /* 마우스 오버 시 커서 변경 */
	        transition: background-color 0.3s ease, transform 0.2s ease; /* 호버 애니메이션 */
	    }
	
	    .fixed-inquiry-button:hover {
	        background-color: #1d4ed8; /* 호버 시 배경색 변경 */
	        transform: translateY(-3px); /* 호버 시 살짝 위로 */
	    }
	
	    /* 화면이 작아질 때 버튼 위치 조정 (선택 사항) */
	    @media (max-width: 768px) {
	        .fixed-inquiry-button-container {
	            bottom: 20px;
	            right: 20px;
	        }
	        .fixed-inquiry-button {
	            padding: 12px 24px;
	            font-size: 15px;
	        }
	    }
    </style>
</head>
<body>
<%
	String userId = (String) session.getAttribute("id");
	ReservationDao rdao = new ReservationDao(application);
%>
    <%@ include file="Navi.jsp" %>
    
    <div class="mypage-container">
        <!-- 프로필 헤더 -->
        <div class="mypage-header">
            <div class="profile-avatar">✈️</div>
            <div class="profile-name">${sessionScope.user.name}님</div>
            <div class="profile-email">${sessionScope.user.email}</div>
            <c:choose>
            	<c:when test="${sessionScope.user.admin == 1}">
            		<div class="membership-badge">✨ 관리자</div>
            	</c:when>
            	<c:otherwise>
					<div class="membership-badge">✨ 일반 회원</div>
            	</c:otherwise>
            </c:choose>
        </div>

        <!-- 탭 네비게이션 -->
        <div class="tab-navigation">
            <button class="tab-button active" onclick="showTab('profile')">📋 내 정보</button>
            <button class="tab-button" onclick="showTab('bookings')">✈️ 예약 내역</button>
            <button class="tab-button" onclick="showTab('settings')">⚙️ 설정</button>
        </div>
  
        <!-- 개인정보 카드 -->
		<div id="profile" class="tab-content active">
            <div class="info-card">
                <h3>📋 개인정보</h3>
                <div class="info-grid">
                    <div>
                        <div class="info-item">
                            <span class="info-label">아이디</span>
                            <span class="info-value">${sessionScope.user.id}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">이름</span>
                            <span class="info-value">${sessionScope.user.name}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">이메일</span>
                            <span class="info-value">${sessionScope.user.email}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">전화번호</span>
                            <span class="info-value">${sessionScope.user.phone}</span>
                        </div>
                    </div>
                    <div>
                        <div class="info-item">
                            <span class="info-label">주소</span>
                            <span class="info-value">${sessionScope.user.address}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">성별</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${sessionScope.user.gender == 'M'}">남성</c:when>
                                    <c:otherwise>여성</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">생년월일</span>
                            <span class="info-value">${sessionScope.user.birth}</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">가입일</span>
                            <span class="info-value">
                                <fmt:formatDate value="${sessionScope.user.createDate}" pattern="yyyy년 MM월 dd일"/>
                            </span>
                        </div>
                    </div>
                </div>
                <div style="text-align: center; margin-top: 30px;">
                    <button class="btn btn-primary" onclick="showTab('settings')">정보 수정하기</button>
                </div>
            </div>
        </div>

        <!-- 예약 내역 탭 -->
        <div id="bookings" class="tab-content">
            <div class="info-card">
                <h3>✈️ 예약 내역</h3>
				<c:choose>
					<c:when test="${not empty reservations}">
						<c:forEach var="r" items="${reservations}">
							<div class="reservation-card">
								<p>
									<strong>예약번호:</strong> ${r.reservationId}
								</p>
								<p>
									<strong>항공편 ID:</strong> ${r.flightId}
								</p>
								<p>
									<strong>좌석 번호:</strong> ${r.seatNumber}
								</p>
								<p>
									<strong>예약일:</strong> ${r.reservationDate}
								</p>
								<p>
								    <strong>결제금액:</strong>
								    <%-- mypage.jsp에서 세금(10%)과 공항 이용료(10,000원)를 포함하여 계산 및 표시 --%>
								    <c:set var="basePrice" value="${r.totalPrice}" />
								    <c:set var="taxAmount" value="${basePrice * 0.1}" />
								    <c:set var="airportFee" value="10000" /> <%-- 좌석당 공항 이용료 --%>
								    <c:set var="finalDisplayPrice" value="${basePrice + taxAmount + airportFee}" />
								    <fmt:formatNumber value="${finalDisplayPrice}" pattern="#,###" />원
								</p>
								<p>
									<strong>상태:</strong> ${r.status}
								</p>
							</div>
						</c:forEach>

						<div class="pagination-container">
							<c:forEach var="i" begin="1" end="${totalPage}">
								<c:choose>
									<c:when test="${i == currentPage}">
										<strong>${i}</strong>
									</c:when>
									<c:otherwise>
										<a href="mypage?page=${i}">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</div>

					</c:when>
					<c:otherwise>
						<div class="empty-reservation">
                            <h4>아직 예약 내역이 없습니다</h4>
                            <p>새로운 여행을 계획하고 첫 번째 항공권을 예약해보세요!</p>
                        </div>
					</c:otherwise>
				</c:choose>

			</div>
        </div>

        <!-- 설정 탭 -->
        <div id="settings" class="tab-content">
            <div class="info-card">
                <h3>⚙️ 개인정보 수정</h3>
                <form action="mypage" method="post">
                	<input type="hidden" name="actionType" value="updateProfile">
                    <div class="info-grid">
                        <div>
                            <div class="form-group">
                                <label>이름</label>
                                <input type="text" name="name" value="${sessionScope.user.name}" readonly="readonly">
                            </div>
                            <div class="form-group">
                                <label>이메일</label>
                                <input type="email" name="email" value="${sessionScope.user.email}">
                            </div>
                            <div class="form-group">
                                <label>전화번호</label>
                                <input type="tel" name="phone" value="${sessionScope.user.phone}">
                            </div>
                        </div>
                        <div>
                            <div class="form-group">
                                <label>주소</label>
                                <input type="text" name="address" value="${sessionScope.user.address}">
                            </div>
                            <div class="form-group">
                                <label>생년월일</label>
                                <fmt:formatDate value="${sessionScope.user.birth}" pattern="yyyy-MM-dd" var="birthFormatted"/>
                                <input type="date" name="birth" value="${birthFormatted}">
                            </div>
                            <div class="form-group">
                                <label>성별</label>
                                <select name="gender">
                                    <option value="M" ${sessionScope.user.gender == 'M' ? 'selected' : ''}>남성</option>
                                    <option value="F" ${sessionScope.user.gender == 'F' ? 'selected' : ''}>여성</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div style="text-align: center; margin-top: 30px;">
                        <button type="submit" class="btn btn-primary">정보 수정</button>
                        <button type="button" class="btn btn-secondary" style="margin-left: 15px;">취소</button>
                    </div>
                </form>
            </div>

            <div class="info-card">
                <h3>🔒 비밀번호 변경</h3>
                <form action="mypage" method="post">
                 	<input type="hidden" name="actionType" value="changePassword">
                    <div class="form-group">
                        <label>현재 비밀번호</label>
                        <input type="password" name="pwd" required>
                    </div>
                    <div class="form-group">
                        <label>새 비밀번호</label>
                        <input type="password" name="nPwd" required>
                    </div>
                    <div class="form-group">
                        <label>새 비밀번호 확인</label>
                        <input type="password" name="cnPwd" required>
                    </div>
                    <div style="text-align: center; margin-top: 30px;">
                        <button type="submit" class="btn btn-primary">비밀번호 변경</button>
                    </div>
                </form>
            </div>

			<div class="info-card">
				<h3>🚪 회원 탈퇴</h3>
				<p style="color: #6b7280; margin-bottom: 20px;">회원 탈퇴 시 모든 개인정보와
					예약 내역이 삭제되며, 복구할 수 없습니다.</p>

				<!-- 탈퇴용 form (화면에는 보이지 않음) -->
				<form id="withdrawForm" action="mypage" method="post"
					style="display: none;">
					<input type="hidden" name="actionType" value="withdraw">
				</form>

				<!-- 사용자에게 보이는 버튼 영역 -->
				<div style="text-align: center;">
					<button type="button" class="btn btn-danger"
						onclick="confirmWithdraw()">회원 탈퇴</button>
				</div>
			</div>
		</div>
    </div>
	<div class="fixed-inquiry-button-container">
        <button type="button" class="fixed-inquiry-button" onclick="location.href='${pageContext.request.contextPath}/myposts'">내 문의 목록</button>
    </div>
    <script>
        // 탭 전환 함수
        function showTab(tabName) {
        // 모든 탭 버튼과 콘텐츠 숨기기
        const tabButtons = document.querySelectorAll('.tab-button');
        const tabContents = document.querySelectorAll('.tab-content');

        tabButtons.forEach(button => button.classList.remove('active'));
        tabContents.forEach(content => content.classList.remove('active'));

        // 버튼 중에서 tabName과 연결된 탭 버튼만 활성화
        const clickedButton = Array.from(tabButtons).find(btn =>
            btn.getAttribute('onclick').includes(tabName)
        );

        if (clickedButton) {
            clickedButton.classList.add('active');
        }

        document.getElementById(tabName).classList.add('active');
    }

        // 회원 탈퇴 확인
        function confirmWithdraw() {
	        if (confirm('정말로 회원탈퇴를 하시겠습니까?\n탈퇴 후에는 복구할 수 없습니다.')) {
	            if (confirm('마지막 확인입니다. 정말로 탈퇴하시겠습니까?')) {
	                document.getElementById("withdrawForm").submit();
	            }
	        }
    	}

        // 초기화
        document.addEventListener('DOMContentLoaded', function () {
		    console.log('마이페이지 로드 완료');
		
		    // 탭 유지
		    const urlParams = new URLSearchParams(window.location.search);
		    const currentPage = urlParams.get('page');
		    if (currentPage) {
		        showTab('bookings');
		    }
		
		    // 비밀번호 확인 검증
		    const passwordForm = document.querySelector('form[action="changePassword"]');
		    if (passwordForm) {
		        passwordForm.addEventListener('submit', function (e) {
		            const newPassword = this.nPwd.value;
		            const confirmPassword = this.cnPwd.value;
		
		            if (newPassword !== confirmPassword) {
		                e.preventDefault();
		                alert('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
		            }
		        });
		    }
		});
    </script>

    <%@ include file="Footer.jsp" %>
</body>
</html>