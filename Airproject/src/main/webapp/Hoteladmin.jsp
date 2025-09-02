<%@page import="dto.Users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.*"%>
<%@ page import="dao.HotelDao"%>
<%@ page import="dto.Hotel"%>
<%@ page import="com.google.gson.Gson"%>
<%
// 관리자 권한 체크
String userId = (String) session.getAttribute("id");
Users loginUser = (Users) session.getAttribute("user");
if (userId == null || loginUser == null || loginUser.getAdmin() != 1) {
    response.sendRedirect("main");
    return;	
}

HotelDao hotelDao = new HotelDao();

// AJAX 요청 처리 - 호텔 상세 정보 가져오기
String ajaxRequest = request.getParameter("ajax");
if ("getHotel".equals(ajaxRequest)) {
	String hotelIdStr = request.getParameter("hotelId");
	if (hotelIdStr != null) {
		int hotelId = Integer.parseInt(hotelIdStr);
		Hotel hotel = hotelDao.getHotelById(hotelId);
		if (hotel != null) {
	// JSON으로 응답
	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	Gson gson = new Gson();
	out.print(gson.toJson(hotel));
	return;
		}
	}
	response.setStatus(404);
	return;
}

List<Hotel> hotelList = hotelDao.getDomesticHotels();
int totalHotels = hotelDao.getTotalHotelCount();
int regionCount = hotelDao.getRegionCount();

// 총 좋아요 수 계산
int totalLikes = 0;
for (Hotel hotel : hotelList) {
	totalLikes += hotel.getLikeCount();
}

// 카테고리별 통계 계산
Map<String, Integer> categoryStats = new HashMap<>();
for (Hotel hotel : hotelList) {
    String category = hotel.getCategoryDisplayName();
    categoryStats.put(category, categoryStats.getOrDefault(category, 0) + 1);
}

request.setAttribute("hotelList", hotelList);
request.setAttribute("categoryStats", categoryStats);

// 메시지 처리
String message = request.getParameter("message");
String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>호텔 관리 - SkyBooking Admin</title>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
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

.admin-container {
	max-width: 1400px;
	margin: 50px auto;
	background: white;
	padding: 40px;
	border-radius: 10px;
	box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
}

.admin-container h2 {
	text-align: center;
	color: #2563eb;
	margin-bottom: 10px;
	font-size: 28px;
	font-weight: bold;
}

.admin-info {
	background: linear-gradient(135deg, #2563eb, #29B6F6);
	color: white;
	padding: 15px 20px;
	border-radius: 8px;
	margin-bottom: 20px;
	text-align: center;
	font-weight: bold;
}

/* 메시지 스타일 */
.message-success {
	padding: 15px;
	margin-bottom: 20px;
	background-color: #d4edda;
	border: 1px solid #c3e6cb;
	border-radius: 8px;
	color: #155724;
}

.message-error {
	padding: 15px;
	margin-bottom: 20px;
	background-color: #f8d7da;
	border: 1px solid #f5c6cb;
	border-radius: 8px;
	color: #721c24;
}

/* 통계 카드 */
.stats-container {
	display: flex;
	gap: 20px;
	margin-bottom: 30px;
}

.stat-card {
	flex: 1;
	padding: 20px;
	background: linear-gradient(135deg, #2563eb, #29B6F6);
	color: white;
	border-radius: 8px;
	text-align: center;
}

.stat-card h3 {
	font-size: 28px;
	margin-bottom: 5px;
}

.stat-card p {
	font-size: 14px;
	opacity: 0.9;
}



/* 관리 도구 */
.admin-controls {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 30px;
	flex-wrap: wrap;
	gap: 15px;
}

.search-container {
	flex: 2;
	max-width: 500px;
	position: relative;
}

.search-box {
	width: 100%;
	padding: 12px 45px 12px 15px;
	border: 2px solid #ddd;
	border-radius: 8px;
	font-size: 14px;
	background-color: #fafafa;
	transition: border-color 0.3s ease;
}

.search-box:focus {
	outline: none;
	border-color: #2563eb;
	background-color: white;
}

.search-icon {
	position: absolute;
	right: 15px;
	top: 50%;
	transform: translateY(-50%);
	color: #2563eb;
}

.category-filters {
	display: flex;
	gap: 8px;
	align-items: center;
	flex-wrap: nowrap;
	overflow-x: auto;
}

.category-btn {
	padding: 6px 12px;
	border: 2px solid #e5e7eb;
	background-color: white;
	color: #6b7280;
	border-radius: 20px;
	cursor: pointer;
	font-size: 12px;
	font-weight: 600;
	transition: all 0.3s ease;
	white-space: nowrap;
	flex-shrink: 0;
}

.category-btn:hover {
	background-color: #f3f4f6;
	border-color: #d1d5db;
}

.category-btn.active {
	background: linear-gradient(135deg, #2563eb, #3b82f6);
	color: white;
	border-color: #2563eb;
}

.filter-container {
	display: flex;
	gap: 10px;
	align-items: center;
}

.filter-select {
	padding: 10px 15px;
	border: 2px solid #ddd;
	border-radius: 8px;
	font-size: 14px;
	background-color: #fafafa;
	cursor: pointer;
	transition: border-color 0.3s ease;
}

.filter-select:focus {
	outline: none;
	border-color: #2563eb;
	background-color: white;
}

.add-btn {
	padding: 12px 25px;
	background-color: #2563eb;
	color: white;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-weight: bold;
	transition: all 0.3s ease;
	white-space: nowrap;
}

.add-btn:hover {
	background-color: #29B6F6;
	transform: translateY(-2px);
}

/* 호텔 테이블 */
.hotel-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 30px;
	background: white;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.hotel-table th {
	background-color: #2563eb;
	color: white;
	padding: 15px;
	text-align: center;
	font-weight: bold;
}

.hotel-table td {
	padding: 15px;
	border-bottom: 1px solid #eee;
	vertical-align: middle;
	text-align: center;
}

.hotel-table tr:hover {
	background-color: #f8f9fa;
}

.hotel-image-thumb {
	width: 80px;
	height: 60px;
	object-fit: cover;
	border-radius: 6px;
}

.hotel-name {
	font-weight: bold;
	color: #2563eb;
	margin-bottom: 5px;
	text-align: center;
}

.hotel-location {
	color: #666;
	font-size: 13px;
	text-align: center;
}

.price-display {
	font-weight: bold;
	color: #2563eb;
}

.rating-display {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 5px;
}

.stars {
	color: #fbbf24;
}

.category-tag {
	background: #f1f5f9;
	color: #475569;
	padding: 3px 8px;
	border-radius: 12px;
	font-size: 12px;
}

.action-buttons {
	display: flex;
	gap: 4px;
	justify-content: center;
	align-items: center;
	white-space: nowrap;
}

.edit-btn, .delete-btn {
	padding: 6px 10px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 11px;
	font-weight: bold;
	transition: all 0.3s ease;
	min-width: 40px;
}

.edit-btn, .delete-btn {
	padding: 6px 12px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 12px;
	font-weight: bold;
	transition: all 0.3s ease;
}

.edit-btn {
	background-color: #10b981;
	color: white;
}

.edit-btn:hover {
	background-color: #059669;
}

.delete-btn {
	background-color: #ef4444;
	color: white;
}

.delete-btn:hover {
	background-color: #dc2626;
}

/* 페이징 스타일 */
.pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	margin: 30px 0;
	gap: 8px;
	flex-wrap: wrap;
}

#pageNumbers {
	display: flex;
	gap: 6px;
	align-items: center;
}

.pagination button {
	padding: 12px 16px;
	border: 2px solid #e5e7eb;
	background-color: white;
	color: #6b7280;
	border-radius: 8px;
	cursor: pointer;
	font-size: 14px;
	font-weight: 600;
	transition: all 0.2s ease;
	min-width: 44px;
	height: 44px;
	display: flex;
	align-items: center;
	justify-content: center;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.pagination button:hover:not(:disabled) {
	background-color: #f3f4f6;
	border-color: #d1d5db;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.pagination button.active {
	background: linear-gradient(135deg, #2563eb, #3b82f6);
	color: white;
	border-color: #2563eb;
	box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.pagination button.active:hover {
	background: linear-gradient(135deg, #1d4ed8, #2563eb);
	box-shadow: 0 6px 16px rgba(37, 99, 235, 0.4);
}

.pagination button:disabled {
	background-color: #f9fafb;
	color: #d1d5db;
	border-color: #f3f4f6;
	cursor: not-allowed;
	box-shadow: none;
}



.pagination .nav-btn {
	background: linear-gradient(135deg, #f8fafc, #f1f5f9);
	border-color: #cbd5e1;
	font-weight: 700;
	color: #475569;
}

.pagination .nav-btn:hover:not(:disabled) {
	background: linear-gradient(135deg, #e2e8f0, #cbd5e1);
	border-color: #94a3b8;
}

/* 모달 스타일 */
.modal {
	display: none;
	position: fixed;
	z-index: 1000;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
	background-color: white;
	margin: 3% auto;
	padding: 30px;
	border-radius: 10px;
	width: 90%;
	max-width: 600px;
	max-height: 90vh;
	overflow-y: auto;
}

.close {
	float: right;
	font-size: 28px;
	font-weight: bold;
	cursor: pointer;
	color: #aaa;
}

.close:hover {
	color: #2563eb;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: bold;
	color: #333;
}

.form-group input, .form-group select, .form-group textarea {
	width: 100%;
	padding: 12px;
	border: 2px solid #ddd;
	border-radius: 8px;
	font-size: 14px;
}

.form-group textarea {
	height: 100px;
	resize: vertical;
}

.modal-buttons {
	display: flex;
	justify-content: center;
	gap: 15px;
	margin-top: 25px;
}

.save-btn, .cancel-btn {
	padding: 12px 25px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-weight: bold;
	font-size: 14px;
}

.admin-container h4 {
	text-align: center;
	color: #666;
	margin-bottom: 30px;
	font-weight: normal;
}

.save-btn {
	background-color: #2563eb;
	color: white;
}

.cancel-btn {
	background-color: #6c757d;
	color: white;
}

.loading {
	text-align: center;
	padding: 20px;
	color: #666;
}

@media ( max-width : 768px) {
	.admin-container {
		margin: 20px;
		padding: 20px;
	}
	.stats-container {
		flex-direction: column;
	}
	.admin-controls {
		flex-direction: column;
		align-items: stretch;
	}
	.search-container {
		max-width: none;
		order: 1;
	}
	.category-filters {
		order: 2;
		justify-content: flex-start;
		margin-bottom: 10px;
	}
	.filter-container {
		order: 3;
		margin-bottom: 10px;
	}
	.add-btn {
		order: 4;
	}
	.hotel-table {
		font-size: 12px;
	}
	.hotel-table th, .hotel-table td {
		padding: 8px;
	}
	.pagination {
		gap: 4px;
		margin: 20px 0;
	}
	.pagination button {
		padding: 10px 12px;
		min-width: 40px;
		height: 40px;
		font-size: 13px;
	}
	.pagination-info {
		font-size: 12px;
		padding: 10px 16px;
		margin: 0 8px;
		order: -1;
		width: 100%;
		text-align: center;
		margin-bottom: 15px;
	}
}
</style>
</head>
<body>
	<%@ include file="Navi.jsp"%>

	<div class="admin-container">
		<!-- 관리자 정보 -->
		<div class="admin-info">
			🔐 관리자 모드 |
			<%=userId%>
			님이 로그인됨
		</div>

		<div style="text-align: center; margin-bottom: 20px;">
			<a href="faqadmin" style="text-decoration: none; margin: 0 15px;">
				<h3	style="display: inline; color: #666;">FAQ 관리</h3>
			</a> 
			<a href="hoteladmin" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #2563eb;">호텔 관리</h3>
			</a> 
			<a href="memberList" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">고객 관리</h3>
			</a> 
			<a href="AdminFlight" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">항공편 관리</h3>
			</a>
			<a href="qnaList" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">문의 관리</h3>
			</a>
		</div>
		<h4>호텔을 추가, 수정, 삭제할 수 있습니다</h4>

		<!-- 메시지 표시 -->
		<c:if test="${param.message != null}">
			<div class="message-success">
				<c:choose>
					<c:when test="${param.message == 'added'}">✅ 호텔이 성공적으로 추가되었습니다.</c:when>
					<c:when test="${param.message == 'updated'}">✅ 호텔이 성공적으로 수정되었습니다.</c:when>
					<c:when test="${param.message == 'deleted'}">✅ 호텔이 성공적으로 삭제되었습니다.</c:when>
				</c:choose>
			</div>
		</c:if>

		<c:if test="${param.error != null}">
			<div class="message-error">❌ 작업 처리 중 오류가 발생했습니다.</div>
		</c:if>

		<!-- 통계 카드 -->
		<div class="stats-container">
			<div class="stat-card">
				<h3><%=totalHotels%></h3>
				<p>전체 호텔</p>
			</div>
			<div class="stat-card">
				<h3><%=regionCount%></h3>
				<p>등록 지역</p>
			</div>
			<div class="stat-card">
				<h3><%=totalLikes%></h3>
				<p>총 좋아요</p>
			</div>
		</div>



		<!-- 관리 도구 -->
		<div class="admin-controls">
			<div class="search-container">
				<input type="text" class="search-box" id="searchInput"
					placeholder="호텔 검색 (호텔명, 위치, 지역)...">
				<span class="search-icon">🔍</span>
			</div>
			
			<div class="category-filters">
				<button class="category-btn active" data-category="">전체</button>
				<button class="category-btn" data-category="luxury">럭셔리</button>
				<button class="category-btn" data-category="business">비즈니스</button>
				<button class="category-btn" data-category="resort">리조트</button>
				<button class="category-btn" data-category="pension">펜션</button>
				<button class="category-btn" data-category="motel">모텔</button>
				<button class="category-btn" data-category="guesthouse">게스트하우스</button>
			</div>
			
			<div class="filter-container">
				<select class="filter-select" id="regionFilter">
					<option value="">전체 지역</option>
					<option value="seoul">서울</option>
					<option value="busan">부산</option>
					<option value="jeju">제주</option>
					<option value="gyeonggi">경기</option>
					<option value="gangwon">강원</option>
					<option value="chungbuk">충북</option>
					<option value="chungnam">충남</option>
					<option value="jeonbuk">전북</option>
					<option value="jeonnam">전남</option>
					<option value="gyeongbuk">경북</option>
					<option value="gyeongnam">경남</option>
				</select>
			</div>
			
			<button class="add-btn" onclick="openModal('add')">+ 새 호텔 추가</button>
		</div>

		<!-- 호텔 목록 테이블 -->
		<table class="hotel-table" id="hotelTable">
			<thead>
				<tr>
					<th width="8%">번호</th>
					<th width="10%">이미지</th>
					<th width="25%">호텔명/위치</th>
					<th width="15%">지역/카테고리</th>
					<th width="12%">가격</th>
					<th width="15%">평점/등급</th>
					<th width="8%">좋아요</th>
					<th width="7%">관리</th>
				</tr>
			</thead>
			<tbody id="hotelTableBody">
				<!-- JavaScript로 동적 생성 -->
			</tbody>
		</table>

		<!-- 페이징 -->
		<div class="pagination">
			<button type="button" id="prevBtn" class="nav-btn">
				<span>◀</span>&nbsp;&nbsp;이전
			</button>
			<div id="pageNumbers"></div>
			<button type="button" id="nextBtn" class="nav-btn">
				다음&nbsp;&nbsp;<span>▶</span>
			</button>
		</div>
	</div>

	<!-- 호텔 추가/수정 모달 -->
	<div id="hotelModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h3 id="modalTitle">새 호텔 추가</h3>
			<div id="loadingMessage" class="loading" style="display: none;">
				<i class="fas fa-spinner fa-spin"></i> 데이터를 불러오는 중...
			</div>
			<form id="hotelForm" onsubmit="saveHotel(event)">
				<input type="hidden" id="hotelId" value="">

				<div class="form-group">
					<label for="hotelName">호텔명 *</label> 
					<input type="text" id="hotelName" name="name" required>
				</div>

				<div class="form-group">
					<label for="hotelLocation">위치 *</label> 
					<input type="text" id="hotelLocation" name="location" required>
				</div>

				<div class="form-group">
					<label for="hotelRegion">지역 *</label> 
					<select id="hotelRegion" name="region" required>
						<option value="">지역 선택</option>
						<option value="seoul">서울</option>
						<option value="busan">부산</option>
						<option value="jeju">제주</option>
						<option value="gyeonggi">경기</option>
						<option value="gangwon">강원</option>
						<option value="chungbuk">충북</option>
						<option value="chungnam">충남</option>
						<option value="jeonbuk">전북</option>
						<option value="jeonnam">전남</option>
						<option value="gyeongbuk">경북</option>
						<option value="gyeongnam">경남</option>
					</select>
				</div>

				<div class="form-group">
					<label for="hotelCategory">카테고리 *</label> 
					<select id="hotelCategory" name="category" required>
						<option value="">카테고리 선택</option>
						<option value="luxury">럭셔리</option>
						<option value="business">비즈니스</option>
						<option value="resort">리조트</option>
						<option value="pension">펜션</option>
						<option value="motel">모텔</option>
						<option value="guesthouse">게스트하우스</option>
					</select>
				</div>

				<div class="form-group">
					<label for="hotelPrice">가격 (1박 기준) *</label> 
					<input type="number" id="hotelPrice" name="price" min="10000" required>
				</div>

				<div class="form-group">
					<label for="hotelStarRating">호텔 등급 *</label> 
					<select id="hotelStarRating" name="starRating" required>
						<option value="">등급 선택</option>
						<option value="1">1성급</option>
						<option value="2">2성급</option>
						<option value="3">3성급</option>
						<option value="4">4성급</option>
						<option value="5">5성급</option>
					</select>
				</div>

				<div class="form-group">
					<label for="hotelRating">평점 (0.0 ~ 10.0)</label> 
					<input type="number" id="hotelRating" name="rating" min="0" max="10" step="0.1" value="8.0">
				</div>

				<div class="form-group">
					<label for="hotelImageUrl">이미지 URL</label> 
					<input type="url" id="hotelImageUrl" name="imageUrl" placeholder="https://...">
				</div>

				<div class="form-group">
					<label for="hotelAmenities">편의시설 (쉼표로 구분)</label> 
					<input type="text" id="hotelAmenities" name="amenities" placeholder="무료 WiFi,수영장,스파,주차장">
				</div>

				<div class="form-group">
					<label for="hotelDescription">설명</label>
					<textarea id="hotelDescription" name="description" placeholder="호텔에 대한 간단한 설명을 입력하세요"></textarea>
				</div>

				<div class="modal-buttons">
					<button type="submit" class="save-btn">저장</button>
					<button type="button" class="cancel-btn" onclick="closeModal()">취소</button>
				</div>
			</form>
		</div>
	</div>

	<script>
        // 전역 변수
        let allHotels = []; // 모든 호텔 데이터
        let filteredHotels = []; // 필터링된 호텔 데이터  
        let currentPage = 1;
        const itemsPerPage = 7;
        let editingId = null;

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            // 서버에서 받은 데이터를 JavaScript 배열로 변환
            initializeHotelData();
            
            // 기본 기능 초기화
            initSearch();
            initModalEvents();
            
            // 페이징 초기화
            setupPagination();
            renderHotelTable();
            
            // 가격 입력 필드 포맷팅
            const priceInput = document.getElementById('hotelPrice');
            priceInput.addEventListener('input', function() {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        });

        // 서버 데이터를 JavaScript 배열로 변환
        function initializeHotelData() {
            allHotels = [];
            
            <c:forEach var="hotel" items="${hotelList}" varStatus="vs">
                allHotels.push({
                    index: ${vs.index + 1},
                    id: ${hotel.id},
                    name: '${hotel.name}',
                    location: '${hotel.location}',
                    region: '${hotel.region}',
                    regionDisplayName: '${hotel.regionDisplayName}',
                    category: '${hotel.category}',
                    categoryDisplayName: '${hotel.categoryDisplayName}',
                    price: ${hotel.price},
                    formattedPrice: '${hotel.formattedPrice}',
                    starRating: ${hotel.starRating},
                    rating: ${hotel.rating},
                    formattedRating: '${hotel.formattedRating}',
                    likeCount: ${hotel.likeCount},
                    imageUrl: '${hotel.safeImageUrl}',
                    amenitiesStr: '${hotel.amenitiesStr != null ? hotel.amenitiesStr : ""}',
                    description: '${hotel.description != null ? hotel.description : ""}'
                });
            </c:forEach>
            
            filteredHotels = [...allHotels];
        }

        // 페이징 설정
        function setupPagination() {
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            
            if (prevBtn && nextBtn) {
                prevBtn.addEventListener('click', function() {
                    if (currentPage > 1) {
                        currentPage--;
                        renderHotelTable();
                        updatePaginationUI();
                    }
                });
                
                nextBtn.addEventListener('click', function() {
                    const totalPages = Math.ceil(filteredHotels.length / itemsPerPage);
                    if (currentPage < totalPages) {
                        currentPage++;
                        renderHotelTable();
                        updatePaginationUI();
                    }
                });
            }
        }

        // 테이블 렌더링
        function renderHotelTable() {
            const tbody = document.getElementById('hotelTableBody');
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const currentPageHotels = filteredHotels.slice(startIndex, endIndex);
            
            // 테이블 내용 생성
            let tableHTML = '';
            currentPageHotels.forEach((hotel, index) => {
                const globalIndex = startIndex + index + 1;
                
                // 별점 생성
                let stars = '';
                for (let i = 0; i < hotel.starRating; i++) {
                    stars += '★';
                }
                
                tableHTML += `
                    <tr data-category="\${hotel.category}" data-region="\${hotel.region}">
                        <td>\${globalIndex}</td>
                        <td><img src="\${hotel.imageUrl}" alt="\${hotel.name}" class="hotel-image-thumb"></td>
                        <td>
                            <div class="hotel-name">\${hotel.name}</div>
                            <div class="hotel-location">\${hotel.location}</div>
                        </td>
                        <td>
                            <div>\${hotel.regionDisplayName}</div>
                            <span class="category-tag">\${hotel.categoryDisplayName}</span>
                        </td>
                        <td>
                            <div class="price-display">₩\${hotel.formattedPrice}</div>
                        </td>
                        <td>
                            <div class="rating-display">
                                <span class="stars">\${stars}</span>
                                <span>\${hotel.formattedRating}</span>
                            </div>
                        </td>
                        <td><i class="fas fa-heart" style="color: #e53e3e;"></i> \${hotel.likeCount}</td>
                        <td>
                            <div class="action-buttons">
                                <button class="edit-btn" onclick="editHotel(\${hotel.id})">수정</button>
                                <button class="delete-btn" onclick="deleteHotel(\${hotel.id})">삭제</button>
                            </div>
                        </td>
                    </tr>
                `;
            });
            
            tbody.innerHTML = tableHTML;
            updatePaginationUI();
        }

        // 페이징 UI 업데이트
        function updatePaginationUI() {
            const totalPages = Math.ceil(filteredHotels.length / itemsPerPage);
            
            // 버튼 상태 업데이트
            document.getElementById('prevBtn').disabled = currentPage <= 1;
            document.getElementById('nextBtn').disabled = currentPage >= totalPages;
            
            // 페이지 번호 버튼 생성
            const pageNumbers = document.getElementById('pageNumbers');
            pageNumbers.innerHTML = '';
            
            const startPage = Math.max(1, currentPage - 2);
            const endPage = Math.min(totalPages, currentPage + 2);
            
            for (let i = startPage; i <= endPage; i++) {
                const pageBtn = document.createElement('button');
                pageBtn.textContent = i;
                pageBtn.onclick = () => goToPage(i);
                if (i === currentPage) {
                    pageBtn.classList.add('active');
                }
                pageNumbers.appendChild(pageBtn);
            }
        }

        // 페이지 이동
        function goToPage(page) {
            const totalPages = Math.ceil(filteredHotels.length / itemsPerPage);
            if (page >= 1 && page <= totalPages) {
                currentPage = page;
                renderHotelTable();
            }
        }

        // 검색 및 필터 기능
        function initSearch() {
            const searchInput = document.getElementById('searchInput');
            const categoryBtns = document.querySelectorAll('.category-btn');
            const regionFilter = document.getElementById('regionFilter');
            
            let selectedCategory = '';
            
            // 카테고리 버튼 이벤트
            categoryBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    // 모든 버튼에서 active 클래스 제거
                    categoryBtns.forEach(b => b.classList.remove('active'));
                    // 클릭된 버튼에 active 클래스 추가
                    this.classList.add('active');
                    
                    selectedCategory = this.dataset.category;
                    applyFilters();
                });
            });
            
            function applyFilters() {
                const searchTerm = searchInput.value.toLowerCase();
                const selectedRegion = regionFilter.value;
                
                filteredHotels = allHotels.filter(hotel => {
                    const matchesSearch = hotel.name.toLowerCase().includes(searchTerm) || 
                                        hotel.location.toLowerCase().includes(searchTerm) || 
                                        hotel.regionDisplayName.toLowerCase().includes(searchTerm);
                    
                    const matchesCategory = !selectedCategory || hotel.category === selectedCategory;
                    const matchesRegion = !selectedRegion || hotel.region === selectedRegion;
                    
                    return matchesSearch && matchesCategory && matchesRegion;
                });
                
                currentPage = 1; // 필터링 후 첫 페이지로
                renderHotelTable();
            }
            
            searchInput.addEventListener('input', applyFilters);
            regionFilter.addEventListener('change', applyFilters);
        }

        // 모달 관련 함수
        function openModal(mode, id = null) {
            const modal = document.getElementById('hotelModal');
            const modalTitle = document.getElementById('modalTitle');
            const form = document.getElementById('hotelForm');
            
            editingId = id;
            
            if (mode === 'add') {
                modalTitle.textContent = '새 호텔 추가';
                form.reset();
                document.getElementById('hotelId').value = '';
                document.getElementById('hotelRating').value = '8.0';
            } else if (mode === 'edit') {
                modalTitle.textContent = '호텔 정보 수정';
                loadHotelData(id);
            }
            
            modal.style.display = 'block';
        }

        function closeModal() {
            const modal = document.getElementById('hotelModal');
            modal.style.display = 'none';
            editingId = null;
        }

        // 호텔 데이터 로드 (수정용) - AJAX로 서버에서 가져오기
        function loadHotelData(id) {
            const form = document.getElementById('hotelForm');
            const loading = document.getElementById('loadingMessage');
            
            // 로딩 표시
            form.style.display = 'none';
            loading.style.display = 'block';
            
            // AJAX 요청
            fetch('Hoteladmin.jsp?ajax=getHotel&hotelId=' + id)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('호텔 정보를 불러올 수 없습니다.');
                    }
                    return response.json();
                })
                .then(hotel => {
                    // 폼에 데이터 채우기
                    document.getElementById('hotelId').value = hotel.id;
                    document.getElementById('hotelName').value = hotel.name || '';
                    document.getElementById('hotelLocation').value = hotel.location || '';
                    document.getElementById('hotelRegion').value = hotel.region || '';
                    document.getElementById('hotelCategory').value = hotel.category || '';
                    document.getElementById('hotelPrice').value = hotel.price || '';
                    document.getElementById('hotelStarRating').value = hotel.starRating || '';
                    document.getElementById('hotelRating').value = hotel.rating || '8.0';
                    document.getElementById('hotelImageUrl').value = hotel.imageUrl || '';
                    document.getElementById('hotelAmenities').value = hotel.amenitiesStr || '';
                    document.getElementById('hotelDescription').value = hotel.description || '';
                    
                    // 로딩 숨기고 폼 표시
                    loading.style.display = 'none';
                    form.style.display = 'block';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('호텔 정보를 불러오는 중 오류가 발생했습니다.');
                    loading.style.display = 'none';
                    form.style.display = 'block';
                });
        }

        // 호텔 수정
        function editHotel(id) {
            openModal('edit', id);
        }

        // 호텔 삭제
        function deleteHotel(id) {
            if (confirm('정말로 이 호텔을 삭제하시겠습니까?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'Hotelaction.jsp';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'hotelId';
                idInput.value = id;
                form.appendChild(idInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }

        // 호텔 저장
        function saveHotel(event) {
            event.preventDefault();
            
            const formData = new FormData(event.target);
            const hotelId = document.getElementById('hotelId').value;
            
            // 필수 필드 검증
            const name = formData.get('name');
            const location = formData.get('location');
            const region = formData.get('region');
            const category = formData.get('category');
            const price = formData.get('price');
            const starRating = formData.get('starRating');
            
            if (!name || !location || !region || !category || !price || !starRating) {
                alert('모든 필수 항목을 입력해주세요.');
                return;
            }
            
            // 폼 생성하여 서버로 전송
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'Hotelaction.jsp';
            
            // action 필드
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = hotelId ? 'update' : 'insert';
            form.appendChild(actionInput);
            
            // 모든 폼 데이터 추가
            for (let [key, value] of formData.entries()) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = value;
                form.appendChild(input);
            }
            
            // hotelId가 있으면 추가
            if (hotelId) {
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'hotelId';
                idInput.value = hotelId;
                form.appendChild(idInput);
            }
            
            document.body.appendChild(form);
            form.submit();
        }

        // 모달 외부 클릭 시 닫기
        function initModalEvents() {
            const modal = document.getElementById('hotelModal');
            window.addEventListener('click', function(event) {
                if (event.target === modal) {
                    closeModal();
                }
            });
        }
    </script>

	<%@ include file="Footer.jsp"%>
</body>
</html>