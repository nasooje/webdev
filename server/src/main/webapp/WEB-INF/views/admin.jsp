<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "관리자 대시보드"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">관리자 대시보드</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">산업재해예방정책원 시스템 관리</p>
        </div>
    </div>
</div>

<div class="bg-white py-16" style="min-height: calc(100vh - 128px);">
    <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                <div class="bg-white border border-gray-200 p-8 hover:shadow-xl transition-all duration-300 group">
                    <div class="w-16 h-16 bg-green-100 flex items-center justify-center text-green-600 mb-6 group-hover:bg-green-600 group-hover:text-white transition-all duration-300">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold mb-4 text-gray-900">사용자 관리</h3>
                    <p class="text-gray-600 leading-relaxed mb-6">
                        시스템의 사용자를 조회하고 편집하거나 삭제합니다. 사용자 역할과 권한을 관리합니다.
                    </p>
                    <a href="/admin/users" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 inline-block">
                        사용자 관리
                    </a>
                </div>
                
                <div class="bg-white border border-gray-200 p-8 hover:shadow-xl transition-all duration-300 group">
                    <div class="w-16 h-16 bg-green-100 flex items-center justify-center text-green-600 mb-6 group-hover:bg-green-600 group-hover:text-white transition-all duration-300">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold mb-4 text-gray-900">파일 저장소 관리</h3>
                    <p class="text-gray-600 leading-relaxed mb-6">
                        시스템에 업로드된 모든 파일을 탐색하고 관리합니다. 저장 공간과 보안을 관리합니다.
                    </p>
                    <a href="/admin/view?path=uploads" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 inline-block">
                        저장소 관리
                    </a>
                </div>
                
                <div class="bg-white border border-gray-200 p-8 hover:shadow-xl transition-all duration-300 group">
                    <div class="w-16 h-16 bg-green-100 flex items-center justify-center text-green-600 mb-6 group-hover:bg-green-600 group-hover:text-white transition-all duration-300">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold mb-4 text-gray-900">안전교육 관리</h3>
                    <p class="text-gray-600 leading-relaxed mb-6">
                        산업안전교육 프로그램을 관리하고 교육 신청자와 수료 현황을 확인합니다.
                    </p>
                    <a href="/admin/safety-training" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 inline-block">
                        교육 관리
                    </a>
                </div>
            </div>
            
            <div class="mt-12 text-center">
                <a href="/user" class="inline-flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    내 대시보드로 돌아가기
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>