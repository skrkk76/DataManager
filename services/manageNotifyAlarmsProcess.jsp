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
			String sNotifyFirst = request.getParameter("notifyFirst");
			String sNotifySecond = request.getParameter("notifySecond");
			String firstDuration = request.getParameter("firstLevelDuration");
			String secondDuration = request.getParameter("secondLevelDuration");
			String notifyDuration = request.getParameter("notifyDuration");
			int iFirstDuration = Integer.parseInt(firstDuration);
			int iSecondDuration = Integer.parseInt(secondDuration);
			int iNotifyDuration = Integer.parseInt(notifyDuration);
			
			if("add".equals(sAction))
			{
				notifyAlarms.addNotificationAlarm(sAlarm, sCntrlType, sNotifyBy, sNotifyFirst, iFirstDuration, sNotifySecond, iSecondDuration, iNotifyDuration);
			}
			else if("edit".equals(sAction))
			{
				notifyAlarms.updateNotificationAlarm(sAlarm, sCntrlType, sNotifyBy, sNotifyFirst, iFirstDuration, sNotifySecond, iSecondDuration, iNotifyDuration);
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