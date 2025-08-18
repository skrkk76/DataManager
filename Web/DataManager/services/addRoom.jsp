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
		if (!String.prototype.trim) 
		{
			String.prototype.trim = function() {
				return this.replace(/^\s+|\s+$/g,'');
			}
		}
		
		function submitForm()
		{
			var roomId = document.getElementById("roomId");
			roomId.value = roomId.value.trim();
			if(roomId.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Room_Name") %>");
				roomId.focus();
				return false;
			}
			
			var roomIP = document.getElementById("roomIP");
			roomIP.value = roomIP.value.trim();
			if(roomIP.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_IP_Address") %>");
				roomIP.focus();
				return false;
			}
			
			var roomType = document.getElementById("roomType");
			if(roomType.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Room_Type") %>");
				roomType.focus();
				return false;
			}
			
			var roomGroup = document.getElementById("roomGroup"); 
			roomGroup.value = roomGroup.value.trim();
			if(roomGroup.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Group_Name") %>");
				roomGroup.focus();
				return false;
			}
			
			var roomStatus = document.getElementById("roomStatus");
			if(roomStatus.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Room_Status") %>");
				roomStatus.focus();
				return false;
			}
			
			document.frm.submit();
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageRoomProcess.jsp">
		<table border="0" cellpadding="1" cellspacing="1" width="100%">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Room_Name") %></b></td>
				<td class="input">
					<input type="text" id="roomId" name="roomId" value="">
				</td>
			</tr>			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.IP_Address") %></b></td>
				<td class="input">
					<input type="text" id="roomIP" name="roomIP" maxlength="15" size="15" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Room_Type") %></b></td>
				<td class="input">
					<select id="roomType" name="roomType">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
						<option value="<%= RDMServicesConstants.TYPE_GROWER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></option>
						<option value="<%= RDMServicesConstants.TYPE_BUNKER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></option>
						<option value="<%= RDMServicesConstants.TYPE_TUNNEL %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></option>
						<option value="<%= RDMServicesConstants.TYPE_GENERAL_GROWER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.General_Grower") %></option>
						<option value="<%= RDMServicesConstants.TYPE_GENERAL_BUNKER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.General_Bunker") %></option>
						<option value="<%= RDMServicesConstants.TYPE_GENERAL_TUNNEL %>"><%= resourceBundle.getProperty("DataManager.DisplayText.General_Tunnel") %></option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Group") %></b></td>
				<td class="input">
					<select id="roomGroup" name="roomGroup">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
					Map<String, String> mGroups = RDMServicesUtils.getCntrlGroups();
					for (Map.Entry<String, String> entry : mGroups.entrySet()) 
					{
						String cntrlGroup = entry.getKey();
%>
						<option value="<%= cntrlGroup %>"><%= cntrlGroup %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Status") %></b></td>
				<td class="input">
					<select id="roomStatus" name="roomStatus">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
						<option value="<%= RDMServicesConstants.ACTIVE %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Active") %></option>
						<option value="<%= RDMServicesConstants.INACTIVE %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Inactive") %></option>
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
