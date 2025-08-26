<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "계정 정보 수정"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">계정 정보 수정</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">개인 정보를 안전하게 업데이트하세요</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-2xl mx-auto">
            
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="border border-green-200 bg-green-50 p-4 mb-6" role="alert">
                    <div class="flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <p class="text-green-800"><%= request.getAttribute("successMessage") %></p>
                    </div>
                </div>
            <% } %>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="border border-red-200 bg-red-50 p-4 mb-6" role="alert">
                    <div class="flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                        </svg>
                        <p class="text-red-800"><%= request.getAttribute("errorMessage") %></p>
                    </div>
                </div>
            <% } %>
            
            <div class="bg-white border border-gray-200 p-8">
                <div class="flex items-center mb-8">
                    <div class="w-16 h-16 bg-green-600 flex items-center justify-center mr-6">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-900 mb-2">계정 정보 수정</h2>
                        <p class="text-gray-600">필요한 정보를 업데이트하세요</p>
                    </div>
                </div>
                
                <form action="/user/edit-profile" method="post" enctype="multipart/form-data">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="md:col-span-1">
                            <label for="username" class="block text-sm font-medium text-gray-700 mb-2">사용자명</label>
                            <input type="text" 
                                   id="username" 
                                   name="username" 
                                   value="<%= ((com.example.demo.model.User) session.getAttribute("user")).getUsername() %>"
                                   class="w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   required>
                        </div>
                        
                        <div class="md:col-span-1">
                            <label for="userId" class="block text-sm font-medium text-gray-700 mb-2">사용자 ID</label>
                            <input type="text" 
                                   id="userId" 
                                   value="<%= ((com.example.demo.model.User) session.getAttribute("user")).getId() %>"
                                   class="w-full px-4 py-3 border border-gray-300 bg-gray-50 text-gray-600"
                                   disabled>
                        </div>
                        
                        <div class="md:col-span-1">
                            <label for="currentPassword" class="block text-sm font-medium text-gray-700 mb-2">현재 비밀번호</label>
                            <input type="password" 
                                   id="currentPassword" 
                                   name="currentPassword"
                                   class="w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="현재 비밀번호를 입력하세요">
                        </div>
                        
                        <div class="md:col-span-1">
                            <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-2">새 비밀번호</label>
                            <input type="password" 
                                   id="newPassword" 
                                   name="newPassword"
                                   class="w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="새 비밀번호 (선택사항)">
                        </div>
                        
                        <div class="md:col-span-2">
                            <label for="profileImage" class="block text-sm font-medium text-gray-700 mb-2">프로필 이미지</label>
                            <div class="flex items-center space-x-4">
                                <div class="w-20 h-20 bg-green-600 flex items-center justify-center">
                                    <% if (((com.example.demo.model.User) session.getAttribute("user")).getProfileImage() != null) { %>
                                        <img src="/user/profile-image" alt="프로필 이미지" class="w-20 h-20 object-cover">
                                    <% } else { %>
                                        <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                        </svg>
                                    <% } %>
                                </div>
                                <div class="flex-1">
                                    <input type="file" 
                                           id="profileImage" 
                                           name="profileImage"
                                           accept="image/*"
                                           class="w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500">
                                    <p class="text-sm text-gray-500 mt-1">JPG, PNG 파일만 업로드 가능합니다 (최대 5MB)</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="flex flex-col sm:flex-row gap-4 justify-end mt-8">
                        <a href="/user" class="px-6 py-3 border border-gray-300 text-gray-700 font-medium hover:bg-gray-50 transition-colors duration-200 text-center">
                            취소
                        </a>
                        <button type="submit" class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 font-medium transition-colors duration-200">
                            정보 업데이트
                        </button>
                    </div>
                </form>
            </div>
            
            <div class="mt-8">
                <a href="/user" class="inline-flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    대시보드로 돌아가기
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>