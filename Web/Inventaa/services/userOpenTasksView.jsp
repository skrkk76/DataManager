<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<%
String sUserId = request.getParameter("userId");
%>

<html>
	<frameset rows="99%,1%" frameborder="0">
		<frame name="content" src="userOpenTasks.jsp?userId=<%= sUserId %>" />
		<frame name="hiddenFrame" src="blank.jsp" />
	</frameset>
</html>