<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.notify.*" %>

<%@include file="commonUtils.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title><%= resourceBundle.getProperty("DataManager.DisplayText.Edit_Notification") %></title>

	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
		function submitForm()
		{
			document.frm.submit();
		}
	</script>
</head>
<%
	String sCntrlType = request.getParameter("cntrlType");
	String sAlarm = request.getParameter("alarm");
	String sGroup = request.getParameter("group");
	String sNotifyBy = request.getParameter("notifyBy");
	int iNotifyDuration = Integer.parseInt(request.getParameter("notifyDuration"));
	
	NotifyAlarms notifyAlarms = new NotifyAlarms();
%>
<body>
	<form name="frm" method="post" action="manageNotifyAlarmsProcess.jsp">
		<input type="hidden" id="cntrlType" name="cntrlType" value="<%= sCntrlType %>">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="100%">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Alarm") %></b></td>
				<td class="input">
					<%= sAlarm %>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.NotificationGroup") %></b></td>
				<td class="input">
<%
					String group = null;
					StringList slGroups = new StringList();
					MapList mlGroups = RDMServicesUtils.getNotificationGroups();
					for(int i=0; i<mlGroups.size(); i++)
					{
						slGroups.add(mlGroups.get(i).get(RDMServicesConstants.ALARM_GROUP));
					}
					slGroups.sort();
%>
					<select id="group" name="group">
<%
					for(int j=0; j<slGroups.size(); j++)
					{
						group = slGroups.get(j);
%>
						<option  value="<%= group %>" <%= sGroup.equals(group) ? "selected" : "" %>><%= group %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_By") %></b></td>
				<td class="input">
					<select id="notifyBy" name="notifyBy">
						<option value="Call" <%= ("Call".equals(sNotifyBy) ? "selected" : "") %>>Call</option>
						<option value="SMS" <%= ("SMS".equals(sNotifyBy) ? "selected" : "") %>>SMS</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Duration") %></b></td>
				<td class="input">
					<select id="notifyDuration" name="notifyDuration">
						<option value="10" <%= iNotifyDuration == 10 ? "selected" : "" %>>10</option>
						<option value="15" <%= iNotifyDuration == 15 ? "selected" : "" %>>15</option>
						<option value="30" <%= iNotifyDuration == 30 ? "selected" : "" %>>30</option>
						<option value="60" <%= iNotifyDuration == 60 ? "selected" : "" %>>60</option>
					</select>
					&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Minutes") %>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" onClick="submitForm()">&nbsp;&nbsp;&nbsp;
					<input type="button" name="Cancel" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Cancel") %>" onClick="javascript:top.window.close()">
				</td>
			</tr>
		</table>
		<input type="hidden" id="alarm" name="alarm" value="<%= sAlarm %>">
		<input type="hidden" id="mode" name="mode" value="edit">
	</form>
</body>
</html>
