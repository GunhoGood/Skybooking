<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkyBooking</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
    <link rel="stylesheet" href="mainmain.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
        integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />

</head>
<style>
	.logo a {
		cursor: pointer;
        text-decoration: none;
        color: #004B85;
	}
</style>
<body>
    <button id="scrollTopBtn" title="맨 위로">↑</button>
    <%@ include file="Navi.jsp" %>
		<c:if test="${not empty sessionScope.errorMessage}">
			<script>
				alert("${sessionScope.errorMessage}"); // 경고창 띄우기
			</script>
			<c:remove var="errorMessage" scope="session" />
			<%-- 메시지를 한 번 사용한 후 세션에서 제거 --%>
		</c:if>
    <!-- 히어로 섹션 -->
    <section class="hero-section">
        <div class="hero-container">
            <h1 class="hero-title">세계 어디든 떠나보세요</h1>
            <p class="hero-subtitle">최저가 항공편을 비교하고 간편하게 예약하세요</p>

            <!-- 검색 박스 -->
            <!-- 메인 컨테이너 -->
            <div class="main-container">
                <!-- 모던 검색 박스 -->
                <div class="search-container">
                    <h2 class="search-title">항공편 검색</h2>

                    <!-- 여행 타입 탭 -->
                    <div class="trip-tabs">
                        <button class="trip-tab active" data-type="round">왕복</button>
                        <button class="trip-tab" data-type="oneway">편도</button>

                    </div>

                    <!-- 검색 폼 -->
                    <form class="search-form" id="flightSearchForm" action="<c:url value='/flight/search' />" method="POST">
                        <!-- 출발지 -->
                        <div class="form-group">
                            <label class="form-label">출발지 <span class="required">*</span></label>
                            <select class="form-select" id="departureCity" name="departureCity" required>
                                <option value="">출발 도시 선택</option>
                                <option value="ICN">서울/인천 (ICN)</option>
                                <option value="GMP">서울/김포 (GMP)</option>
                                <option value="PUS">부산 (PUS)</option>
                                <option value="CJU">제주 (CJU)</option>
                                <option value="TAE">대구 (TAE)</option>
                                <option value="KWJ">광주 (KWJ)</option>
                                <option value="NRT">도쿄/나리타 (NRT)</option>
                                <option value="KIX">오사카 (KIX)</option>
                                <option value="PVG">상하이 (PVG)</option>
                                <option value="PEK">베이징 (PEK)</option>
                                <option value="HKG">홍콩 (HKG)</option>
                                <option value="SIN">싱가포르 (SIN)</option>
                                <option value="BKK">방콕 (BKK)</option>
                                <option value="LAX">로스앤젤레스 (LAX)</option>
                                <option value="JFK">뉴욕 (JFK)</option>
                                <option value="LHR">런던 (LHR)</option>
                                <option value="CDG">파리 (CDG)</option>
                            </select>
                            <div class="swap-button">⇄</div>
                        </div>

                        <!-- 도착지 -->
                        <div class="form-group">
                            <label class="form-label">도착지 <span class="required">*</span></label>
                            <select class="form-select" id="arrivalCity" name="arrivalCity" required>
                                <option value="">도착 도시 선택</option>
                                <option value="ICN">서울/인천 (ICN)</option>
                                <option value="GMP">서울/김포 (GMP)</option>
                                <option value="PUS">부산 (PUS)</option>
                                <option value="CJU">제주 (CJU)</option>
                                <option value="TAE">대구 (TAE)</option>
                                <option value="KWJ">광주 (KWJ)</option>
                                <option value="NRT">도쿄/나리타 (NRT)</option>
                                <option value="KIX">오사카 (KIX)</option>
                                <option value="PVG">상하이 (PVG)</option>
                                <option value="PEK">베이징 (PEK)</option>
                                <option value="HKG">홍콩 (HKG)</option>
                                <option value="SIN">싱가포르 (SIN)</option>
                                <option value="BKK">방콕 (BKK)</option>
                                <option value="LAX">로스앤젤레스 (LAX)</option>
                                <option value="JFK">뉴욕 (JFK)</option>
                                <option value="LHR">런던 (LHR)</option>
                                <option value="CDG">파리 (CDG)</option>
                            </select>
                        </div>

                        <!-- 출발일 -->
                        <div class="form-group">
                            <label class="form-label">출발일 <span class="required">*</span></label>
                            <input type="date" class="form-input" id="departureDate" name="departureDate" required>
                        </div>

                        <!-- 귀국일 -->
                        <div class="form-group" id="returnDateGroup">
                            <label class="form-label">귀국일</label>
                            <input type="date" class="form-input" id="returnDate" name="returnDate">
                        </div>

                        <!-- 승객 선택 -->
                        <div class="form-group">
                            <label class="form-label">승객 <span class="required">*</span></label>
                            <select class="form-select" id="passengerSelect" name="passengers">
                                <option value="1-0-0">성인 1명</option>
                                <option value="2-0-0">성인 2명</option>
                                <option value="3-0-0">성인 3명</option>
                                <option value="4-0-0">성인 4명</option>
                                <option value="1-1-0">성인 1명, 소아 1명</option>
                                <option value="2-1-0">성인 2명, 소아 1명</option>
                                <option value="2-2-0">성인 2명, 소아 2명</option>
                                <option value="1-0-1">성인 1명, 유아 1명</option>
                                <option value="2-0-1">성인 2명, 유아 1명</option>
                            </select>
                        </div>

                        <!-- 승객 세부 정보 및 좌석 등급 -->
                        <div class="passenger-class-section">
                            <div class="form-group">
                                <label class="form-label">성인</label>
                                <input type="number" class="form-input" id="adultCount" name="adultCount" value="1"
                                    min="1" max="9">
                            </div>
                            <div class="form-group">
                                <label class="form-label">소아 (2-11세)</label>
                                <input type="number" class="form-input" id="childCount" name="childCount" value="0"
                                    min="0" max="8">
                            </div>
                            <div class="form-group">
                                <label class="form-label">유아 (0-23개월)</label>
                                <input type="number" class="form-input" id="infantCount" name="infantCount" value="0"
                                    min="0" max="8">
                            </div>
                            <div class="form-group">
                                <label class="form-label">좌석 등급</label>
                                <select class="form-select" id="seatClass" name="seatClass">
                                    <option value="economy">이코노미</option>
                                    <option value="premium">프리미엄 이코노미</option>
                                    <option value="business">비즈니스</option>
                                    <option value="first">퍼스트</option>
                                </select>
                            </div>
                        </div>

                        <!-- 검색 버튼 -->
                        <button type="submit" class="search-button">항공편 검색</button>

                        <!-- 숨겨진 필드 -->
                        <input type="hidden" id="hiddenTripType" name="tripType" value="round">
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- 인기 목적지 -->
    <section class="popular-section">
        <div class="section-container">
            <h2 class="section-title">인기 여행지</h2>
            <p class="section-subtitle">많은 분들이 선택한 인기 목적지를 확인해보세요</p>

            <div class="destinations-grid">
                <div class="destination-card">
                    <div class="destination-image">
                        <img src="./img/d.jpg" width="400px" height="250px">
                    </div>
                    <div class="destination-info">
                        <h3 class="destination-name">도쿄, 일본</h3>
                        <p class="destination-price">₩345,000~</p>
                        <p class="destination-desc">현대와 전통이 공존하는 매력적인 도시</p>
                    </div>
                </div>

                <div class="destination-card">
                    <div class="destination-image">
                        <img src="./img/p.jpg" width="400px" height="250px">
                    </div>
                    <div class="destination-info">
                        <h3 class="destination-name">파리, 프랑스</h3>
                        <p class="destination-price">₩890,000~</p>
                        <p class="destination-desc">로맨틱한 유럽의 중심지</p>
                    </div>
                </div>

                <div class="destination-card">
                    <div class="destination-image">
                        <img src="./img/n.jpg" width="400px" height="250px">
                    </div>
                    <div class="destination-info">
                        <h3 class="destination-name">뉴욕, 미국</h3>
                        <p class="destination-price">₩1,250,000~</p>
                        <p class="destination-desc">꿈의 도시에서 특별한 경험을</p>
                    </div>
                </div>

                <div class="destination-card">
                    <div class="destination-image">
                        <img src="./img/b.jpg" width="400px" height="250px">
                    </div>
                    <div class="destination-info">
                        <h3 class="destination-name">방콕, 태국</h3>
                        <p class="destination-price">₩285,000~</p>
                        <p class="destination-desc">활기찬 동남아의 허브</p>
                    </div>
                </div>

                <div class="destination-card">
                    <div class="destination-image">
                        <img src="./img/s.jpg" width="400px" height="250px">
                    </div>
                    <div class="destination-info">
                        <h3 class="destination-name">시드니, 호주</h3>
                        <p class="destination-price">₩950,000~</p>
                        <p class="destination-desc">아름다운 자연과 도시의 조화</p>
                    </div>
                </div>

                <div class="destination-card">
                    <div class="destination-image">
                        <img src="./img/r.jpg" width="400px" height="250px">
                    </div>
                    <div class="destination-info">
                        <h3 class="destination-name">런던, 영국</h3>
                        <p class="destination-price">₩820,000~</p>
                        <p class="destination-desc">역사와 문화의 보고</p>
                    </div>
                </div>
            </div>
        </div>
    </section>


    <section class="promotion-section">
        <div class="container">
            <h2>특별 프로모션</h2>
            <div class="promos">
                <div class="promo-card">
                    <h3>도쿄 특가!</h3>
                    <p>서울-도쿄 왕복 항공권 199,000원부터~</p>
                    <a href="#" class="view-details">자세히 보기</a>
                </div>
                <div class="promo-card">
                    <h3>제주 여행의 시작</h3>
                    <p>제주도 항공권 지금 예약하고 할인 받으세요!</p>
                    <a href="#" class="view-details">자세히 보기</a>
                </div>
                <div class="promo-card">
                    <h3>제주 여행의 시작</h3>
                    <p>제주도 항공권 지금 예약하고 할인 받으세요!</p>
                    <a href="#" class="view-details">자세히 보기</a>
                </div>
                <div class="promo-card">
                    <h3>미국 서부 자유여행</h3>
                    <p>LA, 샌프란시스코 항공권 특별 할인</p>
                    <a href="#" class="view-details">자세히 보기</a>
                </div>
            </div>
        </div>
    </section>
    <section class="info-promo-section">
        <div class="container">
            <h2>알려드립니다</h2>
            <div class="promo-grid">
                <div class="promo-card">
                    <img src="./img/w2.jpg" alt="카드 할인 프로모션">
                    <div class="promo-card-content">
                        <h3>신규 취항 및 재개 노선 스케줄 안내</h3>
                        <p>신규 노선 10% 할인 시작</p>
                    </div>
                </div>
                <div class="promo-card">
                    <img src="./img/max.jpg" alt="카드 할인 프로모션">
                    <div class="promo-card-content">
                        <h3>카드 할인 프로모션</h3>
                        <p>카드 결제 시 최대 20만원 할인</p>
                    </div>
                </div>
                <div class="promo-card">
                    <img src="./img/pass.jpg" alt="스카이패스 회원 혜택">
                    <div class="promo-card-content">
                        <h3>스카이패스 회원 혜택</h3>
                        <p>회원 전용 특별 할인 및 마일리지 적립</p>
                    </div>
                </div>
                <div class="promo-card">
                    <img src="./img/hu.jpg" alt="새로운 서비스 안내">
                    <div class="promo-card-content">
                        <h3>새로운 서비스 안내</h3>
                        <p>더욱 편리해진 모바일 체크인</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="app-download-section">
        <div class="container">
            <div class="app-download-content">
                <div class="app-download-text">
                    <h2>대한항공 My 앱</h2>
                    <p>지금 다운로드하고 더욱 편리한 여행을 경험하세요.</p>
                    <div class="app-stores">
                        <a href="https://play.google.com/store/apps/details?id=com.koreanair" target="_blank"
                            rel="noopener noreferrer">
                            <div id="icon-down"><i class="fa-brands fa-google-play"></i></div>
                        </a>
                        <a href="https://apps.apple.com/kr/app/%EB%8C%80%ED%95%9C%ED%95%AD%EA%B3%B5/id399120612"
                            target="_blank" rel="noopener noreferrer">
                            <div id="icon-down"><i class="fa-brands fa-apple"></i></div>
                        </a>
                    </div>
                </div>
                <div class="app-screenshot">
                    <img src="./img/lo.png" alt="대한항공 My 앱 스크린샷" width="500px">
                </div>
            </div>
        </div>
    </section>
    <!-- 특징 섹션 -->
    <section class="features-section">
        <div class="section-container">
            <h2 class="section-title">왜 저희를 선택해야 할까요?</h2>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">💰</div>
                    <h3 class="feature-title">최저가 보장</h3>
                    <p class="feature-desc">다양한 항공사의 가격을 비교하여 가장 저렴한 항공편을 찾아드립니다.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">⚡</div>
                    <h3 class="feature-title">빠른 예약</h3>
                    <p class="feature-desc">간단한 몇 번의 클릭만으로 빠르고 안전하게 항공편을 예약할 수 있습니다.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🛡️</div>
                    <h3 class="feature-title">안전한 결제</h3>
                    <p class="feature-desc">SSL 암호화와 다양한 결제 수단으로 안전하고 편리한 결제를 제공합니다.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🎧</div>
                    <h3 class="feature-title">24시간 고객지원</h3>
                    <p class="feature-desc">언제든지 문의하실 수 있는 24시간 고객지원 서비스를 제공합니다.</p>
                </div>
            </div>
        </div>
    </section>
    <%@ include file="Footer.jsp" %>
    <script src="mainmain.js"></script>
</body>
</html>