<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<html>
	<frameset cols="30%,70%" frameborder="0">
		<frame name="filter" src="logFilters.jsp" />
		<frame name="results" src="logResults.jsp" />
	</frameset>
</html>