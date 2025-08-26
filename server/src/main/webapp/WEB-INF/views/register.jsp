<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "회원가입"); %>
<%@ include file="common/header.jsp" %>

<div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
        <div>
            <div class="mx-auto h-12 w-12 bg-green-600 flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                </svg>
            </div>
            <h2 class="mt-6 text-center text-3xl font-bold text-gray-900">
                새 계정을 만들어보세요
            </h2>
            <p class="mt-2 text-center text-sm text-gray-600">
                산업재해예방정책원에 가입하고 전문적인 안전교육을 받으세요
            </p>
        </div>
        
        <form class="mt-8 space-y-6" action="/register" method="post">
            <div class="space-y-4">
                <div>
                    <label for="username" class="block text-sm font-medium text-gray-700 mb-1">사용자명</label>
                    <input id="username" 
                           name="username" 
                           type="text" 
                           required 
                           class="block w-full px-3 py-3 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
                           placeholder="사용자명을 입력하세요">
                </div>
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
                    <input id="password" 
                           name="password" 
                           type="password" 
                           required 
                           class="block w-full px-3 py-3 border border-gray-300 placeholder-gray-500 text-gray-900 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
                           placeholder="비밀번호를 입력하세요">
                </div>
            </div>

            <div class="flex items-center">
                <input id="agree-terms" name="agree-terms" type="checkbox" required class="h-4 w-4 text-green-600 focus:ring-green-500 border-gray-300">
                <label for="agree-terms" class="ml-2 block text-sm text-gray-900">
                    <a href="/terms" class="text-green-600 hover:text-green-500">이용약관</a> 및 
                    <a href="/privacy" class="text-green-600 hover:text-green-500">개인정보처리방침</a>에 동의합니다
                </label>
            </div>

            <div>
                <button type="submit" class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors duration-200">
                    회원가입
                </button>
            </div>
            
            <div class="text-center">
                <span class="text-sm text-gray-600">
                    이미 계정이 있으신가요? 
                    <a href="/login" class="font-medium text-green-600 hover:text-green-500">
                        로그인하기
                    </a>
                </span>
            </div>
        </form>
    </div>
</div>

<%@ include file="common/footer.jsp" %>