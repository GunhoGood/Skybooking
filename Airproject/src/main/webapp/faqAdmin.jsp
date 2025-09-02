<%@page import="dto.Users"%>
<%@page import="dao.FaqDao"%>
<%@page import="dto.FaqDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
// 관리자 권한 체크
String userId = (String) session.getAttribute("id");
Users loginUser = (Users) session.getAttribute("user");
if (userId == null || loginUser == null || loginUser.getAdmin() != 1) {
	response.sendRedirect("main");
	return;
}

FaqDao faqDao = new FaqDao();
List<FaqDto> faqList = faqDao.getAllFaqs();
int totalFaqs = faqDao.getTotalFaqCount();
int categoryCount = faqDao.getCategoryCount();

// 메시지 처리
String message = request.getParameter("message");
String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FAQ 관리 - SkyBooking Admin</title>
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

.admin-container h4 {
	text-align: center;
	color: #666;
	margin-bottom: 30px;
	font-weight: normal;
}

/* 관리자 정보 표시 */
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
	gap: 12px;
	align-items: center;
	flex-wrap: wrap;
}

.category-btn {
	padding: 8px 16px;
	border: 2px solid #e5e7eb;
	background-color: white;
	color: #6b7280;
	border-radius: 20px;
	cursor: pointer;
	font-size: 13px;
	font-weight: 600;
	transition: all 0.3s ease;
	white-space: nowrap;
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
	box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.faq-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 30px;
	background: white;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.faq-table th {
	background-color: #2563eb;
	color: white;
	padding: 15px 12px;
	text-align: center;
	font-weight: bold;
	font-size: 16px;
}

.faq-table td {
	padding: 18px 1px;
	border-bottom: 1px solid #eee;
	vertical-align: top;
	text-align: center;
	font-size: 15px;
	min-height: 60px;
}

.faq-table tr:hover {
	background-color: #f8f9fa;
}

.category-tag {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 12px;
	font-weight: bold;
	color: white;
	min-width: 70px;
	text-align: center;
}

.category-booking {
	background-color: #2563eb;
}

.category-account {
	background-color: #10b981;
}

.category-service {
	background-color: #f59e0b;
}

.category-refund {
	background-color: #ef4444;
}

.action-buttons {
	display: flex;
	gap: 8px;
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

.edit-btn {
	background-color: #10b981;
	color: white;
}

.edit-btn:hover {
	background-color: #059669;
	transform: translateY(-1px);
}

.delete-btn {
	background-color: #ef4444;
	color: white;
}

.delete-btn:hover {
	background-color: #dc2626;
	transform: translateY(-1px);
}

.question-preview {
	max-width: 220px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	text-align: left;
	padding-left: 15px;
}

.answer-preview {
	width: calc(100% - 10px);
	max-width: none;
	overflow: hidden;
	color: #666;
	font-size: 14px;
	text-align: left;
	padding-left: 15px;
	padding-right: 10px;
	line-height: 1.2;
	word-wrap: break-word;
	word-break: break-word;
	white-space: normal;
	display: block;
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
	margin: 5% auto;
	padding: 30px;
	border-radius: 10px;
	width: 80%;
	max-width: 600px;
	max-height: 80vh;
	overflow-y: auto;
	position: relative;
}

.close {
	position: absolute;
	right: 20px;
	top: 15px;
	color: #aaa;
	font-size: 28px;
	font-weight: bold;
	cursor: pointer;
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
	background-color: #fafafa;
	transition: border-color 0.3s ease;
}

.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
	outline: none;
	border-color: #2563eb;
	background-color: white;
}

.form-group textarea {
	height: 150px;
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
	transition: all 0.3s ease;
}

.save-btn {
	background-color: #2563eb;
	color: white;
}

.save-btn:hover {
	background-color: #29B6F6;
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.cancel-btn {
	background-color: #6c757d;
	color: white;
}

.cancel-btn:hover {
	background-color: #5a6268;
	transform: translateY(-2px);
}

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

@media (max-width: 768px) {
	.admin-container {
		margin: 20px;
		padding: 20px;
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
	.add-btn {
		order: 3;
	}
	.faq-table {
		font-size: 11px;
	}
	.faq-table th, .faq-table td {
		padding: 8px 6px;
	}
	.question-preview {
		max-width: 150px;
	}
	.answer-preview {
		max-width: 180px;
	}
	.modal-content {
		width: 95%;
		margin: 10% auto;
		padding: 20px;
	}
	.stats-container {
		flex-direction: column;
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
				<h3	style="display: inline; color: #2563eb;">FAQ 관리</h3>
			</a> 
			<a href="hoteladmin" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">호텔 관리</h3>
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
		<h4>자주묻는질문을 추가, 수정, 삭제할 수 있습니다</h4>

		<!-- 메시지 표시 영역 -->
		<%
		if (message != null) {
		%>
		<div class="message-success">
			<%
			if ("added".equals(message)) {
			%>
			✅ FAQ가 성공적으로 추가되었습니다.
			<%
			} else if ("updated".equals(message)) {
			%>
			✅ FAQ가 성공적으로 수정되었습니다.
			<%
			} else if ("deleted".equals(message)) {
			%>
			✅ FAQ가 성공적으로 삭제되었습니다.
			<%
			}
			%>
		</div>
		<%
		}
		%>

		<%
		if (error != null) {
		%>
		<div class="message-error">
			<%
			if ("missing_fields".equals(error)) {
			%>
			❌ 모든 필수 항목을 입력해주세요.
			<%
			} else if ("insert_failed".equals(error)) {
			%>
			❌ FAQ 추가에 실패했습니다.
			<%
			} else if ("update_failed".equals(error)) {
			%>
			❌ FAQ 수정에 실패했습니다.
			<%
			} else if ("delete_failed".equals(error)) {
			%>
			❌ FAQ 삭제에 실패했습니다.
			<%
			} else if ("invalid_id".equals(error)) {
			%>
			❌ 유효하지 않은 FAQ ID입니다.
			<%
			} else {
			%>
			❌ 오류가 발생했습니다.
			<%
			}
			%>
		</div>
		<%
		}
		%>

		<!-- 통계 카드 -->
		<div class="stats-container">
			<div class="stat-card">
				<h3><%=totalFaqs%></h3>
				<p>전체 FAQ</p>
			</div>
			<div class="stat-card">
				<h3><%=categoryCount%></h3>
				<p>카테고리 수</p>
			</div>
		</div>

		<!-- 관리 도구 -->
		<div class="admin-controls">
			<div class="search-container">
				<input type="text" class="search-box" id="adminSearchInput"
					placeholder="FAQ 검색 (질문, 답변, 카테고리)..."> <span class="search-icon">🔍</span>
			</div>
			
			<div class="category-filters">
				<button class="category-btn active" data-category="">전체</button>
				<button class="category-btn" data-category="booking">예약/결제</button>
				<button class="category-btn" data-category="account">계정/회원</button>
				<button class="category-btn" data-category="service">서비스</button>
				<button class="category-btn" data-category="refund">취소/환불</button>
			</div>
			
			<button class="add-btn" onclick="openModal('add')">+ 새 FAQ 추가</button>
		</div>

		<!-- FAQ 목록 테이블 -->
		<table class="faq-table" id="faqTable">
			<thead>
				<tr>
					<th width="6%">번호</th>
					<th width="12%">카테고리</th>
					<th width="26%">질문</th>
					<th width="48%">답변</th>
					<th width="8%">관리</th>
				</tr>
			</thead>
			<tbody id="faqTableBody">
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

	<!-- 모달 -->
	<div id="faqModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h3 id="modalTitle">새 FAQ 추가</h3>
			<form id="faqForm" onsubmit="saveFaq(event)">
				<input type="hidden" id="faqId" value="">

				<div class="form-group">
					<label for="faqCategory">카테고리 *</label> <select id="faqCategory"
						required>
						<option value="">카테고리를 선택하세요</option>
						<option value="booking">예약/결제</option>
						<option value="account">계정/회원</option>
						<option value="service">서비스</option>
						<option value="refund">취소/환불</option>
					</select>
				</div>

				<div class="form-group">
					<label for="faqQuestion">질문 *</label> <input type="text"
						id="faqQuestion" placeholder="자주 묻는 질문을 입력하세요" required>
				</div>

				<div class="form-group">
					<label for="faqAnswer">답변 *</label>
					<textarea id="faqAnswer" placeholder="답변 내용을 입력하세요" required></textarea>
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
let editingId = null;
let allFaqs = [];
let filteredFaqs = [];
let currentPage = 1;
const itemsPerPage = 7;

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 서버에서 받은 데이터를 JavaScript 배열로 변환
    initializeFaqData();
    
    // 기본 기능 초기화
    initSearch();
    initModalEvents();
    initKeyboardEvents();
    
    // 페이징 초기화
    setupPagination();
    renderFaqTable();
});

// 서버 데이터를 JavaScript 배열로 변환
function initializeFaqData() {
    allFaqs = [];
    
    <%
    int index = 1;
    for (FaqDto faq : faqList) {
    %>
        allFaqs.push({
            index: <%=index++%>,
            faqId: <%=faq.getFaqId()%>,
            category: '<%=faq.getCategory()%>',
            categoryDisplayName: '<%=faq.getCategoryDisplayName()%>',
            question: `<%=faq.getQuestion().replaceAll("`", "\\\\`")%>`,
            answerPreview: `<%=faq.getAnswerPreview().replaceAll("`", "\\\\`")%>`
        });
    <%
    }
    %>
    
    filteredFaqs = [...allFaqs];
}

// 페이징 설정
function setupPagination() {
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    
    if (prevBtn && nextBtn) {
        prevBtn.addEventListener('click', function() {
            if (currentPage > 1) {
                currentPage--;
                renderFaqTable();
                updatePaginationUI();
            }
        });
        
        nextBtn.addEventListener('click', function() {
            const totalPages = Math.ceil(filteredFaqs.length / itemsPerPage);
            if (currentPage < totalPages) {
                currentPage++;
                renderFaqTable();
                updatePaginationUI();
            }
        });
    }
}

// 테이블 렌더링
function renderFaqTable() {
    const tbody = document.getElementById('faqTableBody');
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const currentPageFaqs = filteredFaqs.slice(startIndex, endIndex);
    
    // 테이블 내용 생성
    let tableHTML = '';
    currentPageFaqs.forEach((faq, index) => {
        const globalIndex = startIndex + index + 1;
        tableHTML += `
            <tr data-id="\${faq.faqId}" data-category="\${faq.category}">
                <td>\${globalIndex}</td>
                <td><span class="category-tag category-\${faq.category}">\${faq.categoryDisplayName}</span></td>
                <td class="question-preview" title="\${faq.question}">\${faq.question}</td>
                <td class="answer-preview" title="\${faq.answerPreview}">\${faq.answerPreview}</td>
                <td>
                    <div class="action-buttons">
                        <button class="edit-btn" onclick="editFaq(\${faq.faqId})">수정</button>
                        <button class="delete-btn" onclick="deleteFaq(\${faq.faqId})">삭제</button>
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
    const totalPages = Math.ceil(filteredFaqs.length / itemsPerPage);
    
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
    const totalPages = Math.ceil(filteredFaqs.length / itemsPerPage);
    if (page >= 1 && page <= totalPages) {
        currentPage = page;
        renderFaqTable();
    }
}

// 검색 및 필터 기능 (페이징과 연동)
function initSearch() {
    const searchInput = document.getElementById('adminSearchInput');
    const categoryBtns = document.querySelectorAll('.category-btn');
    
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
        
        filteredFaqs = allFaqs.filter(faq => {
            const matchesSearch = faq.question.toLowerCase().includes(searchTerm) || 
                                faq.answerPreview.toLowerCase().includes(searchTerm) || 
                                faq.categoryDisplayName.toLowerCase().includes(searchTerm);
            
            const matchesCategory = !selectedCategory || faq.category === selectedCategory;
            
            return matchesSearch && matchesCategory;
        });
        
        currentPage = 1; // 필터링 후 첫 페이지로
        renderFaqTable();
    }
    
    searchInput.addEventListener('input', applyFilters);
}

// 모달 관련 함수
function openModal(mode, id = null) {
    const modal = document.getElementById('faqModal');
    const modalTitle = document.getElementById('modalTitle');
    const form = document.getElementById('faqForm');
    
    editingId = id;
    
    if (mode === 'add') {
        modalTitle.textContent = '새 FAQ 추가';
        form.reset();
        document.getElementById('faqId').value = '';
    } else if (mode === 'edit') {
        modalTitle.textContent = 'FAQ 수정';
        loadFaqData(id);
    }
    
    modal.style.display = 'block';
}

function closeModal() {
    const modal = document.getElementById('faqModal');
    modal.style.display = 'none';
    editingId = null;
}

// 특정 FAQ 데이터 로드
function loadFaqData(id) {
    fetch('/Airproject/faq?action=get&id=' + id)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            if (data && !data.error) {
                document.getElementById('faqId').value = data.faqId;
                document.getElementById('faqCategory').value = data.category;
                document.getElementById('faqQuestion').value = data.question;
                document.getElementById('faqAnswer').value = data.answer;
            } else {
                alert('FAQ 데이터를 불러올 수 없습니다: ' + (data.error || 'Unknown error'));
            }
        })
        .catch(error => {
            alert('FAQ 데이터를 불러오는데 실패했습니다: ' + error.message);
        });
}

// 편집 함수
function editFaq(id) {
    openModal('edit', id);
}

// 삭제 함수
function deleteFaq(id) {
    if (confirm('정말로 이 FAQ를 삭제하시겠습니까?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/Airproject/faq';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        form.appendChild(actionInput);
        
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'faqId';
        idInput.value = id;
        form.appendChild(idInput);
        
        document.body.appendChild(form);
        form.submit();
    }
}

// FAQ 저장 함수
function saveFaq(event) {
    event.preventDefault();
    
    const faqId = document.getElementById('faqId').value;
    const category = document.getElementById('faqCategory').value;
    const question = document.getElementById('faqQuestion').value;
    const answer = document.getElementById('faqAnswer').value;
    
    if (!category || !question.trim() || !answer.trim()) {
        alert('모든 필수 항목을 입력해주세요.');
        return;
    }
    
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '/Airproject/faq';
    
    // action 파라미터
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = (faqId && faqId.trim() !== '') ? 'update' : 'insert';
    form.appendChild(actionInput);
    
    // faqId (수정시에만)
    if (faqId && faqId.trim() !== '') {
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'faqId';
        idInput.value = faqId;
        form.appendChild(idInput);
    }
    
    // category
    const categoryInput = document.createElement('input');
    categoryInput.type = 'hidden';
    categoryInput.name = 'category';
    categoryInput.value = category;
    form.appendChild(categoryInput);
    
    // question
    const questionInput = document.createElement('input');
    questionInput.type = 'hidden';
    questionInput.name = 'question';
    questionInput.value = question.trim();
    form.appendChild(questionInput);
    
    // answer
    const answerInput = document.createElement('input');
    answerInput.type = 'hidden';
    answerInput.name = 'answer';
    answerInput.value = answer.trim();
    form.appendChild(answerInput);
    
    document.body.appendChild(form);
    form.submit();
}

// 모달 외부 클릭 시 닫기
function initModalEvents() {
    const modal = document.getElementById('faqModal');
    window.addEventListener('click', function(event) {
        if (event.target === modal) {
            closeModal();
        }
    });
}

// 키보드 이벤트
function initKeyboardEvents() {
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeModal();
        }
    });
}
</script>

	<%@ include file="Footer.jsp"%>
</body>
</html>