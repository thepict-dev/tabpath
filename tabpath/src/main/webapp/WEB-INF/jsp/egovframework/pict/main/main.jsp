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
	    <div class="container">
	        <h1>
	            <a href="/"><img src="/user_img/logo.png" alt=""></a>
	            <p>한번의 TAP으로 한번에 PASS!</p>
	        </h1>
	        <div class="loginBottom">
	            <div class="buttonContainer login">
	                <a href="/login.do" class="bk">로그인</a>
	                <a href="/apply.do" class="bl">사전인증하기</a>
	            </div>
	            <div class="personInfo">
	                <p>로그인하시면 아래 내용에 동의하는 것으로 간주됩니다</p>
	                <div class="personDesc">
	                    <a href="#lnk">개인정보처리방침</a>
	                    <a href="#lnk">이용약관</a>
	                </div>
	            </div>
	        </div>
	    </div>
    </body>
</html>
