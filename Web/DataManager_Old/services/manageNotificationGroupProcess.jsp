<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sAction = request.getParameter("mode");
	String sErr = "";
	
	try
	{
		String sName = request.getParameter("name");
		String sNotifyFirst = request.getParameter("notifyFirst");
		String sNotifySecond = request.getParameter("notifySecond");
		String sNotifyThird = request.getParameter("notifyThird");
		String firstDuration = request.getParameter("firstLevelDuration");
		String secondDuration = request.getParameter("secondLevelDuration");
		String thirdDuration = request.getParameter("thirdLevelDuration");

		Map<String, String> mNotificationGroup = new HashMap<String, String>();
		mNotificationGroup.put(RDMServicesConstants.ALARM_GROUP, sName);
		mNotificationGroup.put(RDMServicesConstants.NOTIFY_LEVEL1, sNotifyFirst);
		mNotificationGroup.put(RDMServicesConstants.NOTIFY_LEVEL2, sNotifySecond);
		mNotificationGroup.put(RDMServicesConstants.NOTIFY_LEVEL3, sNotifyThird);
		mNotificationGroup.put(RDMServicesConstants.LEVEL1_ATTEMPTS, firstDuration);
		mNotificationGroup.put(RDMServicesConstants.LEVEL2_ATTEMPTS, secondDuration);
		mNotificationGroup.put(RDMServicesConstants.LEVEL3_ATTEMPTS, thirdDuration);
		
		if("add".equals(sAction))
		{
			RDMServicesUtils.addNotificationGroup(mNotificationGroup);
		}
		else if("edit".equals(sAction))
		{
			RDMServicesUtils.updateNotificationGroup(mNotificationGroup);
		}
		else if("delete".equals(sAction))
		{
			RDMServicesUtils.deleteNotificationGroup(sName);
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