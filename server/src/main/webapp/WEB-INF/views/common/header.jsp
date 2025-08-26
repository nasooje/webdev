<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>산업재해예방정책원 - ${pageTitle}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#16A34A',
                        secondary: '#22C55E',
                    },
                    fontFamily: {
                        sans: ['Noto Sans KR', 'sans-serif'],
                    },
                }
            }
        }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body class="bg-white font-sans min-h-screen">
    <nav class="bg-white shadow-sm border-b border-gray-200">
        <div class="container mx-auto px-4 py-4">
            <div class="flex justify-between items-center">
                <a href="/" class="flex items-center space-x-3">
                    <span class="font-bold text-xl text-gray-900">산업재해예방정책원</span>
                </a>
                
                <div class="flex space-x-8">
                    <a href="/guide" class="text-gray-600 hover:text-gray-900 font-medium transition-colors duration-200">안전교육 안내</a>
                    <a href="/greeting" class="text-gray-600 hover:text-gray-900 font-medium transition-colors duration-200">인사말</a>
                    <a href="/safety-training" class="text-gray-600 hover:text-gray-900 font-medium transition-colors duration-200">교육신청</a>
                    <a href="/faq" class="text-gray-600 hover:text-gray-900 font-medium transition-colors duration-200">FAQ</a>
                    <a href="/storage" class="text-gray-600 hover:text-gray-900 font-medium transition-colors duration-200">문서관리</a>
                    <% if (session.getAttribute("user") != null) { %>
                        <a href="/storage/upload" class="text-gray-600 hover:text-gray-900 font-medium transition-colors duration-200">업로드</a>
                    <% } %>
                    <% if (session.getAttribute("role") != null && session.getAttribute("role").equals("ADMIN")) { %>
                        <a href="/admin" class="text-gray-600 hover:text-gray-900 font-medium transition-colors duration-200">관리자</a>
                    <% } %>
                </div>
                
                <div class="flex items-center space-x-4">
                    <% if (session.getAttribute("user") == null) { %>
                        <a href="/login" class="text-gray-600 hover:text-gray-900 font-medium transition-colors duration-200">로그인</a>
                        <a href="/register" class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 font-medium transition-colors duration-200">회원가입</a>
                    <% } else { %>
                        <a href="/user" class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 font-medium transition-colors duration-200">마이페이지</a>
                        <a href="/logout" class="text-gray-600 hover:text-red-600 font-medium transition-colors duration-200">로그아웃</a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>
    
    <main> 