<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "안전교육 프로그램 목록"); %>
<%@ include file="../common/header.jsp" %>

<div class="bg-white">
    <div class="bg-gray-900 text-white py-16">
        <div class="container mx-auto px-4">
            <div class="text-center">
                <h1 class="text-4xl font-bold mb-4">안전교육 프로그램</h1>
                <p class="text-xl text-gray-300 max-w-2xl mx-auto">전문적이고 체계적인 산업안전교육을 통해 안전한 작업환경을 만들어갑니다</p>
            </div>
        </div>
    </div>
    
    <div class="container mx-auto px-4 py-12">
        <div class="mb-8">

        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded" role="alert">
                <div class="flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <p><%= request.getAttribute("successMessage") %></p>
                </div>
            </div>
        <% } %>
        
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded" role="alert">
                <div class="flex items-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                    <p><%= request.getAttribute("errorMessage") %></p>
                </div>
            </div>
        <% } %>

        <div class="flex justify-between items-center mb-8">
            <div>
                <% 
                    java.util.List<com.example.demo.model.SafetyTrainingProgram> programs = 
                        (java.util.List<com.example.demo.model.SafetyTrainingProgram>) request.getAttribute("programs");
                    int programCount = (programs != null) ? programs.size() : 0;
                %>
                <p class="text-gray-600">현재 신청 가능한 안전교육 프로그램: <span class="font-medium"><%= programCount %></span>개</p>
            </div>
            
            <div class="flex gap-4">
            
                <% if (session.getAttribute("user") != null) { %>
                    <a href="/safety-training/my-programs" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                        </svg>
                        내 신청 현황
                    </a>
                <% } else { %>
                    <a href="/login" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" />
                        </svg>
                        로그인하여 교육신청
                    </a>
                <% } %>
            </div>
        </div>

                        <% if (programs != null && !programs.isEmpty()) { %>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                        <% for (com.example.demo.model.SafetyTrainingProgram program : programs) { %>
                            <div class="bg-white border border-gray-200 hover:shadow-xl transition-all duration-300 group">
                        <div class="p-6">
                            <div class="flex justify-between items-start">
                                <h2 class="text-xl font-semibold text-gray-800 mb-2 flex-1"><%= program.getTitle() %></h2>
                                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium <%= program.isAvailable() ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800" %>">
                                    <%= program.getStatus() %>
                                </span>
                            </div>
                            
                            <p class="text-gray-600 mt-2 line-clamp-2"><%= program.getDescription() %></p>
                            
                            <div class="mt-4 space-y-2">
                                <div class="flex items-start">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                    </svg>
                                    <span class="text-gray-700"><%= program.getLocation() %></span>
                                </div>
                                
                                <div class="flex items-start">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    <span class="text-gray-700"><%= program.getFormattedDate() %></span>
                                </div>
                                
                                <div class="flex items-start">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span class="text-gray-700"><%= program.getTimeRange() %></span>
                                </div>
                                
                                <div class="flex items-start">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500 mr-2 mt-0.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                                    </svg>
                                    <span class="text-gray-700">
                                        <%= program.getCurrentParticipants() %>/<%= program.getMaxParticipants() %>명 
                                        (<%= program.getRemainingSpots() %>명 남음)
                                    </span>
                                </div>
                            </div>
                            
                                                            <div class="mt-6">
                                    <a href="/safety-training/<%= program.getId() %>" class="w-full inline-flex justify-center items-center px-4 py-3 border border-green-600 text-green-600 hover:bg-green-600 hover:text-white font-medium transition-all duration-300 group-hover:border-green-700">
                                        상세 정보 보기
                                    </a>
                                </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="text-center py-12 bg-white rounded-lg shadow-md">
                <div class="h-24 w-24 mx-auto mb-4 bg-green-100 flex items-center justify-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                    </svg>
                </div>
                <h3 class="text-xl font-medium text-gray-800 mb-2">현재 신청 가능한 안전교육 프로그램이 없습니다</h3>
                <p class="text-gray-600 mb-6">새로운 안전교육 프로그램이 등록되면 알려드리겠습니다.</p>
            </div>
        <% } %>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>