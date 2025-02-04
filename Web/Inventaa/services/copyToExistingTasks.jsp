<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.db.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<%
String sUserTaskId = request.getParameter("taskId");
String sRoom = request.getParameter("room");
String sAdminTaskId = request.getParameter("adminTaskId");
String sOwner = request.getParameter("owner");
String sAssignee = request.getParameter("assignee");

UserTasks userTasks = new UserTasks();
MapList mlTasks = userTasks.moveToUserTasks(sRoom, sAdminTaskId, sOwner, sAssignee);	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />

	<script language="javascript">
	function submitForm()
	{
		var task = "";
		var taskId = document.getElementsByName('taskId');
		for(i=0; i<taskId.length; i++)
		{
			if(taskId[i].checked)
			{
				task = taskId[i].value;
			}		
		}

		if(task == "")
		{
			alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Move_Task") %>");
		}
		else
		{
			document.location.href = 'manageUserTaskProcess.jsp?taskId='+task+'&srcTaskId=<%= sUserTaskId %>&mode=moveToExisting';
		}
	}

	function previous()
	{
		document.location.href = "moveTaskDeliverables.jsp?UserTaskId=<%= sUserTaskId %>&prev=true";
	}	
	</script>
</head>

<body>
	<table border="0" cellpadding="0" align="center" cellspacing="0" width="100%">
		<tr>
			<th class="label" width="3%">&nbsp;</th>
			<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Name") %></th>
			<th class="label" width="19%"><%= resourceBundle.getProperty("DataManager.DisplayText.Estimated_Start") %></th>
			<th class="label" width="19%"><%= resourceBundle.getProperty("DataManager.DisplayText.Estimated_End") %></th>
			<th class="label" width="19%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actual_Start") %></th>
		</tr>
<%
		int iSz = mlTasks.size();
		String sTaskId = null;
		Map<String, String> mTask = null;
		if(iSz > 0)
		{
			for(int i=0; i<mlTasks.size(); i++)
			{
				mTask = mlTasks.get(i);
				sTaskId = mTask.get(RDMServicesConstants.TASK_AUTONAME);
				if(!sTaskId.equals(sUserTaskId))
				{
%>
					<tr>
						<td class="input"><input type="radio" id="taskId" name="taskId" value="<%= sTaskId %>" <%= sTaskId.equals(sUserTaskId) ? "disabled" : "" %>></td>
						<td class="input"><%= sTaskId %></td>							
						<td class="input"><%= mTask.get(RDMServicesConstants.ESTIMATED_START) %></td>
						<td class="input"><%= mTask.get(RDMServicesConstants.ESTIMATED_END) %></td>
						<td class="input"><%= mTask.get(RDMServicesConstants.ACTUAL_START) %></td>
					<tr>
<%
				}
			}
		}
		else
		{
%>
			<tr>
				<td class="input" style="text-align:center" colspan="14">
					<%= resourceBundle.getProperty("DataManager.DisplayText.No_User_Tasks") %>
				</td>
			</tr>
<%
		}
		
%>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="5" align="right">
				<input type="button" name="Prev" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Prev") %>" onClick="previous()">&nbsp;
				<input type="button" name="Next" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Submit") %>" onClick="submitForm()">&nbsp;
				<input type="button" name="Cancel" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Cancel") %>" onClick="javascript:top.window.close()">
			</td>
		</tr>
	</table>
</body>
</html>
