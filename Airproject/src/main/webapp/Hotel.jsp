<%@page import="dto.Hotel"%>
<%@page import="dao.HotelDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%
HotelDao hotelDao = new HotelDao();
List<Hotel> hotelList = hotelDao.getDomesticHotels();
request.setAttribute("hotelList", hotelList);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>국내 호텔 - SkyBooking</title>
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
	font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
		sans-serif;
	line-height: 1.6;
	background: #f8fafc;
}

/* 페이지 헤더 */
.page-header {
	background: linear-gradient(135deg, #004B85, #29B6F6);
	color: white;
	padding: 60px 0;
	text-align: center;
}

.page-title {
	font-size: 2.5rem;
	font-weight: 700;
	margin-bottom: 10px;
}

.page-subtitle {
	font-size: 1.2rem;
	opacity: 0.9;
}

/* 메인 컨테이너 */
.main-container {
	max-width: 1200px;
	margin: 0 auto;
	padding: 40px 20px;
	display: grid;
	grid-template-columns: 350px 1fr;
	gap: 30px;
}

/* 사이드바 */
.sidebar {
	background: white;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	height: fit-content;
	position: sticky;
	top: 100px;
}

.filter-title {
	font-size: 1.2rem;
	font-weight: 700;
	color: #004B85;
	margin-bottom: 15px;
	border-bottom: 2px solid #f0f0f0;
	padding-bottom: 8px;
}

.filter-group {
	margin-bottom: 20px;
}

.filter-label {
	display: block;
	font-weight: 600;
	color: #333;
	margin-bottom: 8px;
}

.filter-select, .filter-input {
	width: 100%;
	padding: 10px;
	border: 2px solid #e2e8f0;
	border-radius: 8px;
	font-size: 14px;
	transition: border-color 0.3s;
}

.filter-select:focus, .filter-input:focus {
	outline: none;
	border-color: #004B85;
}

.price-range {
	display: flex;
	gap: 10px;
	align-items: center;
}

.price-range span {
	color: #666;
	font-weight: 600;
}

.search-btn {
	width: 100%;
	background: #004B85;
	color: white;
	border: none;
	padding: 12px 20px;
	border-radius: 8px;
	font-weight: 600;
	cursor: pointer;
	margin-bottom: 20px;
	transition: all 0.3s;
}

.search-btn:hover {
	background: #29B6F6;
	transform: translateY(-1px);
}

.reset-btn {
	width: 100%;
	background: #6c757d;
	color: white;
	border: none;
	padding: 8px 16px;
	border-radius: 6px;
	font-weight: 500;
	cursor: pointer;
	margin-bottom: 20px;
	font-size: 13px;
}

.reset-btn:hover {
	background: #5a6268;
}

.popular-tag {
	background: #004B85;
	color: white;
	padding: 4px 8px;
	border-radius: 12px;
	font-size: 11px;
	cursor: pointer;
	transition: all 0.3s;
}

.popular-tag:hover {
	background: #29B6F6;
	transform: translateY(-1px);
}

/* 호텔 섹션 */
.hotels-section {
	background: white;
	border-radius: 12px;
	padding: 30px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.section-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 25px;
}

.section-title {
	font-size: 1.5rem;
	font-weight: 700;
	color: #004B85;
}

.sort-controls {
	display: flex;
	gap: 10px;
}

.sort-select {
	padding: 8px 12px;
	border: 2px solid #e2e8f0;
	border-radius: 6px;
}

/* 로딩 */
.loading {
	display: none;
	text-align: center;
	padding: 50px;
	color: #666;
}

.loading.show {
	display: block;
}

.no-results {
	display: none;
	text-align: center;
	padding: 50px;
	color: #666;
}

.no-results.show {
	display: block;
}

/* 호텔 그리드 */
.hotels-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
	gap: 25px;
}

.hotel-card {
	background: white;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	transition: all 0.3s;
	border: 1px solid #e2e8f0;
}

.hotel-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
}

.hotel-image {
	position: relative;
	height: 200px;
	overflow: hidden;
}

.hotel-image img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	transition: transform 0.3s;
}

.hotel-card:hover .hotel-image img {
	transform: scale(1.05);
}

.like-btn {
	position: absolute;
	top: 15px;
	right: 15px;
	background: rgba(255, 255, 255, 0.9);
	border: none;
	border-radius: 50%;
	width: 40px;
	height: 40px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	  transition: all 0.2s ease;
	backdrop-filter: blur(10px);
}

.like-btn:hover {
	background: white;
	transform: scale(1.1) !important;
}

.like-btn.liked {
	 color: #e53e3e;
    background: rgba(229, 62, 62, 0.1);
}
.like-btn:disabled {
    cursor: not-allowed;
}
.hotel-badge {
	position: absolute;
	top: 15px;
	left: 15px;
	background: #004B85;
	color: white;
	padding: 4px 8px;
	border-radius: 4px;
	font-size: 12px;
	font-weight: 600;
}

.hotel-info {
	padding: 20px;
}

.hotel-rating {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-bottom: 8px;
}

.stars {
	color: #fbbf24;
}

.rating-score {
	background: #004B85;
	color: white;
	padding: 2px 6px;
	border-radius: 4px;
	font-size: 12px;
	font-weight: 600;
}

.hotel-name {
	font-size: 1.2rem;
	font-weight: 700;
	color: #1a202c;
	margin-bottom: 8px;
}

.hotel-location {
	color: #64748b;
	font-size: 14px;
	margin-bottom: 12px;
	display: flex;
	align-items: center;
	gap: 5px;
}

.hotel-amenities {
	display: flex;
	flex-wrap: wrap;
	gap: 6px;
	margin-bottom: 15px;
}

.amenity-tag {
	background: #f1f5f9;
	color: #475569;
	padding: 3px 8px;
	border-radius: 12px;
	font-size: 12px;
}

.hotel-price {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.price {
	font-size: 1.3rem;
	font-weight: 700;
	color: #004B85;
}

.price-unit {
	font-size: 14px;
	color: #64748b;
	font-weight: normal;
}

.book-btn {
	background: #29B6F6;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s;
}

.book-btn:hover {
	background: #004B85;
	transform: translateY(-1px);
}

.hotel-stats {
	display: flex;
	align-items: center;
	gap: 15px;
	margin-bottom: 10px;
	font-size: 14px;
	color: #666;
}

.like-count {
	display: flex;
	align-items: center;
	gap: 4px;
}

/* 반응형 */
@media ( max-width : 768px) {
	.main-container {
		grid-template-columns: 1fr;
		padding: 20px 15px;
	}
	.sidebar {
		position: static;
		margin-bottom: 20px;
	}
	.hotels-grid {
		grid-template-columns: 1fr;
	}
	.price-range {
		flex-direction: column;
		gap: 5px;
	}
}
</style>
</head>
<body>
	<%@ include file="Navi.jsp"%>

	<!-- 페이지 헤더 -->
	<section class="page-header">
		<h1 class="page-title">국내 호텔</h1>
		<p class="page-subtitle">전국 각지의 엄선된 호텔을 만나보세요</p>
	</section>

	<!-- 메인 컨테이너 -->
	<div class="main-container">
		<!-- 사이드바 -->
		<aside class="sidebar">
			<h3 class="filter-title">필터</h3>

			<div class="filter-group">
				<label class="filter-label">지역</label> <select class="filter-select"
					id="regionFilter">
					<option value="">전체</option>
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

			<div class="filter-group">
				<label class="filter-label">호텔 등급</label> <select
					class="filter-select" id="starFilter">
					<option value="">전체</option>
					<option value="5">5성급</option>
					<option value="4">4성급</option>
					<option value="3">3성급</option>
					<option value="2">2성급 이하</option>
				</select>
			</div>

			<div class="filter-group">
				<label class="filter-label">가격대 (1박 기준)</label>
				<div class="price-range">
					<input type="number" class="filter-input" placeholder="최소가격"
						id="minPrice" min="0"> <span>~</span> <input type="number"
						class="filter-input" placeholder="최대가격" id="maxPrice" min="0">
				</div>
			</div>

			<div class="filter-group">
				<label class="filter-label">호텔명 검색</label> <input type="text"
					class="filter-input" placeholder="호텔명을 입력하세요" id="hotelSearch">
			</div>

			<button class="search-btn" onclick="applyFilters()">
				<i class="fas fa-search"></i> 필터 적용
			</button>

			<button class="reset-btn" onclick="resetFilters()">
				<i class="fas fa-undo"></i> 필터 초기화
			</button>

			<!-- 인기 검색어 -->
			<div
				style="margin-top: 20px; padding: 15px; background: #f8fafc; border-radius: 8px;">
				<h4 style="color: #004B85; margin-bottom: 10px; font-size: 14px;">🔥
					인기 검색어</h4>
				<div style="display: flex; flex-wrap: wrap; gap: 5px;">
					<span class="popular-tag" onclick="searchPopular('서울')">서울</span> <span
						class="popular-tag" onclick="searchPopular('부산')">부산</span> <span
						class="popular-tag" onclick="searchPopular('제주')">제주</span> <span
						class="popular-tag" onclick="searchPopular('경주')">경주</span> <span
						class="popular-tag" onclick="searchPopular('강릉')">강릉</span>
				</div>
			</div>
		</aside>

		<!-- 호텔 리스트 -->
		<main class="hotels-section">
			<div class="section-header">
				<h2 class="section-title">호텔 목록</h2>
				<div class="sort-controls">
					<select class="sort-select" id="sortSelect" onchange="sortHotels()">
						<option value="recommend">추천순</option>
						<option value="price_low">가격 낮은순</option>
						<option value="price_high">가격 높은순</option>
						<option value="rating">평점순</option>
						<option value="like">좋아요순</option>
					</select>
				</div>
			</div>

			<!-- 로딩 -->
			<div class="loading" id="loading">
				<i class="fas fa-spinner fa-spin"
					style="font-size: 2rem; margin-bottom: 10px;"></i>
				<p>호텔을 검색하고 있습니다...</p>
			</div>

			<!-- 검색 결과 없음 -->
			<div class="no-results" id="noResults">
				<i class="fas fa-search"
					style="font-size: 3rem; margin-bottom: 15px; color: #ccc;"></i>
				<h3>검색 결과가 없습니다</h3>
				<p>다른 조건으로 검색해보세요.</p>
			</div>

			<!-- 호텔 그리드 -->
			<div class="hotels-grid" id="hotelsGrid">
				<c:forEach var="hotel" items="${hotelList}">
					<div class="hotel-card" data-region="${hotel.region}"
						data-star="${hotel.starRating}" data-price="${hotel.price}"
						data-name="${hotel.name}" data-category="${hotel.category}"
						data-hotel-id="${hotel.id}">
						<div class="hotel-image">
							<img src="${hotel.safeImageUrl}" alt="${hotel.name}"
								onerror="this.src='https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=200&fit=crop'">
							<button class="like-btn" onclick="toggleLike(this, ${hotel.id})">
								<i class="far fa-heart"></i>
							</button>
							<div class="hotel-badge">${hotel.categoryDisplayName}</div>
						</div>
						<div class="hotel-info">
							<div class="hotel-rating">
								<div class="stars">
									<c:forEach begin="1" end="${hotel.starRating}">★</c:forEach>
								</div>
								<span class="rating-score">${hotel.formattedRating}</span>
							</div>
							<h3 class="hotel-name">${hotel.name}</h3>
							<div class="hotel-location">
								<i class="fas fa-map-marker-alt"></i> ${hotel.location}
							</div>
							<div class="hotel-stats">
								<div class="like-count">
									<i class="fas fa-heart" style="color: #e53e3e;"></i> <span>${hotel.likeCount}</span>
								</div>
								<div>
									<i class="fas fa-eye"></i> <span>조회 ${hotel.id * 127}</span>
								</div>
							</div>
							<div class="hotel-amenities">
								<c:forEach var="amenity" items="${hotel.amenities}">
									<span class="amenity-tag">${amenity}</span>
								</c:forEach>
							</div>
							<div class="hotel-price">
								<div class="price">
									₩${hotel.formattedPrice} <span class="price-unit">/박</span>
								</div>
								<button class="book-btn" onclick="bookHotel(${hotel.id})">예약하기</button>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</main>
	</div>

	<script>
 // ========== 기존 JSP 파일의 <script> 태그 안에서 다음 함수들을 교체해주세요 ==========

 // 좋아요 토글 (서버 연동 버전) - 기존 toggleLike() 함수를 이것으로 교체
 function toggleLike(button, hotelId) {
     const icon = button.querySelector('i');
     const card = button.closest('.hotel-card');
     const likeCountSpan = card.querySelector('.like-count span');
     let currentCount = parseInt(likeCountSpan.textContent);
     
     // 로그인 체크
     const isLoggedIn = ${not empty sessionScope.id};
     if (!isLoggedIn) {
         if (confirm('좋아요 기능을 사용하려면 로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?')) {
             location.href = 'login';
         }
         return;
     }
     
     // 버튼 비활성화 (중복 클릭 방지)
     button.disabled = true;
     button.style.opacity = '0.6';
     
     const isLiked = icon.classList.contains('fas');
     const action = isLiked ? 'unlike' : 'like';
     
     // 서버에 좋아요 상태 전송
     fetch('likeHotel', {
         method: 'POST',
         headers: {
             'Content-Type': 'application/x-www-form-urlencoded',
         },
         body: 'hotelId=' + hotelId + '&action=' + action
     })
     .then(response => response.text())
     .then(data => {
         if (data.startsWith('SUCCESS:')) {
             const newLikeCount = data.split(':')[1];
             
             if (isLiked) {
                 // 좋아요 취소
                 icon.classList.remove('fas');
                 icon.classList.add('far');
                 button.classList.remove('liked');
                 
                 // 취소 애니메이션
                 button.style.transform = 'scale(0.9)';
                 setTimeout(() => {
                     button.style.transform = 'scale(1)';
                 }, 150);
                 
                 console.log('Hotel ' + hotelId + ' unliked');
             } else {
                 // 좋아요 추가
                 icon.classList.remove('far');
                 icon.classList.add('fas');
                 button.classList.add('liked');
                 
                 // 좋아요 애니메이션
                 button.style.transform = 'scale(1.3)';
                 button.style.color = '#e53e3e';
                 setTimeout(() => {
                     button.style.transform = 'scale(1)';
                 }, 200);
                 
                 // 하트 터지는 효과
                 createHeartAnimation(button);
                 
                 console.log('Hotel ' + hotelId + ' liked');
             }
             
             // 서버에서 반환된 정확한 좋아요 수로 업데이트
             likeCountSpan.textContent = newLikeCount;
             
         } else if (data.startsWith('ERROR:')) {
             const errorMessage = data.split(':')[1];
             alert('오류: ' + errorMessage);
         }
     })
     .catch(error => {
         console.error('좋아요 처리 오류:', error);
         alert('네트워크 오류가 발생했습니다. 다시 시도해주세요.');
     })
     .finally(() => {
         // 버튼 재활성화
         button.disabled = false;
         button.style.opacity = '1';
     });
 }

 // 하트 애니메이션 효과 - 새로 추가할 함수
 function createHeartAnimation(button) {
     const heart = document.createElement('div');
     heart.innerHTML = '❤️';
     heart.style.position = 'fixed';
     heart.style.fontSize = '20px';
     heart.style.color = '#e53e3e';
     heart.style.pointerEvents = 'none';
     heart.style.zIndex = '1000';
     heart.style.transition = 'all 1s ease-out';
     
     // 버튼 위치 기준으로 하트 위치 설정
     const rect = button.getBoundingClientRect();
     heart.style.left = (rect.left + rect.width / 2) + 'px';
     heart.style.top = rect.top + 'px';
     
     document.body.appendChild(heart);
     
     // 애니메이션 시작
     setTimeout(() => {
         heart.style.transform = 'translateY(-40px) scale(0.5)';
         heart.style.opacity = '0';
     }, 50);
     
     // 애니메이션 후 제거
     setTimeout(() => {
         if (heart.parentNode) {
             heart.parentNode.removeChild(heart);
         }
     }, 1000);
 }
        // 필터 적용
        function applyFilters() {
            const region = document.getElementById('regionFilter').value;
            const star = document.getElementById('starFilter').value;
            const minPrice = parseInt(document.getElementById('minPrice').value) || 0;
            const maxPrice = parseInt(document.getElementById('maxPrice').value) || Infinity;
            const searchText = document.getElementById('hotelSearch').value.toLowerCase();
            
            showLoading(true);
            
            setTimeout(() => {
                const cards = document.querySelectorAll('.hotel-card');
                let visibleCount = 0;
                
                cards.forEach(card => {
                    const cardRegion = card.dataset.region;
                    const cardStar = card.dataset.star;
                    const cardPrice = parseInt(card.dataset.price);
                    const cardName = card.dataset.name.toLowerCase();
                    
                    let visible = true;
                    
                    // 지역 필터
                    if (region && cardRegion !== region) {
                        visible = false;
                    }
                    
                    // 별점 필터
                    if (star && cardStar !== star) {
                        visible = false;
                    }
                    
                    // 가격 필터
                    if (cardPrice < minPrice || cardPrice > maxPrice) {
                        visible = false;
                    }
                    
                    // 이름 검색
                    if (searchText && !cardName.includes(searchText)) {
                        visible = false;
                    }
                    
                    if (visible) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });
                
                showLoading(false);
                
                if (visibleCount === 0) {
                    document.getElementById('noResults').classList.add('show');
                } else {
                    document.getElementById('noResults').classList.remove('show');
                }
            }, 300);
        }
        
        // 필터 초기화
        function resetFilters() {
            document.getElementById('regionFilter').value = '';
            document.getElementById('starFilter').value = '';
            document.getElementById('minPrice').value = '';
            document.getElementById('maxPrice').value = '';
            document.getElementById('hotelSearch').value = '';
            document.getElementById('sortSelect').value = 'recommend';
            
            const cards = document.querySelectorAll('.hotel-card');
            cards.forEach(card => {
                card.style.display = 'block';
            });
            
            document.getElementById('noResults').classList.remove('show');
        }
        
        // 정렬
        function sortHotels() {
            const sortType = document.getElementById('sortSelect').value;
            const grid = document.getElementById('hotelsGrid');
            const cards = Array.from(grid.children);
            
            cards.sort((a, b) => {
                switch (sortType) {
                    case 'price_low':
                        return parseInt(a.dataset.price) - parseInt(b.dataset.price);
                    case 'price_high':
                        return parseInt(b.dataset.price) - parseInt(a.dataset.price);
                    case 'rating':
                        const ratingA = parseFloat(a.querySelector('.rating-score').textContent);
                        const ratingB = parseFloat(b.querySelector('.rating-score').textContent);
                        return ratingB - ratingA;
                    case 'like':
                        const likeA = parseInt(a.querySelector('.like-count span').textContent);
                        const likeB = parseInt(b.querySelector('.like-count span').textContent);
                        return likeB - likeA;
                    default:
                        return 0;
                }
            });
            
            cards.forEach(card => grid.appendChild(card));
        }
        
        // 호텔 예약
        function bookHotel(hotelId) {
            // 로그인 체크
            const isLoggedIn = ${not empty sessionScope.id};
            if (!isLoggedIn) {
                if (confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) {
                    location.href = 'login';
                }
                return;
            }
            
            // 예약 페이지로 이동
            location.href = '' + hotelId;
        }
        
        // 유틸리티 함수들
        function showLoading(show) {
            const loading = document.getElementById('loading');
            const grid = document.getElementById('hotelsGrid');
            
            if (show) {
                loading.classList.add('show');
                grid.style.display = 'none';
            } else {
                loading.classList.remove('show');
                grid.style.display = 'grid';
            }
        }
        
        // 인기 검색어 클릭
        function searchPopular(keyword) {
            document.getElementById('hotelSearch').value = keyword;
            applyFilters();
        }
        
        // 초기화
        document.addEventListener('DOMContentLoaded', function() {
            console.log('페이지 로드 완료');
            
            // 엔터 키로 검색
            const hotelSearchInput = document.getElementById('hotelSearch');
            if (hotelSearchInput) {
                hotelSearchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        applyFilters();
                    }
                });
            }
            
            console.log('필터 시스템 초기화 완료');
        });
    </script>

	<%@ include file="Footer.jsp"%>
</body>
</html>