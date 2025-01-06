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
			
			var notifyBy = document.getElementById("notifyBy");
			if(notifyBy.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_NotifyBy") %>");
				notifyBy.focus();
				return;
			}
			
			var notifyFirst = document.getElementById("notifyFirst");
			if(notifyFirst.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_NotifyFirst") %>");
				notifyFirst.focus();
				return;
			}
			
			var notifySecond = document.getElementById("notifySecond");
			if(notifySecond.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_NotifySecond") %>");
				notifySecond.focus();
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
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_First") %></b></td>
				<td class="input">
					<select id="notifyFirst" name="notifyFirst">
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
<%
						Map<String, String> mUser = null;
						String sUserId = null;
						String sUserName = null;

						MapList mlUsers = RDMServicesUtils.getTaskOwners("", false);
						for(int i=0; i<mlUsers.size(); i++)
						{
							mUser = mlUsers.get(i);
							sUserId = mUser.get(RDMServicesConstants.USER_ID);
							sUserName = mUser.get(RDMServicesConstants.DISPLAY_NAME);
%>
							<option value="<%= sUserId %>"><%= sUserName %>&nbsp;(<%= sUserId %>)</option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_First_Duration") %></b></td>
				<td class="input">
					<select id="firstLevelDuration" name="firstLevelDuration">
						<option value="2" selected>2</option>
						<option value="3">3</option>
						<option value="4">4</option>
                        <option value="5">5</option>
					</select>
				</td>
			</tr>			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Second") %></b></td>
				<td class="input">
					<select id="notifySecond" name="notifySecond">
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
<%
						mlUsers = RDMServicesUtils.getManagers("", false);
						mlUsers.addAll(RDMServicesUtils.getAdministrators("", false));
						for(int i=0; i<mlUsers.size(); i++)
						{
							mUser = mlUsers.get(i);
							sUserId = mUser.get(RDMServicesConstants.USER_ID);
							sUserName = mUser.get(RDMServicesConstants.DISPLAY_NAME);
%>
							<option value="<%= sUserId %>"><%= sUserName %>&nbsp;(<%= sUserId %>)</option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Second_Duration") %></b></td>
				<td class="input">
					<select id="secondLevelDuration" name="secondLevelDuration">
						<option value="0" selected><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Duration_Unlimit") %></option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
                        <option value="5">5</option>
					</select>
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
		<input type="hidden" id="mode" name="mode" value="add">
	</form>
</body>
</html>
