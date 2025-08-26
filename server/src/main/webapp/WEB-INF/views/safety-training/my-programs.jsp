<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "내 안전교육"); %>
<%@ include file="../common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">내 안전교육</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">신청하신 안전교육 프로그램을 확인하고 관리하세요</p>
        </div>
    </div>
</div>

<div class="bg-white py-16" style="min-height: calc(100vh - 128px);">
    <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">

            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="border border-green-200 bg-green-50 p-4 mb-8 rounded-lg" role="alert">
                    <div class="flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <p class="text-green-800"><%= request.getAttribute("successMessage") %></p>
                    </div>
                </div>
            <% } %>
            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="border border-red-200 bg-red-50 p-4 mb-8 rounded-lg" role="alert">
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
                        java.util.List<com.example.demo.model.SafetyTrainingApplication> applications = 
                            (java.util.List<com.example.demo.model.SafetyTrainingApplication>) request.getAttribute("applications");
                        int applicationCount = (applications != null) ? applications.size() : 0;
                    %>
                    <h2 class="text-2xl font-bold text-gray-900">신청 현황 (<%= applicationCount %>개)</h2>
                    <p class="text-gray-600 mt-1">신청하신 안전교육 프로그램을 확인하세요</p>
                </div>
                
                <a href="/safety-training" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center shadow-md">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                    </svg>
                    더 많은 프로그램 보기
                </a>
            </div>

            <% if (applications != null && !applications.isEmpty()) { %>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <% for (com.example.demo.model.SafetyTrainingApplication safetyApp : applications) { %>
                        <div class="bg-white border border-gray-200 rounded-lg p-6 hover:shadow-lg transition-shadow duration-300">
                            <div class="flex items-start justify-between mb-4">
                                <h3 class="text-lg font-semibold text-gray-900 line-clamp-2">
                                    <%= safetyApp.getProgramTitle() != null ? safetyApp.getProgramTitle() : "제목 없음" %>
                                </h3>
                                <% 
                                String status = safetyApp.getStatus(); 
                                if (status == null) status = "신청";
                                %>
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
                                    <% if (status.equals("신청")) { %>
                                        bg-green-100 text-green-800
                                    <% } else if (status.equals("취소")) { %>
                                        bg-red-100 text-red-800
                                    <% } else { %>
                                        bg-blue-100 text-blue-800
                                    <% } %>
                                ">
                                    <%= status %>
                                </span>
                            </div>
                            
                            <div class="space-y-3 mb-6">
                                <div class="flex items-center text-sm text-gray-600">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3a2 2 0 012-2h4a2 2 0 012 2v4m-6 0h6m-6 0l-4 7m4-7l4 7" />
                                    </svg>
                                    <%= safetyApp.getActivityDate() != null ? safetyApp.getActivityDate() : "날짜 미정" %>
                                </div>
                                <div class="flex items-center text-sm text-gray-600">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <%= safetyApp.getTimeRange() != null ? safetyApp.getTimeRange() : "시간 미정" %>
                                </div>
                                <div class="flex items-center text-sm text-gray-600">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3a2 2 0 012-2h4a2 2 0 012 2v4m-6 0h6m-6 0l-4 7m4-7l4 7" />
                                    </svg>
                                    신청일: 
                                    <% 
                                    try {
                                        String appliedAt = safetyApp.getAppliedAt();
                                        if (appliedAt != null && !appliedAt.isEmpty()) {
                                            String[] parts = appliedAt.split("\\.");
                                            if (parts.length > 0) {
                                                String formattedDate = parts[0].replace('T', ' ');
                                                out.print(formattedDate);
                                            } else {
                                                out.print(appliedAt);
                                            }
                                        } else {
                                            out.print("-");
                                        }
                                    } catch (Exception e) {
                                        out.print("-");
                                    }
                                    %>
                                </div>
                            </div>
                            
                            <div class="pt-4 border-t border-gray-200">
                                <a href="/safety-training/<%= safetyApp.getProgramId() %>" 
                                   class="w-full bg-green-600 hover:bg-green-700 text-white text-center py-2 px-4 rounded-lg font-medium transition-colors duration-200 block">
                                    프로그램 상세보기
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="bg-white border border-gray-200 rounded-lg p-12 text-center">
                    <div class="w-16 h-16 mx-auto mb-4 bg-green-100 rounded-full flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-2">신청한 안전교육이 없습니다</h3>
                    <p class="text-gray-500 mb-6">안전교육 프로그램을 신청하여 안전 역량을 강화해보세요.</p>
                    <a href="/safety-training" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 inline-flex items-center shadow-md">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                        안전교육 프로그램 보기
                    </a>
                </div>
            <% } %>
            
            <div class="mt-8 text-center">
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

<%@ include file="../common/footer.jsp" %>