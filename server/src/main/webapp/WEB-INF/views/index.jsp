<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "홈"); %>
<%@ include file="common/header.jsp" %>

<div class="hero-section relative h-screen bg-gray-900 text-white overflow-hidden">
    <div class="absolute inset-0 bg-cover bg-center bg-no-repeat" 
         style="background-image: linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.6)), url('${pageContext.request.contextPath}/resources/image/main.png');">
    </div>
    
    <div class="relative z-10 container mx-auto px-4 h-full flex items-center">
        <div class="max-w-4xl">
            <h1 class="text-3xl md:text-4xl lg:text-5xl xl:text-6xl font-bold mb-6 leading-tight">
                산업재해예방정책원과 함께<br>
                <span class="text-green-400">안전한 작업환경을</span>
            </h1>
            <p class="text-xl md:text-2xl mb-8 text-gray-200 leading-relaxed">
                체계적이고 전문적인 안전교육으로<br>
                산업현장의 안전을 지켜나갑니다
            </p>
            <div class="flex flex-col sm:flex-row gap-4">
                <a href="/safety-training" class="bg-green-600 hover:bg-green-700 text-white px-8 py-4 font-semibold text-lg transition-all duration-300 transform hover:scale-105">
                    안전교육 프로그램
                </a>
                <a href="/guide" class="border-2 border-white text-white hover:bg-white hover:text-gray-900 px-8 py-4 font-semibold text-lg transition-all duration-300">
                    자세히 알아보기
                </a>
            </div>
        </div>
    </div>
    
    <div class="absolute bottom-8 right-8 flex space-x-2">
        <div class="w-2 h-2 bg-white"></div>
        <div class="w-2 h-2 bg-gray-400"></div>
        <div class="w-2 h-2 bg-gray-400"></div>
    </div>
</div>

<div class="py-20 bg-white">
    <div class="container mx-auto px-4">
        <div class="text-center mb-16">
            <h2 class="text-4xl font-bold text-gray-900 mb-4">핵심 서비스</h2>
            <div class="w-24 h-1 bg-green-600 mx-auto mb-6"></div>
            <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                산업재해예방정책원은 최첨단 기술과 전문성을 바탕으로 체계적이고 효과적인 안전교육 솔루션을 제공합니다
            </p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="group bg-white border border-gray-200 p-8 transition-all duration-300 hover:shadow-xl hover:border-green-600">
                <div class="w-16 h-16 bg-green-100 flex items-center justify-center text-green-600 mb-6 group-hover:bg-green-600 group-hover:text-white transition-all duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                    </svg>
                </div>
                <h3 class="text-2xl font-bold mb-4 text-gray-900">안전 관리</h3>
                <p class="text-gray-600 leading-relaxed">
                    최고 수준의 안전 기준과 체계적인 안전 관리 시스템으로 모든 프로젝트의 안전성을 보장합니다.
                </p>
            </div>
            
            <div class="group bg-white border border-gray-200 p-8 transition-all duration-300 hover:shadow-xl hover:border-green-600">
                <div class="w-16 h-16 bg-green-100 flex items-center justify-center text-green-600 mb-6 group-hover:bg-green-600 group-hover:text-white transition-all duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                    </svg>
                </div>
                <h3 class="text-2xl font-bold mb-4 text-gray-900">전문 교육</h3>
                <p class="text-gray-600 leading-relaxed">
                    산업별 특성에 맞는 맞춤형 안전교육을 통해 전문적인 안전 역량을 배양합니다.
                </p>
            </div>
            
            <div class="group bg-white border border-gray-200 p-8 transition-all duration-300 hover:shadow-xl hover:border-green-600">
                <div class="w-16 h-16 bg-green-100 flex items-center justify-center text-green-600 mb-6 group-hover:bg-green-600 group-hover:text-white transition-all duration-300">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                    </svg>
                </div>
                <h3 class="text-2xl font-bold mb-4 text-gray-900">시설 관리</h3>
                <p class="text-gray-600 leading-relaxed">
                    첨단 모니터링 시스템과 전문 인력을 통한 체계적인 시설 운영 및 관리를 제공합니다.
                </p>
            </div>
        </div>
    </div>
</div>

<div class="py-20 bg-gray-900 text-white">
    <div class="container mx-auto px-4 text-center">
        <h2 class="text-4xl font-bold mb-6">안전한 미래, 함께 만들어갑니다</h2>
        <p class="text-xl text-gray-300 mb-8 max-w-2xl mx-auto">
            전문적인 안전교육과 체계적인 관리 시스템으로 여러분의 안전을 책임집니다
        </p>
        <a href="/register" class="bg-green-600 hover:bg-green-700 text-white px-10 py-4 font-semibold text-lg transition-all duration-300 transform hover:scale-105">
            지금 시작하기
        </a>
    </div>
</div>

<%@ include file="common/footer.jsp" %>