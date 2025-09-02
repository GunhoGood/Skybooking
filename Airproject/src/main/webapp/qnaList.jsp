<%@page import="dao.BoardDao"%>
<%@page import="dto.Users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%
// 관리자 권한 체크
String userId = (String) session.getAttribute("id");
Users loginUser = (Users)session.getAttribute("user");
if (userId == null || loginUser == null || loginUser.getAdmin() != 1) {
	response.sendRedirect("main");
	return;
}

// BoardDao 인스턴스 생성
BoardDao dao = new BoardDao();

// 총 문의 수와 답변 완료 수 가져오기
int totalQnaCount = dao.getTotalQnaCount();
int answeredQnaCount = dao.getAnsweredQnaCount();
int unansweredQnaCount = totalQnaCount - answeredQnaCount;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 관리 - SkyBooking Admin</title>
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

.admin-info {
	background: linear-gradient(135deg, #2563eb, #29B6F6);
	color: white;
	padding: 15px 20px;
	border-radius: 8px;
	margin-bottom: 20px;
	text-align: center;
	font-weight: bold;
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

.qna-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 30px;
	background: white;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.qna-table th {
	background-color: #2563eb;
	color: white;
	padding: 15px 12px;
	text-align: center;
	font-weight: bold;
	font-size: 16px;
}

.qna-table td {
	padding: 18px 8px;
	border-bottom: 1px solid #eee;
	vertical-align: middle;
	text-align: center;
	font-size: 15px;
	min-height: 60px;
}

.qna-table tr:hover {
	background-color: #f8f9fa;
}

.status-badge {
	display: inline-block;
	padding: 4px 12px;
	border-radius: 12px;
	font-size: 12px;
	font-weight: bold;
	color: white;
	min-width: 70px;
	text-align: center;
}

.status-pending {
	background-color: #f59e0b;
}

.status-answered {
	background-color: #10b981;
}

.title-link {
	color: #2563eb;
	text-decoration: none;
	font-weight: 500;
	max-width: 300px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	display: inline-block;
	text-align: left;
}

.title-link:hover {
	text-decoration: underline;
}

.writer-cell {
	font-weight: 500;
	color: #374151;
}

.date-cell {
	font-family: 'Courier New', monospace;
	font-size: 13px;
	color: #6b7280;
}

.no-posts {
	text-align: center;
	padding: 60px 20px;
	color: #6b7280;
	font-size: 16px;
}

.no-posts i {
	font-size: 48px;
	color: #d1d5db;
	margin-bottom: 20px;
	display: block;
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
	.filter-container {
		order: 2;
		margin-bottom: 10px;
	}
	.qna-table {
		font-size: 11px;
	}
	.qna-table th, .qna-table td {
		padding: 8px 6px;
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
<%@ include file="Navi.jsp" %>

<div class="admin-container">
	<!-- 관리자 정보 -->
	<div class="admin-info">
		🔐 관리자 모드 |
		<%=userId%>
		님이 로그인됨
	</div>

	<div style="text-align: center; margin-bottom: 20px;">
		<a href="faqadmin" style="text-decoration: none; margin: 0 15px;">
			<h3 style="display: inline; color: #666;">FAQ 관리</h3>
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
			<h3 style="display: inline; color: #2563eb;">문의 관리</h3>
		</a>
	</div>
	<h4>1:1 문의 답변을 달 수 있습니다</h4>

	<!-- 통계 카드 -->
	<div class="stats-container">
		<div class="stat-card">
			<h3><%=totalQnaCount%></h3>
			<p>총 문의 수</p>
		</div>
		<div class="stat-card">
			<h3><%=answeredQnaCount%></h3>
			<p>답변 완료</p>
		</div>
		<div class="stat-card">
			<h3><%=unansweredQnaCount%></h3>
			<p>답변 대기</p>
		</div>
	</div>

	<!-- 관리 도구 -->
	<div class="admin-controls">
		<div class="search-container">
			<input type="text" class="search-box" id="qnaSearchInput"
				placeholder="문의 검색 (제목, 작성자)...">
			<span class="search-icon">🔍</span>
		</div>
		<div class="filter-container">
			<select class="filter-select" id="statusFilter">
				<option value="">전체 상태</option>
				<option value="pending">답변 대기</option>
				<option value="answered">답변 완료</option>
			</select>
		</div>
	</div>

	<!-- 문의 목록 테이블 -->
	<c:if test="${empty allPosts}">
		<div class="no-posts">
			<i>📋</i>
			등록된 문의글이 없습니다.
		</div>
	</c:if>
	
	<c:if test="${not empty allPosts}">
		<table class="qna-table" id="qnaTable">
			<thead>
				<tr>
					<th width="8%">번호</th>
					<th width="12%">작성자</th>
					<th width="40%">제목</th>
					<th width="15%">작성일</th>
					<th width="12%">답변 상태</th>
					<th width="13%">답변일</th>
				</tr>
			</thead>
			<tbody id="qnaTableBody">
				<c:forEach var="post" items="${allPosts}" varStatus="vs">
					<tr data-status="${empty post.answer ? 'pending' : 'answered'}">
						<td>${post.boardId}</td>
						<td class="writer-cell">${post.writerId}</td>
						<td>
							<a href="qnaView?board_id=${post.boardId}" class="title-link" title="${post.title}">
								${post.title}
							</a>
						</td>
						<td class="date-cell">${post.writeDate}</td>
						<td>
							<c:if test="${empty post.answer}">
								<span class="status-badge status-pending">답변 대기</span>
							</c:if>
							<c:if test="${not empty post.answer}">
								<span class="status-badge status-answered">답변 완료</span>
							</c:if>
						</td>
						<td class="date-cell">
							<c:if test="${not empty post.answerDate}">
								${post.answerDate}
							</c:if>
							<c:if test="${empty post.answerDate}">
								-
							</c:if>
						</td>
					</tr>
				</c:forEach>
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
	</c:if>
</div>

<script>
// 전역 변수
let allQnas = [];
let filteredQnas = [];
let currentPage = 1;
const itemsPerPage = 7;

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 서버에서 받은 데이터를 JavaScript 배열로 변환
    initializeQnaData();
    
    // 기본 기능 초기화
    initSearch();
    
    // 페이징 초기화
    setupPagination();
    renderQnaTable();
});

//서버 데이터를 JavaScript 배열로 변환
function initializeQnaData() {
    allQnas = [];
    
    <c:forEach var="post" items="${allPosts}" varStatus="vs">
        <%-- JSTL fmt:formatDate를 사용하여 JavaScript 변수에 할당할 값 포맷팅 --%>
        <fmt:formatDate value="${post.writeDate}" pattern="yyyy-MM-dd HH:mm:ss" var="formattedJsWriteDate"/>
        <fmt:formatDate value="${post.answerDate}" pattern="yyyy-MM-dd HH:mm:ss" var="formattedJsAnswerDate"/>

        allQnas.push({
            index: ${vs.index + 1},
            boardId: ${post.boardId},
            writerId: '${post.writerId}',
            title: `<c:out value="${post.title}" escapeXml="true"/>`, // HTML 엔티티 이스케이프 적용
            writeDate: '${formattedJsWriteDate}', // 포맷팅된 값 사용
            answer: `<c:out value="${post.answer}" escapeXml="true"/>`, // HTML 엔티티 이스케이프 적용
            answerDate: '${empty post.answerDate ? "" : formattedJsAnswerDate}', // 포맷팅된 값 사용 (null 처리)
            status: '${empty post.answer ? "pending" : "answered"}'
        });
    </c:forEach>
    
    // allPosts가 비어있지 않을 때만 복사
    if (allQnas.length > 0) {
        filteredQnas = [...allQnas];
    } else {
        filteredQnas = []; // 데이터가 없으면 빈 배열로 초기화
    }
}

// 페이징 설정
function setupPagination() {
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    
    if (prevBtn && nextBtn) {
        prevBtn.addEventListener('click', function() {
            if (currentPage > 1) {
                currentPage--;
                renderQnaTable();
                updatePaginationUI();
            }
        });
        
        nextBtn.addEventListener('click', function() {
            const totalPages = Math.ceil(filteredQnas.length / itemsPerPage);
            if (currentPage < totalPages) {
                currentPage++;
                renderQnaTable();
                updatePaginationUI();
            }
        });
    }
}

// 테이블 렌더링
function renderQnaTable() {
    const tbody = document.getElementById('qnaTableBody');
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const currentPageQnas = filteredQnas.slice(startIndex, endIndex);
    
    // 테이블 내용 생성
    let tableHTML = '';
    currentPageQnas.forEach((qna, index) => {
        const globalIndex = startIndex + index + 1;
        
        const statusText = qna.status === 'pending' ? '답변 대기' : '답변 완료';
        const statusClass = qna.status === 'pending' ? 'status-pending' : 'status-answered';
        const answerDateText = qna.answerDate || '-';
        
        tableHTML += `
            <tr data-status="\${qna.status}">
                <td>\${qna.boardId}</td>
                <td class="writer-cell">\${qna.writerId}</td>
                <td>
                    <a href="qnaView?board_id=\${qna.boardId}" class="title-link" title="\${qna.title}">
                        \${qna.title}
                    </a>
                </td>
                <td class="date-cell">\${qna.writeDate}</td>
                <td>
                    <span class="status-badge \${statusClass}">\${statusText}</span>
                </td>
                <td class="date-cell">\${answerDateText}</td>
            </tr>
        `;
    });
    
    tbody.innerHTML = tableHTML;
    updatePaginationUI();
}

// 페이징 UI 업데이트
function updatePaginationUI() {
    const totalPages = Math.ceil(filteredQnas.length / itemsPerPage);
    
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
    const totalPages = Math.ceil(filteredQnas.length / itemsPerPage);
    if (page >= 1 && page <= totalPages) {
        currentPage = page;
        renderQnaTable();
    }
}

// 검색 및 필터 기능
function initSearch() {
    const searchInput = document.getElementById('qnaSearchInput');
    const statusFilter = document.getElementById('statusFilter');
    
    function applyFilters() {
        const searchTerm = searchInput.value.toLowerCase();
        const selectedStatus = statusFilter.value;
        
        filteredQnas = allQnas.filter(qna => {
            const matchesSearch = qna.title.toLowerCase().includes(searchTerm) || 
                                qna.writerId.toLowerCase().includes(searchTerm);
            
            const matchesStatus = !selectedStatus || qna.status === selectedStatus;
            
            return matchesSearch && matchesStatus;
        });
        
        currentPage = 1; // 필터링 후 첫 페이지로
        renderQnaTable();
    }
    
    searchInput.addEventListener('input', applyFilters);
    statusFilter.addEventListener('change', applyFilters);
}
</script>

<%@ include file="Footer.jsp" %>
</body>
</html>