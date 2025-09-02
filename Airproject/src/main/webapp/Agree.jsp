<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 약관 동의 - SkyBooking</title>
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
    
    .consent-container {
        max-width: 800px;
        margin: 50px auto;
        background: white;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 0 20px rgba(0,0,0,0.1);
    }
    
    .consent-container h2 {
        text-align: center;
        color: #2563eb;
        margin-bottom: 10px;
        font-size: 28px;
        font-weight: bold;
    }
    
    .consent-container h4 {
        text-align: center;
        color: #666;
        margin-bottom: 30px;
        font-weight: normal;
    }
    
    .scroll-box {
        height: 200px;
        overflow-y: auto;
        border: 2px solid #ddd;
        padding: 20px;
        margin-bottom: 20px;
        background-color: #fafafa;
        border-radius: 8px;
        font-size: 14px;
        line-height: 1.8;
    }
    
    .scroll-box::-webkit-scrollbar {
        width: 8px;
    }
    
    .scroll-box::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 4px;
    }
    
    .scroll-box::-webkit-scrollbar-thumb {
        background: #2563eb;
        border-radius: 4px;
    }
    
    .scroll-box::-webkit-scrollbar-thumb:hover {
        background: #29B6F6;
    }
    
    .scroll-box p {
        margin-bottom: 12px;
    }
    
    .scroll-box strong {
        color: #2563eb;
        font-weight: bold;
    }
    
    .scroll-indicator {
        text-align: center;
        margin-bottom: 10px;
        font-size: 12px;
        color: #999;
    }
    
    .scroll-status {
        display: inline-block;
        padding: 4px 8px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: bold;
        margin-left: 10px;
    }
    
    .scroll-status.pending {
        background-color: #ffebee;
        color: #d32f2f;
    }
    
    .scroll-status.completed {
        background-color: #e8f5e8;
        color: #2e7d32;
    }
    
    .button-container {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-top: 30px;
    }
    
    .consent-btn, .cancel-btn {
        padding: 15px 30px;
        font-size: 16px;
        font-weight: bold;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.3s ease;
        min-width: 150px;
    }
    
    .consent-btn {
        background-color: #2563eb;
        color: white;
    }
    
    .consent-btn:enabled:hover {
        background-color: #29B6F6;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(79, 195, 247, 0.3);
    }
    
    .consent-btn:disabled {
        background-color: #ccc;
        cursor: not-allowed;
        opacity: 0.6;
    }
    
    .cancel-btn {
        background-color: #6c757d;
        color: white;
    }
    
    .cancel-btn:hover {
        background-color: #5a6268;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
    }
    
    .progress-bar {
        width: 100%;
        height: 6px;
        background-color: #e0e0e0;
        border-radius: 3px;
        margin-bottom: 15px;
        overflow: hidden;
    }
    
    .progress-fill {
        height: 100%;
        background: linear-gradient(90deg, #2563eb, #81D4FA);
        width: 0%;
        transition: width 0.3s ease;
        border-radius: 3px;
    }
    
    @media (max-width: 768px) {
        .consent-container {
            margin: 20px;
            padding: 20px;
        }
        
        .button-container {
            flex-direction: column;
            align-items: center;
        }
        
        .consent-btn, .cancel-btn {
            width: 100%;
            margin-bottom: 10px;
        }
    }
</style>
</head>
<body>
<%@ include file="Navi.jsp" %>

<div class="consent-container">
    <h2>회원가입 약관 동의</h2>
    <h4>스크롤을 끝까지 내려야 다음 단계로 진행할 수 있습니다</h4>
    
    <div class="progress-bar">
        <div class="progress-fill" id="progress-fill"></div>
    </div>
    
    <div class="scroll-indicator">
        이용약관 읽기 <span class="scroll-status pending" id="terms-status">미완료</span>
    </div>
    <div class="scroll-box" id="terms-box">
        <p><strong>[SkyBooking 이용약관]</strong></p>
        <p>본 약관은 SkyBooking이 제공하는 서비스 이용에 대한 기본적인 사항을 규정합니다.</p>
        
        <p><strong>제1조 (목적)</strong></p>
        <p>이 약관은 SkyBooking(전자상거래 사업자)이 운영하는 온라인 쇼핑몰에서 제공하는 인터넷 관련 서비스(이하 "서비스"라 한다)를 이용함에 있어 회사와 이용자의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.</p>
        
        <p><strong>제2조 (정의)</strong></p>
        <p>1. "몰"이란 회사가 재화 또는 용역을 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 재화 또는 용역을 거래할 수 있도록 설정한 가상의 영업장을 말합니다.</p>
        <p>2. "이용자"란 "몰"에 접속하여 이 약관에 따라 "몰"이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.</p>
        
        <p><strong>제3조 (회원가입)</strong></p>
        <p>회원은 정확한 정보를 바탕으로 가입해야 하며, 허위 정보 제공 시 서비스 제한이 있을 수 있습니다. 회원가입은 이용자의 약관 동의와 가입신청에 대하여 회사의 승낙으로 성립됩니다.</p>
        
        <p><strong>제4조 (서비스 이용)</strong></p>
        <p>회사는 상품 판매 및 배송을 포함한 다양한 온라인 쇼핑 서비스를 제공합니다. 서비스는 연중무휴, 1일 24시간 제공함을 원칙으로 합니다.</p>
        
        <p><strong>제5조 (이용자의 의무)</strong></p>
        <p>타인의 정보를 도용하거나 서비스 운영을 방해하는 행위는 금지됩니다. 이용자는 관계법령, 이 약관의 규정, 이용안내 및 서비스상에 공지한 주의사항, 회사가 통지하는 사항 등을 준수하여야 합니다.</p>
        
        <p><strong>제6조 (계약 해지)</strong></p>
        <p>이용자는 언제든지 회원 탈퇴가 가능하며, 회사는 약관 위반 시 이용 제한이 가능합니다. 회원탈퇴 시 회원이 작성한 게시물은 삭제되지 않습니다.</p>
        
        <p><strong>제7조 (개인정보 보호)</strong></p>
        <p>SkyBooking은 이용자의 개인정보를 안전하게 보호하기 위해 최선을 다합니다. 개인정보의 수집 및 이용에 대해서는 별도의 개인정보처리방침에 따릅니다.</p>
        
        <p><strong>제8조 (면책조항)</strong></p>
        <p>회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.</p>
    </div>
    
    <div class="scroll-indicator">
        개인정보처리방침 읽기 <span class="scroll-status pending" id="privacy-status">미완료</span>
    </div>
    <div class="scroll-box" id="privacy-box">
        <p><strong>[SkyBooking 개인정보 처리방침]</strong></p>
        <p>SkyBooking은 고객의 개인정보를 중요하게 생각하며 안전하게 보호합니다.</p>
        
        <p><strong>1. 개인정보 수집 항목</strong></p>
        <p>필수항목: 아이디, 비밀번호, 이름, 이메일, 전화번호, 주소</p>
        <p>선택항목: 생년월일, 성별, 마케팅 수신 동의</p>
        
        <p><strong>2. 개인정보 수집 및 이용 목적</strong></p>
        <p>- 서비스 제공 및 계약의 이행</p>
        <p>- 주문 처리, 배송, 결제 및 환불</p>
        <p>- 고객 상담 및 불만 처리</p>
        <p>- 마케팅 및 광고에 활용 (선택 동의 시)</p>
        
        <p><strong>3. 개인정보 보유 및 이용 기간</strong></p>
        <p>회원 탈퇴 시까지 보유하며, 탈퇴 후에는 지체없이 파기합니다. 단, 관련 법령에 따라 보존이 필요한 경우 해당 기간 동안 보관 후 파기합니다.</p>
        <p>- 계약 또는 청약철회 등에 관한 기록: 5년</p>
        <p>- 대금결제 및 재화 등의 공급에 관한 기록: 5년</p>
        <p>- 소비자의 불만 또는 분쟁처리에 관한 기록: 3년</p>
        
        <p><strong>4. 개인정보의 제3자 제공</strong></p>
        <p>SkyBooking은 이용자의 개인정보를 제3자에게 제공하지 않습니다. 단, 다음의 경우는 예외로 합니다:</p>
        <p>- 이용자가 사전에 동의한 경우</p>
        <p>- 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</p>
        
        <p><strong>5. 개인정보 보호책임자</strong></p>
        <p>개인정보 보호책임자: 김영희</p>
        <p>연락처: privacy@orangemall.co.kr</p>
        <p>전화번호: 02-1234-5678</p>
        
        <p><strong>6. 권익침해 구제방법</strong></p>
        <p>개인정보주체는 개인정보침해로 인한 구제를 받기 위하여 개인정보보호위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다.</p>
    </div>
    
    <div class="button-container">
        <button class="consent-btn" id="agree-btn" disabled onclick="goToSignup()">
            동의 후 회원가입
        </button>
        <button class="cancel-btn" onclick="goToCancel()">
            회원가입 취소
        </button>
    </div>
</div>

<script>
    const agreeButton = document.getElementById("agree-btn");
    const termsBox = document.getElementById("terms-box");
    const privacyBox = document.getElementById("privacy-box");
    const termsStatus = document.getElementById("terms-status");
    const privacyStatus = document.getElementById("privacy-status");
    const progressFill = document.getElementById("progress-fill");
    
    let termsScrolled = false;
    let privacyScrolled = false;
    
    function isScrolledToBottom(el) {
        return el.scrollTop + el.clientHeight >= el.scrollHeight - 5;
    }
    
    function updateProgress() {
        let progress = 0;
        if (termsScrolled) progress += 50;
        if (privacyScrolled) progress += 50;
        
        progressFill.style.width = progress + '%';
    }
    
    function updateStatus(element, isCompleted) {
        if (isCompleted) {
            element.textContent = '완료';
            element.className = 'scroll-status completed';
        } else {
            element.textContent = '미완료';
            element.className = 'scroll-status pending';
        }
    }
    
    function checkScrolls() {
        termsScrolled = isScrolledToBottom(termsBox);
        privacyScrolled = isScrolledToBottom(privacyBox);
        
        updateStatus(termsStatus, termsScrolled);
        updateStatus(privacyStatus, privacyScrolled);
        updateProgress();
        
        if (termsScrolled && privacyScrolled) {
            agreeButton.disabled = false;
            agreeButton.style.animation = 'pulse 2s infinite';
        } else {
            agreeButton.disabled = true;
            agreeButton.style.animation = 'none';
        }
    }
    
    // 스크롤 이벤트 리스너
    termsBox.addEventListener("scroll", function() {
        if (!termsScrolled) {
            checkScrolls();
        }
    });
    
    privacyBox.addEventListener("scroll", function() {
        if (!privacyScrolled) {
            checkScrolls();
        }
    });
    
    // 페이지 이동 함수들
    function goToSignup() {
        // 실제 회원가입 페이지로 이동 (JSP 파일명으로 수정)
        window.location.href = "signup";
    }
    
    function goToCancel() {
        // 메인 페이지나 이전 페이지로 이동
        if (confirm("회원가입을 취소하시겠습니까?")) {
            window.location.href = "main"; // 또는 history.back();
        }
    }
    
    // 키보드 접근성 지원
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !agreeButton.disabled && document.activeElement === agreeButton) {
            goToSignup();
        }
    });
    
    // 초기 상태 설정
    checkScrolls();
</script>

<style>
@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); }
}
</style>

<%@ include file="Footer.jsp" %>
</body>
</html>