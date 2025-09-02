<%@page import="dto.Users"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="dao.HotelDao"%>
<%@ page import="dto.Hotel"%>
<%
// 관리자 권한 체크
String userId = (String) session.getAttribute("id");
Users loginUser = (Users) session.getAttribute("user");
if (userId == null || loginUser == null || loginUser.getAdmin() != 1) {
	response.sendRedirect("main");
	return;
}

String action = request.getParameter("action");
HotelDao hotelDao = new HotelDao();

String redirectUrl = "Hoteladmin.jsp";
String message = "";
String error = "";

try {
	if ("insert".equals(action)) {
		// 호텔 추가
		Hotel hotel = new Hotel();
		hotel.setName(request.getParameter("name"));
		hotel.setLocation(request.getParameter("location"));
		hotel.setRegion(request.getParameter("region"));
		hotel.setCategory(request.getParameter("category"));
		hotel.setDescription(request.getParameter("description"));

		// 가격 처리
		String priceStr = request.getParameter("price");
		if (priceStr != null && !priceStr.isEmpty()) {
	hotel.setPrice(Integer.parseInt(priceStr));
		}

		// 별점 처리
		String starRatingStr = request.getParameter("starRating");
		if (starRatingStr != null && !starRatingStr.isEmpty()) {
	hotel.setStarRating(Integer.parseInt(starRatingStr));
		}

		// 평점 처리
		String ratingStr = request.getParameter("rating");
		if (ratingStr != null && !ratingStr.isEmpty()) {
	hotel.setRating(Double.parseDouble(ratingStr));
		} else {
	hotel.setRating(8.0); // 기본값
		}

		hotel.setImageUrl(request.getParameter("imageUrl"));
		hotel.setAmenitiesStr(request.getParameter("amenities"));

		boolean success = hotelDao.insertHotel(hotel);
		if (success) {
	message = "added";
		} else {
	error = "insert_failed";
		}

	} else if ("update".equals(action)) {
		// 호텔 수정 - 모든 필드를 완전히 새 값으로 덮어쓰기
		String hotelIdStr = request.getParameter("hotelId");
		if (hotelIdStr != null && !hotelIdStr.isEmpty()) {
	Hotel hotel = new Hotel();
	hotel.setId(Integer.parseInt(hotelIdStr));

	// 모든 필드를 새 값으로 설정 (빈 값도 그대로 저장)
	hotel.setName(request.getParameter("name") != null ? request.getParameter("name") : "");
	hotel.setLocation(request.getParameter("location") != null ? request.getParameter("location") : "");
	hotel.setRegion(request.getParameter("region") != null ? request.getParameter("region") : "");
	hotel.setCategory(request.getParameter("category") != null ? request.getParameter("category") : "");

	// 설명 - 빈 값이면 빈 문자열로 설정
	String description = request.getParameter("description");
	hotel.setDescription(description != null ? description : "");

	// 가격 처리
	String priceStr = request.getParameter("price");
	hotel.setPrice((priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0);

	// 별점 처리
	String starRatingStr = request.getParameter("starRating");
	hotel.setStarRating(
			(starRatingStr != null && !starRatingStr.isEmpty()) ? Integer.parseInt(starRatingStr) : 1);

	// 평점 처리
	String ratingStr = request.getParameter("rating");
	hotel.setRating((ratingStr != null && !ratingStr.isEmpty()) ? Double.parseDouble(ratingStr) : 0.0);

	// 이미지 URL - 빈 값이면 빈 문자열로 설정 (기존 값 완전 삭제)
	String imageUrl = request.getParameter("imageUrl");
	hotel.setImageUrl(imageUrl != null ? imageUrl : "");

	// 편의시설 - 빈 값이면 빈 문자열로 설정 (기존 값 완전 삭제)
	String amenities = request.getParameter("amenities");
	hotel.setAmenitiesStr(amenities != null ? amenities : "");

	System.out.println("수정할 호텔 데이터:");
	System.out.println("ID: " + hotel.getId());
	System.out.println("이름: '" + hotel.getName() + "'");
	System.out.println("위치: '" + hotel.getLocation() + "'");
	System.out.println("설명: '" + hotel.getDescription() + "'");
	System.out.println("이미지 URL: '" + hotel.getImageUrl() + "'");
	System.out.println("편의시설: '" + hotel.getAmenitiesStr() + "'");

	boolean success = hotelDao.updateHotel(hotel);
	if (success) {
		message = "updated";
		System.out.println("호텔 수정 성공: ID " + hotel.getId());
	} else {
		error = "update_failed";
		System.out.println("호텔 수정 실패: ID " + hotel.getId());
	}
		} else {
	error = "invalid_id";
		}

	} else if ("delete".equals(action)) {
		// 호텔 삭제
		String hotelIdStr = request.getParameter("hotelId");
		if (hotelIdStr != null && !hotelIdStr.isEmpty()) {
	int hotelId = Integer.parseInt(hotelIdStr);
	boolean success = hotelDao.deleteHotel(hotelId);
	if (success) {
		message = "deleted";
	} else {
		error = "delete_failed";
	}
		} else {
	error = "invalid_id";
		}

	} else {
		error = "invalid_action";
	}

} catch (NumberFormatException e) {
	error = "invalid_number_format";
	e.printStackTrace();
} catch (Exception e) {
	error = "unexpected_error";
	e.printStackTrace();
}

// 결과에 따라 리다이렉트
if (!message.isEmpty()) {
	redirectUrl += "?message=" + message;
} else if (!error.isEmpty()) {
	redirectUrl += "?error=" + error;
}

response.sendRedirect(redirectUrl);
%>