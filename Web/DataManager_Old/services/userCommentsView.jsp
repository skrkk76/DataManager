<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<html>
	<frameset cols="99%,1%" frameborder="0">
		<frameset cols="20%,80%" frameborder="0">
			<frame name="filter" src="userCommentsFilter.jsp" />
			<frame name="results" src="userCommentsResult.jsp" />
		</frameset>
		<frame name="hiddenFrame" src="blank.jsp" />
	</frameset>
</html>