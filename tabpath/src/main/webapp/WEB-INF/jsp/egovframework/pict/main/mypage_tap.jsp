<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<!DOCTYPE html>
<html lang="ko">
	<c:import url="./include/head.jsp">
    	<c:param name="pageTitle" value="TAPPASS 사용자등록"/>
    </c:import>
    <body>
	    <div class="container login">
	        <div class="contentTop my">
	            <p>마이페이지</p>
	        </div>
	        <div class="comment">
	            <p class="rolling-text">금강산 가는 옛길 걷기 행사에 참여하시는 모든 분들 환영합니다</p>
	        </div>
	        <div class="contentBottom my">
	            <div class="qrContainer tap">
	                <div class="qrInner" id="qr_img"></div>
	                <div class="seatNumber">
	                    <p>좌석코드</p>
	                    <c:if test="${pictVO.bus ne '' && pictVO.bus ne null && pictVO.bus ne undefined && pictVO.seat ne '' && pictVO.seat ne null && pictVO.seat ne undefined}">
                   			<p>${pictVO.bus}-${pictVO.seat}</p>
                   		</c:if> 
                   		<c:if test="${pictVO.bus eq '' || pictVO.bus eq null || pictVO.bus eq undefined || pictVO.seat eq '' || pictVO.seat eq null || pictVO.seat eq undefined}">
                   			<p>미배정</p>
                   		</c:if>
	                    
	                </div>
	            </div>
	            <div class="entryContainer">
	                <div class="entryTexts">
	                    <p>금강산 가는 옛길 걷기<span>행사 응모권</span></p>
	                    <span>이 응모권은 캡처해서 사용하실 수 없습니다</span>
	                </div>
	                <div class="entryNumber">
	                    <p>No.<span>${pictVO.idx }</span></p>
	                    <span>행사당일사용</span>
	                </div>
	            </div>
	        </div>
	    </div>

	    <script>
		    $( document ).ready(function() {
			    var idx = '${pictVO.fairpath_id}'
		    	var qrcode = new QRCode(document.getElementById("qr_img"), {
		    		text: idx        
		    	});
			});
	        $('.cancelContainer a').click(function(){
	            $('.cancelModal').addClass('active');
	        });
	        $('.cancelInner .close').click(function(){
	            $('.cancelModal').removeClass('active');
	        });
	
	        const $comment = $('.comment');
	        const $rollingText = $('.rolling-text');
	    
	        function adjustAnimation() {
	            const commentWidth = $comment.width();
	            const textWidth = $rollingText.width();
	            const duration = (commentWidth + textWidth) / 50; // 속도 조절
	    
	            $rollingText.css({
	                'animation-duration': duration + 's'
	            });
	        }
	    
	        adjustAnimation();
	    
	        $(window).on('resize', adjustAnimation);
	
	
	        const $qrContainer = $('.qrContainer');
	        const $cancelContainer = $('.cancelContainer');
	        const $cancelLink = $('.cancelContainer a');
	
	        $qrContainer.on('click', function(e) {
	            if (!$(e.target).closest('.cancelContainer').length) {
	                $cancelContainer.addClass('active');
	            }
	        });
	
	        $(document).on('click', function(e) {
	            if (!$(e.target).closest('.qrContainer').length || 
	                ($(e.target).closest('.cancelContainer').length && !$(e.target).closest('a').length)) {
	                $cancelContainer.removeClass('active');
	            }
	        });
	
	        $cancelLink.on('click', function(e) {
	            e.stopPropagation();
	        });
	    </script>
    </body>
</html>
