<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>footer</title>
<style >
.footer {
            background: #1f2937;
            color: white;
            padding: 48px 0 24px;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 32px;
        }

        .footer-section h3 {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 16px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 8px;
        }

        .footer-section ul li a {
            color: #d1d5db;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-section ul li a:hover {
            color: white;
        }

        .footer-bottom {
            border-top: 1px solid #374151;
            margin-top: 32px;
            padding-top: 24px;
            text-align: center;
            color: #9ca3af;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }

            .login-container {
                grid-template-columns: 1fr;
                margin: 20px;
                max-width: none;
            }

            .image-section {
                order: -1;
                min-height: 200px;
                padding: 30px 20px;
            }

            .image-section h2 {
                font-size: 24px;
            }

            .image-section p {
                font-size: 16px;
            }

            .login-form-section {
                padding: 40px 30px;
            }

            .login-title {
                font-size: 24px;
            }

            .features-list {
                display: none;
            }
        }

        @media (max-width: 480px) {
            .login-section {
                padding: 20px 10px;
            }

            .login-form-section {
                padding: 30px 20px;
            }

            .forgot-links {
                flex-direction: column;
                gap: 8px;
                text-align: center;
            }

            .form-options {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>회사 정보</h3>
                <ul>
                    <li><a href="#">회사 소개</a></li>
                    <li><a href="#">채용 정보</a></li>
                    <li><a href="#">투자자 정보</a></li>
                    <li><a href="#">뉴스룸</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3>고객 지원</h3>
                <ul>
                    <li><a href="#">고객센터</a></li>
                    <li><a href="#">자주 묻는 질문</a></li>
                    <li><a href="#">예약 확인</a></li>
                    <li><a href="#">취소/환불</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3>정책</h3>
                <ul>
                    <li><a href="#">이용약관</a></li>
                    <li><a href="#">개인정보처리방침</a></li>
                    <li><a href="#">쿠키 정책</a></li>
                    <li><a href="#">접근성</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3>소셜 미디어</h3>
                <ul>
                    <li><a href="#">페이스북</a></li>
                    <li><a href="#">인스타그램</a></li>
                    <li><a href="#">트위터</a></li>
                    <li><a href="#">유튜브</a></li>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p>&copy; 2025 SkyBooking. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>