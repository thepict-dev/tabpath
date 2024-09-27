<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>



<!DOCTYPE html>
<html lang="ko">
	<c:import url="../admin/header.jsp">
    	<c:param name="pageTitle" value="사용자 리스트"/>
    </c:import>
    <style type="text/css">
		.paginations{
		    display: flex;
   			justify-content: center;
		    column-gap: 5px;
		    width: 100%;
		    max-width: 513px;
		    margin: 0 auto;
		    padding: 25px 0 30px 0;
		}
		.paginations li{
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    width: 32px;
		    height: 32px;
		    border-radius: 8px;
		    border: 1px solid #F1F1F1;
		    font-size: 13px;
		    font-weight: 600;
		    font-family: var(--fn-open);
		}
		.paginations li.cut{
		    border: 0;
		}
		.paginations li a{
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    width: 100%;
		    height: 100%;
		    color: #333;
		    border-radius: 8px;
		    text-decoration: none;
		}
		.paginations li.active a{
		    color: #fff;
		    background-color: #0575E6;
		}
	</style>
    <body class="sb-nav-fixed">
        <%@include file="./navigation.jsp" %>
        <div id="layoutSidenav">
	        <div id="layoutSidenav_nav">
				<%@include file="./gnb.jsp" %>
			</div>
			
			<div id="layoutSidenav_content">
				<main class="contents">
					<h2 class="contents-title">사용자 리스트</h2>
					<div class="contents-box">
						<div class="card">
						    <div class="card-body">
							    <div class="search-form">
							    	<form action="" id="search_fm" name="search_fm" method="get" class="search-box" style="max-width:500px">
							    		<input type="text" id="search_text" name="search_text" value="${pictVO.search_text}" class="input" placeholder="이름 혹은 연락처로 검색하세요." autocomplete="off" onkeypress="if(event.keyCode == 13){search();}">
								    	<button type="button" onclick="search();" class="btn"><i class="fa-solid fa-magnifying-glass"></i></button>
							    	</form>
							    </div>
						    	<div class="tbl-basic tbl-hover">
							        <table style="text-align : left">
							        	<colgroup>
							        		<col style="width:10%;">
							        		<col style="width:10%;">
							        		<col style="width:10%;">
							        		<col style="width:10%;">
							        		<col style="width:10%;">
							        		<col style="width:10%;">
							        		<col style="width:10%;">
							        		<col style="width:20%;">
							        		<col style="width:10%;">
							        	</colgroup>
							            <thead>
							                <tr class="thead">
							                    <th>순서</th>
							                    <th>이름</th>
							                    <th>연락처</th>
							                    <th>생년월일</th>
							                    <th>성별</th>
							                    <th>버스좌석</th>
							                    <th>탑승장소</th>
							                    <th>거주지역</th>
							                    <th>상태</th>
							                </tr>
							            </thead>
							            <tbody>
								            <c:forEach var="resultList" items="${resultList}" varStatus="status">
								                <tr>
							                    	
						                    		<c:if test="${pictVO.pageNumber eq 1}">
														<td>${board_cnt - status.index}</td>					
													</c:if>
													<c:if test="${pictVO.pageNumber ne 1}">
														<td>${board_cnt - (status.index +  ((pictVO.pageNumber - 1) * 20))}</td>
													</c:if>
													
							                    	<td class="opt-tl"><a href="javascript:void(0);" onclick="board_mod('${resultList.idx}');" class="link">${resultList.name}</a></td>
							                    	<td>${resultList.mobile}</td>
							                    	<td>${resultList.birthday}</td>
							                    	<td>
							                    		<c:if test="${resultList.birthday_1 eq '1'}">남자</c:if>
							                    		<c:if test="${resultList.birthday_1 eq '2'}">여자</c:if>
						                    		</td>
							                    	<td>
							                    		<c:if test="${resultList.bus ne '' && resultList.bus ne null && resultList.bus ne undefined && resultList.seat ne '' && resultList.seat ne null && resultList.seat ne undefined}">
							                    			${resultList.bus}호차 ${resultList.seat}번
							                    		</c:if>
						                    		</td>
						                    		<td>
						                    			<c:if test="${resultList.boarding eq '1'}">종합운동장</c:if>
						                    			<c:if test="${resultList.boarding eq '2'}">국토정중앙면</c:if>
						                    			<c:if test="${resultList.boarding eq '3'}">동면</c:if>
						                    			<c:if test="${resultList.boarding eq '4'}">방산</c:if>
						                    			<c:if test="${resultList.boarding eq '5'}">해안면</c:if>
					                    			</td>
						                    		<td>${resultList.location}</td>
							                    	<td>
							                    		<c:if test="${resultList.use_at eq 'Y'}"><span style="color : blue">승인</span></c:if>
							                    		<c:if test="${resultList.use_at ne 'Y'}"><span style="color : red">취소</span></c:if>
													</td>
								                </tr>
							                </c:forEach>
							            </tbody>
						            </table>
				            	</div>
				            </div>
				            <ul class="paginations">
								<c:if test="${pictVO.pageNumber ne 1}">
									<li><a href="/admin/user_list.do?search_text=${pictVO.search_text}&pageNumber=1"><img src="/img/First.png" alt=""></a></li>
									<li><a href="/admin/user_list.do?search_text=${pictVO.search_text}&pageNumber=${pictVO.pageNumber - 10 < 1 ? 1 : pictVO.pageNumber - 10}"><img src="/img/Prev.png" alt=""></a></li>
								</c:if>	
							
								<c:forEach var="i" begin="${pictVO.startPage}" end="${pictVO.endPage}">
									<c:if test="${i eq pictVO.pageNumber}">
										<li class="active"><a href="/user_list.do?search_text=${pictVO.search_text}&pageNumber=${i}" >${i}</a></li>
									</c:if>
									<c:if test="${i ne pictVO.pageNumber}">
										<li><a href="/admin/user_list.do?search_text=${pictVO.search_text}&pageNumber=${i}" >${i}</a></li>
									</c:if>
								</c:forEach>	
						
								<c:if test="${pictVO.lastPage ne pictVO.pageNumber}">
									<li><a href="/admin/user_list.do?search_text=${pictVO.search_text}&pageNumber=${pictVO.pageNumber + 10 > pictVO.lastPage ?  pictVO.lastPage : pictVO.pageNumber + 10}"><img src="/img/Next.png" alt=""></a></li>
									<li><a href="/admin/user_list.do?search_text=${pictVO.search_text}&pageNumber=${pictVO.lastPage}"><img src="/img/Last.png" alt=""></a></li>
								</c:if>
							</ul>
			            </div>
		            </div>
				</main>
			</div>
			<form action="" id="register" name="register" method="post" enctype="multipart/form-data">
				<input type="hidden" name="idx" id="idx" value="" />
			</form>
		</div>
		<script>

			function board_mod(idx){
				location.href= "/admin/user_register.do?idx="+idx;
			}		
			function board_insert(){
				location.href= "/admin/user_register.do";
			}		
			function search(){
				$("#search_fm").attr("action", "/admin/user_list.do");
				$("#search_fm").submit();
			}
		</script>
            
		<script src="../../../../../js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
		<script src="../../../../../js/scripts.js"></script>
		<script src="../../../../../js/Chart.min.js" crossorigin="anonymous"></script>
		<script src="../../../../../js/simple-datatables@latest.js" crossorigin="anonymous"></script>
		
    </body>
</html>