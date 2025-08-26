<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "파일 저장소 관리"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">파일 저장소 관리</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">시스템에 업로드된 모든 파일을 관리합니다</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">
            <% 
                java.util.List<String> files = (java.util.List<String>) request.getAttribute("files");
                String path = (String) request.getAttribute("path");
                String displayPath = path != null ? path : "root";
                String searchQuery = request.getParameter("search");
            %>
            
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 gap-4">
                <div class="flex items-center">
                    <div class="w-12 h-12 bg-green-100 flex items-center justify-center mr-4">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
                        </svg>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-900">디렉토리 내용</h2>
                        <p class="text-gray-600 font-mono">/<%= displayPath %></p>
                    </div>
                </div>
                
                <div class="flex gap-4">
                    <div class="relative">
                        <form method="GET" action="/admin/view">
                            <input type="hidden" name="path" value="<%= path != null ? path : "" %>">
                            <input type="text" 
                                   name="search" 
                                   value="<%= searchQuery != null ? searchQuery : "" %>"
                                   placeholder="파일 검색..." 
                                   class="border border-gray-300 pl-10 pr-4 py-3 w-80 focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400 absolute left-3 top-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="bg-gray-50 p-6 mb-8">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="text-center">
                        <div class="text-2xl font-bold text-gray-900"><%= files != null ? files.size() : 0 %></div>
                        <p class="text-gray-600">총 파일 수</p>
                    </div>
                    <div class="text-center">
                        <div class="text-2xl font-bold text-gray-900">
                            <% 
                                int dirCount = 0;
                                int fileCount = 0;
                                if (files != null) {
                                    for (String file : files) {
                                        if (file.endsWith("/")) {
                                            dirCount++;
                                        } else {
                                            fileCount++;
                                        }
                                    }
                                }
                            %>
                            <%= dirCount %>
                        </div>
                        <p class="text-gray-600">디렉토리</p>
                    </div>
                    <div class="text-center">
                        <div class="text-2xl font-bold text-gray-900"><%= fileCount %></div>
                        <p class="text-gray-600">파일</p>
                    </div>
                </div>
            </div>
            
            <% if (files != null && !files.isEmpty()) { %>
                <div class="bg-white border border-gray-200">
                    <div class="overflow-x-auto">
                        <table class="min-w-full">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-4 text-left text-sm font-medium text-gray-900 uppercase tracking-wider">이름</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200">
                                <% if (path != null && !path.isEmpty() && !path.equals("uploads")) { %>
                                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                                        <td class="px-6 py-4 flex items-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                                            </svg>
                                            <% 
                                                String parentPath = path.contains("/") ? path.substring(0, path.lastIndexOf("/")) : "uploads";
                                            %>
                                        </td>
                                    </tr>
                                <% } %>
                                
                                <% for (String file : files) { 
                                    boolean isDirectory = file.endsWith("/");
                                    String fileName = isDirectory ? file.substring(0, file.length() - 1) : file;
                                    String fileExtension = "";
                                    if (!isDirectory && fileName.contains(".")) {
                                        fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                                    }
                                %>
                                    <tr class="hover:bg-gray-50 transition-colors duration-200">
                                        <td class="px-6 py-4">
                                            <div class="flex items-center">
                                                <% if (isDirectory) { %>
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
                                                    </svg>
                                                    <a href="/admin/view?path=<%= path != null ? path + "/" + fileName : fileName %>" 
                                                       class="text-green-600 hover:text-green-900 font-medium transition-colors duration-200">
                                                        <%= fileName %>
                                                    </a>
                                                <% } else if ("pdf".equals(fileExtension)) { %>
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                                    </svg>
                                                    <span class="text-gray-900 font-medium"><%= fileName %></span>
                                                <% } else if (java.util.Arrays.asList("jpg", "jpeg", "png", "gif").contains(fileExtension)) { %>
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-blue-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                                    </svg>
                                                    <span class="text-gray-900 font-medium"><%= fileName %></span>
                                                <% } else { %>
                                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                                    </svg>
                                                    <span class="text-gray-900 font-medium"><%= fileName %></span>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } else { %>
                <div class="text-center py-12">
                    <div class="h-20 w-20 mx-auto mb-4 bg-green-100 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-medium text-gray-800 mb-2">파일을 찾을 수 없습니다</h3>
                    <p class="text-gray-600 mb-6">이 위치에 파일이나 디렉토리가 없습니다.</p>
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

<%@ include file="common/footer.jsp" %>