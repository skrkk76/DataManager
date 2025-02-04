<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.notify.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sAction = request.getParameter("mode");
	String sErr = "";
	
	try
	{
		String sCntrlType = request.getParameter("cntrlType");
		String sAlarm = request.getParameter("alarm");
		NotifyAlarms notifyAlarms = new NotifyAlarms();

		if("delete".equals(sAction))
		{
			notifyAlarms.deleteNotificationAlarm(sAlarm, sCntrlType);
		}
		else
		{
			String sNotifyBy = request.getParameter("notifyBy");
			String sNotifyDuration = request.getParameter("notifyDuration");
			String sGroup = request.getParameter("group");
			int iNotifyDuration = Integer.parseInt(sNotifyDuration);
			
			if("add".equals(sAction))
			{
				notifyAlarms.addNotificationAlarm(sAlarm, sCntrlType, sNotifyBy, sGroup, iNotifyDuration);
			}
			else if("edit".equals(sAction))
			{
				notifyAlarms.updateNotificationAlarm(sAlarm, sCntrlType, sNotifyBy, sGroup, iNotifyDuration);
			}
		}
	}
	catch(Exception e)
	{
		sErr = e.getMessage();
		sErr = (sErr == null ? "null" : sErr.replaceAll("\"", "'").replaceAll("\r", " ").replaceAll("\n", " "));
	}
%>

	<script>
		var sErr = "<%= sErr %>";
		var mode = "<%= sAction %>";
		if(sErr != "")
		{
			alert("Error: "+sErr);
			history.back(-1);
		}
		else
		{	
			if(mode == "add" || mode == "edit")
			{
				top.opener.document.location.href = top.opener.document.location.href;
				window.close();
			}
			else
			{				
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
		
	</script>

</html>