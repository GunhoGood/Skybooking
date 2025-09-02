<%@page import="dao.FaqDao"%>
<%@page import="dto.FaqDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    FaqDao faqDao = new FaqDao();
    List<FaqDto> faqList = faqDao.getAllFaqs();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자주묻는질문 - SkyBooking</title>
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
    
    .faq-container {
        max-width: 800px;
        margin: 50px auto;
        background: white;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 0 20px rgba(0,0,0,0.1);
        /* 뷰포트 기준으로 fixed 할 것이므로 position: relative; 는 제거합니다. */
        /* position: relative; */
    }
    
    .faq-container h2 {
        text-align: center;
        color: #2563eb;
        margin-bottom: 10px;
        font-size: 28px;
        font-weight: bold;
    }
    
    .faq-container h4 {
        text-align: center;
        color: #666;
        margin-bottom: 30px;
        font-weight: normal;
    }
    
    .search-container {
        position: relative;
        margin-bottom: 30px;
    }
    
    .search-box {
        width: 100%;
        padding: 15px 50px 15px 20px;
        border: 2px solid #ddd;
        border-radius: 8px;
        font-size: 16px;
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
        font-size: 18px;
    }
    
    .faq-item {
        margin-bottom: 15px;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        overflow: hidden;
        transition: all 0.3s ease;
    }
    
    .faq-item:hover {
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    
    .faq-question {
        padding: 20px;
        background-color: #fafafa;
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: bold;
        color: #333;
        transition: background-color 0.3s ease;
    }
    
    .faq-question:hover {
        background-color: #f0f0f0;
    }
    
    .faq-question.active {
        background-color: #2563eb;
        color: white;
    }
    
    .faq-toggle {
        font-size: 18px;
        font-weight: bold;
        transition: transform 0.3s ease;
    }
    
    .faq-toggle.active {
        transform: rotate(45deg);
    }
    
    .faq-answer {
        padding: 0 20px;
        max-height: 0;
        overflow: hidden;
        background-color: white;
        transition: all 0.3s ease;
    }
    
    .faq-answer.active {
        padding: 20px;
        max-height: 500px;
    }
    
    .faq-answer p {
        margin-bottom: 12px;
        color: #555;
        line-height: 1.8;
        white-space: pre-line;
    }
    
    .faq-answer strong {
        color: #2563eb;
    }
    
    .category-filter {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-bottom: 30px;
        flex-wrap: wrap;
    }
    
    .category-btn {
        padding: 10px 20px;
        border: 2px solid #2563eb;
        background-color: white;
        color: #2563eb;
        border-radius: 20px;
        cursor: pointer;
        font-weight: bold;
        transition: all 0.3s ease;
    }
    
    .category-btn:hover,
    .category-btn.active {
        background-color: #2563eb;
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
    }
    
    .no-results {
        text-align: center;
        padding: 40px;
        color: #666;
        font-size: 16px;
        display: none;
    }
    
    .no-results .icon {
        font-size: 48px;
        margin-bottom: 15px;
        color: #ccc;
    }
    
	/* 1:1 문의하기 버튼 컨테이너 스타일 */
    .inquiry-button-container {
	    position: fixed;
	    bottom: 30px;     /* 기존 100px → 30px로 조정 */
	    right: 100px;     /* 더 오른쪽으로 붙이고 싶으면 숫자 조절 */
	    z-index: 1000;
	}

    /* 1:1 문의하기 버튼 스타일 */
    .inquiry-button {
        padding: 12px 25px;
        background-color: #2563eb; /* 버튼 배경색 */
        color: white;             /* 버튼 글자색 */
        border: none;             /* 테두리 없음 */
        border-radius: 5px;       /* 둥근 모서리 */
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.2s ease;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2); /* 그림자 효과 */
    }

    .inquiry-button:hover {
        background-color: #29B6F6;
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
    }
    
    .back-to-top {
        position: fixed;
        bottom: 30px; /* 1:1 문의하기 버튼보다 아래쪽에 위치 */
        right: 30px;
        background-color: #2563eb;
        color: white;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        border: none;
        cursor: pointer;
        font-size: 18px;
        display: none;
        transition: all 0.3s ease;
        z-index: 1000;
    }
    
    .back-to-top:hover {
        background-color: #29B6F6;
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
    }
    
    .back-to-top.show {
        display: block;
    }
    
    @media (max-width: 768px) {
        .faq-container {
            margin: 20px;
            padding: 20px;
        }
        
        .category-filter {
            gap: 5px;
        }
        
        .category-btn {
            padding: 8px 15px;
            font-size: 14px;
        }
        
        .faq-question {
            padding: 15px;
            font-size: 14px;
        }
        
        .faq-answer.active {
            padding: 15px;
        }

        /* 모바일에서 1:1 문의하기 버튼 위치 조정 (fixed 유지) */
        .inquiry-button-container {
	        bottom: 30px;  /* 모바일도 동일한 위치 유지 */
	        right: 20px;
	    }
    }
</style>
</head>
<body>
<%@ include file="Navi.jsp" %>

<div class="faq-container">
    <h2>자주묻는질문</h2>
    <h4>SkyBooking 이용 시 궁금한 점들을 확인해보세요</h4>
    
    <!-- 검색 기능 -->
    <div class="search-container">
        <input type="text" class="search-box" id="searchInput" placeholder="궁금한 내용을 검색해보세요...">
        <span class="search-icon">🔍</span>
    </div>
    
    <!-- 카테고리 필터 -->
    <div class="category-filter">
        <button class="category-btn active" data-category="all">전체</button>
        <button class="category-btn" data-category="booking">예약/결제</button>
        <button class="category-btn" data-category="account">계정/회원</button>
        <button class="category-btn" data-category="service">서비스</button>
        <button class="category-btn" data-category="refund">취소/환불</button>
    </div>
    
    <!-- FAQ 목록 -->
    <div class="faq-list" id="faqList">
        <% for(FaqDto faq : faqList) { %>
        <div class="faq-item" data-category="<%= faq.getCategory() %>">
            <div class="faq-question">
                <span><%= faq.getQuestion() %></span>
                <span class="faq-toggle">+</span>
            </div>
            <div class="faq-answer">
                <p><%= faq.getAnswer() %></p>
            </div>
        </div>
        <% } %>
    </div>
    
    <!-- 검색 결과 없음 -->
    <div class="no-results" id="noResults">
        <div class="icon">❓</div>
        <p>검색 결과가 없습니다.</p>
        <p>다른 검색어를 입력해보시거나 고객센터로 문의해주세요.</p>
    </div>
    <div class="inquiry-button-container">
    	<button class="inquiry-button" onclick="location.href='inquiryWrite'">1:1 문의하기</button>
	</div>
</div>

<!-- 맨 위로 가기 버튼 -->
<button class="back-to-top" id="backToTop">↑</button>

<script>
    // DOM 요소들
    const searchInput = document.getElementById('searchInput');
    const categoryBtns = document.querySelectorAll('.category-btn');
    const faqItems = document.querySelectorAll('.faq-item');
    const faqList = document.getElementById('faqList');
    const noResults = document.getElementById('noResults');
    const backToTop = document.getElementById('backToTop');
    
    // FAQ 아코디언 기능
    function initFaqAccordion() {
        const faqQuestions = document.querySelectorAll('.faq-question');
        
        faqQuestions.forEach(question => {
            question.addEventListener('click', function() {
                const faqItem = this.parentElement;
                const answer = faqItem.querySelector('.faq-answer');
                const toggle = this.querySelector('.faq-toggle');
                
                // 다른 모든 FAQ 닫기
                faqQuestions.forEach(otherQuestion => {
                    if (otherQuestion !== this) {
                        const otherItem = otherQuestion.parentElement;
                        const otherAnswer = otherItem.querySelector('.faq-answer');
                        const otherToggle = otherQuestion.querySelector('.faq-toggle');
                        
                        otherQuestion.classList.remove('active');
                        otherAnswer.classList.remove('active');
                        otherToggle.classList.remove('active');
                    }
                });
                
                // 현재 FAQ 토글
                this.classList.toggle('active');
                answer.classList.toggle('active');
                toggle.classList.toggle('active');
            });
        });
    }
    
    // 카테고리 필터 기능
    function initCategoryFilter() {
        categoryBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                // 활성 버튼 변경
                categoryBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                const category = this.getAttribute('data-category');
                filterFaqItems(category, searchInput.value.toLowerCase());
            });
        });
    }
    
    // 검색 기능
    function initSearch() {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const activeCategory = document.querySelector('.category-btn.active').getAttribute('data-category');
            filterFaqItems(activeCategory, searchTerm);
        });
    }
    
    // FAQ 항목 필터링
    function filterFaqItems(category, searchTerm) {
        let visibleCount = 0;
        
        faqItems.forEach(item => {
            const itemCategory = item.getAttribute('data-category');
            const question = item.querySelector('.faq-question span').textContent.toLowerCase();
            const answer = item.querySelector('.faq-answer').textContent.toLowerCase();
            
            const categoryMatch = category === 'all' || itemCategory === category;
            const searchMatch = !searchTerm || question.includes(searchTerm) || answer.includes(searchTerm);
            
            if (categoryMatch && searchMatch) {
                item.style.display = 'block';
                visibleCount++;
            } else {
                item.style.display = 'none';
                // 숨겨지는 항목의 아코디언 닫기
                const question = item.querySelector('.faq-question');
                const answer = item.querySelector('.faq-answer');
                const toggle = item.querySelector('.faq-toggle');
                
                question.classList.remove('active');
                answer.classList.remove('active');
                toggle.classList.remove('active');
            }
        });
        
        // 검색 결과 없음 표시
        if (visibleCount === 0) {
            noResults.style.display = 'block';
            faqList.style.display = 'none';
        } else {
            noResults.style.display = 'none';
            faqList.style.display = 'block';
        }
    }
    
    // 맨 위로 가기 버튼
    function initBackToTop() {
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                backToTop.classList.add('show');
            } else {
                backToTop.classList.remove('show');
            }
        });
        
        backToTop.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
    
    // 키보드 접근성
    function initKeyboardAccessibility() {
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                if (e.target.classList.contains('faq-question')) {
                    e.target.click();
                } else if (e.target.classList.contains('category-btn')) {
                    e.target.click();
                }
            }
        });
    }
    
    // 초기화
    document.addEventListener('DOMContentLoaded', function() {
        initFaqAccordion();
        initCategoryFilter();
        initSearch();
        initBackToTop();
        initKeyboardAccessibility();
    });
</script>

<%@ include file="Footer.jsp" %>
</body>
</html>