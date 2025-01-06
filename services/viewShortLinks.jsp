<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet"/>

	<script language="javascript">
		function loadContent(url)
		{
			document.location.href = url;
		}
		
		function popupContent(url, h, w)
		{
			var retval = window.open(url, '', 'left=200,top=100,resizable=no,scrollbars=no,status=no,toolbar=no,height='+h+',width='+w);			
		}
		
		function updateHomePage()
		{
			var name = "";
			var ele = document.getElementsByName('shortLink');
			for(var i=0; i<ele.length; i++)
			{
				if(ele[i].checked)
				{
					name = ele[i].value;
				}
			}
			
			document.frm.submit(); 
		}
	</script>
</head>
<%
	String sHomePage = u.getHomePage();
	sHomePage = (sHomePage == null || "".equals(sHomePage) ? RDMServicesConstants.HOME : sHomePage);
%>
<body>
	<form name="frm" method="post" action="manageUserProcess.jsp">
		<input type="hidden" id="mode" name="mode" value="setHomePage">
		<table align="left" border="0" cellpadding="1" cellspacing="0" width="20%">
			<tr>
				<td align="left">
					<input type="button" id="save" name="save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Update") %>" onClick="javascript:updateHomePage()">
				</td>
			</tr>
			<tr>
				<td class="label" style="font-size:10pt">
					<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.HOME %>" <%= sHomePage.equals(RDMServicesConstants.HOME) ? "checked" : "" %>>
					<b>&raquo;&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Home") %></b>
					<%= sHomePage.equals(RDMServicesConstants.HOME) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
				</td>
			</tr>
			<tr>
				<td class="label" style="font-size:10pt">
					<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.SHORTLINKS %>" <%= sHomePage.equals(RDMServicesConstants.SHORTLINKS) ? "checked" : "" %>>
					<b>&raquo;&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Short_Links") %></b>
					<%= sHomePage.equals(RDMServicesConstants.SHORTLINKS) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
				</td>
			</tr>
<%
			String tabSpace = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			boolean bCreateTask = u.hasViewAccess(RDMServicesConstants.ACTIONS_CREATE_TASK);
			boolean bUpdateBNO = u.hasViewAccess(RDMServicesConstants.ACTIONS_UPDATE_BNO);

			if(bCreateTask || bUpdateBNO)
			{
%>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="label" style="font-size:10pt">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<b>&raquo;&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></b>
					</td>
				</tr>
<%
				if(bCreateTask)
				{
%>				
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ACTIONS_CREATE_TASK %>" <%= sHomePage.equals(RDMServicesConstants.ACTIONS_CREATE_TASK) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:popupContent('addUserTaskView.jsp', '550', '400')"><%= resourceBundle.getProperty("DataManager.DisplayText.Create_Task") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.ACTIONS_CREATE_TASK) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bUpdateBNO)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ACTIONS_UPDATE_BNO %>" <%= sHomePage.equals(RDMServicesConstants.ACTIONS_UPDATE_BNO) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('manageBatchNosView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Update_Batch_Nos") %></a>
							</b><%= sHomePage.equals(RDMServicesConstants.ACTIONS_UPDATE_BNO) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
			}
			
			boolean bViewGrwDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER);
			boolean bViewBnkDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER);
			boolean bViewTnlDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL);
			boolean bViewSingle = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM);
			boolean bViewMultiGrw = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_GROWER);
			boolean bViewMultiBnk = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_BUNKER);
			boolean bViewMultiTnl = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_TUNNEL);
			
			if((bViewGrwDB || bViewBnkDB || bViewTnlDB) || bViewSingle || (bViewMultiGrw || bViewMultiBnk || bViewMultiTnl))
			{
%>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="label" style="font-size:10pt">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<b>&raquo;&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Rooms_View") %></b>
					</td>
				</tr>
<%
				if(bViewGrwDB || bViewBnkDB || bViewTnlDB)
				{
%>
					<tr>
						<td class="input">
							<%= tabSpace %><%= tabSpace %>
							<b>&raquo;&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Dashboard") %></b>
						</td>
					</tr>
<%
					if(bViewGrwDB)
					{
%>
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER %>" <%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('dashboardView.jsp?cntrlType=Grower')"><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
					if(bViewBnkDB)
					{
%>
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER %>" <%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('dashboardView.jsp?cntrlType=Bunker')"><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
					if(bViewTnlDB)
					{
%>
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL %>" <%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('dashboardView.jsp?cntrlType=Tunnel')"><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
				}
				if(bViewSingle)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM %>" <%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('singleRoomView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Single_Room") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bViewMultiGrw || bViewMultiBnk || bViewMultiTnl)
				{
%>
					<tr>
						<td class="input">
							<%= tabSpace %><%= tabSpace %>
							<b>&raquo;&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Multi_Room") %></b>
						</td>
					</tr>
<%
					if(bViewMultiGrw)
					{
%>
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_GROWER %>" <%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_GROWER) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('multiRoomView.jsp?cntrlType=Grower')"><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_GROWER) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
					if(bViewMultiBnk)
					{
%>
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_BUNKER %>" <%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_BUNKER) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('multiRoomView.jsp?cntrlType=Bunker')"><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_BUNKER) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
					if(bViewMultiTnl)
					{
%>
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_TUNNEL %>" <%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_TUNNEL) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('multiRoomView.jsp?cntrlType=Tunnel')"><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_TUNNEL) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
				}
			}
			
			boolean bViewAttrGraph = u.hasViewAccess(RDMServicesConstants.VIEWS_GRAPH_ATTRDATA);
			boolean bViewProdGraph = u.hasViewAccess(RDMServicesConstants.VIEWS_GRAPH_PRODUCTIVITY);
			boolean bViewBatchLoad = u.hasViewAccess(RDMServicesConstants.VIEWS_GRAPH_BATCHLOAD);
			boolean bViewAlarms = u.hasViewAccess(RDMServicesConstants.VIEWS_ALARMS);
			boolean bViewLogs = u.hasViewAccess(RDMServicesConstants.VIEWS_LOGS);
			boolean bViewComments = u.hasViewAccess(RDMServicesConstants.VIEWS_COMMENTS);
			boolean bViewTasks = u.hasViewAccess(RDMServicesConstants.VIEWS_TASKS);
			boolean bViewYields = u.hasViewAccess(RDMServicesConstants.VIEWS_YIELDS);
			boolean bViewTimesheets = u.hasViewAccess(RDMServicesConstants.VIEWS_TIMESHEETS);
			boolean bViewReports = u.hasViewAccess(RDMServicesConstants.VIEWS_REPORTS);
			boolean bViewProductvity = u.hasViewAccess(RDMServicesConstants.VIEWS_PRODUCTIVITY);
			
			if(bViewAttrGraph || bViewProdGraph || bViewBatchLoad || bViewAlarms || bViewLogs || bViewComments 
				|| bViewTasks || bViewYields || bViewTimesheets || bViewReports || bViewProductvity)
			{
%>				
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="label" style="font-size:10pt">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<b>&raquo;&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Views") %></b>
					</td>
				</tr>
<%
				if(bViewAttrGraph || bViewProdGraph || bViewBatchLoad)
				{
%>
					<tr>
						<td class="input">
							<%= tabSpace %><%= tabSpace %>
							<b>&raquo;&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Graph") %></b>
						</td>
					</tr>
<%
					if(bViewAttrGraph)
					{
%>					
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_GRAPH_ATTRDATA %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_GRAPH_ATTRDATA) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('attrDataGraphView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Attribute_Data") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.VIEWS_GRAPH_ATTRDATA) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
					if(bViewProdGraph)
					{
%>
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_GRAPH_PRODUCTIVITY %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_GRAPH_PRODUCTIVITY) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('productivityGraphView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Productivity") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.VIEWS_GRAPH_PRODUCTIVITY) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
					if(bViewBatchLoad)
					{
%>
						<tr>
							<td class="input">
								<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_GRAPH_BATCHLOAD %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_GRAPH_BATCHLOAD) ? "checked" : "" %>>
								<%= tabSpace %><%= tabSpace %>
								<b>&raquo;&nbsp;<a href="javascript:loadContent('batchPhaseLoadsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_Phase_Loads") %></a></b>
								<%= sHomePage.equals(RDMServicesConstants.VIEWS_GRAPH_BATCHLOAD) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
							</td>
						</tr>
<%
					}
				}
				if(bViewAlarms)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_ALARMS %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_ALARMS) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('alarmView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Alarms") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.VIEWS_ALARMS) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bViewLogs)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_LOGS %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_LOGS) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('logView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Logs") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.VIEWS_LOGS) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bViewComments)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_COMMENTS %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_COMMENTS) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('userCommentsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Comments") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.VIEWS_COMMENTS) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bViewTasks)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_TASKS %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_TASKS) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('userTasksView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Tasks") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.VIEWS_TASKS) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bViewYields)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_YIELDS %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_YIELDS) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('viewYields.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Yields") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.VIEWS_YIELDS) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bViewReports)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_REPORTS %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_REPORTS) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('viewReportsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Reports") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.VIEWS_REPORTS) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bViewTimesheets)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_TIMESHEETS %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_TIMESHEETS) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('manageTimesheetsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Manage_Timesheets") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.VIEWS_TIMESHEETS) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
				if(bViewProductvity)
				{
%>
					<tr>
						<td class="input">
							<input type="radio" name="shortLink" id="shortLink" value="<%= RDMServicesConstants.VIEWS_PRODUCTIVITY %>" <%= sHomePage.equals(RDMServicesConstants.VIEWS_PRODUCTIVITY) ? "checked" : "" %>>
							<%= tabSpace %>
							<b>&raquo;&nbsp;<a href="javascript:loadContent('userProductivity.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Productivity") %></a></b>
							<%= sHomePage.equals(RDMServicesConstants.VIEWS_PRODUCTIVITY) ? "("+resourceBundle.getProperty("DataManager.DisplayText.Default_View")+")" : "" %>
						</td>
					</tr>
<%
				}
			}
%>
		</table>
	</form>
</body>
</html>
