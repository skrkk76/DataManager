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
		
		function editRoom(roomId)
		{
			var roomIP = document.getElementById(roomId+'_IP'); 
			roomIP.value = roomIP.value.trim();
			if(roomIP.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Room_IP") %>");
				roomIP.focus();
				return false;
			}
			
			var roomType = document.getElementById(roomId+'_type'); 
			var roomStatus = document.getElementById(roomId+'_status');

			parent.frames['hiddenFrame'].document.location.href = "manageRoomProcess.jsp?roomId="+roomId+"&roomIP="+roomIP.value+"&roomType="+roomType.value+"&roomStatus="+roomStatus.value+"&mode=edit";
		}
		
		function chgCredentials(roomId)
		{
			var url = "changeControllerAuth.jsp?roomId="+roomId;
			var retval = window.open(url, '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=250,width=400');
		}
		
		function addRoom()
		{
			var retval = window.open('addRoom.jsp', '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=250,width=400');
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="<%= winWidth * 0.5 %>">
			<tr>
				<td colspan="5" style="text-align: right;"><input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Room") %>" onClick="addRoom()"></td>
			</tr>
			<tr>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Room_Name") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.IP_Address") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Room_Type") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Status") %></th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			Map<String, String> mInfo = null;
			String roomId = null;
			String roomIP = null;
			String roomType = null; 
			String roomStatus = null;
			String sHeader = null;
			StringList slHeaders = new StringList();
			MapList mlRooms = RDMServicesUtils.getRoomsList();
			
			for(int i=0; i<mlRooms.size(); i++)
			{
				mInfo = mlRooms.get(i);
				roomId = mInfo.get(RDMServicesConstants.ROOM_ID);
				roomIP = mInfo.get(RDMServicesConstants.ROOM_IP);
				roomType = mInfo.get(RDMServicesConstants.CNTRL_TYPE);
				roomStatus = mInfo.get(RDMServicesConstants.ROOM_STATUS);
				
				sHeader = (roomType.startsWith("General") ? "General" : roomType);
				if(!slHeaders.contains(sHeader))
				{
					slHeaders.add(sHeader);
%>
					<tr>
						<td colspan="5" align="center"><b><%= resourceBundle.getProperty("DataManager.DisplayText."+sHeader) %></b></td>
					</tr>
<%
				}
%>
				<tr>
					<td class="input"><%= roomId %></td>
					<td class="input"><input type="text" id="<%= roomId %>_IP" name="<%= roomId %>_IP" value="<%= roomIP %>" maxlength="15" size="15"></td>
					<td class="input">
						<select id="<%= roomId %>_type" name="<%= roomId %>_type">
							<option value="<%= RDMServicesConstants.TYPE_GROWER %>" <%= RDMServicesConstants.TYPE_GROWER.equals(roomType) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></option>
							<option value="<%= RDMServicesConstants.TYPE_BUNKER %>" <%= RDMServicesConstants.TYPE_BUNKER.equals(roomType) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></option>
							<option value="<%= RDMServicesConstants.TYPE_TUNNEL %>" <%= RDMServicesConstants.TYPE_TUNNEL.equals(roomType) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></option>
							<option value="<%= RDMServicesConstants.TYPE_GENERAL_GROWER %>" <%= RDMServicesConstants.TYPE_GENERAL_GROWER.equals(roomType) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.General_Grower") %></option>
							<option value="<%= RDMServicesConstants.TYPE_GENERAL_BUNKER %>" <%= RDMServicesConstants.TYPE_GENERAL_BUNKER.equals(roomType) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.General_Bunker") %></option>
							<option value="<%= RDMServicesConstants.TYPE_GENERAL_TUNNEL %>" <%= RDMServicesConstants.TYPE_GENERAL_TUNNEL.equals(roomType) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.General_Tunnel") %></option>
						</select>
					</td>
					<td class="input">
						<select id="<%= roomId %>_status" name="<%= roomId %>_status">
							<option value="<%= RDMServicesConstants.ACTIVE %>" <%= RDMServicesConstants.ACTIVE.equals(roomStatus) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.Active") %></option>
							<option value="<%= RDMServicesConstants.INACTIVE %>" <%= RDMServicesConstants.INACTIVE.equals(roomStatus) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.Inactive") %></option>
						</select>
					</td>
					<td class="input" style="text-align:center">
						<a href="javascript:editRoom('<%= roomId %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
