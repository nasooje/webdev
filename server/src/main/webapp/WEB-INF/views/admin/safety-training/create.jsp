<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "안전교육 프로그램 등록"); %>
<%@ include file="../../common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">새 안전교육 프로그램 등록</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">새로운 안전교육 프로그램을 등록합니다</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-3xl mx-auto">
            
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

            <div class="bg-white border border-gray-200 p-8">
                <form action="/admin/safety-training/create" method="post">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="md:col-span-2">
                            <label for="title" class="block text-sm font-medium text-gray-700 mb-2">교육 프로그램 제목 *</label>
                            <input type="text" id="title" name="title" required 
                                   class="block w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="예: 화학물질 안전관리 교육">
                        </div>

                        <div class="md:col-span-2">
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">교육 설명 *</label>
                            <textarea id="description" name="description" rows="4" required
                                      class="block w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                      placeholder="교육 프로그램에 대한 상세한 설명을 입력하세요"></textarea>
                        </div>

                        <div>
                            <label for="location" class="block text-sm font-medium text-gray-700 mb-2">교육 장소 *</label>
                            <input type="text" id="location" name="location" required
                                   class="block w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="예: 본관 3층 교육실">
                        </div>

                        <div>
                            <label for="maxParticipants" class="block text-sm font-medium text-gray-700 mb-2">최대 참가자 수 *</label>
                            <input type="number" id="maxParticipants" name="maxParticipants" required min="1" max="1000"
                                   class="block w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500"
                                   placeholder="30">
                        </div>

                        <div>
                            <label for="activityDate" class="block text-sm font-medium text-gray-700 mb-2">교육 일자 *</label>
                            <input type="date" id="activityDate" name="activityDate" required
                                   class="block w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500">
                        </div>

                        <div>
                            <label for="startTime" class="block text-sm font-medium text-gray-700 mb-2">시작 시간 *</label>
                            <input type="time" id="startTime" name="startTime" required
                                   class="block w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500">
                        </div>

                        <div>
                            <label for="endTime" class="block text-sm font-medium text-gray-700 mb-2">종료 시간 *</label>
                            <input type="time" id="endTime" name="endTime" required
                                   class="block w-full px-4 py-3 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500">
                        </div>
                    </div>

                    <div class="flex flex-col sm:flex-row gap-4 justify-end mt-8 pt-6 border-t border-gray-200">
                        <a href="/admin/safety-training" class="px-6 py-3 border border-gray-300 text-gray-700 font-medium hover:bg-gray-50 transition-colors duration-200 text-center">
                            취소
                        </a>
                        <button type="submit" class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 font-medium transition-colors duration-200">
                            교육 프로그램 등록
                        </button>
                    </div>
                </form>
            </div>
            
            <div class="mt-8">
                <a href="/admin/safety-training" class="inline-flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    안전교육 관리로 돌아가기
                </a>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('activityDate').setAttribute('min', today);
});
</script>

<%@ include file="../../common/footer.jsp" %>