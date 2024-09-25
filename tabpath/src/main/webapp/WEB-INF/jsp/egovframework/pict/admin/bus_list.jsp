<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>



<!DOCTYPE html>
<html lang="ko">
	<c:import url="../admin/header.jsp">
    	<c:param name="pageTitle" value="버스탑승 리스트"/>
    </c:import>
    
    <body class="sb-nav-fixed">
        <%@include file="./navigation.jsp" %>
        <div id="layoutSidenav">
	        <div id="layoutSidenav_nav">
				<%@include file="./gnb.jsp" %>
			</div>
			
			<div id="layoutSidenav_content">
				<main class="contents">
					<h2 class="contents-title">버스탑승 리스트</h2>
					<div class="contents-box">
						<div class="card">
						    <div class="card-body">
							    <div class="search-form">
							    	<form action="" id="search_fm" name="search_fm" method="get" class="search-box">
								    	<select id="bus" name="bus" style="width:250px; margin-left:65px" class="input opt-max-width-500">
											<option value="1" <c:if test="${pictVO.bus eq '1'}">selected</c:if>>1호차</option>
	                    					<option value="2" <c:if test="${pictVO.bus eq '2'}">selected</c:if>>2호차</option>
										</select>
								    	
							    	</form>
							    </div>
						    	<div class="tbl-basic tbl-hover">
							        <table style="text-align : left">
							        	<colgroup>
							        		<col style="width:10%;">
							        		<col style="width:10%;">
							        		<col style="width:15%;">
							        		<col style="width:10%;">
							        		<col style="width:15%;">
							        		<col style="width:15%;">
							        	</colgroup>
							            <thead>
							                <tr class="thead">
							                    <th>순서</th>
							                    <th>이름</th>
							                    <th>연락처</th>
							                    <th>생년월일</th>
							                    <th>성별</th>
							                    <th>좌석</th>
							                </tr>
							            </thead>
							            <tbody>
								            <c:forEach var="resultList" items="${resultList}" varStatus="status">
								                <tr>
							                    	<td>${status.count}</td>
							                    	<td>${resultList.name}</td>
							                    	<td>${resultList.mobile}</td>
							                    	<td>${resultList.birthday}</td>
							                    	<td>
							                    		<c:if test="${resultList.birthday_1 eq '1'}">남</c:if>
							                    		<c:if test="${resultList.birthday_1 eq '2'}">여</c:if>
						                    		</td>
							                    	<td>${resultList.seat}</td>
								                </tr>
							                </c:forEach>
							            </tbody>
						            </table>
				            	</div>
				            </div>
			            </div>
		            </div>
				</main>
			</div>
			<form action="" id="register" name="register" method="post" enctype="multipart/form-data">
				<input type="hidden" name="idx" id="idx" value="" />
			</form>
		</div>
		<script>
			$('#bus').on('change', function() {
				$("#search_fm").attr("action", "/admin/bus_list.do");
				$("#search_fm").submit();
	        });
			function search(){
				$("#search_fm").attr("action", "/admin/bus_list.do");
				$("#search_fm").submit();
			}
		</script>
            
		<script src="../../../../../js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
		<script src="../../../../../js/scripts.js"></script>
		<script src="../../../../../js/Chart.min.js" crossorigin="anonymous"></script>
		<script src="../../../../../js/simple-datatables@latest.js" crossorigin="anonymous"></script>
		
    </body>
</html>