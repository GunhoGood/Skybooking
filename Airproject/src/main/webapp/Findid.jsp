<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기 - SkyBooking</title>
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
    max-width: 900px;
    width: 100%;
    display: grid;
    grid-template-columns: 1fr 1fr;
    min-height: 550px;
}

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
    box-sizing: border-box;
}

.form-input:focus {
    outline: none;
    border-color: #2563eb;
    background: white;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
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

.back-link {
    text-align: center;
    margin-top: 30px;
    color: #6b7280;
}

.back-link a {
    color: #2563eb;
    text-decoration: none;
    font-weight: 600;
    margin: 0 8px;
}

.back-link a:hover {
    text-decoration: underline;
}

.result-section {
    background: #f0f9ff;
    border: 2px solid #0ea5e9;
    border-radius: 12px;
    padding: 20px;
    margin-top: 20px;
    text-align: center;
}

.result-section.success {
    background: #f0fdf4;
    border-color: #22c55e;
}

.result-section.error {
    background: #fef2f2;
    border-color: #ef4444;
}

.result-title {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 12px;
}

.result-title.success {
    color: #16a34a;
}

.result-title.error {
    color: #dc2626;
}

.result-text {
    color: #374151;
    line-height: 1.5;
}

.found-id {
    font-size: 20px;
    font-weight: 700;
    color: #2563eb;
    background: white;
    padding: 12px 20px;
    border-radius: 8px;
    margin: 16px 0;
    display: inline-block;
    border: 2px solid #dbeafe;
}

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

.info-list {
    list-style: none;
    text-align: left;
}

.info-list li {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
    font-size: 16px;
}

.info-list li i {
    color: #fbbf24;
    font-size: 18px;
}

@media (max-width: 768px) {
    .login-container {
        grid-template-columns: 1fr;
        max-width: 500px;
    }
    
    .image-section {
        display: none;
    }
    
    .login-form-section {
        padding: 40px 30px;
    }
}
</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>
<%@ include file="Navi.jsp" %>

<section class="login-section">
    <div class="login-container">
        <!-- 아이디 찾기 폼 -->
        <div class="login-form-section">
            <h1 class="login-title">아이디 찾기</h1>
            <p class="login-subtitle">등록된 이름과 이메일로 아이디를 찾을 수 있습니다</p>

            <form class="login-form" action='<c:url value="/findId"/>' method="POST">
                <div class="form-group">
                    <label class="form-label" for="name">이름</label>
                    <input type="text" id="name" name="name" class="form-input" 
                           placeholder="등록한 이름을 입력하세요" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">이메일</label>
                    <input type="email" id="email" name="email" class="form-input" 
                           placeholder="등록한 이메일을 입력하세요" required>
                </div>

                <button type="submit" class="login-button">아이디 찾기</button>
            </form>

            <!-- 결과 표시 영역 -->
            <c:if test="${not empty findResult}">
                <div class="result-section ${findResult.success ? 'success' : 'error'}">
                    <div class="result-title ${findResult.success ? 'success' : 'error'}">
                        <i class="fas ${findResult.success ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                        ${findResult.title} <%-- 변경: findResult.success에 따라 title 필드 사용 --%>
                    </div>
                    <div class="result-text">
                        <c:choose>
                            <c:when test="${findResult.success}">
                                회원님의 아이디는
                                <div class="found-id">${findResult.foundId}</div>
                                입니다.
                            </c:when>
                            <c:otherwise>
                                ${findResult.message} <%-- 변경: findResult.message 필드 사용 --%>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <div class="back-link">
                <a href='<c:url value="/login"/>'>로그인으로 돌아가기</a> |
                <a href='<c:url value="/findPwd"/>'>비밀번호 찾기</a>
            </div>
        </div>

        <!-- 이미지 섹션 -->
        <div class="image-section">
            <div class="image-content">
                <h2>계정 찾기<br>도움이 필요하세요?</h2>
                <p>SkyBooking이 도와드리겠습니다.<br>안전하고 간편한 계정 복구 서비스</p>
                
                <ul class="info-list">
                    <li>
                        <i class="fas fa-shield-alt"></i>
                        <span>안전한 본인 인증 시스템</span>
                    </li>
                    <li>
                        <i class="fas fa-clock"></i>
                        <span>빠른 계정 복구 서비스</span>
                    </li>
                    <li>
                        <i class="fas fa-headset"></i>
                        <span>24시간 고객지원</span>
                    </li>
                    <li>
                        <i class="fas fa-user-lock"></i>
                        <span>개인정보 보호 보장</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</section>

<%@ include file="Footer.jsp" %>

<script>
// 폼 제출 시 로딩 표시
document.querySelector('.login-form').addEventListener('submit', function() {
    const button = document.querySelector('.login-button');
    button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 검색 중...';
    button.disabled = true;
});
</script>

</body>
</html>