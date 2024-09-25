<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<c:import url="../admin/header.jsp">
	<c:param name="pageTitle" value="사용자 리스트"/>
</c:import>
<body class="sb-nav-fixed">
	<form action="" id="register" name="register" method="post" enctype="multipart/form-data">
		<%@include file="./navigation.jsp"%>
		<div id="layoutSidenav">
			<div id="layoutSidenav_nav">
				<%@include file="./gnb.jsp"%>
			</div>
			<div id="layoutSidenav_content">
				<main class="contents">
					<h2 class="contents-title">사용자 등록</h2>
					<div class="contents-box" style="position:relative">
						<div class="card">
							<div class="card-body">
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">이름</label>
										<div class="input-box">
											<input type="text" id="name" name="name" value="${pictVO.name}" class="input opt-max-width-500">
										</div>
									</div>
								</div>
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">휴대전화번호</label>
										<div class="input-box">
											<input type="text" id="mobile" name="mobile" value="${pictVO.mobile}" class="input opt-max-width-500">
										</div>
									</div>
								</div>
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">생년월일</label>
										<div class="input-box">
											<input type="text" id="birthday" name="birthday" value="${pictVO.birthday}" class="input opt-max-width-500">
										</div>
									</div>
								</div>
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">성별</label>
										<div class="input-box">
											<select id="birthday_1" name="birthday_1" style="width:250px;">
												<option value="1" <c:if test="${pictVO.birthday_1 eq '1'}">selected</c:if> >남자</option>
		                    					<option value="2" <c:if test="${pictVO.birthday_1 eq '2'}">selected</c:if>>여자</option>
											</select>
										</div>
									</div>
								</div>
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">버스(호차)</label>
										<div class="input-box">
											<input type="text" id="bus" name="bus" value="${pictVO.bus}" class="input opt-max-width-500">
										</div>
									</div>
								</div>
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">버스(좌석)</label>
										<div class="input-box">
											<input type="text" id="seat" name="seat" value="${pictVO.seat}" class="input opt-max-width-500">
										</div>
									</div>
								</div>
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">상태</label>
										<div class="input-box">
											<select id="use_at" name="use_at" style="width:250px;">
												<option value="Y" <c:if test="${pictVO.use_at eq 'Y'}">selected</c:if> >승인</option>
		                    					<option value="C" <c:if test="${pictVO.use_at eq 'C'}">selected</c:if>>취소</option>
											</select>
										</div>
									</div>
								</div>
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">거주지역</label>
										<div class="input-box">
											<input type="text" id="location" name="location" value="${pictVO.location}" class="input opt-max-width-500">
										</div>
									</div>
								</div>
								<div class="write-box">
									<div class="write-item">
										<label for="title" class="title">탑승 장소</label>
										<div class="input-box">
											<select id="boarding" name="boarding" style="width:250px;">
												<option value="1" <c:if test="${pictVO.boarding eq '1'}">selected</c:if> >종합운동장</option>
		                    					<option value="2" <c:if test="${pictVO.boarding eq '2'}">selected</c:if>>국토정중앙면</option>
		                    					<option value="3" <c:if test="${pictVO.boarding eq '3'}">selected</c:if>>동면</option>
		                    					<option value="4" <c:if test="${pictVO.boarding eq '4'}">selected</c:if>>방산</option>
		                    					<option value="5" <c:if test="${pictVO.boarding eq '5'}">selected</c:if>>해안면</option>
											</select>
										</div>
									</div>
								</div>
								<div class="btn-box">
									<c:if test="${pictVO.saveType eq 'insert'}">
										<button type="button" onclick="button1_click();" class="btn-basic btn-primary btn-sm">등록</button>
									</c:if>
									<c:if test="${pictVO.saveType ne 'insert'}">
										<button type="button" onclick="button1_click();" class="btn-basic btn-primary btn-sm">수정</button>
									</c:if>
						        	<button type="button" onclick="javascript:popup_list();" class="btn-basic btn-common btn-sm">목록보기</button>    
					            </div>
							</div>
						</div>
						
		            </div>
		            
				</main>
			</div>
		</div>
		<input type='hidden' name="saveType" id="saveType" value='${pictVO.saveType}' /> 
		<input type='hidden' name="idx" id="idx" value='${pictVO.idx}' /> 
		<input type="hidden" name="fairpath_id" id="fairpath_id" value="${pictVO.fairpath_id}">
	</form>

	<script>
		function board_delete() {
			if (confirm("삭제 하시겠습니까?")) {
				$("#register").attr("action", "/admin/user_delete.do");
				$("#register").submit();
			}
			
		}
		function board_list() {
			location.href = "/admin/user_list.do";
		}
		function button1_click() {
			var name = $('#name').val();
			var mobile = $('#mobile').val();
			var name = $('#name').val();
			
			var saveType = $('#saveType').val();
			
			if (name == "" || name == undefined) {
				window.alert("이름을 입력해주세요.");
				$('#name').focus();
				return false;
			}
			if (mobile == "" || mobile == undefined) {
				window.alert("연락처를 입력해주세요.");
				$('#mobile').focus();
				return false;
			}

			if (name == "" || name == undefined) {
				window.alert("이름을 입력해주세요.");
				$('#name').focus();
				return false;
			}
			if (name == "" || name == undefined) {
				window.alert("이름을 입력해주세요.");
				$('#name').focus();
				return false;
			}
			if (name == "" || name == undefined) {
				window.alert("이름을 입력해주세요.");
				$('#name').focus();
				return false;
			}

			var text = "등록하시겠습니까?";
			if (saveType == 'update') {
				text = "수정하시겠습니까?"
			}
			if (confirm(text)) {
				$("#register").attr("action", "/admin/user_save.do");
				$("#register").submit();
			}
		}
		
	</script>

	<script src="../../../../../js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
	<script src="../../../../../js/scripts.js"></script>
	<script src="../../../../../js/Chart.min.js" crossorigin="anonymous"></script>
	<script src="../../../../../js/simple-datatables@latest.js" crossorigin="anonymous"></script>

</body>
</html>