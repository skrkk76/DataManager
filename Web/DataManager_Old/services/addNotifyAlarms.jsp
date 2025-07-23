<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.notify.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sCntrlType = request.getParameter("cntrlType");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title><%= resourceBundle.getProperty("DataManager.DisplayText.Add_Notification") %></title>

	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
		function submitForm()
		{
			var alarm = document.getElementById("alarm");
			if(alarm.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Alarm") %>");
				alarm.focus();
				return;
			}
			
			var group = document.getElementById("group");
			if(group.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_NotificationGroup") %>");
				group.focus();
				return;
			}
			
			var notifyBy = document.getElementById("notifyBy");
			if(notifyBy.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_NotifyBy") %>");
				notifyBy.focus();
				return;
			}

			document.frm.submit();
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageNotifyAlarmsProcess.jsp">
		<input type="hidden" id="cntrlType" name="cntrlType" value="<%= sCntrlType %>">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="100%">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Alarm") %></b></td>
				<td class="input">
					<select id="alarm" name="alarm">
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						NotifyAlarms notifyAlarms = new NotifyAlarms();
						StringList sAlarms = notifyAlarms.listAlarms(sCntrlType);
						for(int i=0; i<sAlarms.size(); i++)
						{
%>
							<option value="<%= sAlarms.get(i) %>"><%= sAlarms.get(i) %></option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.NotificationGroup") %></b></td>
				<td class="input">
<%
					String sGroup = null;
					StringList slGroups = new StringList();
					MapList mlGroups = RDMServicesUtils.getNotificationGroups();
					for(int i=0; i<mlGroups.size(); i++)
					{
						slGroups.add(mlGroups.get(i).get(RDMServicesConstants.ALARM_GROUP));
					}
					slGroups.sort();
%>
					<select id="group" name="group">
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
<%
					for(int j=0; j<slGroups.size(); j++)
					{
						sGroup = slGroups.get(j);
%>
						<option  value="<%= sGroup %>"><%= sGroup %></option>
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
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
						<option value="Call">Call</option>
						<option value="SMS">SMS</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Duration") %></b></td>
				<td class="input">
					<select id="notifyDuration" name="notifyDuration">
						<option value="10" selected>10</option>
						<option value="15">15</option>
						<option value="30">30</option>
						<option value="60">60</option>
					</select>
					&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Minutes") %>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" onClick="submitForm()">&nbsp;&nbsp;&nbsp;
					<input type="button" name="Cancel" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Cancel") %>" onClick="javascript:top.window.close()">
				</td>
			</tr>
		</table>
		<input type="hidden" id="mode" name="mode" value="add">
	</form>
</body>
</html>
