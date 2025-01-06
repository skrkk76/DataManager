<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<%
String sParentTask = request.getParameter("parentTask");
sParentTask = (sParentTask == null ? "" : sParentTask);
%>

<html>
	<frameset cols="99%,1%" frameborder="0">
		<frame name="content" src="addUserTask.jsp?parentTask=<%= sParentTask %>" />
		<frame name="hidden" src="blank.jsp" />
	</frameset>
</html>