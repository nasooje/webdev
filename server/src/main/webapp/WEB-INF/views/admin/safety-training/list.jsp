<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "안전교육 관리"); %>
<%@ include file="../../common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">안전교육 관리</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">안전교육 프로그램을 생성, 수정 및 관리할 수 있습니다</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">
            
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="border border-green-200 bg-green-50 p-4 mb-8" role="alert">
                    <div class="flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <p class="text-green-800"><%= request.getAttribute("successMessage") %></p>
                    </div>
                </div>
            <% } %>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="border border-red-200 bg-red-50 p-4 mb-8" role="alert">
                    <div class="flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                        </svg>
                        <p class="text-red-800"><%= request.getAttribute("errorMessage") %></p>
                    </div>
                </div>
            <% } %>
            
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
                <div>
                    <%
                        java.util.List<com.example.demo.model.SafetyTrainingProgram> programs = 
                            (java.util.List<com.example.demo.model.SafetyTrainingProgram>) request.getAttribute("programs");
                        int programCount = (programs != null) ? programs.size() : 0;
                    %>
                    <h2 class="text-2xl font-bold text-gray-900">안전교육 프로그램 (<%= programCount %>개)</h2>
                    <p class="text-gray-600 mt-1">등록된 안전교육 프로그램을 관리하세요</p>
                </div>
                
                <a href="/admin/safety-training/create" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                    </svg>
                    새 교육 프로그램 등록
                </a>
            </div>
            
            <% if (programs != null && !programs.isEmpty()) { %>
                <div class="bg-white border border-gray-200 shadow-sm">
                    <table class="min-w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">교육명</th>
                                <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">상태</th>
                                <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">신청자 수</th>
                                <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">등록일</th>
                                <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">작업</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <% for (com.example.demo.model.SafetyTrainingProgram program : programs) { %>
                                <tr class="hover:bg-gray-50 transition-colors duration-200">
                                    <td class="px-6 py-4 text-sm text-gray-900 font-medium"><%= program.getId() %></td>
                                    <td class="px-6 py-4 text-sm text-gray-900">
                                        <div>
                                            <div class="font-medium"><%= program.getTitle() %></div>
                                            <div class="text-gray-500 text-xs mt-1">
                                                <%= program.getDescription() != null && program.getDescription().length() > 50 ? 
                                                    program.getDescription().substring(0, 50) + "..." : 
                                                    program.getDescription() %>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 text-sm">
                                        <% if (program.isAvailable()) { %>
                                            <span class="inline-flex items-center px-3 py-1 text-xs font-medium bg-green-100 text-green-800">
                                                <%= program.getStatus() %>
                                            </span>
                                        <% } else { %>
                                            <span class="inline-flex items-center px-3 py-1 text-xs font-medium bg-red-100 text-red-800">
                                                <%= program.getStatus() %>
                                            </span>
                                        <% } %>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-900">
                                        <%= program.getCurrentParticipants() %> / <%= program.getMaxParticipants() %>명
                                        <div class="w-full bg-gray-200 h-2 mt-1">
                                            <% 
                                                double percentage = program.getMaxParticipants() > 0 ? 
                                                    (double) program.getCurrentParticipants() / program.getMaxParticipants() * 100 : 0;
                                            %>
                                            <div class="bg-green-600 h-2" style="width: <%= percentage %>%"></div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 text-sm text-gray-500">
                                        <%= program.getFormattedDate() %>
                                    </td>
                                    <td class="px-6 py-4 text-sm">
                                        <div class="flex space-x-2">
                                            <a href="/admin/safety-training/<%= program.getId() %>/edit" 
                                               class="text-green-600 hover:text-green-900 font-medium transition-colors duration-200">
                                                편집
                                            </a>
                                            <span class="text-gray-300">|</span>
                                            <button onclick="deleteProgram(<%= program.getId() %>)" 
                                                    class="text-red-600 hover:text-red-900 font-medium transition-colors duration-200">
                                                삭제
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="text-center py-12">
                    <div class="w-24 h-24 bg-green-100 mx-auto mb-4 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-medium text-gray-800 mb-2">등록된 안전교육 프로그램이 없습니다</h3>
                    <p class="text-gray-600 mb-6">첫 번째 안전교육 프로그램을 등록해보세요.</p>
                    <a href="/admin/safety-training/create" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 inline-flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                        새 교육 프로그램 등록
                    </a>
                </div>
            <% } %>
            
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
function deleteProgram(id) {
    if (confirm('정말로 이 안전교육 프로그램을 삭제하시겠습니까?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/admin/safety-training/' + id + '/delete';
        
        form.appendChild(document.createElement('input'));
        document.body.appendChild(form);
        form.submit();
    }
}
</script>

<%@ include file="../../common/footer.jsp" %>