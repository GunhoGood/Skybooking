<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 - SkyBooking</title>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
<style>
.login-section {
            min-height: calc(100vh - 120px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            max-width: 1000px;
            width: 100%;
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 600px;
        }

        /* 로그인 폼 영역 */
        .login-form-section {
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-title {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 8px;
            text-align: center;
        }

        .login-subtitle {
            color: #6b7280;
            text-align: center;
            margin-bottom: 40px;
            font-size: 16px;
        }

        .login-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-group {
            position: relative;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .form-input {
            width: 100%;
            padding: 16px 20px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 16px;
            background: #f9fafb;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #2563eb;
            background: white;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .password-input-container {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: #6b7280;
            font-size: 18px;
        }

        .password-toggle:hover {
            color: #2563eb;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 10px 0;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .remember-me input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: #2563eb;
        }

        .remember-me label {
            font-size: 14px;
            color: #6b7280;
            cursor: pointer;
        }

        .forgot-links {
            display: flex;
            gap: 16px;
        }

        .forgot-link {
            font-size: 14px;
            color: #2563eb;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .forgot-link:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }

        .login-button {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            color: white;
            border: none;
            padding: 16px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .login-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 30px 0;
        }

        .divider-line {
            flex: 1;
            height: 1px;
            background: #e5e7eb;
        }

        .divider-text {
            padding: 0 16px;
            color: #9ca3af;
            font-size: 14px;
        }

        /* 소셜 로그인 */
        .social-login {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .social-button {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            padding: 14px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            background: white;
            color: #374151;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .social-button:hover {
            border-color: #d1d5db;
            background: #f9fafb;
            transform: translateY(-1px);
        }

        .social-button.google {
            border-color: #ea4335;
            color: #ea4335;
        }

        .social-button.google:hover {
            background: #fef2f2;
            border-color: #dc2626;
        }

        .social-button.kakao {
            background: #fee500;
            border-color: #fee500;
            color: #3c1e1e;
        }

        .social-button.kakao:hover {
            background: #fde047;
            border-color: #eab308;
        }

        .social-button.naver {
            background: #03c75a;
            border-color: #03c75a;
            color: white;
        }

        .social-button.naver:hover {
            background: #16a34a;
            border-color: #15803d;
        }

        .signup-link {
            text-align: center;
            margin-top: 30px;
            color: #6b7280;
        }

        .signup-link a {
            color: #2563eb;
            text-decoration: none;
            font-weight: 600;
        }

        .signup-link a:hover {
            text-decoration: underline;
        }

        /* 이미지 섹션 */
        .image-section {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.8), rgba(29, 78, 216, 0.9)), url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><defs><pattern id="plane-pattern" patternUnits="userSpaceOnUse" width="100" height="100" patternTransform="rotate(45)"><path d="M20,20 L80,50 L20,80 Z" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="1000" height="1000" fill="url(%23plane-pattern)"/></svg>');
            background-size: cover;
            background-position: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            padding: 50px;
            position: relative;
            overflow: hidden;
        }

        .image-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(-20px, -20px) rotate(180deg); }
        }

        .image-content {
            position: relative;
            z-index: 2;
        }

        .image-section h2 {
            font-size: 36px;
            font-weight: 700;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .image-section p {
            font-size: 18px;
            opacity: 0.9;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .features-list {
            list-style: none;
            text-align: left;
        }

        .features-list li {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 16px;
            font-size: 16px;
        }

        .features-list li i {
            color: #fbbf24;
            font-size: 18px;
        }
</style>
</head>

<body>
<%@ include file="Navi.jsp" %>

 <section class="login-section">
        <div class="login-container">
            <!-- 로그인 폼 -->
            <div class="login-form-section">
                <h1 class="login-title">로그인</h1>
                <p class="login-subtitle">SkyBooking에 오신 것을 환영합니다</p>

                <form class="login-form" action='<c:url value="/login"/>' method="POST">
                    <div class="form-group">
                        <label class="form-label" for="username">아이디</label>
                        <input type="text" id="username" name="id" class="form-input" 
                               placeholder="아이디를 입력하세요" value="${cookie.id.value}" autofocus required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">비밀번호</label>
                        <div class="password-input-container">
                            <input type="password" id="password" name="pwd" class="form-input" 
                                   placeholder="비밀번호를 입력하세요" required>
                            <button type="button" class="password-toggle"
								onclick="togglePassword('password', 'passwordIcon1')">
								<i class="fas fa-eye" id="passwordIcon1"></i>
							</button>
                        </div>
                    </div>

                    <div class="form-options">
                        <div class="remember-me">
                            <input type="checkbox" id="rememberMe" name="rememberid"  ${not empty cookie.id.value ? "checked" : ""}>
                            <label for="rememberMe">아이디 기억하기</label>
                        </div>
                        <div class="forgot-links">
                            <a href="findId" class="forgot-link">아이디 찾기</a>
                            <a href="findPwd" class="forgot-link">비밀번호 찾기</a>
                        </div>
                    </div>

                    <button type="submit" class="login-button">로그인</button>
                    <input type="hidden" name="url" value="${url}">
                </form>

                <div class="divider">
                    <div class="divider-line"></div>
                    <span class="divider-text">또는</span>
                    <div class="divider-line"></div>
                </div>

                <!-- 소셜 로그인 -->
                <div class="social-login">
                    <a href="#" class="social-button google">
                        <i class="fab fa-google"></i>
                        Google로 로그인
                    </a>
                    <a href="#" class="social-button kakao">
                        <i class="fas fa-comment"></i>
                        카카오로 로그인
                    </a>
                    <a href="#" class="social-button naver">
                        <span style="font-weight: bold;">N</span>
                        네이버로 로그인
                    </a>
                </div>

                <div class="signup-link">
                    아직 계정이 없으신가요? <a href="agree">회원가입</a>
                </div>
            </div>

            <!-- 이미지 섹션 -->
            <div class="image-section">
                <div class="image-content">
                    <h2>세계 어디든<br>함께 떠나요</h2>
                    <p>SkyBooking과 함께 특별한 여행을 시작하세요.<br>최저가 항공편부터 프리미엄 서비스까지</p>
                    
                    <ul class="features-list">
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>전 세계 항공사 실시간 비교</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>24시간 고객지원 서비스</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>안전하고 간편한 예약 시스템</span>
                        </li>
                        <li>
                            <i class="fas fa-check-circle"></i>
                            <span>회원 전용 특별 할인 혜택</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

<%@ include file="Footer.jsp" %>
<script>
	if(${param.loginError != null}) alert("아이디와 비밀번호를 확인해주세요.");
	
	// 비밀번호 토글 기능
	function togglePassword(inputId, iconId) {
		const input = document.getElementById(inputId);
		const icon = document.getElementById(iconId);

		if (input.type === 'password') {
			input.type = 'text';
			icon.classList.remove('fa-eye');
			icon.classList.add('fa-eye-slash');
		} else {
			input.type = 'password';
			icon.classList.remove('fa-eye-slash');
			icon.classList.add('fa-eye');
		}
	}
</script>
</body>
</html>