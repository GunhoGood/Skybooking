<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Board" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.Users" %>

<%
    // 로그인 체크
    Users loggedInUser = (Users) session.getAttribute("user");

    if (loggedInUser == null) {
        response.sendRedirect("login");
        return;
    }

    String userId = loggedInUser.getId();

    BoardDao boardDao = new BoardDao();
    List<Board> myPosts = boardDao.selectMyPosts(userId);

    // 통계 계산
    int totalCount = myPosts.size();
    int pendingCount = 0;
    int answeredCount = 0;
    
    for (Board post : myPosts) {
        if (post.getAnswer() == null || post.getAnswer().trim().isEmpty()) {
            pendingCount++;
        } else {
            answeredCount++;
        }
    }

    request.setAttribute("myPosts", myPosts);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 문의글 - SkyBooking</title>
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
	padding: 50px 40px 40px;
	border-radius: 16px;
	box-shadow: 0 4px 25px rgba(0, 0, 0, 0.08);
	border: 1px solid #f1f5f9;
}

.admin-container h2 {
	text-align: center;
	color: #2563eb;
	margin-bottom: 15px;
	font-size: 32px;
	font-weight: bold;
}

.admin-container h4 {
	text-align: center;
	color: #64748b;
	margin-bottom: 40px;
	font-weight: normal;
	font-size: 16px;
	max-width: 600px;
	margin-left: auto;
	margin-right: auto;
	line-height: 1.6;
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

..right-controls {
	display: flex;
	gap: 15px;
	align-items: center;
	flex-wrap: nowrap;
	flex-direction: row;
}

.category-filters {
	display: flex;
	gap: 6px;
	align-items: center;
	flex-wrap: nowrap;
}

.category-btn {
	padding: 6px 12px;
	border: 2px solid #e5e7eb;
	background-color: white;
	color: #6b7280;
	border-radius: 20px;
	cursor: pointer;
	font-size: 12px;
	font-weight: 600;
	transition: all 0.3s ease;
	white-space: nowrap;
	flex-shrink: 0;
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
	text-decoration: none;
	display: inline-block;
}

.add-btn:hover {
	background-color: #29B6F6;
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
	color: white;
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

.title-link:hover {
	text-decoration: underline;
	color: #2563eb;
}

.board-id-cell {
	font-family: 'Courier New', monospace;
	font-weight: bold;
	color: #2563eb;
}

.date-cell {
	font-family: 'Courier New', monospace;
	font-size: 12px;
	color: #6b7280;
}

.no-posts {
	text-align: center;
	padding: 80px 20px;
	background: linear-gradient(135deg, #f8fafc, #f1f5f9);
	border-radius: 16px;
	border: 2px dashed #cbd5e1;
	margin: 40px 0;
}

.no-posts i {
	font-size: 64px;
	margin-bottom: 20px;
	display: block;
	opacity: 0.6;
}

.no-posts-title {
	font-size: 20px;
	color: #475569;
	margin-bottom: 8px;
	font-weight: 600;
}

.no-posts-desc {
	font-size: 16px;
	color: #64748b;
	margin-bottom: 30px;
	line-height: 1.5;
}

.no-posts-btn {
	display: inline-block;
	padding: 14px 28px;
	background: linear-gradient(135deg, #2563eb, #3b82f6);
	color: white;
	text-decoration: none;
	border-radius: 8px;
	font-weight: 600;
	font-size: 16px;
	transition: all 0.3s ease;
	box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.no-posts-btn:hover {
	background: linear-gradient(135deg, #1d4ed8, #2563eb);
	transform: translateY(-2px);
	box-shadow: 0 6px 16px rgba(37, 99, 235, 0.4);
	color: white;
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
	.right-group {
		order: 2;
		flex-direction: row;
		align-items: center;
		gap: 8px;
		flex-wrap: wrap;
	}
	.category-filters {
		justify-content: flex-start;
	}
	.add-btn {
		text-align: center;
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
	<h2>내 문의글</h2>
	<h4>작성하신 문의글 목록을 확인하고 답변 상태를 조회할 수 있습니다</h4>

	<!-- 관리 도구 -->
	<div class="admin-controls">
		<div class="search-container">
			<input type="text" class="search-box" id="searchInput"
				placeholder="제목으로 검색...">
			<span class="search-icon">🔍</span>
		</div>
		
		<div class="right-group">
			<button class="category-btn active" data-status="">전체</button>
			<button class="category-btn" data-status="pending">답변 대기</button>
			<button class="category-btn" data-status="answered">답변 완료</button>
			<a href="${pageContext.request.contextPath}/inquiryWrite" class="add-btn">+ 새 문의 작성</a>
		</div>
	</div>

	<!-- 문의글 목록 테이블 -->
	<c:if test="${empty myPosts}">
		<div class="no-posts">
			<i>📝</i>
			<div class="no-posts-title">작성하신 문의글이 없습니다</div>
			<div class="no-posts-desc">궁금한 사항이 있으시면 언제든지 문의해 주세요!</div>
			<a href="${pageContext.request.contextPath}/inquiryWrite" class="no-posts-btn">
				✏️ 첫 문의글 작성하기
			</a>
		</div>
	</c:if>
	
	<c:if test="${not empty myPosts}">
		<table class="qna-table" id="qnaTable">
			<thead>
				<tr>
					<th width="10%">번호</th>
					<th width="45%">제목</th>
					<th width="15%">작성일</th>
					<th width="15%">답변 상태</th>
					<th width="15%">답변일</th>
				</tr>
			</thead>
			<tbody id="qnaTableBody">
				<c:forEach var="post" items="${myPosts}" varStatus="vs">
					<tr data-status="${empty post.answer ? 'pending' : 'answered'}">
						<td class="board-id-cell">${post.boardId}</td>
						<td>
							<a href="${pageContext.request.contextPath}/viewBoard?board_id=${post.boardId}" 
							   class="title-link" title="${post.title}">
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
let allPosts = [];
let filteredPosts = [];
let currentPage = 1;
const itemsPerPage = 7;

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    // 서버에서 받은 데이터를 JavaScript 배열로 변환
    initializePostData();
    
    // 기본 기능 초기화
    initSearch();
    
    // 페이징 초기화 (데이터가 있을 때만)
    if (allPosts.length > 0) {
        setupPagination();
        renderPostTable();
    }
});

// 서버 데이터를 JavaScript 배열로 변환
function initializePostData() {
    allPosts = [];
    
    <c:forEach var="post" items="${myPosts}" varStatus="vs">
        // 여기서 JSTL fmt:formatDate를 사용하여 포맷팅된 값을 가져옵니다.
        <fmt:formatDate value="${post.writeDate}" pattern="yyyy-MM-dd HH:mm:ss" var="formattedJsWriteDate"/>
        <fmt:formatDate value="${post.answerDate}" pattern="yyyy-MM-dd HH:mm:ss" var="formattedJsAnswerDate"/>

        allPosts.push({
            index: ${vs.index + 1},
            boardId: ${post.boardId},
            title: '${post.title}',
            // 포맷팅된 JSP 변수 사용
            writeDate: '${formattedJsWriteDate}',
            answer: '${post.answer}',
            // 포맷팅된 JSP 변수 사용 (null일 경우 빈 문자열)
            answerDate: '${empty post.answerDate ? "" : formattedJsAnswerDate}',
            status: '${empty post.answer ? "pending" : "answered"}'
        });
    </c:forEach>
    
    // myPosts가 비어있지 않을 때만 복사
    if (allPosts.length > 0) {
        filteredPosts = [...allPosts];
    } else {
        filteredPosts = []; // 데이터가 없으면 빈 배열로 초기화
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
                renderPostTable();
                updatePaginationUI();
            }
        });
        
        nextBtn.addEventListener('click', function() {
            const totalPages = Math.ceil(filteredPosts.length / itemsPerPage);
            if (currentPage < totalPages) {
                currentPage++;
                renderPostTable();
                updatePaginationUI();
            }
        });
    }
}

// 테이블 렌더링
function renderPostTable() {
    const tbody = document.getElementById('qnaTableBody');
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const currentPagePosts = filteredPosts.slice(startIndex, endIndex);
    
    // 테이블 내용 생성
    let tableHTML = '';
    currentPagePosts.forEach((post, index) => {
        const globalIndex = startIndex + index + 1;
        
        const statusText = post.status === 'pending' ? '답변 대기' : '답변 완료';
        const statusClass = post.status === 'pending' ? 'status-pending' : 'status-answered';
        const answerDateText = post.answerDate || '-';
        
        tableHTML += `
            <tr data-status="\${post.status}">
                <td class="board-id-cell">\${post.boardId}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/viewBoard?board_id=\${post.boardId}" 
                       class="title-link" title="\${post.title}">
                        \${post.title}
                    </a>
                </td>
                <td class="date-cell">\${post.writeDate}</td>
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
    const totalPages = Math.ceil(filteredPosts.length / itemsPerPage);
    
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
    const totalPages = Math.ceil(filteredPosts.length / itemsPerPage);
    if (page >= 1 && page <= totalPages) {
        currentPage = page;
        renderPostTable();
    }
}

// 검색 및 필터 기능
function initSearch() {
    const searchInput = document.getElementById('searchInput');
    const categoryBtns = document.querySelectorAll('.category-btn');
    
    let selectedStatus = '';
    
    // 카테고리 버튼 이벤트
    categoryBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            // 모든 버튼에서 active 클래스 제거
            categoryBtns.forEach(b => b.classList.remove('active'));
            // 클릭된 버튼에 active 클래스 추가
            this.classList.add('active');
            
            selectedStatus = this.dataset.status;
            applyFilters();
        });
    });
    
    function applyFilters() {
        const searchTerm = searchInput.value.toLowerCase();
        
        filteredPosts = allPosts.filter(post => {
            const matchesSearch = post.title.toLowerCase().includes(searchTerm);
            const matchesStatus = !selectedStatus || post.status === selectedStatus;
            
            return matchesSearch && matchesStatus;
        });
        
        currentPage = 1; // 필터링 후 첫 페이지로
        renderPostTable();
    }
    
    searchInput.addEventListener('input', applyFilters);
}
</script>

<%@ include file="Footer.jsp" %>
</body>
</html>