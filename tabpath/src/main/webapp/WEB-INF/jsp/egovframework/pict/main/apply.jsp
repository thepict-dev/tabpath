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
	        <div class="contentBottom app">
	            <div class="progress">
	                <div class="proInner"></div>
	            </div>
	            <h2>금강산 가는 옛길 걷기<br>참가등록입니다</h2>
	            <form action="" id="register" name="register" method="post" enctype="multipart/form-data" class="appContainer">
        	        <div class="inputBox boarding" style="display: none;">
	                    <p class="inputCaption">탑승 장소</p>
                        <div class="checkContainer">
                            <div class="checkInput">
                                <input type="radio" name="boarding" id="boarding1">
                                <label for="boarding1">종합운동장</label>
                            </div>
                            <div class="checkInput">
                                <input type="radio" name="boarding" id="boarding2">
                                <label for="boarding2">국토정중앙면</label>
                            </div>
                            <div class="checkInput">
                                <input type="radio" name="boarding" id="boarding3">
                                <label for="boarding3">동면</label>
                            </div>
                            <div class="checkInput">
                                <input type="radio" name="boarding" id="boarding4">
                                <label for="boarding4">방산</label>
                            </div>
                            <div class="checkInput">
                                <input type="radio" name="boarding" id="boarding5">
                                <label for="boarding5">해안</label>
                            </div>
                        </div>
	                </div>
	            	<div class="inputBox location" style="display: none;">
	                    <p class="inputCaption">거주 지역(간단히)</p>
                        <input type="text" name="location" id="location" placeholder="ex)강원특별자치도 양구군, 서울특별시 양재동">
	                </div>
	                <div class="inputBox phone" style="display: none;">
	                    <p class="inputCaption">휴대폰 번호</p>
	                    <div class="inputButton">
	                        <input type="text" name="phone" id="phone" placeholder="휴대폰 번호를 입력하세요">
	                        <!-- 재전송 -->
	                        <a href="#lnk" onclick="sms_number()">인증번호 전송</a>
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
	                    <a href="javascript:history.back();" class="wt">이전으로</a>
	                    <a href="#lnk" class="gr" onclick="apply_next()">다음으로</a>
	                </div>
	            </form>
	        </div>
	    </div>
	    <script>
	    	function apply_next(){
	    		var text = "참가등록 하시겠습니까?";

				if (confirm(text)) {
					var param = {
		    			name : $("#name").val(),
		    			mobile : $('#phone').val(),
		    			sms_rand : $('#verify').val(),
		    			
		    		}
					
					$.ajax({
						url: '/register_save.do'
						, type : "POST"
						, data : JSON.stringify(param)
						, contentType : "application/json"
						, async : false
						, success : function(result){
							var code = result.code;
							if(code == '200'){
								alert(result.message)
								window.location.href= result.url
							}
							else if(code == '400'){
								alert(result.message)
							}
						},
						error : function (err){
							console.log(err)
						}
					})
				}	
	    	}
	    	
	    	
	    	function sms_number(){
	    		var param = {
	    			name : $("#name").val(),
	    			mobile : $('#phone').val(),
	    			birth : $('#birth').val(),
	    			gender : $('#gender').val(),
	    			
	    		}
				
				$.ajax({
					url: '/sms_number.do'
					, type : "POST"
					, data : JSON.stringify(param)
					, contentType : "application/json"
					, async : false
					, success : function(result){
						var rst = result.replace(/[\r\n]+/g, ' ');
						if(rst.includes("더픽트")){
							alert(rst.replace("더픽트", ''))
						}
					},
					error : function (err){
						console.log(err)
					}
				})
	    	}
	    
	    	$(document).ready(function() {
	    	    const $nameInput = $('#name');
	    	    const $birthInput = $('#birth');
	    	    const $genderInput = $('#gender');
	    	    const $phoneInput = $('#phone');
	    	    const $verifyInput = $('#verify');
	    	    const $locationInput = $('#location');
	    	    const $boardingInputs = $('input[name="boarding"]');
	    	    const $birthInputBox = $('.inputBox.per');
	    	    const $phoneInputBox = $('.inputBox.phone');
	    	    const $locationInputBox = $('.inputBox.location');
	    	    const $boardingInputBox = $('.inputBox.boarding');
	    	    const $verifyBox = $('.inputButton:last-child');
	    	    const $nextButton = $('.buttonContainer.app .gr');
	    	    const $progressBar = $('.proInner');
	    	    const totalFields = 7; // 이름, 생년월일, 성별, 휴대폰 번호, 인증번호, 거주 지역, 탑승 장소
	    	    let filledFields = 0;

	    	    // 초기 상태 설정
	    	    $birthInputBox.hide();
	    	    $phoneInputBox.hide();
	    	    $locationInputBox.hide();
	    	    $boardingInputBox.hide();
	    	    $verifyBox.hide();

	    	    // 이름 입력 시 생년월일 필드 표시
	    	    $nameInput.on('input', function() {
	    	        if ($(this).val().trim() !== '') {
	    	            $birthInputBox.slideDown(300);
	    	        } else {
	    	            $birthInputBox.slideUp(300);
	    	            $phoneInputBox.slideUp(300);
	    	            $verifyBox.slideUp(300);
	    	            $locationInputBox.slideUp(300);
	    	            $boardingInputBox.slideUp(300);
	    	        }
	    	        checkInputs();
	    	        checkField($(this), $(this).val().trim() !== '');
	    	    });

	    	    // 생년월일 및 성별 입력 확인 및 휴대폰 번호 필드 표시
	    	    function checkBirthAndGender() {
	    	        if ($birthInput.val().length === 6 && $genderInput.val().length === 1) {
	    	            $phoneInputBox.slideDown(300);
	    	        } else {
	    	            $phoneInputBox.slideUp(300);
	    	            $verifyBox.slideUp(300);
	    	            $locationInputBox.slideUp(300);
	    	            $boardingInputBox.slideUp(300);
	    	        }
	    	        checkInputs();
	    	    }

	    	    // 생년월일 입력 제한 (YYMMDD 형식)
	    	    $birthInput.on('input', function() {
	    	        let value = $(this).val().replace(/[^0-9]/g, '');
	    	        if (value.length > 6) {
	    	            value = value.slice(0, 6);
	    	        }
	    	        $(this).val(value);
	    	        checkBirthAndGender();
	    	        checkField($(this), value.length === 6);
	    	    });

	    	    // 성별 입력 제한 (1-4만 입력 가능)
	    	    $genderInput.on('input', function() {
	    	        let value = $(this).val().replace(/[^1-4]/g, '');
	    	        if (value.length > 1) {
	    	            value = value.slice(0, 1);
	    	        }
	    	        $(this).val(value);
	    	        checkBirthAndGender();
	    	        checkField($(this), value.length === 1);
	    	    });

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
	    	            $locationInputBox.slideUp(300);
	    	            $boardingInputBox.slideUp(300);
	    	        }
	    	        
	    	        checkInputs();
	    	        checkField($(this), value.length === 11);
	    	    });

	    	    // 인증번호 입력 제한 및 활성화 상태 설정, 거주 지역 필드 표시
	    	    $verifyInput.on('input', function() {
	    	        let value = $(this).val().replace(/[^0-9]/g, '');
	    	        if (value.length > 6) {
	    	            value = value.slice(0, 6);
	    	        }
	    	        $(this).val(value);
	    	        
	    	        if (value.length === 6) {
	    	            $verifyBox.addClass('active');
	    	            $locationInputBox.slideDown(300);
	    	        } else {
	    	            $verifyBox.removeClass('active');
	    	            $locationInputBox.slideUp(300);
	    	            $boardingInputBox.slideUp(300);
	    	        }
	    	        
	    	        checkInputs();
	    	        checkField($(this), value.length === 6);
	    	    });

	    	    // 거주 지역 입력 확인 및 탑승 장소 필드 표시
	    	    $locationInput.on('input', function() {
	    	        if ($(this).val().trim() !== '') {
	    	            $boardingInputBox.slideDown(300);
	    	        } else {
	    	            $boardingInputBox.slideUp(300);
	    	        }
	    	        checkInputs();
	    	        checkField($(this), $(this).val().trim() !== '');
	    	    });

	    	    // 탑승 장소 선택 확인
	    	    $boardingInputs.on('change', function() {
	    	        checkInputs();
	    	        checkField($boardingInputs, $boardingInputs.filter(':checked').length > 0);
	    	    });

	    	    // 입력 확인 및 버튼 활성화
	    	    function checkInputs() {
	    	        if ($nameInput.val().trim() !== '' &&
	    	            $birthInput.val().length === 6 &&
	    	            $genderInput.val().length === 1 &&
	    	            $phoneInput.val().length === 11 &&
	    	            $verifyInput.val().length === 6 &&
	    	            $locationInput.val().trim() !== '' &&
	    	            $boardingInputs.filter(':checked').length > 0) {
	    	            $nextButton.addClass('active');
	    	        } else {
	    	            $nextButton.removeClass('active');
	    	        }
	    	        updateProgressBar();
	    	    }

	    	    function updateProgressBar() {
	    	        const percentage = (filledFields / totalFields) * 100;
	    	        $progressBar.css('width', percentage + '%');
	    	    }

	    	    function checkField($field, condition) {
	    	        if (condition) {
	    	            if (!$field.data('filled')) {
	    	                $field.data('filled', true);
	    	                filledFields++;
	    	            }
	    	        } else {
	    	            if ($field.data('filled')) {
	    	                $field.data('filled', false);
	    	                filledFields--;
	    	            }
	    	        }
	    	        updateProgressBar();
	    	    }
	    	});
	    </script>	
    </body>
</html>
