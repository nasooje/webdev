<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "안전교육 안내"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">안전교육 안내</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">산업안전보건법에 따른 체계적이고 전문적인 안전교육 프로그램을 안내합니다</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-12">
                
                <div class="space-y-8">
                    <div class="bg-gray-50 p-8">
                        <h2 class="text-2xl font-bold text-gray-900 mb-6">산업안전교육이란?</h2>
                        <div class="space-y-4 text-gray-700">
                            <div>
                                <h3 class="font-semibold text-lg mb-2">교육의 정의</h3>
                                <p class="leading-relaxed">산업안전보건법에 따른 의무교육으로, 근로자의 안전의식 향상과 사고예방을 위한 체계적인 교육과정입니다.</p>
                            </div>
                            <div>
                                <h3 class="font-semibold text-lg mb-2">교육의 목적</h3>
                                <ul class="space-y-1 pl-4">
                                    <li>• 근로자 안전의식 향상</li>
                                    <li>• 산업재해 예방</li>
                                    <li>• 안전한 작업환경 조성</li>
                                    <li>• 법정 의무교육 이행</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-white border border-gray-200 p-8">
                        <h2 class="text-2xl font-bold text-gray-900 mb-6">교육 프로그램 유형</h2>
                        <div class="space-y-4">
                            <div class="border-l-4 border-green-600 pl-4">
                                <h3 class="font-semibold text-lg text-green-600">산업안전 기초교육</h3>
                                <p class="text-gray-600">근로자를 위한 기본 안전수칙 교육</p>
                            </div>
                            <div class="border-l-4 border-green-600 pl-4">
                                <h3 class="font-semibold text-lg text-green-600">화학물질 안전관리</h3>
                                <p class="text-gray-600">화학물질 취급 및 관리 전문교육</p>
                            </div>
                            <div class="border-l-4 border-green-600 pl-4">
                                <h3 class="font-semibold text-lg text-green-600">건설현장 안전교육</h3>
                                <p class="text-gray-600">건설현장 맞춤형 안전교육</p>
                            </div>
                            <div class="border-l-4 border-green-600 pl-4">
                                <h3 class="font-semibold text-lg text-green-600">기계안전 교육</h3>
                                <p class="text-gray-600">기계조작 및 유지보수 안전교육</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="space-y-8">
                    <div class="bg-green-50 p-8">
                        <h2 class="text-2xl font-bold text-gray-900 mb-6">신청 방법</h2>
                        <div class="space-y-4">
                            <div class="flex items-start space-x-3">
                                <div class="bg-green-600 text-white w-6 h-6 flex items-center justify-center text-sm font-bold">1</div>
                                <div>
                                    <h3 class="font-semibold">회원가입 및 로그인</h3>
                                    <p class="text-gray-600 text-sm">산업재해예방정책원 홈페이지에서 회원가입 후 로그인</p>
                                </div>
                            </div>
                            <div class="flex items-start space-x-3">
                                <div class="bg-green-600 text-white w-6 h-6 flex items-center justify-center text-sm font-bold">2</div>
                                <div>
                                    <h3 class="font-semibold">교육 프로그램 선택</h3>
                                    <p class="text-gray-600 text-sm">원하는 안전교육 프로그램을 선택</p>
                                </div>
                            </div>
                            <div class="flex items-start space-x-3">
                                <div class="bg-green-600 text-white w-6 h-6 flex items-center justify-center text-sm font-bold">3</div>
                                <div>
                                    <h3 class="font-semibold">신청서 작성</h3>
                                    <p class="text-gray-600 text-sm">필요한 정보를 입력하여 신청서 작성</p>
                                </div>
                            </div>
                            <div class="flex items-start space-x-3">
                                <div class="bg-green-600 text-white w-6 h-6 flex items-center justify-center text-sm font-bold">4</div>
                                <div>
                                    <h3 class="font-semibold">교육 참여</h3>
                                    <p class="text-gray-600 text-sm">지정된 일시에 교육에 참여</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-6 pt-6 border-t border-green-200">
                            <a href="/safety-training" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 font-medium transition-colors duration-200 inline-block">
                                교육 신청하기
                            </a>
                        </div>
                    </div>
                    
                    <div class="bg-white border border-gray-200 p-8">
                        <h2 class="text-2xl font-bold text-gray-900 mb-6">신청 요건</h2>
                        <div class="space-y-4 text-gray-700">
                            <div>
                                <h3 class="font-semibold text-lg mb-2">필수 조건</h3>
                                <ul class="space-y-1 pl-4">
                                    <li>• 만 18세 이상의 근로자</li>
                                    <li>• 산업안전보건법 적용 사업장 근무자</li>
                                    <li>• 본인 확인이 가능한 신분증 소지</li>
                                </ul>
                            </div>
                            <div>
                                <h3 class="font-semibold text-lg mb-2">준비사항</h3>
                                <ul class="space-y-1 pl-4">
                                    <li>• 사업자등록증 (사업주의 경우)</li>
                                    <li>• 근로계약서 또는 재직증명서</li>
                                    <li>• 이전 교육 수료증 (해당시)</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="bg-gray-50 py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto text-center">
            <h2 class="text-3xl font-bold text-gray-900 mb-12">안전교육의 효과</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div class="bg-white p-6 shadow-sm">
                    <div class="w-16 h-16 bg-green-100 mx-auto mb-4 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold mb-2">사고 예방</h3>
                    <p class="text-gray-600">체계적인 안전교육을 통한 산업재해 예방</p>
                </div>
                
                <div class="bg-white p-6 shadow-sm">
                    <div class="w-16 h-16 bg-green-100 mx-auto mb-4 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold mb-2">역량 강화</h3>
                    <p class="text-gray-600">근로자의 안전 의식 및 대응 능력 향상</p>
                </div>
                
                <div class="bg-white p-6 shadow-sm">
                    <div class="w-16 h-16 bg-green-100 mx-auto mb-4 flex items-center justify-center">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold mb-2">법규 준수</h3>
                    <p class="text-gray-600">산업안전보건법 의무교육 이행</p>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>