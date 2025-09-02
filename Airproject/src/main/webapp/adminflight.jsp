<%@page import="dto.Users"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>항공편 관리 - SkyBooking Admin</title>
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

        .add-flight-form {
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 30px;
            border: 2px solid #e9ecef;
        }

        .add-flight-form h3 {
            color: #2563eb;
            margin-bottom: 20px;
            text-align: center;
            font-size: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
            font-size: 14px;
        }

        .form-group input, .form-group select {
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #2563eb;
        }

        .submit-btn {
            background-color: #2563eb;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }

        .submit-btn:hover {
            background-color: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
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
            flex: 1;
            min-width: 300px;
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

        .flight-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .flight-table th {
            background-color: #2563eb;
            color: white;
            padding: 15px 12px;
            text-align: center;
            font-weight: bold;
            font-size: 14px;
        }

        .flight-table td {
            padding: 15px 12px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
            text-align: center;
            font-size: 13px;
        }

        .flight-table tr:hover {
            background-color: #f8f9fa;
        }

        .delete-btn, .edit-btn {
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            transition: all 0.3s ease;
            margin: 0 5px;
            min-width: 50px;
        }

        .delete-btn {
            background-color: #ef4444;
            color: white;
        }

        .delete-btn:hover {
            background-color: #dc2626;
            transform: translateY(-1px);
        }

        .edit-btn {
            background-color: #10b981;
            color: white;
        }

        .edit-btn:hover {
            background-color: #059669;
            transform: translateY(-1px);
        }


        .flight-id-cell {
            font-family: 'Courier New', monospace;
            font-weight: bold;
            color: #2563eb;
        }

        .airline-cell {
            font-weight: bold;
        }

        .time-cell {
            font-family: 'Courier New', monospace;
            font-size: 12px;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
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
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: #000;
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

        .pagination button:disabled:hover {
            box-shadow: none;
        }

        .pagination-info {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            color: #475569;
            font-size: 14px;
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 8px;
            margin: 0 15px;
            border: 2px solid #e2e8f0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .pagination-info span {
            font-weight: 700;
            color: #2563eb;
        }

        /* 이전/다음 버튼 특별 스타일 */
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

        .pagination .nav-btn:disabled {
            background: #f8fafc;
            color: #cbd5e1;
        }

        /* 반응형 디자인 */
        @media (max-width: 640px) {
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
            
            .pagination-info {
                font-size: 12px;
                padding: 10px 16px;
                margin: 0 8px;
                order: -1;
                width: 100%;
                text-align: center;
                margin-bottom: 15px;
            }
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
                min-width: auto;
            }
            
            .flight-table {
                font-size: 11px;
            }
            
            .flight-table th, .flight-table td {
                padding: 8px 6px;
            }
            
            .stats-container {
                flex-direction: column;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
	<%@ include file="Navi.jsp" %>

    <div class="admin-container">
        <div class="admin-info">
			🔐 관리자 모드 |
			<%=userId%>
			님이 로그인됨
		</div>

        <!-- 관리자 메뉴 링크 -->
        <div style="text-align: center; margin-bottom: 20px;">
			<a href="faqadmin" style="text-decoration: none; margin: 0 15px;">
				<h3	style="display: inline; color: #666;">FAQ 관리</h3>
			</a> 
			<a href="hoteladmin" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">호텔 관리</h3>
			</a> 
			<a href="memberList" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">고객 관리</h3>
			</a> 
			<a href="AdminFlight" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #2563eb;">항공편 관리</h3>
			</a>
			<a href="qnaList" style="text-decoration: none; margin: 0 15px;">
				<h3 style="display: inline; color: #666;">문의 관리</h3>
			</a>
		</div>

        
        <h4>항공편을 추가, 수정, 삭제할 수 있습니다</h4>

        <c:if test="${not empty message}">
            <div class="message-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message-error">${error}</div>
        </c:if>

        <div class="stats-container">
            <div class="stat-card">
                <h3><c:out value="${fn:length(flightList)}"/></h3>
                <p>전체 항공편 수</p>
            </div>
            <div class="stat-card">
                <h3 id="todayFlights">0</h3>
                <p>오늘 운항</p>
            </div>
            <div class="stat-card">
                <h3 id="totalSeats">0</h3>
                <p>총 좌석 수</p>
            </div>
        </div>

        <div class="add-flight-form">
            <h3>✈️ 새 항공편 추가</h3>
            <form action="AdminFlight" method="post" onsubmit="return validateFlightForm()">
                <input type="hidden" name="action" value="insert">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="flightId">항공편 번호 *</label>
                        <input type="text" id="flightId" name="flightId" required 
                               placeholder="예: KE123" maxlength="10">
                    </div>
                    <div class="form-group">
                        <label for="airline">항공사 *</label>
                        <select id="airline" name="airline" required>
                            <option value="">항공사 선택</option>
                            <option value="대한항공">대한항공</option>
                            <option value="아메리칸항공">아메리칸항공</option>
                            <option value="싱가포르항공">싱가포르항공</option>
                            <option value="타이항공">타이항공</option>
                            <option value="아시아나항공">아시아나항공</option>
                            <option value="제주항공">제주항공</option>
                            <option value="진에어">진에어</option>
                            <option value="티웨이항공">티웨이항공</option>
                            <option value="에어부산">에어부산</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="departureCity">출발지 *</label>
                        <select id="departureCity" name="departureCity" required>
                            <option value="">출발지 선택</option>
                            <option value="ICN">ICN (인천국제공항)</option>
                            <option value="NRT">NRT (나리타국제공항)</option>
                            <option value="LAX">LAX (로스앤젤레스국제공항)</option>
                            <option value="SIN">SIN (싱가포르 창이공항)</option>
                            <option value="BKK">BKK (방콕 수완나품공항)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="arrivalCity">도착지 *</label>
                        <select id="arrivalCity" name="arrivalCity" required>
                            <option value="">도착지 선택</option>
                            <option value="ICN">ICN (인천국제공항)</option>
                            <option value="NRT">NRT (나리타국제공항)</option>
                            <option value="LAX">LAX (로스앤젤레스국제공항)</option>
                            <option value="SIN">SIN (싱가포르 창이공항)</option>
                            <option value="BKK">BKK (방콕 수완나품공항)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="departureTime">출발시간 *</label>
                        <input type="time" id="departureTime" name="departureTime" required>
                    </div>
                    <div class="form-group">
                        <label for="arrivalTime">도착시간 *</label>
                        <input type="time" id="arrivalTime" name="arrivalTime" required>
                    </div>
                    <div class="form-group">
                        <label for="flightDate">운항날짜 *</label>
                        <input type="date" id="flightDate" name="flightDate" required>
                    </div>
                </div>
                <button type="submit" class="submit-btn">항공편 추가</button>
            </form>
        </div>

        <div class="admin-controls">
            <div class="search-container">
                <input type="text" class="search-box" id="flightSearchInput" 
                       placeholder="항공편 검색 (항공편번호, 항공사, 출발지, 도착지)...">
                <span class="search-icon">🔍</span>
            </div>
            <div class="filter-container">
                <select class="filter-select" id="airlineFilter">
                    <option value="">전체 항공사</option>
                    <option value="대한항공">대한항공</option>
                    <option value="아메리칸항공">아메리칸항공</option>
                    <option value="싱가포르항공">싱가포르항공</option>
                    <option value="타이항공">타이항공</option>
                    <option value="아시아나항공">아시아나항공</option>
                    <option value="제주항공">제주항공</option>
                    <option value="진에어">진에어</option>
                    <option value="티웨이항공">티웨이항공</option>
                    <option value="에어부산">에어부산</option>
                </select>
                <select class="filter-select" id="dateFilter">
                    <option value="">전체 날짜</option>
                    <option value="today">오늘</option>
                    <option value="week">이번 주</option>
                    <option value="month">이번 달</option>
                </select>
            </div>
        </div>

        <table class="flight-table" id="flightTable">
            <thead>
                <tr>
                    <th width="6%">번호</th>
                    <th width="10%">항공편번호</th>
                    <th width="10%">항공사</th>
                    <th width="8%">출발지</th>
                    <th width="8%">도착지</th>
                    <th width="8%">출발시간</th>
                    <th width="8%">도착시간</th>
                    <th width="10%">운항날짜</th>
                    <th width="6%">총좌석</th>
                    <th width="6%">예약가능</th>
                    <th width="20%">관리</th>
                </tr>
            </thead>
            <tbody id="flightTableBody">
                <c:forEach var="f" items="${flightList}" varStatus="vs">
                    <tr data-airline="${f.airline}" data-date="${f.flightDate}">
                        <td>${vs.index + 1}</td>
                        <td class="flight-id-cell">${f.flightId}</td>
                        <td class="airline-cell">${f.airline}</td>
                        <td>${f.departureCity}</td>
                        <td>${f.arrivalCity}</td>
                        <td class="time-cell">${f.departureTime}</td>
                        <td class="time-cell">${f.arrivalTime}</td>
                        <td>${f.flightDate}</td>
                        <td>20</td>
                        <td>${f.availableSeats}</td>
                        <td>
                            <button type="button" class="edit-btn" 
                                    onclick="openEditModal('${f.flightId}', '${f.airline}', '${f.departureCity}', '${f.arrivalCity}', '${f.departureTime}', '${f.arrivalTime}', '${f.flightDate}')">
                                수정
                            </button>
                            <form action="AdminFlight" method="post"
                                  onsubmit="return confirm('정말 삭제하시겠습니까? 관련 좌석과 예약도 모두 삭제됩니다.');" 
                                  style="display: inline;">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="flightId" value="${f.flightId}" />
                                <button type="submit" class="delete-btn">삭제</button>
                            </form>
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

        
    </div>

    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h3>항공편 수정</h3>
            <form action="AdminFlight" method="post" onsubmit="return validateEditForm()">
                <input type="hidden" name="action" value="update">
                <input type="hidden" id="editFlightId" name="flightId">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="editAirline">항공사 *</label>
                        <select id="editAirline" name="airline" required>
                            <option value="대한항공">대한항공</option>
                            <option value="아메리칸항공">아메리칸항공</option>
                            <option value="싱가포르항공">싱가포르항공</option>
                            <option value="타이항공">타이항공</option>
                            <option value="아시아나항공">아시아나항공</option>
                            <option value="제주항공">제주항공</option>
                            <option value="진에어">진에어</option>
                            <option value="티웨이항공">티웨이항공</option>
                            <option value="에어부산">에어부산</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editDepartureCity">출발지 *</label>
                        <select id="editDepartureCity" name="departureCity" required>
                            <option value="ICN">ICN (인천국제공항)</option>
                            <option value="NRT">NRT (나리타국제공항)</option>
                            <option value="LAX">LAX (로스앤젤레스국제공항)</option>
                            <option value="SIN">SIN (싱가포르 창이공항)</option>
                            <option value="BKK">BKK (방콕 수완나품공항)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editArrivalCity">도착지 *</label>
                        <select id="editArrivalCity" name="arrivalCity" required>
                            <option value="ICN">ICN (인천국제공항)</option>
                            <option value="NRT">NRT (나리타국제공항)</option>
                            <option value="LAX">LAX (로스앤젤레스국제공항)</option>
                            <option value="SIN">SIN (싱가포르 창이공항)</option>
                            <option value="BKK">BKK (방콕 수완나품공항)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editDepartureTime">출발시간 *</label>
                        <input type="time" id="editDepartureTime" name="departureTime" required>
                    </div>
                    <div class="form-group">
                        <label for="editArrivalTime">도착시간 *</label>
                        <input type="time" id="editArrivalTime" name="arrivalTime" required>
                    </div>
                    <div class="form-group">
                        <label for="editFlightDate">운항날짜 *</label>
                        <input type="date" id="editFlightDate" name="flightDate" required>
                    </div>
                </div>
                <button type="submit" class="submit-btn">수정 완료</button>
            </form>
        </div>
    </div>

    <script>
        // 전역 변수
        let allFlights = []; // 모든 항공편 데이터
        let filteredFlights = []; // 필터링된 항공편 데이터  
        let currentPage = 1;
        const itemsPerPage = 7;

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', function() {
            // 서버에서 받은 데이터를 JavaScript 배열로 변환
            initializeFlightData();
            
            // 기본 기능 초기화
            calculateStats();
            initSearch();
            setMinDate();
            
            // 페이징 초기화
            setupPagination();
            renderFlightTable();
        });

        // 서버 데이터를 JavaScript 배열로 변환
        function initializeFlightData() {
            allFlights = [];
            
            <c:forEach var="f" items="${flightList}" varStatus="vs">
                allFlights.push({
                    index: ${vs.index + 1},
                    flightId: '${f.flightId}',
                    airline: '${f.airline}',
                    departureCity: '${f.departureCity}',
                    arrivalCity: '${f.arrivalCity}',
                    departureTime: '${f.departureTime}',
                    arrivalTime: '${f.arrivalTime}',
                    flightDate: '${f.flightDate}',
                    availableSeats: ${f.availableSeats}
                });
            </c:forEach>
            
            filteredFlights = [...allFlights];
        }

        // 페이징 설정
        function setupPagination() {
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            
            if (prevBtn && nextBtn) {
                prevBtn.addEventListener('click', function() {
                    if (currentPage > 1) {
                        currentPage--;
                        renderFlightTable();
                        updatePaginationUI();
                    }
                });
                
                nextBtn.addEventListener('click', function() {
                    const totalPages = Math.ceil(filteredFlights.length / itemsPerPage);
                    if (currentPage < totalPages) {
                        currentPage++;
                        renderFlightTable();
                        updatePaginationUI();
                    }
                });
            }
        }

        // 테이블 렌더링
        function renderFlightTable() {
            const tbody = document.getElementById('flightTableBody');
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const currentPageFlights = filteredFlights.slice(startIndex, endIndex);
            
            // 테이블 내용 생성
            let tableHTML = '';
            currentPageFlights.forEach((flight, index) => {
                const globalIndex = startIndex + index + 1;
                tableHTML += `
                    <tr data-airline="\${flight.airline}" data-date="\${flight.flightDate}">
                        <td>\${globalIndex}</td>
                        <td class="flight-id-cell">\${flight.flightId}</td>
                        <td class="airline-cell">\${flight.airline}</td>
                        <td>\${flight.departureCity}</td>
                        <td>\${flight.arrivalCity}</td>
                        <td class="time-cell">\${flight.departureTime}</td>
                        <td class="time-cell">\${flight.arrivalTime}</td>
                        <td>\${flight.flightDate}</td>
                        <td>20</td>
                        <td>\${flight.availableSeats}</td>
                        <td>
                            <button type="button" class="edit-btn" 
                                    onclick="openEditModal('\${flight.flightId}', '\${flight.airline}', '\${flight.departureCity}', '\${flight.arrivalCity}', '\${flight.departureTime}', '\${flight.arrivalTime}', '\${flight.flightDate}')">
                                수정
                            </button>
                            <form action="AdminFlight" method="post"
                                  onsubmit="return confirm('정말 삭제하시겠습니까? 관련 좌석과 예약도 모두 삭제됩니다.');" 
                                  style="display: inline;">
                                <input type="hidden" name="action" value="delete" />
                                <input type="hidden" name="flightId" value="\${flight.flightId}" />
                                <button type="submit" class="delete-btn">삭제</button>
                            </form>
                        </td>
                    </tr>
                `;
            });
            
            tbody.innerHTML = tableHTML;
            updatePaginationUI();
        }

        // 페이징 UI 업데이트
        function updatePaginationUI() {
            const totalPages = Math.ceil(filteredFlights.length / itemsPerPage);
            
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
            const totalPages = Math.ceil(filteredFlights.length / itemsPerPage);
            if (page >= 1 && page <= totalPages) {
                currentPage = page;
                renderFlightTable();
            }
        }

        // 통계 계산
        function calculateStats() {
            let todayFlights = 0;
            let totalSeats = 0;
            const today = new Date().toISOString().split('T')[0];
            
            allFlights.forEach(flight => {
                if (flight.flightDate === today) {
                    todayFlights++;
                }
                totalSeats += 20; // 항상 20석
            });
            
            document.getElementById('todayFlights').textContent = todayFlights;
            document.getElementById('totalSeats').textContent = totalSeats;
        }

        // 검색 및 필터 기능
        function initSearch() {
            const searchInput = document.getElementById('flightSearchInput');
            const airlineFilter = document.getElementById('airlineFilter');
            const dateFilter = document.getElementById('dateFilter');
            
            function applyFilters() {
                const searchTerm = searchInput.value.toLowerCase();
                const selectedAirline = airlineFilter.value;
                const selectedDateFilter = dateFilter.value;
                const today = new Date();
                
                filteredFlights = allFlights.filter(flight => {
                    const matchesSearch = flight.flightId.toLowerCase().includes(searchTerm) || 
                                        flight.airline.toLowerCase().includes(searchTerm) || 
                                        flight.departureCity.toLowerCase().includes(searchTerm) || 
                                        flight.arrivalCity.toLowerCase().includes(searchTerm);
                    
                    const matchesAirline = !selectedAirline || flight.airline === selectedAirline;
                    
                    let matchesDate = true;
                    if (selectedDateFilter === 'today') {
                        matchesDate = flight.flightDate === today.toISOString().split('T')[0];
                    } else if (selectedDateFilter === 'week') {
                        const flightDate = new Date(flight.flightDate);
                        const weekFromNow = new Date(today.getTime() + 7 * 24 * 60 * 60 * 1000);
                        matchesDate = flightDate >= today && flightDate <= weekFromNow;
                    } else if (selectedDateFilter === 'month') {
                        const flightDate = new Date(flight.flightDate);
                        const monthFromNow = new Date(today.getFullYear(), today.getMonth() + 1, today.getDate());
                        matchesDate = flightDate >= today && flightDate <= monthFromNow;
                    }
                    
                    return matchesSearch && matchesAirline && matchesDate;
                });
                
                currentPage = 1; // 필터링 후 첫 페이지로
                renderFlightTable();
            }
            
            searchInput.addEventListener('input', applyFilters);
            airlineFilter.addEventListener('change', applyFilters);
            dateFilter.addEventListener('change', applyFilters);
        }

        // 폼 유효성 검증
        function validateFlightForm() {
            const departureCity = document.getElementById('departureCity').value;
            const arrivalCity = document.getElementById('arrivalCity').value;
            const departureTime = document.getElementById('departureTime').value;
            const arrivalTime = document.getElementById('arrivalTime').value;
            const flightDate = document.getElementById('flightDate').value;
            
            if (departureCity === arrivalCity) {
                alert('출발지와 도착지는 같을 수 없습니다.');
                return false;
            }
            
            if (departureTime === arrivalTime) {
                alert('출발시간과 도착시간은 같을 수 없습니다.');
                return false;
            }
            
            const selectedDate = new Date(flightDate);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate < today) {
                alert('운항날짜는 오늘 이후여야 합니다.');
                return false;
            }
            
            return true;
        }

        function validateEditForm() {
            const departureCity = document.getElementById('editDepartureCity').value;
            const arrivalCity = document.getElementById('editArrivalCity').value;
            const departureTime = document.getElementById('editDepartureTime').value;
            const arrivalTime = document.getElementById('editArrivalTime').value;
            
            if (departureCity === arrivalCity) {
                alert('출발지와 도착지는 같을 수 없습니다.');
                return false;
            }
            
            if (departureTime === arrivalTime) {
                alert('출발시간과 도착시간은 같을 수 없습니다.');
                return false;
            }
            
            return true;
        }

        // 수정 모달 관련 함수
        function openEditModal(flightId, airline, departureCity, arrivalCity, departureTime, arrivalTime, flightDate) {
            document.getElementById('editFlightId').value = flightId;
            document.getElementById('editAirline').value = airline;
            document.getElementById('editDepartureCity').value = departureCity;
            document.getElementById('editArrivalCity').value = arrivalCity;
            document.getElementById('editDepartureTime').value = departureTime;
            document.getElementById('editArrivalTime').value = arrivalTime;
            document.getElementById('editFlightDate').value = flightDate;
            document.getElementById('editModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        window.onclick = function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        }

        function setMinDate() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('flightDate').setAttribute('min', today);
            document.getElementById('editFlightDate').setAttribute('min', today);
        }
    </script>

    <%@ include file="Footer.jsp" %>
</body>
</html>