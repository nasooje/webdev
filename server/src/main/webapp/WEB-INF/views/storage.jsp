<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "문서 관리"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">문서 관리</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">중요한 문서를 안전하게 보관하고 관리하세요</p>
        </div>
    </div>
</div>

<div class="bg-white py-16" style="min-height: calc(100vh - 128px);">
    <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">
            
            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="border border-green-200 bg-green-50 p-4 mb-8" role="alert">
                    <div class="flex items-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <div class="text-green-800">
                            <p><%= request.getAttribute("successMessage") %></p>
                            <% if (request.getAttribute("uploadedFile") != null) { %>
                                <% 
                                    String uploadedFile = (String)request.getAttribute("uploadedFile");
                                    String displayName = uploadedFile;
                                    int lastDotIndex = uploadedFile.lastIndexOf(".");
                                    if (lastDotIndex > 0) {
                                        displayName = uploadedFile.substring(0, lastDotIndex);
                                    }
                                %>
                                <p class="mt-1">파일 '<span class="font-medium"><%= displayName %></span>'가 성공적으로 업로드되었습니다.</p>
                            <% } %>
                        </div>
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
                        java.util.List<String> files = (java.util.List<String>) request.getAttribute("files");
                        int fileCount = (files != null) ? files.size() : 0;
                    %>
                    <h2 class="text-2xl font-bold text-gray-900">내 문서 (<%= fileCount %>개)</h2>
                    <p class="text-gray-600 mt-1">업로드된 문서들을 확인하고 관리하세요</p>
                </div>
                
                <% if (session.getAttribute("user") != null) { %>
                    <a href="/storage/upload" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center shadow-md">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                        </svg>
                        새 문서 업로드
                    </a>
                <% } %>
            </div>
            
            <% if (files != null && !files.isEmpty()) { %>
                <div class="bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden">
                    <div class="divide-y divide-gray-200">
                        <% for (String fileName : files) { 
                            // Get file extension
                            String fileExtension = "";
                            int lastDotIndex = fileName.lastIndexOf(".");
                            if (lastDotIndex > 0) {
                                fileExtension = fileName.substring(lastDotIndex + 1).toLowerCase();
                            }
                            
                            // Get display name (remove file extension)
                            String displayName = fileName;
                            if (lastDotIndex > 0) {
                                displayName = fileName.substring(0, lastDotIndex);
                            }
                        %>
                            <div class="p-6 hover:bg-gray-50 transition-colors duration-200">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                                            <% if (java.util.Arrays.asList("jpg", "jpeg", "png", "gif", "bmp").contains(fileExtension)) { %>
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                                </svg>
                                            <% } else if ("pdf".equals(fileExtension)) { %>
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                                </svg>
                                            <% } else { %>
                                                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                                </svg>
                                            <% } %>
                                        </div>
                                        
                                        <div>
                                            <h3 class="text-lg font-medium text-gray-900"><%= displayName %></h3>
                                            <p class="text-sm text-gray-500"><%= fileExtension.toUpperCase() %> 파일</p>
                                        </div>
                                    </div>
                                    
                                    <div class="flex items-center space-x-3">
                                        <% if (java.util.Arrays.asList("jpg", "jpeg", "png", "gif", "bmp").contains(fileExtension)) { %>
                                            <a href="/storage/view?file=<%= java.net.URLEncoder.encode(fileName, "UTF-8") %>" 
                                               class="text-blue-600 hover:text-blue-800 text-sm font-medium transition-colors duration-200">
                                                미리보기
                                            </a>
                                        <% } %>
                                        <a href="/storage/download?file=<%= java.net.URLEncoder.encode(fileName, "UTF-8") %>" 
                                           class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors duration-200">
                                            다운로드
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } else { %>
                <div class="bg-white border border-gray-200 rounded-lg p-12 text-center">
                    <div class="w-16 h-16 mx-auto mb-4 bg-green-100 rounded-full flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-semibold text-gray-900 mb-2">문서가 없습니다</h3>
                    <p class="text-gray-500 mb-6">아직 업로드된 문서가 없습니다. 첫 번째 문서를 업로드해보세요.</p>
                    <% if (session.getAttribute("user") != null) { %>
                        <a href="/storage/upload" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 inline-flex items-center shadow-md">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                            </svg>
                            첫 번째 문서 업로드하기
                        </a>
                    <% } else { %>
                        <a href="/login" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 shadow-md">
                            로그인하여 문서 업로드하기
                        </a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>