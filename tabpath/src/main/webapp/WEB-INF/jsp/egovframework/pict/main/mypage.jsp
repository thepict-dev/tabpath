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
	            <h2>인증이<br>완료되었습니다</h2>
	            <div class="qrContainer">
	                <div class="qrInner" id="qr_img"></div>
	                <!-- 
	                <div class="cancelContainer">
	                    <a href="#lnk">참여취소</a>
	                </div>
	                 -->
	            </div>
	            <div class="entryContainer">
	                <div class="entryTexts">
	                    <p>금강산 가는 옛길 걷기<span>행사 응모권</span></p>
	                    <span>이 응모권은 캡처해서 사용하실 수 없습니다</span>
	                </div>
	                <div class="entryNumber">
	                    <p>No.<span>${pictVO.idx}</span></p>
	                    <span>행사당일사용</span>
	                </div>
	            </div>
	        </div>
	    </div>
	    <div class="cancelModal">
	        <div class="cancelInner">
	            <p>참여 취소</p>
	            <span>행사 참여를 취소하시겠어요?<br>
	                취소시 재등록은 불가해요.</span>
	            <div class="buttonContainer">
	                <a href="#lnk" class="wt close">닫기</a>
	                <a href="#lnk" class="bl my" onclick="fn_cancel('${pictVO.idx}')">참여 취소</a>
	            </div>
	        </div>
	    </div>
	    <form action="" id="register" name="register" method="post" enctype="multipart/form-data">
	    	<input type="hidden" id="idx" name="idx">
	    </form>
	    <script>
	    	function fn_cancel(idx){
	    		$('#idx').val(idx)
	    		var text = "참가등록을 취소하시겠습니까?";

				if (confirm(text)) {
					$("#register").attr("action", "/register_cancel.do");
					$("#register").submit();
				}
	    	}
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
