<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<html>
	<frameset cols="99%,1%" frameborder="0">
		<frameset cols="30%,70%" frameborder="0">
			<frame name="filter" src="alarmFilters.jsp" />
			<frame name="results" src="alarmResults.jsp" />
		</frameset>
		<frame name="hidden" src="blank.jsp" />
	</frameset>
</html>