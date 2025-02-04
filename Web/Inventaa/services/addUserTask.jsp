<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sParentTask = request.getParameter("parentTask");
	sParentTask = (sParentTask == null ? "" : sParentTask);
	
	String sRoom = "";
	if(!"".equals(sParentTask))
	{
		UserTasks userTasks = new UserTasks();
		Map<String, String> mTask = userTasks.userTaskDetails(sParentTask);
		sRoom = mTask.get(RDMServicesConstants.ROOM_ID);
	}

	Map<String, String> mInfo = null;
	String sTaskId = "";
	String sTaskName = "";
	StringBuilder sbuf = new StringBuilder();
	
	MapList mlTasks = RDMServicesUtils.getAdminTasks(u.getDepartment());
	for(int i=0; i<mlTasks.size(); i++)
	{
		mInfo = mlTasks.get(i);

		if(i > 0)
		{
			sbuf.append(", ");
		}

		sbuf.append("\""+mInfo.get(RDMServicesConstants.TASK_ID)+"\"");
		sbuf.append(":");
		sbuf.append("\""+mInfo.get(RDMServicesConstants.TASK_NAME)+"\"");
	}

	String[] HOUR = new String[] {"00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", 
									"12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"};
	String[] MIN = new String[] {"00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"};
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>	
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<link type="text/css" href="../styles/calendar.css" rel="stylesheet" />
	<link type="text/css" href="../styles/bootstrap.min.css" rel="stylesheet" />
	<link type="text/css" href="../styles/select2.min.css" rel="stylesheet" />
	
	<script language="javaScript" type="text/javascript" src="../scripts/calendar.js"></script>
	<script language="javaScript" type="text/javascript" src="../scripts/jquery.min.js"></script>
	<script language="javaScript" type="text/javascript" src="../scripts/select2.full.js"></script>
	<script language="javaScript" type="text/javascript" src="../scripts/bootstrap.min.js"></script>
	
	<style type="text/css">		
		td.txtLabel
		{
			border: solid 1px #ffffff;
			text-align: left;
			background-color: #888888;
			color: #ffffff;
			font-size:12px;
			font-family:Arial,sans-serif;
		}
	</style>

	<script type="text/javascript">
		//<![CDATA[
		$(document).ready(function(){
			$(".js-example-basic-multiple").select2();
		});
		//]]>
	</script>

	<script language="javascript">
		if (!String.prototype.trim) 
		{
			String.prototype.trim = function() {
				return this.replace(/^\s+|\s+$/g,'');
			}
		}
		
		var mTasks =  {<%= sbuf.toString() %>};
		function showTaskName()
		{
			var e = document.frm.taskId;
			var taskId = e.options[e.selectedIndex].value;
			var name = mTasks[taskId];
			if(name == "undefined" || name == undefined)
			{
				name = "";
			}
			document.frm.name.value = name;
		}
		
		function submitForm()
		{			
			var taskId = document.getElementById("taskId");
			if(taskId.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Task") %>");
				taskId.focus();
				return false;
			}
			
			var start_date = document.getElementById("start_date");
			var start_hr = document.getElementById("start_hr");
			if(start_date.value == "" || start_hr.value == "00")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Est_Start") %>");
				return false;
			}
			
			var end_date = document.getElementById("end_date");
			var end_hr = document.getElementById("end_hr");
			if(end_date.value == "" || end_hr.value == "00")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Est_End") %>");
				return false;
			}

			var today = new Date();
			var dt = today.getDate();
			if(dt < 10)
			{
				dt = '0' + dt;
			}
			var mon = today.getMonth();
			if(mon < 10)
			{
				mon = '0' + mon;
			}
			var yr = today.getFullYear();
			today = new Date(yr, mon, dt);

			var startDt = document.getElementById("start_date").value;
			var dt1  = parseInt(startDt.substring(0,2),10); 
			var mon1 = parseInt(startDt.substring(3,5),10);
			var yr1  = parseInt(startDt.substring(6,10),10); 
			mon1 = mon1 - 1;
			var date1 = new Date(yr1, mon1, dt1);		
			
			var endDt = document.getElementById("end_date").value;
			var dt2  = parseInt(endDt.substring(0,2),10); 
			var mon2 = parseInt(endDt.substring(3,5),10); 
			var yr2  = parseInt(endDt.substring(6,10),10); 
			mon2 = mon2 - 1;
			var date2 = new Date(yr2, mon2, dt2);
			
			if(date1 < today)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Start_Date_Invalid") %>");
				return false;
			}

			if(date2 < today)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.End_Date_Invalid") %>");
				return false;
			}
			
			if (date1 > date2)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Start_Beyond_End") %>");
				return false;
			}
		
			document.frm.submit();
		}
		
		function setEstDate()
		{
			var today = new Date();
			
			var dd = today.getDate();
			if(dd < 10)
			{
				dd = '0' + dd;
			}
			
			var mm = today.getMonth() + 1;
			if(mm < 10)
			{
				mm = '0' + mm;
			}
			
			var yy = today.getFullYear();
			
			document.getElementById('start_date').value = dd + "-" + mm + "-" + yy;
			document.getElementById('end_date').value = dd + "-" + mm + "-" + yy;

			var start_hr = today.getHours() + 1;
			if(start_hr < 10)
			{
				document.getElementById('start_hr').value = '0' + start_hr;
			}
			else
			{
				document.getElementById('start_hr').value = start_hr;
			}

			var end_hr = today.getHours() + 2;
			if(end_hr < 10)
			{
				document.getElementById('end_hr').value = '0' + end_hr;
			}
			else
			{
				document.getElementById('end_hr').value = end_hr;
			}
		}
		
		function reloadUsers()
		{
			var e = document.frm.taskId;
			var taskId = e.options[e.selectedIndex].value;
			if(taskId != "")
			{
				parent.frames['hidden'].location.href = "loadTaskOwnerAssignee.jsp?taskId="+taskId;
			}
		}
	</script>
</head>

<body onLoad="setEstDate()">
	<form name="frm" method="post" action="manageUserTaskProcess.jsp">
		<input type="hidden" id="mode" name="mode" value="add">
		<input type="hidden" id="parentTask" name="parentTask" value="<%= sParentTask %>">
		<table border="0" cellpadding="1" cellspacing="1" width="100%">
			<tr>
				<td colspan="3" align="center" style="font-size:16px;font-weight:bold;font-family:Arial,sans-serif">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Create_Tasks") %>
				</td>
			</tr>
			<tr>
				<td class="txtLabel" width="25%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task") %></b></td>
				<td class="input" colspan="2" width="75%">
					<select id="taskId" name="taskId" onChange="javascript:showTaskName();reloadUsers();" style="width:250px" class="js-example-basic-multiple">
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						for(int i=0; i<mlTasks.size(); i++)
						{
							mInfo = mlTasks.get(i);
							sTaskId = mInfo.get(RDMServicesConstants.TASK_ID);
							sTaskName = mInfo.get(RDMServicesConstants.TASK_NAME);
%>
							<option value="<%= sTaskId %>"><%= sTaskId %>&nbsp;(<%= sTaskName %>)</option>
<%
						}
%>
					</select>
					<input type="hidden" id="name" name="name" value="">
				</td>
			</tr>
			<tr>
				<td class="txtLabel"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></b></td>
				<td class="input" colspan="2">
					<select id="room" name="room">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						MapList mlControllers = RDMServicesUtils.getRoomsList();
						mlControllers.sort(RDMServicesConstants.ROOM_ID);
						String cntrlType = null;
						String controller = null;

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
			<tr>
				<td class="txtLabel" width="20px"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Owner") %></b></td>
				<td class="input" colspan="2">
					<select id="owner" name="owner" style="width:250px" class="js-example-basic-multiple">
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						MapList mlOwners = RDMServicesUtils.getTaskOwners(u.getDepartment(), false);
						String userId = null;
						String userName = null;
						for(int i=0, iSz=mlOwners.size(); i<iSz; i++)
						{
							mInfo = mlOwners.get(i);
							userId = mInfo.get(RDMServicesConstants.USER_ID);
							userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
							if(!userId.equals(u.getUser()))
							{
%>
								<option value="<%= userId %>"><%= userName %>&nbsp;(<%= userId %>)</option>
<%
							}
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="txtLabel"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Co_Owners") %></b></td>
				<td class="input" colspan="2">
					<select id="CoOwners" name="CoOwners" style="width:250px" class="js-example-basic-multiple" multiple="multiple">
<%
						for(int i=0, iSz=mlOwners.size(); i<iSz; i++)
						{
							mInfo = mlOwners.get(i);
							userId = mInfo.get(RDMServicesConstants.USER_ID);
							userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
							if(!userId.equals(u.getUser()))
							{
%>
								<option value="<%= userId %>"><%= userName %>&nbsp;(<%= userId %>)</option>
<%
							}
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="txtLabel"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Assignees") %></b></td>
				<td class="input" colspan="2">
					<select id="assignee" name="assignee" style="width:250px" class="js-example-basic-multiple" multiple="multiple">
<%
						MapList mlAssignees = RDMServicesUtils.getAssigneeList(u.getDepartment(), false);							
						for(int i=0, iSz=mlAssignees.size(); i<iSz; i++)
						{
							mInfo = mlAssignees.get(i);
							userId = mInfo.get(RDMServicesConstants.USER_ID);
							userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
							if(!userId.equals(u.getUser()))
							{
%>
								<option value="<%= userId %>"><%= userName %>&nbsp;(<%= userId %>)</option>
<%
							}
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="txtLabel" id="a"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Estimated_Start") %></b></td>
				<td class="input">
					<input type="text" size="10" id="start_date" name="start_date" readonly>
					<a href="#" onClick="setYears(2000, 2025);showCalender('a', 'start_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('start_date').value=''"><img src="../images/clear.png"></a>
				</td>
				<td class="input">
					&nbsp;HH&nbsp;
					<select id="start_hr" name="start_hr">
<%					
					for(int i=0; i<HOUR.length; i++)
					{
%>
						<option value="<%= HOUR[i] %>"><%= HOUR[i] %></option>
<%
					}
%>
					</select>
					&nbsp;MM&nbsp;
					<select id="start_min" name="start_min">
<%					
					for(int i=0; i<MIN.length; i++)
					{
%>
						<option value="<%= MIN[i] %>"><%= MIN[i] %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="txtLabel" id="b"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Estimated_End") %></b></td>
				<td class="input">
					<input type="text" size="10" id="end_date" name="end_date" readonly>
					<a href="#" onClick="setYears(2000, 2025);showCalender('b', 'end_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('end_date').value=''"><img src="../images/clear.png"></a>
				</td>
				<td class="input">
					&nbsp;HH&nbsp;
					<select id="end_hr" name="end_hr">
<%					
					for(int i=0; i<HOUR.length; i++)
					{
%>
						<option value="<%= HOUR[i] %>"><%= HOUR[i] %></option>
<%
					}
%>
					</select>
					&nbsp;MM&nbsp;
					<select id="end_min" name="end_min">
<%					
					for(int i=0; i<MIN.length; i++)
					{
%>
						<option value="<%= MIN[i] %>"><%= MIN[i] %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr height="5">
				<td colspan="3"></td>
			</tr>
			<tr>
				<td colspan="3" align="right">
					<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" onClick="submitForm()">&nbsp;&nbsp;&nbsp;
					<input type="button" name="Cancel" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Cancel") %>" onClick="javascript:top.window.close()">
				</td>
			</tr>
		</table>		
	</form>
	<table id="calenderTable">
		<tbody id="calenderTableHead">
			<tr>
				<td colspan="4" align="center">
					<select onChange="showCalenderBody(createCalender(document.getElementById('selectYear').value, this.selectedIndex, false));" id="selectMonth">
						<option value="0"><%= resourceBundle.getProperty("DataManager.DisplayText.January") %></option>
						<option value="1"><%= resourceBundle.getProperty("DataManager.DisplayText.February") %></option>
						<option value="2"><%= resourceBundle.getProperty("DataManager.DisplayText.March") %></option>
						<option value="3"><%= resourceBundle.getProperty("DataManager.DisplayText.April") %></option>
						<option value="4"><%= resourceBundle.getProperty("DataManager.DisplayText.May") %></option>
						<option value="5"><%= resourceBundle.getProperty("DataManager.DisplayText.June") %></option>
						<option value="6"><%= resourceBundle.getProperty("DataManager.DisplayText.July") %></option>
						<option value="7"><%= resourceBundle.getProperty("DataManager.DisplayText.August") %></option>
						<option value="8"><%= resourceBundle.getProperty("DataManager.DisplayText.September") %></option>
						<option value="9"><%= resourceBundle.getProperty("DataManager.DisplayText.October") %></option>
						<option value="10"><%= resourceBundle.getProperty("DataManager.DisplayText.November") %></option>
						<option value="11"><%= resourceBundle.getProperty("DataManager.DisplayText.December") %></option>

					</select>
				</td>
				<td colspan="2" align="center">
					<select onChange="showCalenderBody(createCalender(this.value, document.getElementById('selectMonth').selectedIndex, false));" id="selectYear">
					</select>
				</td>
				<td align="center">
					<a href="#" onClick="closeCalender();"><font color="#003333" size="2">X</font></a>
				</td>
			</tr>
		</tbody>
		<tbody id="calenderTableDays">
			<tr style="">
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Sunday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Monday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Tuesday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Wednesday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Thursday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Friday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Saturday") %></td>
			</tr>
		</tbody>
		<tbody id="calender"></tbody>
	</table>
</body>
</html>
