<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% pageContext.setAttribute("pageTitle", "자주하는 질문"); %>
<%@ include file="common/header.jsp" %>

<div class="bg-gray-900 text-white py-16">
    <div class="container mx-auto px-4">
        <div class="text-center">
            <h1 class="text-4xl font-bold mb-4">자주 묻는 질문</h1>
            <p class="text-xl text-gray-300 max-w-2xl mx-auto">산업안전교육 관련 자주 묻는 질문과 답변을 확인하세요</p>
        </div>
    </div>
</div>

<div class="bg-white py-16">
    <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
            <div class="space-y-12">
                
                <div>
                    <h2 class="text-2xl font-bold text-green-600 mb-8 border-b-2 border-green-600 pb-2">교육 신청 관련</h2>
                    <div class="space-y-6">
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 안전교육 승인은 얼마나 걸리나요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 안전교육 신청 후 일반적으로 7일 이내에 승인됩니다. 단, 전문적인 교육이나 커스텀 교육의 경우 추가 준비 시간이 소요될 수 있습니다. 진행 상황은 마이페이지에서 확인 가능합니다.</p>
                        </div>
                        
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 안전교육 수료증은 어떻게 발급받나요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 마이페이지 > 내 교육내역에서 원하는 교육을 선택한 후 수료증 발급 버튼을 클릭하시면 발급받을 수 있습니다. 발급된 수료증은 PDF 형태로 다운로드 가능합니다.</p>
                        </div>
                        
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 교육 신청 후 취소가 가능한가요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 교육 시작 24시간 전까지는 취소가 가능합니다. 마이페이지에서 해당 교육을 선택하여 취소 신청을 하시면 됩니다. 교육 시작 후에는 취소가 불가능하니 신중하게 신청해 주세요.</p>
                        </div>
                    </div>
                </div>
                
                <div>
                    <h2 class="text-2xl font-bold text-green-600 mb-8 border-b-2 border-green-600 pb-2">교육 진행 관련</h2>
                    <div class="space-y-6">
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 교육 신청 기한이 있나요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 각 교육 프로그램마다 신청 마감일이 다릅니다. 교육 상세 페이지에서 신청 기한을 확인하실 수 있으며, 정원이 마감되면 조기 마감될 수 있습니다.</p>
                        </div>
                        
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 교육 시간은 어떻게 되나요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 교육 종류에 따라 다르지만, 기본 안전교육은 4시간, 전문 교육은 8~16시간으로 구성됩니다. 정확한 교육 시간은 각 프로그램 상세 페이지에서 확인 가능합니다.</p>
                        </div>
                        
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 온라인 교육도 가능한가요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 네, 일부 교육 과정은 온라인으로도 진행됩니다. 현장 실습이 필요한 교육은 오프라인으로만 진행되며, 교육 방식은 각 프로그램 상세 페이지에서 확인하실 수 있습니다.</p>
                        </div>
                    </div>
                </div>
                
                <div>
                    <h2 class="text-2xl font-bold text-green-600 mb-8 border-b-2 border-green-600 pb-2">기타 관련</h2>
                    <div class="space-y-6">
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 안전교육 관련 상담은 어디서 받을 수 있나요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 고객센터(1588-0000)로 문의하시거나, 홈페이지 문의게시판을 이용하시면 안전관리사가 친절하게 상담해 드립니다. 평일 오전 9시부터 오후 6시까지 상담 가능합니다.</p>
                        </div>
                        
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 교육비는 얼마인가요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 기본 안전교육은 무료이며, 전문 교육은 과정에 따라 5만원~20만원의 교육비가 발생합니다. 정확한 교육비는 각 프로그램 상세 페이지에서 확인하실 수 있습니다.</p>
                        </div>
                        
                        <div class="border border-gray-200 p-6">
                            <h3 class="font-bold text-gray-900 mb-3 text-lg">Q. 단체 교육 신청도 가능한가요?</h3>
                            <p class="text-gray-700 leading-relaxed">A. 네, 10명 이상의 단체 교육도 가능합니다. 별도 문의를 통해 맞춤형 교육 프로그램을 제공해 드리며, 현장 방문 교육도 가능합니다. 자세한 내용은 고객센터로 문의해 주세요.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="common/footer.jsp" %>