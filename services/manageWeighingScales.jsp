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
		
		function editScale(sId)
		{
			var scaleId = document.getElementById(sId+'_ID');
			scaleId.value = scaleId.value.trim();
			if(scaleId.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Name") %>");
				scaleId.focus();
				return false;
			}
		
			var scaleIP = document.getElementById(sId+'_IP'); 
			scaleIP.value = scaleIP.value.trim();
			if(scaleIP.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_IP_Address") %>");
				scaleIP.focus();
				return false;
			}
			
			var scalePort = document.getElementById(sId+'_Port'); 
			scalePort.value = scalePort.value.trim();
			if(scalePort.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Port") %>");
				scalePort.focus();
				return false;
			}
			
			var scaleStatus = document.getElementById(sId+'_status').value;

			parent.frames['hiddenFrame'].document.location.href = "manageWeighingScaleProcess.jsp?scaleId="+scaleId.value+"&scaleIP="+scaleIP.value+"&scalePort="+scalePort.value+"&scaleStatus="+scaleStatus+"&scaleIdCurr="+sId+"&mode=edit";
		}
		
		function deleteScale(scaleId)
		{		
			parent.frames['hiddenFrame'].document.location.href = "manageWeighingScaleProcess.jsp?scaleId="+scaleId+"&mode=delete";
		}
		
		function addScale()
		{
			var retval = window.open('addWeighingScale.jsp', '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=250,width=400');
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="<%= winWidth * 0.4 %>">
			<tr>
				<td colspan="5" style="text-align: right;"><input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Scale") %>" onClick="addScale()"></td>
			</tr>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Name") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.IP_Address") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Port") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Status") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			Map<String, String> mInfo = null;
			String scaleId = null;
			String scaleIP = null;
			String sPort = null; 
			String sStatus = null;
			MapList mlScales = RDMServicesUtils.getScalesList();
			
			for(int i=0; i<mlScales.size(); i++)
			{
				mInfo = mlScales.get(i);
				scaleId = mInfo.get(RDMServicesConstants.SCALE_ID);
				scaleIP = mInfo.get(RDMServicesConstants.SCALE_IP);
				sPort = mInfo.get(RDMServicesConstants.SCALE_PORT);
				sStatus = mInfo.get(RDMServicesConstants.SCALE_STATUS);
%>
				<tr>
					<td class="input"><input type="text" id="<%= scaleId %>_ID" name="<%= scaleId %>_ID" value="<%= scaleId %>" maxlength="15" size="15"></td>
					<td class="input"><input type="text" id="<%= scaleId %>_IP" name="<%= scaleId %>_IP" value="<%= scaleIP %>" maxlength="15" size="15"></td>
					<td class="input"><input type="text" id="<%= scaleId %>_Port" name="<%= scaleId %>_Port" value="<%= sPort %>" maxlength="4" size="4"></td>
					<td class="input">
						<select id="<%= scaleId %>_status" name="<%= scaleId %>_status">
							<option value="<%= RDMServicesConstants.ACTIVE %>" <%= RDMServicesConstants.ACTIVE.equals(sStatus) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.Active") %></option>
							<option value="<%= RDMServicesConstants.INACTIVE %>" <%= RDMServicesConstants.INACTIVE.equals(sStatus) ? "Selected" : ""%>><%= resourceBundle.getProperty("DataManager.DisplayText.Inactive") %></option>
						</select>
					</td>
					<td class="input" style="text-align:center">
						<a href="javascript:editScale('<%= scaleId %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteScale('<%= scaleId %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
