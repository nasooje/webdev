<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "문서 업로드"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">문서 업로드</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">안전하고 빠르게 문서를 업로드하세요</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-2xl mx-auto">
            <div class="bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden">
                
                <div class="p-8">
                    <form action="/storage/upload" method="post" enctype="multipart/form-data" class="space-y-8">
                        <div class="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center hover:border-green-500 hover:bg-green-50 transition-all duration-300 relative group">
                            <div class="space-y-4">
                                <div class="w-16 h-16 mx-auto bg-gray-100 rounded-full flex items-center justify-center group-hover:bg-green-100 transition-colors duration-300">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-gray-400 group-hover:text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                                    </svg>
                                </div>
                                <div>
                                    <h3 class="text-xl font-semibold text-gray-900 mb-2">파일을 업로드하세요</h3>
                                    <p class="text-gray-500">파일을 끌어다 놓거나 클릭하여 선택하세요</p>
                                    <p class="text-sm text-gray-400 mt-2">이미지, PDF, 문서 파일 지원</p>
                                </div>
                            </div>
                            
                            <input type="file" name="file" id="file-upload" required 
                                class="opacity-0 absolute inset-0 w-full h-full cursor-pointer z-10"
                                onchange="updateFileNameDisplay(this)">
                        </div>
                        
                        <div id="image-preview" class="hidden">
                            <div class="bg-gray-100 p-4 rounded-lg border border-gray-300">
                                <div class="mb-2 flex items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-600 mr-2" viewBox="0 0 20 20" fill="currentColor">
                                        <path fill-rule="evenodd" d="M4 3a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V5a2 2 0 00-2-2H4zm12 12H4l4-8 3 6 2-4 3 6z" clip-rule="evenodd" />
                                    </svg>
                                    <span class="text-lg font-medium text-gray-800">이미지 미리보기</span>
                                </div>
                                <div class="flex justify-center">
                                    <img id="preview-image" src="#" alt="미리보기" 
                                        class="max-w-full h-auto rounded-lg shadow-md" 
                                        style="max-height: 300px;">
                                </div>
                                <div class="mt-3 text-center">
                                    <span id="selected-file-name" class="text-sm text-gray-600 font-medium"></span>
                                </div>
                            </div>
                        </div>
                        
                        <div id="file-name-display" class="bg-green-50 border border-green-200 text-green-800 p-4 rounded-lg hidden">
                            <div class="flex items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-3 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                <span id="file-name" class="font-medium">선택된 파일이 없습니다</span>
                            </div>
                        </div>
                        
                        <div>
                            <label for="description" class="block text-sm font-semibold text-gray-900 mb-3">
                                파일 설명 (선택사항)
                            </label>
                            <textarea id="description" name="description" 
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 focus:border-green-500 resize-none" 
                                placeholder="파일에 대한 간단한 설명을 입력하세요..."
                                rows="4"></textarea>
                        </div>
                        
                        <div class="flex gap-4">
                            <a href="/storage" class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 font-semibold py-3 px-6 rounded-lg transition-colors duration-200 text-center">
                                취소
                            </a>
                            <button type="submit" class="flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors duration-200 shadow-md">
                                업로드
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="mt-8 text-center">
                <a href="/storage" class="inline-flex items-center text-green-600 hover:text-green-700 font-medium transition-colors duration-200">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    문서 관리로 돌아가기
                </a>
            </div>
        </div>
    </div>
</div>

<script>
    function updateFileNameDisplay(input) {
        const fileNameDisplay = document.getElementById('file-name-display');
        const fileNameElement = document.getElementById('file-name');
        const imagePreview = document.getElementById('image-preview');
        const previewImage = document.getElementById('preview-image');
        const selectedFileName = document.getElementById('selected-file-name');
        
        if (input.files && input.files[0]) {
            const fileName = input.files[0].name;
            
            fileNameElement.textContent = fileName;
            fileNameDisplay.classList.remove('hidden');
            selectedFileName.textContent = fileName;
            
            const fileType = input.files[0].type;
            if (fileType.match(/^image\//)) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImage.src = e.target.result;
                    imagePreview.classList.remove('hidden');
                }
                reader.readAsDataURL(input.files[0]);
            } else {
                imagePreview.classList.add('hidden');
            }
        } else {
            fileNameDisplay.classList.add('hidden');
            imagePreview.classList.add('hidden');
        }
    }
    
    document.addEventListener('DOMContentLoaded', function() {
        const dropArea = document.querySelector('.border-dashed');
        const fileInput = document.getElementById('file-upload');
        
        dropArea.addEventListener('click', function(e) {
            if (e.target !== fileInput) {
                fileInput.click();
            }
        });
        
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, preventDefaults, false);
        });
        
        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }
        
        ['dragenter', 'dragover'].forEach(eventName => {
            dropArea.addEventListener(eventName, highlight, false);
        });
        
        ['dragleave', 'drop'].forEach(eventName => {
            dropArea.addEventListener(eventName, unhighlight, false);
        });
        
        function highlight() {
            dropArea.classList.add('border-green-400');
        }
        
        function unhighlight() {
            dropArea.classList.remove('border-green-400');
        }
        
        dropArea.addEventListener('drop', handleDrop, false);
        
        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            fileInput.files = files;
            updateFileNameDisplay(fileInput);
        }
    });
</script>

<%@ include file="common/footer.jsp" %>