<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>



<script type="text/javascript">

	<c:if test="${retType eq ':none'}">
		alert("${fn:replace(message, '<br>', '\\n')}");
	</c:if>
</script>