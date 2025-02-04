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
			var name = document.getElementById("name");
			name.value = name.value.trim();
			if(name.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Name") %>");
				name.focus();
				return false;
			}
			
			var notifyFirst = document.getElementById("notifyFirst");
			var firstLevelDuration = document.getElementById("firstLevelDuration");
			if(notifyFirst.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_NotifyFirst") %>");
				notifyFirst.focus();
				return;
			}
			else if(firstLevelDuration.value == "0")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_FirstLevelAttempts") %>");
				firstLevelDuration.focus();
				return;
			}
			
			var notifySecond = document.getElementById("notifySecond").value;
			var secondLevelDuration = document.getElementById("secondLevelDuration");
			if(notifySecond != "" && secondLevelDuration.value == "0")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_SecondLevelAttempts") %>");
				secondLevelDuration.focus();
				return;
			}
			
			var notifyThird = document.getElementById("notifyThird").value;
			var thirdLevelDuration = document.getElementById("thirdLevelDuration");
			if(notifyThird != "" && thirdLevelDuration.value == "0")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_ThirdLevelAttempts") %>");
				thirdLevelDuration.focus();
				return;
			}
			
			document.frm.submit();
		}
	</script>
</head>
<%
	String sName = request.getParameter("name");
	String sNotifyFirst = request.getParameter("notifyFirst");
	String sNotifySecond = request.getParameter("notifySecond");
	String sNotifyThird = request.getParameter("notifyThird");
	int iLevel1Duration = Integer.parseInt(request.getParameter("level1Duration"));
	int iLevel2Duration = Integer.parseInt(request.getParameter("level2Duration"));
	int iLevel3Duration = Integer.parseInt(request.getParameter("level3Duration"));
%>
<body>
	<form name="frm" method="post" action="manageNotificationGroupProcess.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="100%">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.NotificationGroup") %></b></td>
				<td class="input">
					<%= sName %>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_First") %></b></td>
				<td class="input">
					<select id="notifyFirst" name="notifyFirst">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						Map<String, String> mUser = null;
						String sUserId = null;
						String sUserName = null;

						MapList mlUsers = RDMServicesUtils.getUsers("", "", false);
						mlUsers.addAll(RDMServicesUtils.getAdministrators("", false));
						mlUsers.sort(RDMServicesConstants.USER_ID, null);
						
						for(int i=0; i<mlUsers.size(); i++)
						{
							mUser = mlUsers.get(i);
							sUserId = mUser.get(RDMServicesConstants.USER_ID);
							sUserName = mUser.get(RDMServicesConstants.DISPLAY_NAME);
							if(sUserName == null)
							{
								sUserName = mUser.get(RDMServicesConstants.LAST_NAME)+", "+mUser.get(RDMServicesConstants.FIRST_NAME);
							}
%>
							<option value="<%= sUserId %>" <%= (sUserId.equals(sNotifyFirst) ? "selected" : "") %>><%= sUserName %>&nbsp;(<%= sUserId %>)</option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_First_Attempts") %></b></td>
				<td class="input">
					<select id="firstLevelDuration" name="firstLevelDuration">
						<option value="2" <%= iLevel1Duration == 2 ? "selected" : "" %>>2</option>
						<option value="3" <%= iLevel1Duration == 3 ? "selected" : "" %>>3</option>
						<option value="4" <%= iLevel1Duration == 4 ? "selected" : "" %>>4</option>
						<option value="5" <%= iLevel1Duration == 5 ? "selected" : "" %>>5</option>
						<option value="999" <%= iLevel1Duration == 999 ? "selected" : "" %>>Infinite</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Second") %></b></td>
				<td class="input">
					<select id="notifySecond" name="notifySecond">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						for(int i=0; i<mlUsers.size(); i++)
						{
							mUser = mlUsers.get(i);
							sUserId = mUser.get(RDMServicesConstants.USER_ID);
							sUserName = mUser.get(RDMServicesConstants.DISPLAY_NAME);
							if(sUserName == null)
							{
								sUserName = mUser.get(RDMServicesConstants.LAST_NAME)+", "+mUser.get(RDMServicesConstants.FIRST_NAME);
							}
%>
							<option value="<%= sUserId %>" <%= (sUserId.equals(sNotifySecond) ? "selected" : "") %>><%= sUserName %>&nbsp;(<%= sUserId %>)</option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Second_Attempts") %></b></td>
				<td class="input">
					<select id="secondLevelDuration" name="secondLevelDuration">
						<option value="0" <%= iLevel2Duration == 0 ? "selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
						<option value="2" <%= iLevel2Duration == 2 ? "selected" : "" %>>2</option>
						<option value="3" <%= iLevel2Duration == 3 ? "selected" : "" %>>3</option>
						<option value="4" <%= iLevel2Duration == 4 ? "selected" : "" %>>4</option>
						<option value="5" <%= iLevel2Duration == 5 ? "selected" : "" %>>5</option>
						<option value="999" <%= iLevel2Duration == 999 ? "selected" : "" %>>Infinite</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Third") %></b></td>
				<td class="input">
					<select id="notifyThird" name="notifyThird">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						for(int i=0; i<mlUsers.size(); i++)
						{
							mUser = mlUsers.get(i);
							sUserId = mUser.get(RDMServicesConstants.USER_ID);
							sUserName = mUser.get(RDMServicesConstants.DISPLAY_NAME);
							if(sUserName == null)
							{
								sUserName = mUser.get(RDMServicesConstants.LAST_NAME)+", "+mUser.get(RDMServicesConstants.FIRST_NAME);
							}
%>
							<option value="<%= sUserId %>" <%= (sUserId.equals(sNotifyThird) ? "selected" : "") %>><%= sUserName %>&nbsp;(<%= sUserId %>)</option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Third_Attempts") %></b></td>
				<td class="input">
					<select id="thirdLevelDuration" name="thirdLevelDuration">
						<option value="0" <%= iLevel3Duration == 0 ? "selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
						<option value="2" <%= iLevel3Duration == 2 ? "selected" : "" %>>2</option>
						<option value="3" <%= iLevel3Duration == 3 ? "selected" : "" %>>3</option>
						<option value="4" <%= iLevel3Duration == 4 ? "selected" : "" %>>4</option>
						<option value="5" <%= iLevel3Duration == 5 ? "selected" : "" %>>5</option>
						<option value="999" <%= iLevel3Duration == 999 ? "selected" : "" %>>Infinite</option>
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
		<input type="hidden" id="name" name="name" value="<%= sName %>">
		<input type="hidden" id="mode" name="mode" value="edit">
	</form>
</body>
</html>
