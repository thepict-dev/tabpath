<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html lang="ko">
	<c:import url="./include/head.jsp">
    	<c:param name="pageTitle" value="TAPPASS 사용자등록"/>
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
	                    <input type="text" name="name1" id="name1" placeholder="이름을 입력하세요">
	                </div>
	                <div class="inputBox">
	                    <p class="inputCaption">휴대폰번호</p>
	                    <input type="text" name="mobile1" id="mobile1" placeholder="휴대폰번호를 입력하세요" onkeypress="if(event.keyCode == 13){fn_login();}">
	                </div>
	                <a href="#lnk" onclick="fn_login()">로그인</a>
	            </form>
	        </div>
	    </div>
	    <form action="#" id="loginForm" name="loginForm" method="post">
			<input type="hidden" name="name" id="name" value="">
			<input type="hidden" name="mobile" id="mobile" value="">
		</form>
	    <script>
			function fn_login() {

				if ($("#name1").val() == "") {
					alert("이름을 입력하세요.");
					$("#name1").focus();
					return false;
				}
				else{
					$("#name").val($("#name1").val());
				}
				
				if ($("#mobile1").val() == "") {
					alert("휴대전화번호를 입력하세요.");
					$("#mobile1").focus();
					return false;
				} else {
					$("#mobile").val($("#mobile1").val());
				}
				document.loginForm.action = "/login_action.do";
				document.loginForm.submit();
				
			}
	        const $nameInput = $('#name1');
	        const $phoneInput = $('#mobile1');
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
