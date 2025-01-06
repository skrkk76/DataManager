<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sTaskId = request.getParameter("taskId");
	String sTaskAdmId = request.getParameter("taskAdmId");
	String sDeliverableId = request.getParameter("deliverableId");
	String sRoom = request.getParameter("room");
%>
<html>
	<frameset rows="99%,1%" frameborder="0">
		<frame name="content" src="manageTaskDeliverable.jsp?taskId=<%= sTaskId %>&taskAdmId=<%= sTaskAdmId %>&deliverableId=<%= sDeliverableId %>&room=<%= sRoom %>" />
		<frame name="hiddenFrame" src="blank.jsp" />
	</frameset>
</html>