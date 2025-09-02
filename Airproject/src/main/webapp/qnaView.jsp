<%@page import="dto.Board"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
Board b = (Board) request.getAttribute("board");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${board.title}- SkyBooking Admin</title>
<link rel="icon" type="image/png"
	href="${pageContext.request.contextPath}/img/fabicon.png">
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
	max-width: 1000px;
	margin: 50px auto;
	background: white;
	padding: 40px;
	border-radius: 10px;
	box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
}

.admin-header {
	text-align: center;
	margin-bottom: 30px;
}

.admin-header h2 {
	color: #2563eb;
	font-size: 28px;
	font-weight: bold;
	margin-bottom: 10px;
}

.admin-header .breadcrumb {
	color: #6b7280;
	font-size: 14px;
}

.admin-header .breadcrumb a {
	color: #2563eb;
	text-decoration: none;
}

.admin-header .breadcrumb a:hover {
	text-decoration: underline;
}

.message-container {
	margin-bottom: 20px;
}

.error-message {
	background-color: #fef2f2;
	border: 1px solid #fecaca;
	color: #dc2626;
	padding: 12px 16px;
	border-radius: 8px;
	text-align: center;
	margin-bottom: 15px;
}

.success-message {
	background-color: #f0fdf4;
	border: 1px solid #bbf7d0;
	color: #16a34a;
	padding: 12px 16px;
	border-radius: 8px;
	text-align: center;
	margin-bottom: 15px;
}

.qna-card {
	background: #f8fafc;
	border: 2px solid #e2e8f0;
	border-radius: 12px;
	margin-bottom: 30px;
	overflow: hidden;
}

.qna-header {
	background: linear-gradient(135deg, #2563eb, #3b82f6);
	color: white;
	padding: 20px 25px;
}

.qna-header h3 {
	font-size: 22px;
	margin-bottom: 10px;
	font-weight: 600;
}

.qna-meta {
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-size: 14px;
	opacity: 0.9;
}

.qna-meta .author {
	font-weight: 500;
}

.qna-meta .date {
	font-family: 'Courier New', monospace;
}

.qna-content {
	padding: 25px;
	background: white;
}

.qna-content .content-text {
	line-height: 1.8;
	color: #374151;
	white-space: pre-line;
	font-size: 16px;
}

.answer-section {
	background: #f9fafb;
	border: 2px solid #e5e7eb;
	border-radius: 12px;
	overflow: hidden;
}

.answer-header {
	background: linear-gradient(135deg, #059669, #10b981);
	color: white;
	padding: 15px 25px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.answer-header h4 {
	font-size: 18px;
	font-weight: 600;
}

.answer-status {
	font-size: 12px;
	background: rgba(255, 255, 255, 0.2);
	padding: 4px 12px;
	border-radius: 12px;
}

.answer-form {
	padding: 25px;
	background: white;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 600;
	color: #374151;
	font-size: 14px;
}

.form-group textarea {
	width: 100%;
	padding: 15px;
	border: 2px solid #d1d5db;
	border-radius: 8px;
	font-size: 16px;
	transition: all 0.3s ease;
	resize: vertical;
	min-height: 150px;
	font-family: inherit;
	line-height: 1.5;
}

.form-group textarea:focus {
	outline: none;
	border-color: #2563eb;
	box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.form-group textarea::placeholder {
	color: #9ca3af;
}

.button-group {
	display: flex;
	gap: 12px;
	justify-content: flex-end;
	margin-top: 25px;
}

.btn {
	padding: 12px 24px;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	font-size: 16px;
	font-weight: 600;
	transition: all 0.3s ease;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 8px;
}

.btn-primary {
	background: linear-gradient(135deg, #2563eb, #3b82f6);
	color: white;
	box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.btn-primary:hover {
	background: linear-gradient(135deg, #1d4ed8, #2563eb);
	transform: translateY(-2px);
	box-shadow: 0 6px 16px rgba(37, 99, 235, 0.4);
}

.btn-secondary {
	background: linear-gradient(135deg, #6b7280, #9ca3af);
	color: white;
	box-shadow: 0 4px 12px rgba(107, 114, 128, 0.3);
}

.btn-secondary:hover {
	background: linear-gradient(135deg, #4b5563, #6b7280);
	transform: translateY(-2px);
	box-shadow: 0 6px 16px rgba(107, 114, 128, 0.4);
}

.answer-date {
	text-align: right;
	margin-top: 15px;
	padding-top: 15px;
	border-top: 1px solid #e5e7eb;
	color: #6b7280;
	font-size: 14px;
	font-style: italic;
}

.current-answer {
	background: #f0fdf4;
	border: 1px solid #bbf7d0;
	border-radius: 8px;
	padding: 20px;
	margin-bottom: 20px;
}

.current-answer h5 {
	color: #16a34a;
	margin-bottom: 12px;
	font-size: 16px;
	font-weight: 600;
	display: flex;
	align-items: center;
	gap: 8px;
}

.current-answer .answer-text {
	color: #374151;
	line-height: 1.7;
	white-space: pre-line;
	font-size: 15px;
}

.not-found-container {
	text-align: center;
	padding: 60px 20px;
}

.not-found-container h2 {
	color: #ef4444;
	margin-bottom: 20px;
	font-size: 24px;
}

.not-found-container p {
	color: #6b7280;
	margin-bottom: 30px;
	font-size: 16px;
}

.not-found-container .btn {
	margin-top: 20px;
}

@media ( max-width : 768px) {
	.admin-container {
		margin: 20px;
		padding: 20px;
	}
	.qna-header, .answer-form {
		padding: 20px;
	}
	.qna-header h3 {
		font-size: 20px;
	}
	.qna-meta {
		flex-direction: column;
		align-items: flex-start;
		gap: 8px;
	}
	.button-group {
		flex-direction: column;
	}
	.btn {
		justify-content: center;
	}
}

/* 애니메이션 효과 */
.qna-card, .answer-section {
	animation: fadeInUp 0.6s ease-out;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* 로딩 상태 스타일 */
.btn:disabled {
	opacity: 0.6;
	cursor: not-allowed;
	transform: none;
}

.btn:disabled:hover {
	transform: none;
	box-shadow: initial;
}
</style>
</head>
<body>
	<%@ include file="Navi.jsp"%>

	<div class="admin-container">
		<div class="admin-header">
			<h2>문의 상세 관리</h2>
			<div class="breadcrumb">
				<a href="qnaList">문의 관리</a> > 문의 상세
			</div>
		</div>

		<div class="message-container">
			<c:if test="${not empty requestScope.error}">
				<div class="error-message">❌ ${requestScope.error}</div>
			</c:if>
			<c:if test="${param.msg == 'answerSuccess'}">
				<div class="success-message">✅ 답변이 성공적으로 등록/수정되었습니다.</div>
			</c:if>
		</div>

		<c:if test="${board == null}">
			<div class="not-found-container">
				<h2>문의글을 찾을 수 없습니다</h2>
				<p>요청하신 문의글이 존재하지 않거나 삭제되었을 수 있습니다.</p>
				<a href="qnaList" class="btn btn-primary"> 📋 문의글 목록으로 돌아가기 </a>
			</div>
		</c:if>

		<c:if test="${board != null}">
			<!-- 문의글 카드 -->
			<div class="qna-card">
				<div class="qna-header">
					<h3>${board.title}</h3>
					<div class="qna-meta">
						<span class="author">👤 ${board.writerId}</span>
						<fmt:formatDate value="${board.writeDate}"
							pattern="yyyy-MM-dd HH:mm:ss" var="writeDate" />
						<span class="date">📅 ${writeDate}</span>
					</div>
				</div>
				<div class="qna-content">
					<div class="content-text">${board.content}</div>
				</div>
			</div>

			<!-- 답변 섹션 -->
			<div class="answer-section">
				<div class="answer-header">
					<h4>관리자 답변</h4>
					<div class="answer-status">
						<c:if test="${empty board.answer}">답변 대기</c:if>
						<c:if test="${not empty board.answer}">답변 완료</c:if>
					</div>
				</div>

				<div class="answer-form">
					<!-- 현재 답변 표시 (수정 모드) -->
					<c:if test="${not empty board.answer}">
						<div class="current-answer">
							<h5>✅ 현재 답변 내용</h5>
							<div class="answer-text">${board.answer}</div>
						</div>
					</c:if>

					<!-- 답변 작성/수정 폼 -->
					<form action="qnaView" method="post"
						onsubmit="return validateAnswer()">
						<input type="hidden" name="board_id" value="${board.boardId}">

						<div class="form-group">
							<label for="answer"> <c:if test="${empty board.answer}">답변 내용 작성</c:if>
								<c:if test="${not empty board.answer}">답변 내용 수정</c:if>
							</label>
							<textarea id="answer" name="answer" required
								placeholder="고객에게 도움이 되는 친절하고 정확한 답변을 작성해주세요...">${board.answer}</textarea>
						</div>

						<div class="button-group">
							<button type="submit" class="btn btn-primary" id="submitBtn">
								<c:if test="${empty board.answer}">📝 답변 등록</c:if>
								<c:if test="${not empty board.answer}">✏️ 답변 수정</c:if>
							</button>
							<a href="qnaList" class="btn btn-secondary"> 📋 목록으로 </a>
						</div>
					</form>

					<!-- 답변 일시 표시 -->
					<c:if
						test="${not empty board.answer && not empty board.answerDate}">
						<fmt:formatDate value="${board.answerDate}"
							pattern="yyyy-MM-dd HH:mm:ss" var="answerDate" />
						<div class="answer-date">최종 답변일: ${answerDate}</div>
					</c:if>
				</div>
			</div>
		</c:if>
	</div>

	<script>
// 답변 유효성 검사
function validateAnswer() {
	const answerText = document.getElementById('answer').value.trim();
	const submitBtn = document.getElementById('submitBtn');
	
	if (answerText.length < 10) {
		alert('답변은 최소 10자 이상 작성해주세요.');
		return false;
	}
	
	if (answerText.length > 2000) {
		alert('답변은 2000자를 초과할 수 없습니다.');
		return false;
	}
	
	// 제출 버튼 비활성화 (중복 제출 방지)
	submitBtn.disabled = true;
	submitBtn.innerHTML = '처리 중...';
	
	// 3초 후 버튼 재활성화 (네트워크 오류 대비)
	setTimeout(() => {
		submitBtn.disabled = false;
		submitBtn.innerHTML = submitBtn.innerHTML.includes('등록') ? '📝 답변 등록' : '✏️ 답변 수정';
	}, 3000);
	
	return true;
}

// 텍스트영역 자동 높이 조절
document.addEventListener('DOMContentLoaded', function() {
	const textarea = document.getElementById('answer');
	
	function adjustHeight() {
		textarea.style.height = 'auto';
		textarea.style.height = Math.max(150, textarea.scrollHeight) + 'px';
	}
	
	textarea.addEventListener('input', adjustHeight);
	adjustHeight(); // 초기 높이 설정
	
	// 글자 수 카운터 추가
	const charCounter = document.createElement('div');
	charCounter.style.cssText = 'text-align: right; margin-top: 8px; font-size: 12px; color: #6b7280;';
	textarea.parentNode.appendChild(charCounter);
	
	function updateCharCount() {
		const length = textarea.value.length;
		charCounter.textContent = `${length}/2000자`;
		charCounter.style.color = length > 1800 ? '#ef4444' : '#6b7280';
	}
	
	textarea.addEventListener('input', updateCharCount);
	updateCharCount(); // 초기 카운트 설정
});

// 페이지 로드 시 애니메이션
document.addEventListener('DOMContentLoaded', function() {
	const cards = document.querySelectorAll('.qna-card, .answer-section');
	cards.forEach((card, index) => {
		card.style.animationDelay = `${index * 0.1}s`;
	});
});
</script>

	<%@ include file="Footer.jsp"%>
</body>
</html>