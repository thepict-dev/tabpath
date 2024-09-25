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
	        <div class="contentBottom app">
	            <div class="progress">
	                <div class="proInner"></div>
	            </div>
	            <h2>금강산 가는 옛길 걷기<br>사전등록입니다</h2>
	            <form action="#" class="appContainer">
	                <div class="inputBox phone" style="display: none;">
	                    <p class="inputCaption">휴대폰 번호</p>
	                    <div class="inputButton">
	                        <input type="text" name="phone" id="phone" placeholder="휴대폰 번호를 입력하세요">
	                        <!-- 재전송 -->
	                        <a href="#lnk">인증번호 전송</a>
	                    </div>
	                    <div class="inputButton verify">
	                        <input type="text" name="verify" id="verify" placeholder="인증번호를 입력하세요">
	                        <p class="sec">3:00</p>
	                        <p class="done">인증완료</p>
	                    </div>
	                </div>
	                <div class="inputBox per" style="display: none;">
	                    <p class="inputCaption">생년월일</p>
	                    <div class="birthInput">
	                        <input type="text" name="birth" id="birth" placeholder="YYMMDD" class="">
	                        <span>-</span>
	                        <label for="gender">
	                            <input type="text" name="gender" id="gender">
	                        </label>
	                    </div>
	                </div>
	                <div class="inputBox">
	                    <p class="inputCaption">이름</p>
	                    <input type="text" name="name" id="name" placeholder="이름을 입력하세요">
	                </div>
	                <div class="buttonContainer app">
	                    <a href="#lnk" class="wt">이전으로</a>
	                    <a href="#lnk" class="gr">다음으로</a>
	                </div>
	            </form>
	        </div>
	    </div>
	    <script>
		    $(document).ready(function() {
		        const $nameInput = $('#name');
		        const $birthInput = $('#birth');
		        const $genderInput = $('#gender');
		        const $phoneInput = $('#phone');
		        const $verifyInput = $('#verify');
		        const $birthInputBox = $('.inputBox.per');
		        const $phoneInputBox = $('.inputBox.phone');
		        const $verifyBox = $('.inputButton:last-child');
		        const $nextButton = $('.buttonContainer.app .gr');
	
		        // 초기 상태 설정
		        $birthInputBox.hide();
		        $phoneInputBox.hide();
		        $verifyBox.hide();
	
		        // 이름 입력 시 생년월일 필드 표시
		        $nameInput.on('input', function() {
		            if ($(this).val().trim() !== '') {
		                $birthInputBox.slideDown(300);
		            } else {
		                $birthInputBox.slideUp(300);
		                $phoneInputBox.slideUp(300);
		            }
		            checkInputs();
		        });
	
		        // 생년월일 입력 제한 (YYMMDD 형식)
		        $birthInput.on('input', function() {
		            let value = $(this).val().replace(/[^0-9]/g, '');
		            if (value.length > 6) {
		                value = value.slice(0, 6);
		            }
		            $(this).val(value);
		            checkBirthAndGender();
		        });
	
		        // 성별 입력 제한 (1-4만 입력 가능)
		        $genderInput.on('input', function() {
		            let value = $(this).val().replace(/[^1-4]/g, '');
		            if (value.length > 1) {
		                value = value.slice(0, 1);
		            }
		            $(this).val(value);
		            checkBirthAndGender();
		        });
	
		        // 생년월일 및 성별 입력 확인 및 휴대폰 번호 필드 표시
		        function checkBirthAndGender() {
		            if ($birthInput.val().length === 6 && $genderInput.val().length === 1) {
		                $phoneInputBox.slideDown(300);
		            } else {
		                $phoneInputBox.slideUp(300);
		            }
		            checkInputs();
		        }
	
		        // 휴대폰 번호 입력 제한 및 인증번호 필드 표시
		        $phoneInput.on('input', function() {
		            let value = $(this).val().replace(/[^0-9]/g, '');
		            if (value.length > 11) {
		                value = value.slice(0, 11);
		            }
		            $(this).val(value);
		            
		            if (value.length === 11) {
		                $verifyBox.slideDown(300);
		            } else {
		                $verifyBox.slideUp(300);
		                $verifyInput.val('');
		            }
		            
		            checkInputs();
		        });
	
		        // 인증번호 입력 제한 및 활성화 상태 설정
		        $verifyInput.on('input', function() {
		            let value = $(this).val().replace(/[^0-9]/g, '');
		            if (value.length > 6) {
		                value = value.slice(0, 6);
		            }
		            $(this).val(value);
		            
		            if (value.length === 6) {
		                $verifyBox.addClass('active');
		            } else {
		                $verifyBox.removeClass('active');
		            }
		            
		            checkInputs();
		        });
	
		        // 입력 확인 및 버튼 활성화
		        function checkInputs() {
		            if ($nameInput.val().trim() !== '' &&
		                $birthInput.val().length === 6 &&
		                $genderInput.val().length === 1 &&
		                $phoneInput.val().length === 11 &&
		                $verifyInput.val().length === 6) {
		                $nextButton.addClass('active');
		            } else {
		                $nextButton.removeClass('active');
		            }
		        }
		    });
	    </script>	
    </body>
</html>
