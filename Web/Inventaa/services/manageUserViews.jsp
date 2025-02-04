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
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
		function editUserView(view)
		{
			var retval = window.open('updateUserViews.jsp?view='+view, '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=300,width=400');
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="1" cellspacing="0" width="<%= winWidth * 0.5 %>">
			<tr>
				<th class="label" width="40%"><%= resourceBundle.getProperty("DataManager.DisplayText.Views") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Hide") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Role") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Department") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			String sRole = "";
			String sDept = "";
			String sHide = "";
			String ALL = resourceBundle.getProperty("DataManager.DisplayText.All");
			String tabSpace = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			Map<String, Map<String, Object>> mUserViews = RDMServicesUtils.getUserViews();
			Map<String, Object> mView = null;
%>
			<tr>
				<td class="input" colspan="5">
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></b>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Create_Task") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ACTIONS_CREATE_TASK);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ACTIONS_CREATE_TASK %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Update_Batch_Nos") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ACTIONS_UPDATE_BNO);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ACTIONS_UPDATE_BNO %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input" colspan="5">
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.Rooms_View") %></b>
				</td>
			</tr>
			<tr>
				<td class="input" colspan="5">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Dashboard") %>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Single_Room") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input" colspan="5">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Multi_Room") %>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_GROWER);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_GROWER %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_BUNKER);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_BUNKER %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_TUNNEL);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_TUNNEL %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input" colspan="5">
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.Views") %></b>
				</td>
			</tr>
			<tr>
				<td class="input" colspan="5">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Graph") %>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Attribute_Data") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_GRAPH_ATTRDATA);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_GRAPH_ATTRDATA %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Productivity") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_GRAPH_PRODUCTIVITY);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_GRAPH_PRODUCTIVITY %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %><%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Batch_Phase_Loads") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_GRAPH_BATCHLOAD);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_GRAPH_BATCHLOAD %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Alarms") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_ALARMS);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_ALARMS %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Logs") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_LOGS);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_LOGS %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Comments") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_COMMENTS);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_COMMENTS %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Tasks") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_TASKS);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_TASKS %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Yields") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_YIELDS);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_YIELDS %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Reports") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_REPORTS);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_REPORTS %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Manage_Timesheets") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_TIMESHEETS);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_TIMESHEETS %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>
			<tr>
				<td class="input">
					<%= tabSpace %>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Productivity") %>
<%
					sRole = ""; sDept = ""; sHide = "False";
					mView = mUserViews.get(RDMServicesConstants.VIEWS_PRODUCTIVITY);
					if(mView != null)
					{
						sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
						sRole = ((StringList)mView.get(RDMServicesConstants.ROLE_NAME)).join(',').replaceAll(",", "<br>");
						sDept = ((StringList)mView.get(RDMServicesConstants.DEPT_NAME)).join(',').replaceAll(",", "<br>");
					}
					if("false".equalsIgnoreCase(sHide))
					{
						sRole = ("".equals(sRole) ? ALL : sRole);
						sDept = ("".equals(sDept) ? ALL : sDept);
					}
%>
				</td>
				<td class="input">
					<%= "false".equalsIgnoreCase(sHide) ? "No" : "Yes" %>
				</td>
				<td class="input">
					<%= sRole %>
				</td>
				<td class="input">
					<%= sDept %>
				</td>
				<td class="input" style="text-align:center">
					<a href="javascript:editUserView('<%= RDMServicesConstants.VIEWS_PRODUCTIVITY %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
				</td>
			</tr>

		</table>
	</form>
</body>
</html>
