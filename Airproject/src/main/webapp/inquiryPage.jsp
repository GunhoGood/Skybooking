<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의하기 - SkyBooking</title>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
<style>
    /* 기존 FAQ 페이지의 스타일을 재활용하거나 새로 정의 */
    body { font-family: 'Arial', sans-serif; background-color: #f5f5f5; line-height: 1.6; }
    .container { max-width: 800px; margin: 50px auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
    .container p a {color:black; text-decoration: none;}
    .container p a:hover {font-weight: bold; text-decoration: underline;}
    h2 { text-align: center; color: #2563eb; margin-bottom: 30px; }
    .form-group { margin-bottom: 20px; }
    label { display: block; margin-bottom: 8px; font-weight: bold; color: #333; }
    input[type="text"], textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; transition: border-color 0.3s; }
    input[type="text"]:focus, textarea:focus { outline: none; border-color: #2563eb; }
    textarea { resize: vertical; min-height: 150px; }
    .button-group { text-align: right; }
    .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; transition: background-color 0.3s; }
    .btn-primary { background-color: #2563eb; color: white; }
    .btn-primary:hover { background-color: #1a4ed8; }
    .btn-secondary { background-color: #6c757d; color: white; margin-left: 10px; }
    .btn-secondary:hover { background-color: #5a6268; }
</style>
</head>
<body>
<%@ include file="Navi.jsp" %>

<div class="container">
    <h2>1:1 문의 작성</h2>
    
    <c:if test="${empty sessionScope.user}">
        <p style="text-align: center; color: red;">로그인 후 이용 가능합니다. <a href="login">로그인 페이지로 이동</a></p>
    </c:if>
    <c:if test="${not empty sessionScope.user}">
        <form action="${pageContext.request.contextPath}/inquiryWrite" method="post"> <%-- 서블릿 매핑 이름으로 변경 예정 --%>
            <div class="form-group">
                <label for="writerId">작성자 ID:</label>
                <input type="text" id="writerId" name="writerId" value="${sessionScope.user.id}" readonly>
            </div>
            <div class="form-group">
                <label for="title">제목:</label>
                <input type="text" id="title" name="title" required>
            </div>
            <div class="form-group">
                <label for="content">내용:</label>
                <textarea id="content" name="content" required></textarea>
            </div>
            <div class="button-group">
                <button type="submit" class="btn btn-primary">문의 제출</button>
                <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
            </div>
        </form>
    </c:if>
</div>

<%@ include file="Footer.jsp" %>
</body>
</html>