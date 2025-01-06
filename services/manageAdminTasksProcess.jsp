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
		String sTaskId = request.getParameter("taskId");
		String sTaskName = request.getParameter("taskName");
		String sDuration = request.getParameter("duration");
		sDuration = ("".equals(sDuration) ? "0" : sDuration);
		String[] saTaskAttrs = request.getParameterValues("taskAttrs");
		String[] saTaskDepts = request.getParameterValues("taskDepts");
		String sProductivityView = request.getParameter("productivityView");
		sProductivityView = (sProductivityView == null ? "FALSE" : sProductivityView);
		
		String sTaskAttrs = "";		
		if(saTaskAttrs != null)
		{
			for(int i=0; i<saTaskAttrs.length; i++)
			{
				if(i > 0)
				{
					sTaskAttrs += "|";
				}
				sTaskAttrs += saTaskAttrs[i];
			}
		}
		
		String sTaskDepts = "";		
		if(saTaskDepts != null)
		{
			for(int i=0; i<saTaskDepts.length; i++)
			{
				if(i > 0)
				{
					sTaskDepts += "|";
				}
				sTaskDepts += saTaskDepts[i];
			}
		}
		
		Map<String, String> mInfo = new HashMap<String, String>();
		mInfo.put(RDMServicesConstants.TASK_ID, sTaskId);
		mInfo.put(RDMServicesConstants.TASK_NAME, sTaskName);
		mInfo.put(RDMServicesConstants.TASK_ATTRIBUTES, sTaskAttrs);
		mInfo.put(RDMServicesConstants.DEPARTMENT_NAME, sTaskDepts);
		mInfo.put(RDMServicesConstants.DURATION_ALERT, sDuration);
		mInfo.put(RDMServicesConstants.PRODUCTIVITY_TASK, sProductivityView);		

		if("add".equals(sAction))
		{
			RDMServicesUtils.addAdminTask(mInfo);
		}
		else if("edit".equals(sAction))
		{
			RDMServicesUtils.updateAdminTask(mInfo);
		}
		else if("delete".equals(sAction))
		{
			RDMServicesUtils.deleteAdminTask(sTaskId);
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