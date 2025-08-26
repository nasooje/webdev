<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "대시보드"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">대시보드</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">산업재해예방정책원에 오신 것을 환영합니다</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">
            <div class="bg-white border border-gray-200 p-8 mb-8">
                <div class="flex items-center mb-6">
                    <div class="w-16 h-16 bg-green-600 flex items-center justify-center mr-6">
                        <% if (((com.example.demo.model.User) session.getAttribute("user")).getProfileImage() != null) { %>
                            <img src="/user/profile-image" alt="프로필 이미지" class="w-16 h-16 object-cover">
                        <% } else { %>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                        <% } %>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-900 mb-2">계정 정보</h2>
                        <p class="text-gray-600">산업재해예방정책원 회원 정보</p>
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div>
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">아이디</label>
                                <p class="text-gray-900 font-medium"><%= ((com.example.demo.model.User) session.getAttribute("user")).getUsername() %></p>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">사용자 ID</label>
                                <p class="text-gray-600 text-sm font-mono"><%= ((com.example.demo.model.User) session.getAttribute("user")).getId() %></p>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">계정 상태</label>
                                <span class="inline-flex items-center px-3 py-1 text-sm font-medium bg-green-100 text-green-800">
                                    활성
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <div>
                        <div class="bg-gray-50 p-6">
                            <h3 class="text-lg font-semibold text-gray-900 mb-4">빠른 메뉴</h3>
                            <div class="space-y-3">
                                <a href="/user/edit-profile" class="flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                    </svg>
                                    계정 정보 수정
                                </a>
                                <a href="/safety-training/my-programs" class="flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                                    </svg>
                                    내 안전교육 현황
                                </a>
                                <a href="/storage" class="flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                    </svg>
                                    내 문서 보기
                                </a>
                                <a href="/storage/upload" class="flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                                    </svg>
                                    문서 업로드
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-white border border-gray-200 p-6 text-center hover:shadow-lg transition-shadow duration-300">
                    <div class="w-16 h-16 bg-green-100 mx-auto mb-4 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">안전교육 신청</h3>
                    <p class="text-gray-600 mb-4 text-sm">새로운 안전교육 프로그램에 참여하세요</p>
                    <a href="/safety-training" class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 font-medium transition-colors duration-200">
                        교육 신청하기
                    </a>
                </div>
                
                <div class="bg-white border border-gray-200 p-6 text-center hover:shadow-lg transition-shadow duration-300">
                    <div class="w-16 h-16 bg-green-100 mx-auto mb-4 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">문서 관리</h3>
                    <p class="text-gray-600 mb-4 text-sm">중요한 문서를 안전하게 보관하세요</p>
                    <a href="/storage" class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 font-medium transition-colors duration-200">
                        문서 보기
                    </a>
                </div>
                
                <div class="bg-white border border-gray-200 p-6 text-center hover:shadow-lg transition-shadow duration-300">
                    <div class="w-16 h-16 bg-green-100 mx-auto mb-4 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">도움말</h3>
                    <p class="text-gray-600 mb-4 text-sm">자주 묻는 질문과 가이드를 확인하세요</p>
                    <a href="/faq" class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 font-medium transition-colors duration-200">
                        FAQ 보기
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>