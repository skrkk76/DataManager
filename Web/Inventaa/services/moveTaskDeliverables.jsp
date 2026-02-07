<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sParam = null;
	StringList slDeliverableIds = new StringList();

	String sTaskId = request.getParameter("UserTaskId");
	String sPrev = request.getParameter("prev");
	
	if(sPrev == null || "".equals(sPrev))
	{
		Enumeration<String> eParams = request.getParameterNames();
		while(eParams.hasMoreElements())
		{
			sParam = eParams.nextElement();
			if(!"chk_all".equals(sParam) && "Y".equalsIgnoreCase(request.getParameter(sParam)))
			{
				slDeliverableIds.add(sParam);
			}
		}
		
		session.setAttribute("DeliverableIds", slDeliverableIds);
	}

	UserTasks userTasks = new UserTasks();
	Map<String, String> mTaskInfo = userTasks.userTaskDetails(sTaskId);
	String sRoom = mTaskInfo.get(RDMServicesConstants.ROOM_ID);
	sRoom = ((sRoom == null) ? "" : sRoom);
	String sOwner = mTaskInfo.get(RDMServicesConstants.OWNER);
	String sAssignee = mTaskInfo.get(RDMServicesConstants.ASSIGNEE);
	String sTaskAdmId = mTaskInfo.get(RDMServicesConstants.TASK_ID);
	
	Map<String, String> mAdmTaskInfo = RDMServicesUtils.getAdminTask(sTaskAdmId);
	String sTaskDept = mAdmTaskInfo.get(RDMServicesConstants.DEPARTMENT_NAME);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<link type="text/css" href="../styles/select2.min.css" rel="stylesheet" />

	<script language="javaScript" type="text/javascript" src="../scripts/jquery.min.js"></script>
	<script language="javaScript" type="text/javascript" src="../scripts/select2.full.js"></script>
	<script language="javaScript" type="text/javascript" src="../scripts/bootstrap.min.js"></script>
	<script type="text/javascript">
		//<![CDATA[
		$(document).ready(function(){
			$(".js-example-basic-multiple").select2();
		});
		//]]>
	</script>

	<script language="javascript">
	function submitForm()
	{
		var task = "";
		var taskType = document.getElementsByName('task');
		for(i=0; i<taskType.length; i++)
		{
			if(taskType[i].checked)
			{
				task = taskType[i].value;
			}		
		}

		if(task == "")
		{
			alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Task_to_Move") %>");
		}
		else
		{
			if(task == "New")
			{
				document.location.href = 'copyUserTasks.jsp?taskId=<%= sTaskId %>&mode=moveToNew';
			}
			else
			{
				var room = document.getElementById('room').value;
				var owner = document.getElementById('owner').value;
				var assignee = document.getElementById('assignee').value;

				document.location.href = 'copyToExistingTasks.jsp?taskId=<%= sTaskId %>&room='+room+'&adminTaskId=<%= sTaskAdmId %>&owner='+owner+'&assignee='+assignee;
			}
		}
	}
	
	function toggle(arg)
	{
		var fg = true;
		if(arg == "old")
		{
			fg = false;
		}
		
		document.getElementById('room').disabled = fg;
		document.getElementById('owner').disabled = fg;
		document.getElementById('assignee').disabled = fg;
	}
	</script>
</head>
<body onLoad="javascript:toggle('')">
	<table border="0" cellpadding="1" cellspacing="1" width="100%">
		<tr>
			<td align="center" style="font-size:16px;font-weight:bold;font-family:Arial,sans-serif">
				<%= resourceBundle.getProperty("DataManager.DisplayText.Move_Deliverable") %>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="input">
				&nbsp;<input type="radio" id="task" name="task" value="New" onClick="toggle('new')"><%= resourceBundle.getProperty("DataManager.DisplayText.Move_to_NewTask") %></input>
			</td>
		</tr>			
		<tr>
			<td class="input">
				<table border="0" cellpadding="1" cellspacing="1" width="100%">	
					<tr>
						<td class="input" colspan="2">
							<input type="radio" id="task" name="task" value="Old" onClick="toggle('old')"><%= resourceBundle.getProperty("DataManager.DisplayText.Move_to_ExistingTask") %></input>
						</td>
					</tr>	
					<tr>
						<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></b></td>
						<td class="input">
							<select id="room" name="room">
<%
								MapList mlControllers = RDMServicesUtils.getRoomsList();
								String cntrlType = null;
								String controller = null;
								String userId = null;
								String userName = null;
								Map<String, String> mInfo = null;

								for(int i=0, iSz=mlControllers.size(); i<iSz; i++)
								{
									mInfo = mlControllers.get(i);
									controller = mInfo.get(RDMServicesConstants.ROOM_ID);
									cntrlType = mInfo.get(RDMServicesConstants.CNTRL_TYPE);
									if(!(RDMServicesConstants.TYPE_GENERAL_GROWER.equals(cntrlType) ||
										RDMServicesConstants.TYPE_GENERAL_BUNKER.equals(cntrlType) ||
											RDMServicesConstants.TYPE_GENERAL_TUNNEL.equals(cntrlType)))
									{
%>
										<option value="<%= controller %>" <%= controller.equals(sRoom) ? "selected" : "" %>><%= controller %></option>
<%
									}
								}
%>
							</select>
						</td>
					</tr>
<%
					if(RDMServicesConstants.ROLE_SUPERVISOR.equals(u.getRole()))
					{
%>
						<input type="hidden" id="owner" name="owner" value="<%= u.getUser() %>">
<%
					}
					else
					{
%>
						<tr>
							<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Owner") %></b></td>
							<td class="input">
								<select id="owner" name="owner" style="width:250px" class="js-example-basic-multiple">
<%
									MapList mlOwners = RDMServicesUtils.getTaskOwners(sTaskDept, false);
									for(int i=0, iSz=mlOwners.size(); i<iSz; i++)
									{
										mInfo = mlOwners.get(i);
										userId = mInfo.get(RDMServicesConstants.USER_ID);
										userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
										if(!userId.equals(u.getUser()))
										{
%>
											<option value="<%= userId %>" <%= userId.equals(sOwner) ? "selected" : "" %>><%= userName %>&nbsp;(<%= userId %>)</option>
<%
										}
									}
%>
								</select>
							</td>
						</tr>
<%
					}
%>
					<tr>
						<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Assignee") %></b></td>
						<td class="input" colspan="2">
							<select id="assignee" name="assignee" style="width:250px" class="js-example-basic-multiple">
<%
								MapList mlAssignees = RDMServicesUtils.getAssigneeList(sTaskDept, false);
								for(int i=0, iSz=mlAssignees.size(); i<iSz; i++)
								{
									mInfo = mlAssignees.get(i);
									userId = mInfo.get(RDMServicesConstants.USER_ID);
									userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
									if(!userId.equals(u.getUser()))
									{
%>
										<option value="<%= userId %>" <%= userId.equals(sAssignee) ? "selected" : "" %>><%= userName %>&nbsp;(<%= userId %>)</option>
<%
									}
								}
%>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="right">
				<input type="button" name="Next" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Next") %>" onClick="submitForm()">&nbsp;
				<input type="button" name="Cancel" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Cancel") %>" onClick="javascript:top.window.close()">
			</td>
		</tr>
	</table>
</body>	
</html>