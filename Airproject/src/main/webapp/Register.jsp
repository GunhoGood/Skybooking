<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 - SkyBooking</title>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
<style>
.signup-section {
	min-height: calc(100vh - 120px);
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 60px 20px;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.signup-container {
	background: white;
	border-radius: 20px;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
	overflow: hidden;
	max-width: 1200px;
	width: 100%;
	display: grid;
	grid-template-columns: 1fr 1fr;
	min-height: 700px;
}

/* 회원가입 폼 영역 */
.signup-form-section {
	padding: 40px 50px;
	display: flex;
	flex-direction: column;
	justify-content: center;
	overflow-y: auto;
}

.signup-title {
	font-size: 32px;
	font-weight: 700;
	color: #1f2937;
	margin-bottom: 8px;
	text-align: center;
}

.signup-subtitle {
	color: #6b7280;
	text-align: center;
	margin-bottom: 30px;
	font-size: 16px;
}

.signup-form {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

.duplicateBtn {
	background: #2563eb;
	color: white;
	border: none;
	padding: 14px 20px;
	border-radius: 10px;
	font-size: 14px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	white-space: nowrap;
}

.duplicateBtn:hover {
	background: #1d4ed8;
	transform: translateY(-1px);
}

.signup-form .form-group:first-child > div[style*="display: flex"] {
    margin-bottom: 0px; 
}

#idCheckResult {
    margin-top: 5px;
    display: block !important;
}

.form-row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 15px;
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

.form-label.required::after {
	content: ' *';
	color: #ef4444;
}

.form-input {
	width: 100%;
	padding: 14px 16px;
	border: 2px solid #e5e7eb;
	border-radius: 10px;
	font-size: 15px;
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

.form-select {
	width: 100%;
	padding: 14px 16px;
	border: 2px solid #e5e7eb;
	border-radius: 10px;
	font-size: 15px;
	background: #f9fafb;
	transition: all 0.3s ease;
	box-sizing: border-box;
	cursor: pointer;
}

.form-select:focus {
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

/* 성별 선택 */
.gender-group {
	display: flex;
	gap: 20px;
	align-items: center;
}

.gender-option {
	display: flex;
	align-items: center;
	gap: 8px;
	cursor: pointer;
}

.gender-option input[type="radio"] {
	width: 18px;
	height: 18px;
	accent-color: #2563eb;
}

.gender-option label {
	font-size: 15px;
	color: #374151;
	cursor: pointer;
}

/* 주소 검색 */
.address-group {
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.address-search {
	display: flex;
	gap: 10px;
}

.address-search-btn {
	background: #2563eb;
	color: white;
	border: none;
	padding: 14px 20px;
	border-radius: 10px;
	font-size: 14px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	white-space: nowrap;
}

.address-search-btn:hover {
	background: #1d4ed8;
	transform: translateY(-1px);
}

.address-detail {
	margin-top: 5px;
}

/* 버튼 그룹 */
.button-group {
	display: flex;
	gap: 15px;
	margin-top: 20px;
}

.signup-button {
	background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
	color: white;
	border: none;
	padding: 16px;
	border-radius: 12px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	flex: 1;
}

.signup-button:hover {
	transform: translateY(-1px);
	box-shadow: 0 8px 20px rgba(37, 99, 235, 0.3);
}

.back-button {
	background: #6b7280;
	color: white;
	border: none;
	padding: 16px;
	border-radius: 12px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	flex: 0 0 120px;
}

.back-button:hover {
	background: #4b5563;
	transform: translateY(-1px);
}

.login-link {
	text-align: center;
	margin-top: 25px;
	color: #6b7280;
}

.login-link a {
	color: #2563eb;
	text-decoration: none;
	font-weight: 600;
}

.login-link a:hover {
	text-decoration: underline;
}

/* 이미지 섹션 (로그인과 동일) */
.image-section {
	background: linear-gradient(135deg, rgba(37, 99, 235, 0.8),
		rgba(29, 78, 216, 0.9)),
		url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><defs><pattern id="plane-pattern" patternUnits="userSpaceOnUse" width="100" height="100" patternTransform="rotate(45)"><path d="M20,20 L80,50 L20,80 Z" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="1000" height="1000" fill="url(%23plane-pattern)"/></svg>');
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
	background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%,
		transparent 70%);
	animation: float 6s ease-in-out infinite;
}

@
keyframes float { 0%, 100% {
	transform: translate(0, 0) rotate(0deg);
}

50
%
{
transform
:
translate(
-20px
,
-20px
)
rotate(
180deg
);
}
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

/* 반응형 */
@media ( max-width : 768px) {
	.signup-container {
		grid-template-columns: 1fr;
		max-width: 500px;
	}
	.image-section {
		display: none;
	}
	.form-row {
		grid-template-columns: 1fr;
	}
	.signup-form-section {
		padding: 30px 25px;
	}
}
</style>
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<!-- 카카오 지도 API -->
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body>
	<%@ include file="Navi.jsp"%>

	<section class="signup-section">
		<div class="signup-container">
			<!-- 회원가입 폼 -->
			<div class="signup-form-section">
				<h1 class="signup-title">회원가입</h1>
				<p class="signup-subtitle">SkyBooking과 함께 새로운 여행을 시작하세요</p>

				<form class="signup-form" action='<c:url value="/signup"/>' method="POST">
					<!-- 아이디 -->
					<div class="form-group">
						<label class="form-label required" for="userId">아이디</label>
						<div style="display: flex; gap: 10px;">
							<input type="text" id="userId" name="id" class="form-input"
								placeholder="아이디를 입력하세요 (4-20자)" required>
							<button class="duplicateBtn" type="button" onclick="checkId()">중복 확인</button>
						</div>
						<span id="idCheckResult"
							style="margin-top: 5px; display: inline-block; font-size: 14px;"></span>
					</div>

					<!-- 비밀번호 -->
					<div class="form-group">
						<label class="form-label required" for="password">비밀번호</label>
						<div class="password-input-container">
							<input type="password" id="password" name="pwd"
								class="form-input" placeholder="비밀번호를 입력하세요 (8자 이상)" required>
							<button type="button" class="password-toggle"
								onclick="togglePassword('password', 'passwordIcon1')">
								<i class="fas fa-eye" id="passwordIcon1"></i>
							</button>
						</div>
					</div>

					<!-- 비밀번호 확인 -->
					<div class="form-group">
						<label class="form-label required" for="passwordConfirm">비밀번호
							확인</label>
						<div class="password-input-container">
							<input type="password" id="passwordConfirm"
								name="cpwd" class="form-input"
								placeholder="비밀번호를 다시 입력하세요" required>
							<button type="button" class="password-toggle"
								onclick="togglePassword('passwordConfirm', 'passwordIcon2')">
								<i class="fas fa-eye" id="passwordIcon2"></i>
							</button>
						</div>
					</div>

					<!-- 이름, 이메일 -->
					<div class="form-row">
						<div class="form-group">
							<label class="form-label required" for="userName">이름</label> <input
								type="text" id="userName" name="name" class="form-input"
								placeholder="실명을 입력하세요" required>
						</div>
						<div class="form-group">
							<label class="form-label required" for="email">이메일</label> <input
								type="email" id="email" name="email" class="form-input"
								placeholder="example@email.com" required>
						</div>
					</div>

					<!-- 생년월일, 성별 -->
					<div class="form-row">
						<div class="form-group">
							<label class="form-label required" for="birthDate">생년월일</label> <input
								type="date" id="birthDate" name="birth" class="form-input"
								required>
						</div>
						<div class="form-group">
							<label class="form-label required" for="userNum">휴대폰번호</label> <input
								type="tel" id="userNum" name="phone" class="form-input"
								placeholder="010포함 11자리입력 " pattern="[0-9]{11}"
								maxlength="11" >
						</div>
						<div class="form-group">
							<label class="form-label required">성별</label>
							<div class="gender-group">
								<div class="gender-option">
									<input type="radio" id="male" name="gender" value="M" required>
									<label for="male">남성</label>
								</div>
								<div class="gender-option">
									<input type="radio" id="female" name="gender" value="F"
										required> <label for="female">여성</label>
								</div>
							</div>
						</div>
					</div>

					<!-- 주소 -->
					<div class="form-group">
						<label class="form-label required">주소</label>
						<div class="address-group">
							<div class="address-search">
								<input type="text" id="postcode" name="addrNum"
									class="form-input" placeholder="우편번호" readonly required>
								<button type="button" class="address-search-btn"
									onclick="execDaumPostcode()">주소 검색</button>
							</div>
							<input type="text" id="address" name="address" class="form-input"
								placeholder="기본주소" readonly required> 
							<input type="text" id="detailAddress" name="detailAddress"
							class="form-input address-detail" placeholder="상세주소를 입력하세요">
						</div>
					</div>

					<!-- 버튼 그룹 -->
					<div class="button-group">
						<button type="button" class="back-button" onclick="goBack()">
							<i class="fas fa-arrow-left"></i> 뒤로
						</button>
						<button type="submit" class="signup-button">회원가입</button>
					</div>
				</form>

				<div class="login-link">
					이미 계정이 있으신가요? <a href="login">로그인</a>
				</div>
			</div>

			<!-- 이미지 섹션 -->
			<div class="image-section">
				<div class="image-content">
					<h2>
						새로운 여행의<br>
					</h2>
					<p>
						SkyBooking 회원이 되어<br>특별한 혜택을 만나보세요
					</p>

					<ul class="features-list">
						<li><i class="fas fa-gift"></i> <span>신규 회원 10% 할인 쿠폰</span>
						</li>
						<li><i class="fas fa-star"></i> <span>마일리지 적립 및 사용</span></li>
						<li><i class="fas fa-bell"></i> <span>항공료 할인 알림 서비스</span></li>
						<li><i class="fas fa-heart"></i> <span>개인 맞춤 여행 추천</span></li>
					</ul>
				</div>
			</div>
		</div>
	</section>
	
	<%@ include file="Footer.jsp"%>
	<c:if test="${not empty errorMsg}">
        <script>
            alert("${errorMsg}");
        </script>
   	</c:if>
	<script>
		if(${param.loginError != null}) alert("회원가입에 실패하셨습니다. 다시 시도해주세요.");
		// 아이디 중복 체크
		function checkId() {
		    const id = document.getElementById("userId").value.trim();
		    const resultSpan = document.getElementById("idCheckResult");
		
		    if (!id) {
		        alert("아이디를 입력해주세요.");
		        return;
		    }
		    if(id.length < 4) {
		    	resultSpan.textContent = "아이디는 4자 이상 입력해주세요.";
                resultSpan.style.color = "red";
                return;
		    }
		    fetch("checkId?id=" + encodeURIComponent(id))
		        .then(response => response.text())
		        .then(result => {
		            if (result === "available") {
		                resultSpan.textContent = "사용 가능한 아이디입니다.";
		                resultSpan.style.color = "green";
		            } else {
		                resultSpan.textContent = "이미 사용 중인 아이디입니다.";
		                resultSpan.style.color = "red";
		            }
		        })
	        .catch(error => {
	            console.error("중복 체크 오류:", error);
	            resultSpan.textContent = "오류가 발생했습니다.";
	            resultSpan.style.color = "red";
	        });
		}
		
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

		// 카카오 주소 검색 API
		function execDaumPostcode() {
			new daum.Postcode({
				oncomplete : function(data) {
					// 각 주소의 노출 규칙에 따라 주소를 조합한다.
					var addr = ''; // 주소 변수

					// 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
					if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
						addr = data.roadAddress;
					} else { // 사용자가 지번 주소를 선택했을 경우(J)
						addr = data.jibunAddress;
					}

					// 우편번호와 주소 정보를 해당 필드에 넣는다.
					document.getElementById('postcode').value = data.zonecode;
					document.getElementById('address').value = addr;
					// 커서를 상세주소 필드로 이동한다.
					document.getElementById('detailAddress').focus();
				}
			}).open();
		}

		// 뒤로가기 기능
		function goBack() {
			if (confirm('회원가입을 중단하시겠습니까?')) {
				/* window.location.href = 'main.jsp'; // 또는 'index.jsp' */
				history.back();
			}
		}

		// 폼 유효성 검사
		document.querySelector('.signup-form').addEventListener(
				'submit',
				function(e) {
					const password = document.getElementById('password').value;
					const passwordConfirm = document
							.getElementById('passwordConfirm').value;

					if (password !== passwordConfirm) {
						e.preventDefault();
						alert('비밀번호가 일치하지 않습니다.');
						document.getElementById('passwordConfirm').focus();
						return false;
					}

					if (password.length < 8) {
						e.preventDefault();
						alert('비밀번호는 8자 이상 입력해주세요.');
						document.getElementById('password').focus();
						return false;
					}
				});
		document.getElementById('userNum').addEventListener('input',
				function(e) {
					// 숫자가 아닌 문자 제거
					let value = e.target.value.replace(/[^0-9]/g, '');

					// 11자리로 제한
					if (value.length > 11) {
						value = value.slice(0, 11);
					}

					e.target.value = value;
				});

		// 폼 제출 시 유효성 검사
		document.addEventListener('DOMContentLoaded', function() {
			const form = document.querySelector('form'); 
			if (form) {
				form.addEventListener('submit', function(e) {
					const phoneInput = document.getElementById('userNum');
					const phoneValue = phoneInput.value;

					if (phoneValue.length !== 11
							|| !/^[0-9]{11}$/.test(phoneValue)) {
						e.preventDefault();
						alert('휴대폰번호는 11자리 숫자로 입력해주세요.');
						phoneInput.focus();
						return false;
					}
				});
			}
		});
	</script>

</body>
</html>