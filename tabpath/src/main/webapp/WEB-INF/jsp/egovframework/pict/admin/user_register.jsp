<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
<c:import url="../main/header.jsp">
	<c:param name="pageTitle" value="사용자 등록" />
</c:import>

<body>
	<div class="wrapper">
		<form action="" id="register" name="register" method="post" enctype="multipart/form-data">
			<%@include file="../main/navigation.jsp"%>
			<main class="sub-container">
				<h3 class="contents-title">사용자 등록</h3>
    			<div class="board-write">
	    			<table>
	    				<colgroup>
	    					<col style="width:15%;">
	    					<col style="width:auto;">
	    				</colgroup>
						<tbody>
							<tr>
								<th class="title">이름*</th>
								<td>
									<input type="text" id="name" name="name" value="${pictVO.name}" class="board-write-input">
								</td>
							</tr>
							<tr>
								<th class="title">연락처*</th>
								<td>
									<input type="text" id="mobile" name="mobile" value="${pictVO.mobile}" class="board-write-input">
								</td>
							</tr>
							<tr>
								<th class="title">생년월일*</th>
								<td>
									<input type="text" id="birthday" name="birthday" value="${pictVO.birthday}" class="board-write-input">
									<input type="text" id="birthday_1" name="birthday_1" value="${pictVO.birthday_1}" class="board-write-input" maxlength="1">
								</td>
							</tr>
							<tr>
								<th class="title">버스(호차)</th>
								<td>
									<input type="text" id="bus" name="bus" value="${pictVO.bus}" class="board-write-input">
								</td>
							</tr>
							<tr>
								<th class="title">좌석번호</th>
								<td>
									<input type="text" id="seat" name="seat" value="${pictVO.seat}" class="board-write-input">
								</td>
							</tr>
							
						</tbody>
					</table>
				</div>
				<div class="board-write-btn">
					<c:if test="${pictVO.saveType eq 'update'}">
						<button type="button" onclick="javascript:board_delete()" class="btn-basic btn-default">삭제</button>
					</c:if>
		            <button type="button" onclick="button1_click();" class="btn-basic btn-primary">
						<c:if test="${pictVO.saveType eq 'insert'}">등록</c:if>
						<c:if test="${pictVO.saveType ne 'insert'}">수정</c:if>
					</button>
		        	<button type="button" onclick="javascript:board_list()" class="btn-basic btn-outline">목록보기</button>    
	            </div>
			</main>
			<input type='hidden' name="saveType" id="saveType" value='${pictVO.saveType}' /> 
			<input type='hidden' name="idx" id="idx" value='${pictVO.idx}' /> 
			<input type='hidden' name="use_at" id="use_at" value='${pictVO.use_at}' />
			<input type="hidden" name="fairpath_id" id="fairpath_id" value="${pictVO.fairpath_id }">
		</form>
	</div>

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