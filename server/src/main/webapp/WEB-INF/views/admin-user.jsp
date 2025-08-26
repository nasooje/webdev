<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.demo.model.User" %>
<% pageContext.setAttribute("pageTitle", "사용자 관리"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">사용자 관리</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">시스템 사용자를 조회하고 관리합니다</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">
            
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
                <div class="flex items-center">
                    <div class="w-12 h-12 bg-green-100 flex items-center justify-center mr-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                        </svg>
                    </div>
                    <div>
                        <% List<User> users = (List<User>) request.getAttribute("userList");
                           int userCount = (users != null) ? users.size() : 0;
                        %>
                        <h2 class="text-2xl font-bold text-gray-900">총 사용자: <%= userCount %>명</h2>
                        <p class="text-gray-600">등록된 모든 사용자 계정</p>
                    </div>
                </div>
                
                <div class="flex gap-4">
                    <div class="relative">
                        <input type="text" 
                               id="searchInput" 
                               placeholder="사용자 검색..." 
                               class="border border-gray-300 pl-10 pr-4 py-3 w-80 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400 absolute left-3 top-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                    </div>
                    <button class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                        새 사용자
                    </button>
                </div>
            </div>
            
            <div class="bg-white border border-gray-200 shadow-sm">
                <table class="min-w-full">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">ID</th>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">사용자명</th>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">UUID</th>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">역할</th>
                            <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">상태</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200" id="userTableBody">
                        <% if (users != null && !users.isEmpty()) { 
                              for (User user : users) { %>
                            <tr class="hover:bg-gray-50 user-row transition-colors duration-200">
                                <td class="px-6 py-4 text-sm text-gray-900 font-medium"><%= user.getId() %></td>
                                <td class="px-6 py-4 text-sm text-gray-900">
                                    <div class="flex items-center">
                                        <div class="w-8 h-8 bg-green-600 flex items-center justify-center text-white text-xs font-bold mr-3">
                                            <%= user.getUsername().substring(0, 1).toUpperCase() %>
                                        </div>
                                        <span class="font-medium"><%= user.getUsername() %></span>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-sm font-mono text-gray-500"><%= user.getUuid() %></td>
                                <td class="px-6 py-4 text-sm">
                                    <% if ("admin".equals(user.getUsername())) { %>
                                        <span class="inline-flex items-center px-3 py-1 text-xs font-medium bg-red-100 text-red-800">
                                            관리자
                                        </span>
                                    <% } else { %>
                                        <span class="inline-flex items-center px-3 py-1 text-xs font-medium bg-green-100 text-green-800">
                                            사용자
                                        </span>
                                    <% } %>
                                </td>
                                <td class="px-6 py-4 text-sm">
                                    <span class="inline-flex items-center px-3 py-1 text-xs font-medium bg-green-100 text-green-800">
                                        활성
                                    </span>
                                </td>
                            </tr>
                        <% } 
                           } else { %>
                            <tr>
                                <td colspan="5" class="px-6 py-12 text-center">
                                    <div class="text-gray-500">
                                        <div class="w-16 h-16 bg-gray-100 mx-auto mb-4 flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z" />
                                            </svg>
                                        </div>
                                        <p class="text-lg font-medium mb-2">등록된 사용자가 없습니다</p>
                                        <p class="text-sm">새로운 사용자를 추가해보세요.</p>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div class="mt-8">
                <a href="/admin" class="inline-flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    관리자 대시보드로 돌아가기
                </a>
            </div>
        </div>
    </div>
</div>

<script>
document.getElementById('searchInput').addEventListener('keyup', function() {
    const searchTerm = this.value.toLowerCase();
    const rows = document.querySelectorAll('.user-row');
    
    rows.forEach(row => {
        const username = row.cells[1].textContent.toLowerCase();
        const id = row.cells[0].textContent.toLowerCase();
        const uuid = row.cells[2].textContent.toLowerCase();
        
        if (username.includes(searchTerm) || id.includes(searchTerm) || uuid.includes(searchTerm)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
});
</script>

<%@ include file="common/footer.jsp" %>