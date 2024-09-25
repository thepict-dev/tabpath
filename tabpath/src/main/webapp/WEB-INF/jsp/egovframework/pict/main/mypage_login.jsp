<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
	<c:import url="./include/head.jsp">
    	<c:param name="pageTitle" value="TABPATH 사용자등록"/>
    </c:import>
    <body>
	    <div class="container login">
	        <div class="contentTop">
	            <a href="/main.do"><img src="/user_img/back.png" alt=""></a>
	            <p>로그인</p>
	        </div>
	        <div class="contentBottom">
	            <form action="#" class="loginContainer">
	                <div class="inputBox">
	                    <p class="inputCaption">이름</p>
	                    <input type="text" name="name" id="name" placeholder="이름을 입력하세요">
	                </div>
	                <div class="inputBox">
	                    <p class="inputCaption">휴대폰번호</p>
	                    <input type="text" name="phone" id="phone" placeholder="휴대폰번호를 입력하세요">
	                </div>
	                <a href="#lnk">로그인</a>
	            </form>
	        </div>
	    </div>
	    <script>
	        const $nameInput = $('#name');
	        const $phoneInput = $('#phone');
	        const $loginButton = $('.loginContainer a');
	
	        // 휴대폰 번호
	        $phoneInput.on('input', function() {
	            let value = $(this).val().replace(/[^0-9]/g, '');
	            if (value.length > 11) {
	                value = value.slice(0, 11);
	            }
	            $(this).val(value);
	        });
	
	        // 입력 확인 버튼
	        function checkInputs() {
	            if ($nameInput.val() !== '' && $phoneInput.val().length === 11) {
	                $loginButton.addClass('active');
	            } else {
	                $loginButton.removeClass('active');
	            }
	        }
	
	        $nameInput.on('input', checkInputs);
	        $phoneInput.on('input', checkInputs);
	    </script>
    </body>
</html>
