<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

<!DOCTYPE html>
<html lang="ko">
	<c:import url="./header.jsp">
    	<c:param name="pageTitle" value="TABPATH"/>
    </c:import>
    
    <body class="sb-nav-fixed">
        <%@include file="./navigation.jsp" %>
        <div id="layoutSidenav">
	        <div id="layoutSidenav_nav">
				<%@include file="./gnb.jsp" %>
			</div>
			
			<div id="layoutSidenav_content">
				<main class="contents">
					<h2 class="contents-title">TAPPASS</h2>
					<div class="contents-box">
						<div class="card">
						    <div class="card-body">
							    <div class="search-form" style="justify-content: flex-start">
							    	<form action="" id="search_fm" name="search_fm" method="get" class="search-box" style="max-width:650px">
							    		<div style="position:relative">
									    	<input type="text" id="search_idx" name="search_idx" value="${pictVO.search_idx}" class="input" placeholder="바코드를 인식해주세요." autocomplete="off" onkeypress="if(event.keyCode == 13){search();return false;}">
									    	<button type="button" onclick="search();" class="btn"><i class="fa-solid fa-magnifying-glass"></i></button>
								    	</div>
								    	<!-- 
								    	<select id="bus" name="bus" style="width:250px; margin-left:65px" class="input opt-max-width-500">
								    		<c:forEach var="item" begin="1" end="45" step="1" varStatus="status">
												<option value="${status.index}" >${status.index}호차</option>
											</c:forEach>
										</select>
										 -->
							    	</form>
							    </div>
							    <div class="passContainer">
							    	<ul class="passItem">
							    		<li>
							    			<p>성명</p>
							    			<span id="name"></span>
							    		</li>
							    		<li>
							    			<p>연락처</p>
							    			<span id="mobile"></span>
							    		</li>
							    		<li>
							    			<p>생년월일</p>
							    			<span id="birthday"></span>
							    		</li>
							    		<li>
							    			<p>성별</p>
							    			<span id="birthday_1"></span>
							    		</li>
							    		<li>
							    			<p>버스(호차)</p>
							    			<span id="bus_text"></span>
							    		</li>
							    		<li>
							    			<p>버스(좌석)</p>
							    			<span id="seat"></span>
							    		</li>
									</ul>
							    	
									<button type="button" onclick="intros();" id="intro_btn" class="btn" style="display:none">입장</button>
				            	</div>
				            </div>
			            </div>
		            </div>
				</main>
			</div>
		</div>
		<script>
			$( document ).ready(function() {
				
				const url = new URL(window.location.href);
				const urlParams = url.searchParams;
				var bus = urlParams.get('bus')
				if(bus == '' || bus == null || bus == undefined){
					alert("버스 호차를 선택하지 않았습니다.\n탑승할 버스 파라미터를 추가해주세요.")
					window.location.href="/admin/intro_bus.do?bus=1"
				}
			    $('#search_idx').focus();

			});
			
			function search(){
				const url = new URL(window.location.href);
				const urlParams = url.searchParams;
				var bus = urlParams.get('bus')
				
				var param = {
					idx : $('#search_idx').val(),
					bus : bus
				}
				
				
				$.ajax({
					url: '/qr_insert.do'
					, type : "POST"
					, data : JSON.stringify(param)
					, contentType : "application/json"
					, dataType : "json"
					, async : true
					, success : function(result){
						console.log(result)
						if(result.text == "already"){
							alert("이미 버스좌석 배정을 받았습니다.")
							$('#name').text(result.rst.name)
							$('#mobile').text(result.rst.mobile)
							$('#birthday').text(result.rst.birthday)
							var gender = ""
							if(result.rst.birthday_1 == '1') gender ="남"
							if(result.rst.birthday_1 == '2') gender ="여"
							
							$('#birthday_1').text(gender)
							$('#bus_text').text(result.rst.bus + "호차")
							$('#seat').text(result.rst.seat + "번")
						}
						else if(result.text == "success"){
							$('#name').text(result.rst.name)
							$('#mobile').text(result.rst.mobile)
							$('#birthday').text(result.rst.birthday)
							var gender = ""
							if(result.rst.birthday_1 == '1') gender ="남"
							if(result.rst.birthday_1 == '2') gender ="여"
							
							$('#birthday_1').text(gender)
							$('#bus_text').text(result.rst.bus + "호차")
							$('#seat').text(result.rst.seat + "번")
							
							setTimeout(function(){
								alert("정상적으로 배차되었습니다.")
								window.location.reload()
							}, 200);
							
							
						}
						else if(result.text == "max"){
							alert("준비된 버스의 배차가 완료되었습니다.");
						}
						else{
							alert("오류가 발생했습니다.\n관리자에게 문의해주세요");
							window.location.reload(true);
						}
						
					},
					error : function(err){
						alert("오류가 발생했습니다.\n관리자에게 문의해주세요");
						console.log(err)
					}
				});
			}
			
		</script>
            
		<script src="../../../../../js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
		<script src="../../../../../js/scripts.js"></script>
		<script src="../../../../../js/Chart.min.js" crossorigin="anonymous"></script>
		<script src="../../../../../js/simple-datatables@latest.js" crossorigin="anonymous"></script>
		
    </body>
</html>
