<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>navi</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
<style>
 header.header {
            background-color: #fff;
            color: #004B85;
            position: relative;
            width: 100%;
            z-index: 1000;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 60px;
            padding: 0 20px;
        }

        .logo {
            font-size: 28px;
            font-weight: 700;
            cursor: default;
            user-select: none;
        }

		.logo a {
			cursor: pointer;
            text-decoration: none;
            color: #004B85;
		}

        nav.nav-menu {
            flex-grow: 1;
            margin-left: 40px;
        }

        nav.nav-menu .menu {
            list-style: none;
            display: flex;
            gap: 40px;
        }

        nav.nav-menu .menu>li {
            position: relative;
            cursor: pointer;
            font-weight: 600;
            font-size: 16px;
            color: #004B85;
        }

        nav.nav-menu .menu>li>a {
            color: #004B85;
            text-decoration: none;
            padding: 20px 0;
            display: block;
        }

        nav.nav-menu .menu>li:hover>a {
            color: #0074d9;
        }

        .submenu {
            display: none;
            position: absolute;
            top: 100%;
            left: 0;
            width: 180px;
            background-color: #f5f9fc;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 4px;
            padding: 10px 0;
            z-index: 9999;
        }

        .submenu-inner {
            padding-left: 0;
        }

        .submenu-inner ul {
            list-style: none;
            padding-left: 0;
        }

        .submenu-inner ul li {
            padding: 10px 20px;
            font-weight: 500;
            font-size: 14px;
        }

        .submenu-inner ul li a {
            color: #004B85;
            text-decoration: none;
            display: block;
        }

        .submenu-inner ul li a:hover {
            background-color: #d9e9fc;
            text-decoration: none;
        }

        nav.nav-menu .menu>li:hover .submenu {
            display: block;
        }

        .user-section {
            display: flex;
            gap: 10px;
        }

        .user-section button {
            background-color: transparent;
            border: 1px solid #004B85;
            color: #004B85;
            padding: 6px 12px;
            font-size: 14px;
            border-radius: 3px;
            cursor: pointer;
            transition: background-color 0.3s, color 0.3s;
        }

        .user-section button:hover {
            background-color: #004B85;
            color: white;
            border-color: #004B85;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            background: #f8fafc;
        }

        .header {
            background: white;
            padding: 16px 0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
</style>
</head>
<body>
<header class="header">
        <div class="header-container">
            <div class="logo" ><a href='<c:url value="/main" />'>SkyBooking</a></div>
            <nav class="nav-menu">
                <ul class="menu">
                    <li>
                        <a href="#">항공편</a>
                        <div class="submenu">
                            <div class="submenu-inner">
                                <ul>
                                    <li><a href="#">국내선</a></li>
                                    <li><a href="#">국제선</a></li>
                                    <li><a href="#">특가 항공권</a></li>
                                    <li><a href="#">운항 스케줄</a></li>
                                    <li><a href="#">기내 서비스</a></li>
                                </ul>
                            </div>
                        </div>
                    </li>
                    <li>
                        <a href="#">호텔</a>
                        <div class="submenu">
                            <div class="submenu-inner">
                                <ul>
                                    <li><a href="hotel">국내 호텔</a></li>
                                    <li><a href="#">해외 호텔</a></li>
                                    <li><a href="#">특가 상품</a></li>
                                    <li><a href="#">예약 안내</a></li>
                                </ul>
                            </div>
                        </div>
                    </li>
                    <li>
                        <a href="#">렌터카</a>
                        <div class="submenu">
                            <div class="submenu-inner">
                                <ul>
                                    <li><a href="#">국내 렌터카</a></li>
                                    <li><a href="#">해외 렌터카</a></li>
                                </ul>
                            </div>
                        </div>
                    </li>
                    <li>
                        <a href="#">패키지</a>
                        <div class="submenu">
                            <div class="submenu-inner">
                                <ul>
                                    <li><a href="#">국내 패키지</a></li>
                                    <li><a href="#">해외 패키지</a></li>
                                    <li><a href="#">맞춤형 여행</a></li>
                                </ul>
                            </div>
                        </div>
                    </li>
                    <li>
                        <a href="faq">고객센터</a>
                    </li>
                </ul>
            </nav>
            <div class="user-section">
            	<c:choose>
       		        <c:when test="${sessionScope.user.admin == 1}">
       		        	<div class="session-timer" 
						     data-login-time="${sessionScope.loginTime}" 
						     data-max-interval="${pageContext.session.maxInactiveInterval}">
					  		 <i class="fa-solid fa-clock"></i> <span class="timer-text">계산 중...</span>
						</div>
            			<button class="login-btn" onclick="location.href='faqadmin'">관리자</button>
            			<button class="login-btn" onclick="location.href='mypage'">마이페이지</button>
            			<button class="login-btn" onclick="location.href='logout'">로그아웃</button>
            		</c:when>
            		<c:when test="${not empty sessionScope.id}">
            			<div class="session-timer" 
						     data-login-time="${sessionScope.loginTime}" 
						     data-max-interval="${pageContext.session.maxInactiveInterval}">
					  		 <i class="fa-solid fa-clock"></i> <span class="timer-text">계산 중...</span>
						</div>
            			<button class="login-btn" onclick="location.href='mypage'">마이페이지</button>
            			<button class="login-btn" onclick="location.href='logout'">로그아웃</button>
            		</c:when>
            		<c:otherwise>
						<button class="login-btn" onclick="location.href='login'">로그인</button>
						<button class="signup-btn" onclick="location.href='agree'">회원가입</button>            		
            		</c:otherwise>
            	</c:choose>
            </div>
        </div>
    </header>
<script>
document.addEventListener("DOMContentLoaded", () => {
    const containers = document.querySelectorAll(".session-timer");

    containers.forEach(container => {
        const timerEl = container.querySelector(".timer-text");
        const loginTimeStr = container.dataset.loginTime;
        const maxInterval = parseInt(container.dataset.maxInterval); // 1800초

        if (!loginTimeStr || isNaN(maxInterval)) return;

        const loginTime = new Date(loginTimeStr); // Date 타입으로 변환
        const now = new Date();
        let elapsed = Math.floor((now - loginTime) / 1000); // 경과 시간(초)
        let remaining = maxInterval - elapsed;

        function updateTimer() {
            if (!timerEl) return;

            if (remaining <= 0) {
                timerEl.textContent = "세션 만료됨";
                location.href = "logout";
                return;
            }

            const m = Math.floor(remaining / 60);
            const s = remaining % 60;
            timerEl.textContent = `${'${m}'}분 ${"${s < 10 ? '0' : ''}${s}"}초`;
            remaining--;
        }

        updateTimer();
        const interval = setInterval(updateTimer, 1000);
    });
});
</script>
</body>
</html>