<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- <%@ page import="dao.BoardDao" %> (더 이상 필요 없음) --%>
<%-- <%@ page import="dto.Users" %> (더 이상 필요 없음) --%>
<%-- 모든 스크립트릿 제거 --%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><c:if test="${board != null}">${board.title}</c:if><c:if test="${board == null}">문의글 상세</c:if> - SkyBooking</title>
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/fabicon.png">
<style>
    body { font-family: 'Arial', sans-serif; background-color: #f5f5f5; line-height: 1.6; }
    .container { max-width: 800px; margin: 50px auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
    h2 { color: #2563eb; margin-bottom: 20px; text-align: center; }
    .post-header { border-bottom: 1px solid #eee; padding-bottom: 15px; margin-bottom: 20px; }
    .post-header h3 { margin: 0; color: #333; font-size: 24px; }
    .post-meta { font-size: 14px; color: #777; margin-top: 5px; }
    .post-content { margin-bottom: 30px; line-height: 1.8; color: #444; white-space: pre-line; }
    .answer-section { border-top: 2px solid #2563eb; padding-top: 20px; margin-top: 30px; background-color: #f9f9f9; padding: 20px; border-radius: 8px;}
    .answer-section h4 { color: #2563eb; margin-bottom: 15px; }
    .answer-section p { line-height: 1.8; color: #555; white-space: pre-line; }
    .button-group { text-align: right; margin-top: 20px; }
    .btn { padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; font-weight: bold; transition: background-color 0.3s; }
    .btn-secondary { background-color: #2563eb; color: white; }
    .btn-secondary:hover { background-color: #29B6F6; }
</style>
</head>
<body>
<%@ include file="Navi.jsp" %>

<div class="container">
    <c:if test="${board == null}">
        <h2>문의글을 찾을 수 없거나 접근 권한이 없습니다.</h2>
        <p style="text-align: center;"><a href="myposts.jsp">내 문의글 목록으로 돌아가기</a></p>
    </c:if>
    <c:if test="${board != null}">
        <h2>문의글 상세</h2>
        <div class="post-header">
            <h3>${board.title}</h3>
            <fmt:formatDate value="${board.writeDate}" pattern="yyyy-MM-dd HH:mm:ss" var="writeDate"/>
            <div class="post-meta">
                작성자: ${board.writerId} | 작성일: ${writeDate}
            </div>
        </div>
        <div class="post-content">
            <p>${board.content}</p>
        </div>

        <c:if test="${not empty board.answer}">
            <div class="answer-section">
                <h4>SkyBooking 답변</h4>
                <p>${board.answer}</p>
                <fmt:formatDate value="${board.answerDate}" pattern="yyyy-MM-dd HH:mm:ss" var="answerDate"/>
                <div class="post-meta" style="text-align: right;">답변일: ${answerDate}</div>
            </div>
        </c:if>
        <c:if test="${empty board.answer}">
            <div class="answer-section" style="border-top: 2px solid orange; background-color: #fff3e0;">
                <h4 style="color: orange;">답변 대기 중</h4>
                <p>관리자의 답변을 기다리고 있습니다.</p>
            </div>
        </c:if>

        <div class="button-group">
            <button type="button" class="btn btn-secondary" onclick="location.href='myposts.jsp'">목록으로</button>
        </div>
    </c:if>
</div>

<%@ include file="Footer.jsp" %>
</body>
</html>