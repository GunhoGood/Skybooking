<%@page import="dto.Users"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
// 관리자 권한 체크
String userId = (String) session.getAttribute("id");
Users loginUser = (Users) session.getAttribute("user");
if (userId == null || loginUser == null || loginUser.getAdmin() != 1) {
	response.sendRedirect("main");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리 - SkyBooking Admin</title>
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

.member-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 30px;
	background: white;
	border-radius: 8px;
	overflow: hidden;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.member-table th {
	background-color: #2563eb;
	color: white;
	padding: 15px 12px;
	text-align: center;
	font-weight: bold;
	font-size: 14px;
}

.member-table td {
	padding: 12px 8px;
	border-bottom: 1px solid #eee;
	vertical-align: middle;
	text-align: center;
	font-size: 13px;
	height: 50px;
}

.member-table tr:hover {
	background-color: #f8f9fa;
}

.admin-badge {
	display: inline-block;
	padding: 4px 12px;
	border-radius: 12px;
	font-size: 12px;
	font-weight: bold;
	color: white;
}

.admin-badge.admin {
	background-color: #ef4444;
}

.admin-badge.user {
	background-color: #10b981;
}

.gender-badge {
	display: inline-block;
	padding: 4px 8px;
	border-radius: 8px;
	font-size: 11px;
	font-weight: bold;
	min-width: 35px;
	text-align: center;
}

.gender-badge.male {
	background-color: #dbeafe;
	color: #1d4ed8;
}

.gender-badge.female {
	background-color: #fce7f3;
	color: #be185d;
}

.admin-action {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	white-space: nowrap;
	min-height: 32px;
}

.admin-badge {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 12px;
	font-size: 11px;
	font-weight: bold;
	color: white;
	min-width: 60px;
	text-align: center;
}

.admin-badge.admin {
	background-color: #ef4444;
}

.admin-badge.user {
	background-color: #10b981;
}

.delete-btn {
	background-color: #ef4444;
	color: white;
	border: none;
	padding: 4px 10px;
	border-radius: 4px;
	cursor: pointer;
	font-size: 11px;
	font-weight: bold;
	transition: all 0.3s ease;
	min-width: 40px;
}

.delete-btn:hover {
	background-color: #dc2626;
	transform: translateY(-1px);
}

.protected-text {
	color: #999;
	font-size: 11px;
	font-weight: 500;
	min-width: 40px;
	text-align: center;
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

.email-cell {
	max-width: 180px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

.address-cell {
	max-width: 200px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

.phone-cell {
	font-family: 'Courier New', monospace;
	font-size: 12px;
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

@media ( max-width : 768px) {
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
	.member-table {
		font-size: 11px;
	}
	.member-table th, .member-table td {
		padding: 8px 6px;
	}
	.stats-container {
		flex-direction: column;
	}
	.email-cell, .address-cell {
		max-width: 120px;
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
				<h3	style="display: inline; color: #666;">FAQ 관리</h3>
			</a> 
			<a href="hoteladmin" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">호텔 관리</h3>
			</a> 
			<a href="memberList" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #2563eb;">고객 관리</h3>
			</a> 
			<a href="AdminFlight" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">항공편 관리</h3>
			</a>
			<a href="qnaList" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">문의 관리</h3>
			</a>
		</div>
		<h4>가입된 회원들을 조회하고 관리할 수 있습니다</h4>

		<!-- 통계 카드 -->
		<div class="stats-container">
			<div class="stat-card">
				<h3>
					<c:out value="${fn:length(memberList)}" />
				</h3>
				<p>전체 회원 수</p>
			</div>
			<div class="stat-card">
				<h3 id="adminCount">0</h3>
				<p>관리자</p>
			</div>
			<div class="stat-card">
				<h3 id="userCount">0</h3>
				<p>일반 회원</p>
			</div>
		</div>

		<!-- 관리 도구 -->
		<div class="admin-controls">
			<div class="search-container">
				<input type="text" class="search-box" id="memberSearchInput"
					placeholder="회원 검색 (이름, 아이디, 이메일)..."> <span
					class="search-icon">🔍</span>
			</div>
			<div class="filter-container">
				<select class="filter-select" id="genderFilter">
					<option value="">전체 성별</option>
					<option value="M">남성</option>
					<option value="F">여성</option>
				</select> <select class="filter-select" id="adminFilter">
					<option value="">전체 권한</option>
					<option value="1">관리자</option>
					<option value="0">일반회원</option>
				</select>
			</div>
		</div>

		<!-- 회원 목록 테이블 -->
		<table class="member-table" id="memberTable">
			<thead>
				<tr>
					<th width="5%">번호</th>
					<th width="9%">아이디</th>
					<th width="7%">이름</th>
					<th width="16%">이메일</th>
					<th width="10%">전화번호</th>
					<th width="18%">주소</th>
					<th width="5%">성별</th>
					<th width="9%">생년월일</th>
					<th width="9%">가입일</th>
					<th width="12%">권한/관리</th>
				</tr>
			</thead>
			<tbody id="memberTableBody">
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

	<script>
        // 전역 변수
        let allMembers = []; // 모든 회원 데이터
        let filteredMembers = []; // 필터링된 회원 데이터  
        let currentPage = 1;
        const itemsPerPage = 7;

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            console.log('회원 관리 페이지 로드 완료');
            
            // 서버에서 받은 데이터를 JavaScript 배열로 변환
            initializeMemberData();
            
            // 기본 기능 초기화
            calculateStats();
            initSearch();
            
            // 페이징 초기화
            setupPagination();
            renderMemberTable();
            
            console.log('초기화 완료');
        });

        // 서버 데이터를 JavaScript 배열로 변환
        function initializeMemberData() {
            allMembers = [];
            
            <c:forEach var="u" items="${memberList}" varStatus="vs">
                allMembers.push({
                    index: ${vs.index + 1},
                    id: '${u.id}',
                    name: '${u.name}',
                    email: '${u.email}',
                    phone: '${u.phone}',
                    address: '${u.address}',
                    gender: '${u.gender}',
                    birth: '${u.birth}',
                    createDate: '<fmt:formatDate value="${u.createDate}" pattern="yyyy-MM-dd" />',
                    admin: ${u.admin}
                });
            </c:forEach>
            
            filteredMembers = [...allMembers];
        }

        // 페이징 설정
        function setupPagination() {
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            
            if (prevBtn && nextBtn) {
                prevBtn.addEventListener('click', function() {
                    if (currentPage > 1) {
                        currentPage--;
                        renderMemberTable();
                        updatePaginationUI();
                    }
                });
                
                nextBtn.addEventListener('click', function() {
                    const totalPages = Math.ceil(filteredMembers.length / itemsPerPage);
                    if (currentPage < totalPages) {
                        currentPage++;
                        renderMemberTable();
                        updatePaginationUI();
                    }
                });
            }
        }

        // 테이블 렌더링
        function renderMemberTable() {
            const tbody = document.getElementById('memberTableBody');
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const currentPageMembers = filteredMembers.slice(startIndex, endIndex);
            
            // 테이블 내용 생성
            let tableHTML = '';
            currentPageMembers.forEach((member, index) => {
                const globalIndex = startIndex + index + 1;
                
                const genderText = member.gender === 'M' ? '남성' : '여성';
                const genderClass = member.gender === 'M' ? 'male' : 'female';
                const adminText = member.admin === 1 ? '관리자' : '일반회원';
                const adminClass = member.admin === 1 ? 'admin' : 'user';
                
                let actionHTML = '';
                if (member.admin !== 1) {
                    actionHTML = `
                        <div class="admin-action">
                            <span class="admin-badge \${adminClass}">\${adminText}</span>
                            <form action="deleteUser" method="post"
                                  onsubmit="return confirm('정말 삭제하시겠습니까?');"
                                  style="display: inline;">
                                <input type="hidden" name="id" value="\${member.id}" />
                                <button type="submit" class="delete-btn">삭제</button>
                            </form>
                        </div>
                    `;
                } else {
                    actionHTML = `
                        <div class="admin-action">
                            <span class="admin-badge \${adminClass}">\${adminText}</span>
                            <span class="protected-text">보호됨</span>
                        </div>
                    `;
                }
                
                tableHTML += `
                    <tr data-admin="\${member.admin}" data-gender="\${member.gender}">
                        <td>\${globalIndex}</td>
                        <td><strong>\${member.id}</strong></td>
                        <td>\${member.name}</td>
                        <td class="email-cell" title="\${member.email}">\${member.email}</td>
                        <td class="phone-cell">\${member.phone}</td>
                        <td class="address-cell" title="\${member.address}">\${member.address}</td>
                        <td><span class="gender-badge \${genderClass}">\${genderText}</span></td>
                        <td>\${member.birth}</td>
                        <td>\${member.createDate}</td>
                        <td>\${actionHTML}</td>
                    </tr>
                `;
            });
            
            tbody.innerHTML = tableHTML;
            updatePaginationUI();
        }

        // 페이징 UI 업데이트
        function updatePaginationUI() {
            const totalPages = Math.ceil(filteredMembers.length / itemsPerPage);
            
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
            const totalPages = Math.ceil(filteredMembers.length / itemsPerPage);
            if (page >= 1 && page <= totalPages) {
                currentPage = page;
                renderMemberTable();
            }
        }

        // 통계 계산
        function calculateStats() {
            let adminCount = 0;
            let userCount = 0;
            
            allMembers.forEach(member => {
                if (member.admin === 1) {
                    adminCount++;
                } else {
                    userCount++;
                }
            });
            
            document.getElementById('adminCount').textContent = adminCount;
            document.getElementById('userCount').textContent = userCount;
        }

        // 검색 기능
        function initSearch() {
            const searchInput = document.getElementById('memberSearchInput');
            const genderFilter = document.getElementById('genderFilter');
            const adminFilter = document.getElementById('adminFilter');
            
            function applyFilters() {
                const searchTerm = searchInput.value.toLowerCase();
                const selectedGender = genderFilter.value;
                const selectedAdmin = adminFilter.value;
                
                filteredMembers = allMembers.filter(member => {
                    const matchesSearch = member.id.toLowerCase().includes(searchTerm) || 
                                        member.name.toLowerCase().includes(searchTerm) || 
                                        member.email.toLowerCase().includes(searchTerm);
                    
                    const matchesGender = !selectedGender || member.gender === selectedGender;
                    const matchesAdmin = !selectedAdmin || member.admin.toString() === selectedAdmin;
                    
                    return matchesSearch && matchesGender && matchesAdmin;
                });
                
                currentPage = 1; // 필터링 후 첫 페이지로
                renderMemberTable();
            }
            
            searchInput.addEventListener('input', applyFilters);
            genderFilter.addEventListener('change', applyFilters);
            adminFilter.addEventListener('change', applyFilters);
        }
    </script>

	<%@ include file="Footer.jsp"%>
</body>
</html>