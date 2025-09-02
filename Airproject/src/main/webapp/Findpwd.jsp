<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기 - SkyBooking</title>
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
    min-height: 600px;
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
    line-height: 1.5;
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

.login-button:disabled {
    background: #9ca3af;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
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

.password-form {
    background: #f8fafc;
    border-radius: 12px;
    padding: 20px;
    margin-top: 20px;
}

.password-requirements {
    background: #fffbeb;
    border: 1px solid #fbbf24;
    border-radius: 8px;
    padding: 12px;
    margin-bottom: 16px;
    font-size: 14px;
}

.password-requirements ul {
    margin: 8px 0 0 20px;
    color: #92400e;
}

.password-requirements li {
    margin-bottom: 4px;
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

.step-indicator {
    display: flex;
    justify-content: center;
    margin-bottom: 30px;
}

.step {
    display: flex;
    align-items: center;
    gap: 8px;
}

.step-number {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: #e5e7eb;
    color: #6b7280;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 14px;
}

.step-number.active {
    background: #2563eb;
    color: white;
}

.step-text {
    font-size: 14px;
    color: #6b7280;
    margin-right: 20px;
}

.step-text.active {
    color: #2563eb;
    font-weight: 600;
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
    
    .step-indicator {
        flex-direction: column;
        align-items: center;
        gap: 8px;
    }
    
    .step-text {
        margin-right: 0;
        text-align: center;
    }
}
</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>
<%@ include file="Navi.jsp" %>

<section class="login-section">
    <div class="login-container">
        <!-- 비밀번호 찾기 폼 -->
        <div class="login-form-section">
            <h1 class="login-title">비밀번호 찾기</h1>
            <p class="login-subtitle">아이디, 이름, 이메일을 입력하여<br>새로운 비밀번호를 설정하세요</p>

            <!-- 진행 단계 표시 -->
            <div class="step-indicator">
                <div class="step">
                    <div class="step-number ${empty resetToken ? 'active' : ''}">1</div>
                    <span class="step-text ${empty resetToken ? 'active' : ''}">정보 확인</span>
                </div>
                <div class="step">
                    <div class="step-number ${not empty resetToken ? 'active' : ''}">2</div>
                    <span class="step-text ${not empty resetToken ? 'active' : ''}">비밀번호 재설정</span>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty resetToken}">
                    <!-- 1단계: 정보 확인 -->
                    <form class="login-form" action='<c:url value="/findPwd"/>' method="POST">
                        <div class="form-group">
                            <label class="form-label" for="id">아이디</label>
                            <input type="text" id="id" name="id" class="form-input" 
                                   placeholder="아이디를 입력하세요" required>
                        </div>

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

                        <button type="submit" class="login-button">다음 단계</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- 2단계: 새 비밀번호 설정 -->
                    <div class="password-form">
                        <div class="password-requirements">
                            <strong><i class="fas fa-info-circle"></i> 비밀번호 요구사항</strong>
                            <ul>
                                <li>8자 이상 16자 이하</li>
                                <li>영문 대소문자, 숫자, 특수문자 포함</li>
                                <li>공백 문자 사용 불가</li>
                            </ul>
                        </div>

                        <form class="login-form" action='<c:url value="findPwd"/>' method="POST">
                            <div class="form-group">
                                <label class="form-label" for="newPassword">새 비밀번호</label>
                                <div class="password-input-container">
                                    <input type="password" id="newPassword" name="newPassword" class="form-input" 
                                           placeholder="새 비밀번호를 입력하세요" required>
                                    <button type="button" class="password-toggle" onclick="togglePassword('newPassword', 'newPasswordIcon')">
                                        <i class="fas fa-eye" id="newPasswordIcon"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="confirmPassword">비밀번호 확인</label>
                                <div class="password-input-container">
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" 
                                           placeholder="비밀번호를 다시 입력하세요" required>
                                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword', 'confirmPasswordIcon')">
                                        <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                                    </button>
                                </div>
                            </div>

                            <button type="submit" class="login-button">비밀번호 변경</button>
                            <input type="hidden" name="resetToken" value="${resetToken}">
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- 결과 표시 영역 -->
            <c:if test="${not empty findResult}">
                <div class="result-section ${findResult.success ? 'success' : 'error'}">
                    <div class="result-title ${findResult.success ? 'success' : 'error'}">
                        <i class="fas ${findResult.success ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
                        ${findResult.title}
                    </div>
                    <div class="result-text">
                        ${findResult.message}
                    </div>
                </div>
            </c:if>

            <div class="back-link">
                <a href='<c:url value="/login"/>'>로그인으로 돌아가기</a> |
                <a href='<c:url value="/findId"/>'>아이디 찾기</a>
            </div>
        </div>

        <!-- 이미지 섹션 -->
        <div class="image-section">
            <div class="image-content">
                <h2>안전한<br>비밀번호 재설정</h2>
                <p>걱정하지 마세요!<br>간단한 절차로 새로운 비밀번호를 설정하세요</p>
                
                <ul class="info-list">
                    <li>
                        <i class="fas fa-shield-alt"></i>
                        <span>보안 인증을 통한 안전한 재설정</span>
                    </li>
                    <li>
                        <i class="fas fa-user-check"></i>
                        <span>본인 확인 후 즉시 변경 가능</span>
                    </li>
                    <li>
                        <i class="fas fa-lock"></i>
                        <span>강력한 암호화로 정보 보호</span>
                    </li>
                    <li>
                        <i class="fas fa-headset"></i>
                        <span>문제 발생 시 고객지원 이용</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</section>

<%@ include file="Footer.jsp" %>

<script>
// 비밀번호 표시/숨김 토글
function togglePassword(inputId, iconId) {
    const passwordInput = document.getElementById(inputId);
    const passwordIcon = document.getElementById(iconId);
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        passwordIcon.classList.remove('fa-eye');
        passwordIcon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        passwordIcon.classList.remove('fa-eye-slash');
        passwordIcon.classList.add('fa-eye');
    }
}

// 비밀번호 유효성 검사
function validatePassword() {
    const password = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const button = document.querySelector('.login-button');
    
    // 비밀번호 요구사항 체크
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$/;
    
    if (password && confirmPassword) {
        if (password !== confirmPassword) {
            alert('비밀번호가 일치하지 않습니다.');
            return false;
        }
        if (!passwordRegex.test(password)) {
            alert('비밀번호는 8-16자의 영문 대소문자, 숫자, 특수문자를 포함해야 합니다.');
            return false;
        }
    }
    return true;
}

// 폼 제출 시 유효성 검사 및 로딩 표시
document.addEventListener('DOMContentLoaded', function() {
    const forms = document.querySelectorAll('.login-form');
    
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const isPasswordForm = form.querySelector('#newPassword');
            
            if (isPasswordForm && !validatePassword()) {
                e.preventDefault();
                return;
            }
            
            const button = form.querySelector('.login-button');
            if (isPasswordForm) {
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 비밀번호 변경 중...';
            } else {
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 확인 중...';
            }
            button.disabled = true;
        });
    });
    
    // 비밀번호 실시간 체크
    const newPassword = document.getElementById('newPassword');
    const confirmPassword = document.getElementById('confirmPassword');
    
    if (newPassword && confirmPassword) {
        [newPassword, confirmPassword].forEach(input => {
            input.addEventListener('input', function() {
                if (newPassword.value && confirmPassword.value) {
                    if (newPassword.value === confirmPassword.value) {
                        confirmPassword.style.borderColor = '#22c55e';
                    } else {
                        confirmPassword.style.borderColor = '#ef4444';
                    }
                } else {
                    confirmPassword.style.borderColor = '#e5e7eb';
                }
            });
        });
    }
});
</script>

</body>
</html>