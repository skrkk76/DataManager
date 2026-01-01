<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%
	MapList mlControllers = RDMServicesUtils.getRoomsList();
	mlControllers.sort(RDMServicesConstants.ROOM_ID);
	MapList mlTasks = RDMServicesUtils.getAdminTasks(u.getDepartment());
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

	<script type="text/javascript">
		//<![CDATA[
		$(document).ready(function(){
			$(".js-example-basic-multiple").select2();
		});
		//]]>
	</script>
	
	<script language="javascript">
		function searchTasks()
		{
			document.frm.target = "results";
			document.frm.submit();
		}
		
		function exportTasks()
		{
			var childTasks = document.getElementById('childTasks').checked;
			var parentTasks = document.getElementById('parentTasks').checked;
			var coOwners = document.getElementById('coOwners').checked;
			var limit = document.getElementById('limit').value;
			if(limit == "")
			{
				limit = "-1";
			}
			
			var cnt = 0;
			var sTaskIds = "";
			var selTaskIds = document.getElementById('taskId');
			for(i=0; i<selTaskIds.length; i++)
			{
				if(selTaskIds[i].selected == true && selTaskIds[i].value != "")
				{
					if(cnt > 0)
					{
						sTaskIds +=  "','";
					}
					sTaskIds +=  selTaskIds[i].value;
					cnt++;
				}
			}
			
			var url = "../ExportUserTasks";
			url += "?taskName=";
			url += "&taskId="+sTaskIds;
			url += "&room="+document.getElementById('room').value;
			url += "&dept="+document.getElementById('dept').value;
			url += "&owner="+document.getElementById('owner').value; 
			url += "&assignee="+document.getElementById('assignee').value;
			url += "&status="+document.getElementById('status').value;
			url += "&start_date="+document.getElementById('start_date').value;
			url += "&end_date="+document.getElementById('end_date').value;
			url += "&batch="+document.getElementById('batch').value;
			url += "&stage="+document.getElementById('stage').value;
			url += "&searchType="+document.getElementById('searchType').value;
			url += "&childTasks="+childTasks;
			url += "&parentTasks="+parentTasks;
			url += "&coOwners="+coOwners;
			url += "&limit="+limit;
			document.location.href = url;
		}
	</script>
</head>

<body onLoad="searchTasks()">
	<form name="frm" method="post" target="results" action="userTasksResults.jsp">
		<input type="hidden" id="mode" name="mode" value="search">
		<table align="center" border="0" cellpadding="1" cellspacing="1">
			<tr><td>
			<table align="center" border="0" cellpadding="1" cellspacing="1">
			<tr>
				<td class="txtLabel" rowspan="3"><%= resourceBundle.getProperty("DataManager.DisplayText.Task") %></td>
				<td rowspan="3">
					<select id="taskId" name="taskId" style="width:150px" multiple size="5">
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
					Map<String, String> mTask = null;
					String sTaskId = "";
					String sTaskName = "";
					for(int i=0; i<mlTasks.size(); i++)
					{
						mTask = mlTasks.get(i);
						sTaskId = mTask.get(RDMServicesConstants.TASK_ID);
						sTaskName = mTask.get(RDMServicesConstants.TASK_NAME);
%>
						<option value="<%= sTaskId %>"><%= sTaskId %> (<%= sTaskName %>)</option>
<%
					}
%>
					</select>
				</td>

				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Status") %></td>
				<td>
					<select id="status" name="status" style="width:125px">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
						<option value="<%= RDMServicesConstants.TASK_STATUS_NOT_STARTED %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Status_Not_Started") %></option>
						<option value="<%= RDMServicesConstants.TASK_STATUS_WIP %>" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Status_In_Progress") %></option>
						<option value="<%= RDMServicesConstants.TASK_STATUS_COMPLETED %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Status_Completed") %></option>
						<option value="<%= RDMServicesConstants.TASK_STATUS_CANCELLED %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Status_Cancelled") %></option>
					</select>
				</td>
				
				<td colspan="2">&nbsp;</td>

				<td colspan="3" class="txtLabel" style="text-align:center">
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.SortBy") %>&nbsp;&nbsp;</b>
					<input type="radio" name="searchType" id="searchType" value="<%= RDMServicesConstants.ROOM_BASED %>" checked>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Room") %>
					&nbsp;&nbsp;
					<input type="radio" name="searchType" id="searchType" value="<%= RDMServicesConstants.USER_BASED %>">
					<%= resourceBundle.getProperty("DataManager.DisplayText.User") %>
					&nbsp;&nbsp;
					<input type="radio" name="searchType" id="searchType" value="<%= RDMServicesConstants.DATE_BASED %>">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Date") %>
				</td>
				<td colspan="7">&nbsp;</td>
			</tr>
			<tr>
				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></td>
				<td>
					<select id="room" name="room" style="width:125px">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
						<option value="<%= RDMServicesConstants.NO_ROOM %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Not_Specified") %></option>
<%
						Map<String, String> mInfo = null;
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
								<option value="<%= controller %>"><%= controller %></option>
<%
							}
						}
%>
					</select>
				</td>

				<td class="txtLabel" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.Start_Date") %></td>
				<td>
					<input type="text" size="10" id="start_date" name="start_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('a', 'start_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('start_date').value=''"><img src="../images/clear.png"></a>
				</td>

				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Assignee") %></td>
				<td>
					<select id="assignee" name="assignee" style="width:180px" class="js-example-basic-multiple">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
						MapList mlAssignees = RDMServicesUtils.getAssigneeList(u.getDepartment(), true);
						String userId = null;
						String userName = null;
						for(int i=0, iSz=mlAssignees.size(); i<iSz; i++)
						{
							mInfo = mlAssignees.get(i);
							userId = mInfo.get(RDMServicesConstants.USER_ID);
							userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
%>
							<option value="<%= userId %>"><%= userName %>&nbsp;(<%= userId %>)</option>
<%
						}
%>
					</select>
				</td>

				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></td>
				<td>
					<input type="text" id="batch" name="batch" value="" style="width:125px">
				</td>
				
				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Include_Parent_Tasks") %></td>
				<td>
					<input type="checkbox" id="parentTasks" name="parentTasks" value="Y">
				</td>
				
				<td class="txtLabel" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.Search_CoOwners") %></td>
				<td>
					<input type="checkbox" id="coOwners" name="coOwners" value="Y">
				</td>
				<td colspan="2">&nbsp;</td>
			</tr>
<%
			Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
			List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
			Collections.sort(lDepartments, String.CASE_INSENSITIVE_ORDER);
			String sDeptName = null;
			StringList slUserDept = u.getDepartment();
%>
			<tr>
				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Department") %></td>
				<td>
					<select id="dept" name="dept" style="width:125px">
<%
					if(slUserDept.size() != 1)
					{
%>
						<option value="<%= ((slUserDept.size() == 0) ? "" : slUserDept.join('|')) %>" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
					}
					for(int j=0; j<lDepartments.size(); j++)
					{
						sDeptName = lDepartments.get(j);
						if(slUserDept.isEmpty() || slUserDept.contains(sDeptName))
						{
%>
							<option  value="<%= sDeptName %>"><%= sDeptName %></option>
<%
						}
					}
%>
					</select>
				</td>

				<td class="txtLabel" id="b"><%= resourceBundle.getProperty("DataManager.DisplayText.End_Date") %></td>
				<td>
					<input type="text" size="10" id="end_date" name="end_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('b', 'end_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('end_date').value=''"><img src="../images/clear.png"></a>
				</td>
				
				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Owner") %></td>
				<td>
<%
				if(RDMServicesConstants.ROLE_ADMIN.equals(u.getRole()) || RDMServicesConstants.ROLE_MANAGER.equals(u.getRole()))
				{
%>
					<select id="owner" name="owner" style="width:180px" class="js-example-basic-multiple">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
						MapList mlOwners = RDMServicesUtils.getTaskOwners(u.getDepartment(), true);
						for(int i=0, iSz=mlOwners.size(); i<iSz; i++)
						{
							mInfo = mlOwners.get(i);
							userId = mInfo.get(RDMServicesConstants.USER_ID);
							userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
%>
							<option value="<%= userId %>"><%= userName %>&nbsp;(<%= userId %>)</option>
<%
						}
%>
					</select>
<%
				}
				else
				{
%>					
					<input type="text" id="ownerName" name="ownerName" style="width:125px" value="<%= u.getLastName() %>, <%= u.getFirstName() %>" readonly disabled>
					<input type="hidden" id="owner" name="owner" value="<%= u.getUser() %>">
<%
				}
%>
				</td>

				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Stage") %></td>
				<td>
					<select id="stage" name="stage" style="width:125px">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
						Map<String, ArrayList<String[]>> mTypePhases = RDMServicesUtils.getControllerTypeStages();
						String sPhaseSeq = "";
						String stageName = "";
						String sPhase = "";
						String sCntrlType = "";
						ArrayList<String[]> alPhases = null;

						Iterator<String> itr = mTypePhases.keySet().iterator();
						while(itr.hasNext())
						{
							sCntrlType = itr.next();
							alPhases = mTypePhases.get(sCntrlType);
%>
							<optgroup label="<%= resourceBundle.getProperty("DataManager.DisplayText."+sCntrlType) %>">
<%
							for(int i=0; i<alPhases.size(); i++)
							{
								sPhaseSeq = alPhases.get(i)[0];
								stageName = alPhases.get(i)[1];
								sPhase = (sPhaseSeq.equals(stageName) ? sPhaseSeq : stageName+"&nbsp;("+sPhaseSeq+")");
%>					
								<option value="<%= sPhaseSeq %>|<%= sCntrlType %>"><%= sPhase %></option>
<%
							}
						}
%>
					</select>
				</td>

				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Include_Child_Tasks") %></td>
				<td>
					<input type="checkbox" id="childTasks" name="childTasks" value="Y" checked>
				</td>
				
				<td class="txtLabel"><%= resourceBundle.getProperty("DataManager.DisplayText.Limit_Results") %></td>
				<td>
					<input type="text" id="limit" name="limit" size="5" value="500">
				</td>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		</td>
		<td>
			<table border="1" align="center" cellpadding="2" cellspacing="2" width="100%">
				<tr>
					<td align="right" width="10%">
						<div id="actions">
							<button class="buttons" id="start" name="start" onClick="javascript:frames['results'].startTasks()"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Start") %></button>
							<button class="buttons" id="complete" name="complete" onClick="javascript:frames['results'].completeTasks()"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Complete") %></button>
							<button class="buttons" id="delete" name="delete" onClick="javascript:frames['results'].deleteTasks()"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Delete") %></button>
						</div>
					</td>
				</tr>
				<tr>
					<td align="left" width="10%">
						<div id="downloadbtn">
							<button class="buttons" id="download" name="download" onClick="javascript:frames['results'].download()"><%= resourceBundle.getProperty("DataManager.DisplayText.Download") %></button>
						</div>
					</td>
				</tr>
				<tr>
					<td align="left" width="10%">
						<div id="copybtn">
							<button class="buttons" id="copy" name="copy" onClick="javascript:frames['results'].copyTasks()"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Copy") %></button>
						</div>
					</td>
				</tr>
<%
				if(RDMServicesConstants.ROLE_ADMIN.equals(u.getRole()))
				{
%>
				<tr>
					<td align="left" width="10%">
						<button class="buttons" id="ExportTasks" name="ExportTasks" onClick="exportTasks()"><%= resourceBundle.getProperty("DataManager.DisplayText.Export_Tasks") %></button>
					</td>
				</tr>
<%
				}
%>
				<tr>
					<td align="left" width="10%">
						<button class="buttons" id="SearchTasks" name="SearchTasks" onClick="searchTasks()"><%= resourceBundle.getProperty("DataManager.DisplayText.Search_Tasks") %></button>
					</td>
				</tr>
			</table>
		</td>
		</tr>
		</table>
		<table align="left" border="0" cellpadding="0" cellspacing="0" width="98%">
			<tr height="10pt">
				<td width="0.6%">&nbsp;</td>
				<td class="input" width="10%" colspan="4" style="font-size:12px;font-weight:bold;text-align:center"><div id="noTasks"></div></td>
				<td class="input" width="90%" colspan="14" style="font-size:12px;font-weight:bold;text-align:left"><div id="totalDeliverables"></div></td>
			</tr>
			<tr height="10pt">
				<td width="0.6%">&nbsp;</td>
				<td class="input" width="16%" colspan="4" style="font-size:12px;font-weight:bold;text-align:center"><div id="taskInfo_id"></div></td>
				<td class="input" width="66%" colspan="10" style="font-size:12px;font-weight:bold;text-align:left"><div id="taskInfo_notes"></div></td>
				<td class="input" width="18%" colspan="4" style="font-size:12px;font-weight:bold;text-align:left"><div id="taskInfo_size"></div></td>
			</tr>
			<tr height="10pt">
				<td width="0.6%">&nbsp;</td>
				<td class="txtLabel" width="2%" style="text-align:center"><input type="checkbox" id="chk_all" name="chk_all" onClick="javascript:frames['results'].checkAll()"></td>
				<td class="txtLabel" width="2%" style="text-align:center">ATT</td>
				<td class="txtLabel" width="5%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Name") %></td>
				<td class="txtLabel" width="7%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Id") %></td>
				<td class="txtLabel" width="5%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Room_No") %></td>
				<td class="txtLabel" width="5%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></td>
				<td class="txtLabel" width="5%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Status") %></td>
				<td class="txtLabel" width="9%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Owner") %></td>
				<td class="txtLabel" width="9%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Assignee") %></td>
				<td class="txtLabel" width="5%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.In_Time") %></td>
				<td class="txtLabel" width="7%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Estimated_Start") %></td>
				<td class="txtLabel" width="7%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Estimated_End") %></td>
				<td class="txtLabel" width="6%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Actual_Start") %></td>
				<td class="txtLabel" width="6%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Actual_End") %></td>
				<td class="txtLabel" width="7%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.First_Del_CreatedOn") %></td>
				<td class="txtLabel" width="7%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.Last_Del_CreatedOn") %></td>
				<td class="txtLabel" width="3%" style="text-align:center; background-color:#FFFFFF;"><img src="../images/TaskDeliverables.jpg"></td>
				<td class="txtLabel" width="3%" style="text-align:center"><%= resourceBundle.getProperty("DataManager.DisplayText.WBS") %></td>
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
	
	<iframe name="results" src="userTasksResults.jsp" align="left" frameBorder="0" width="100%" height="<%= (winHeight * 0.64) %>px">
</body>
</html>