<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<html>
	<frameset cols="99%,1%" frameborder="0">
		<frameset cols="20%,80%" frameborder="0">
			<frame name="filter" src="viewYieldsFilter.jsp" />
			<frame name="results" src="viewYieldsResult.jsp" />
		</frameset>
		<frame name="hiddenFrame" src="blank.jsp" />
</html>