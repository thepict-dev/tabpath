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
    
   	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jQuery.print/1.6.0/jQuery.print.min.js"></script>
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
							    	<form action="" id="search_fm" name="search_fm" method="get" class="search-box" style="display:flex; column-gap: 10px;">
								    	<select id="bus" name="bus" style="width:250px; margin-left:65px" class="input opt-max-width-500">
								    		<c:forEach var="item" begin="1" end="50" step="1" varStatus="status">
												<option value="${status.index}" <c:if test="${pictVO.bus eq item}">selected</c:if>>${status.index}호차</option>
											</c:forEach>
	                    					
										</select>
    									<button class="print-btn no-print" style="display:flex; align-items:center; justify-content: center; width:160px; border: 1px solid #dddfe1; border-radius: 4px;">인쇄</button>
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
		function printCardBody() {
		    // 프린트 스타일 정의
		    var style = `
		        <style>
		            @media print {
		                @page {
		                    size: A4;
		                    margin: 0;
		                }
		                body {
		                    font-size: 10pt;
		                    width: 190mm;
		                    height: 277mm;
		                    margin: 0 auto;
		                } 
		                .print-btn{ display: none; }
		                table {
		                    border-collapse: collapse;
		                    width: 100%;
		                    page-break-inside: auto;
		                }
		                tr { page-break-inside: avoid; page-break-after: auto; }
		                .tbl-basic .thead th, .tbl-basic .thead td {
		                    padding: 4px 15px;
		                    color: #000;
		                    font-weight: 500;
		                }
		                .tbl-basic th, .tbl-basic td {
		                    padding: 4px 15px;
			                color: #000;
			            }
		                thead { display: table-header-group; }
		                .tbl-basic { overflow-x: hidden; }
		            }
		        </style>
		    `;

		    // 프린트 옵션 설정
		    var options = {
		        globalStyles: true,
		        mediaPrint: false,
		        stylesheet: null,
		        noPrintSelector: ".no-print",
		        iframe: true,
		        append: style,
		        manuallyCopyFormValues: true,
		        deferred: $.Deferred(),
		        timeout: 750,
		        title: null,
		        doctype: '<!doctype html>'
		    };

		    // 프린트 실행
		    $(".card-body").print(options);
		}

		// 프린트 버튼에 이벤트 리스너 추가
		$(document).ready(function() {
		    $(".print-btn").on("click", function(e) {
		        e.preventDefault();
		        printCardBody();
		    });
		});
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