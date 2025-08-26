<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "안전교육 프로그램 상세"); %>
<%@ include file="../common/header.jsp" %>

<% 
    com.example.demo.model.SafetyTrainingProgram program = 
        (com.example.demo.model.SafetyTrainingProgram) request.getAttribute("program");
    boolean hasApplied = (Boolean) request.getAttribute("hasApplied");
    boolean isLoggedIn = session.getAttribute("user") != null;
%>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
            <div class="flex items-center mb-6">
                <a href="/safety-training" class="inline-flex items-center text-gray-300 hover:text-white transition-colors duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    안전교육 프로그램
                </a>
            </div>
            <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
                <div>
                    <h1 class="text-4xl font-bold mb-4"><%= program.getTitle() %></h1>
                    <div class="flex items-center gap-4">
                        <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium <%= program.isAvailable() ? "bg-green-600 text-white" : "bg-yellow-500 text-white" %>">
                            <%= program.getStatus() %>
                        </span>
                        <span class="text-gray-300">
                            <%= program.getCurrentParticipants() %>/<%= program.getMaxParticipants() %>명 신청
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="bg-white py-16" style="min-height: calc(100vh - 128px);">
    <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">

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

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <div class="bg-gradient-to-br from-blue-50 to-blue-100 border border-blue-200 rounded-lg p-6">
                    <div class="flex items-center mb-3">
                        <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                        </div>
                        <h3 class="text-sm font-semibold text-blue-800 ml-3">교육 장소</h3>
                    </div>
                    <p class="text-blue-900 font-medium"><%= program.getLocation() %></p>
                </div>

                <div class="bg-gradient-to-br from-green-50 to-green-100 border border-green-200 rounded-lg p-6">
                    <div class="flex items-center mb-3">
                        <div class="w-10 h-10 bg-green-500 rounded-lg flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                        </div>
                        <h3 class="text-sm font-semibold text-green-800 ml-3">교육 날짜</h3>
                    </div>
                    <p class="text-green-900 font-medium"><%= program.getFormattedDate() %></p>
                </div>

                <div class="bg-gradient-to-br from-purple-50 to-purple-100 border border-purple-200 rounded-lg p-6">
                    <div class="flex items-center mb-3">
                        <div class="w-10 h-10 bg-purple-500 rounded-lg flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                        <h3 class="text-sm font-semibold text-purple-800 ml-3">교육 시간</h3>
                    </div>
                    <p class="text-purple-900 font-medium"><%= program.getTimeRange() %></p>
                </div>

                <div class="bg-gradient-to-br from-orange-50 to-orange-100 border border-orange-200 rounded-lg p-6">
                    <div class="flex items-center mb-3">
                        <div class="w-10 h-10 bg-orange-500 rounded-lg flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                            </svg>
                        </div>
                        <h3 class="text-sm font-semibold text-orange-800 ml-3">신청 현황</h3>
                    </div>
                    <p class="text-orange-900 font-medium">
                        <%= program.getCurrentParticipants() %>/<%= program.getMaxParticipants() %>명
                        <% if (program.getRemainingSpots() > 0) { %>
                            <span class="block text-sm text-green-600 mt-1">(<%= program.getRemainingSpots() %>명 남음)</span>
                        <% } else { %>
                            <span class="block text-sm text-red-600 mt-1">(마감)</span>
                        <% } %>
                    </p>
                </div>
            </div>

            <div class="bg-gray-50 border border-gray-200 rounded-lg p-8 mb-8">
                <h2 class="text-2xl font-bold text-gray-900 mb-6">프로그램 상세정보</h2>
                <div class="prose max-w-none text-gray-700 leading-relaxed">
                    <p class="text-lg"><%= program.getDescription() %></p>
                </div>
            </div>

            <div class="bg-white border border-gray-200 rounded-lg p-8">
                <div class="text-center">
                    <% if (hasApplied) { %>
                        <div class="mb-6">
                            <div class="inline-flex items-center px-4 py-2 bg-green-100 text-green-800 rounded-full text-sm font-medium mb-4">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                신청 완료
                            </div>
                            <p class="text-gray-600 mb-6">이미 이 안전교육에 신청하셨습니다.</p>
                        </div>
                    <% } %>
                    
                    <div class="flex flex-col sm:flex-row gap-4 justify-center max-w-md mx-auto">
                        <% if (!isLoggedIn) { %>
                            <a href="/login" class="flex-1 bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg font-semibold transition-colors duration-200 text-center shadow-md">
                                로그인하고 신청하기
                            </a>
                        <% } else if (hasApplied) { %>
                            <form action="/safety-training/<%= program.getId() %>/cancel" method="post" class="flex-1">
                                <button type="submit" class="w-full bg-red-600 hover:bg-red-700 text-white px-8 py-3 rounded-lg font-semibold transition-colors duration-200 shadow-md">
                                    신청 취소하기
                                </button>
                            </form>
                        <% } else if (program.isAvailable()) { %>
                            <form action="/safety-training/<%= program.getId() %>/apply" method="post" class="flex-1">
                                <button type="submit" class="w-full bg-green-600 hover:bg-green-700 text-white px-8 py-3 rounded-lg font-semibold transition-colors duration-200 shadow-md">
                                    신청하기
                                </button>
                            </form>
                        <% } else { %>
                            <button disabled class="flex-1 bg-gray-400 text-white px-8 py-3 rounded-lg font-semibold cursor-not-allowed">
                                신청 마감
                            </button>
                        <% } %>
                        
                        <a href="/safety-training" class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 px-8 py-3 rounded-lg font-semibold transition-colors duration-200 text-center">
                            목록으로
                        </a>
                    </div>
                </div>
            </div>
            
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