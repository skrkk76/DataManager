<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sTaskId = request.getParameter("taskId");
%>
<html>
	<frameset rows="99%,1%" frameborder="0">
		<frame name="content" src="userTaskDeliverables.jsp?taskId=<%= sTaskId %>" />
		<frame name="hiddenFrame" src="blank.jsp" />
	</frameset>
</html>