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
			var scaleId = document.getElementById("scaleId");
			scaleId.value = scaleId.value.trim();
			if(scaleId.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Name") %>");
				scaleId.focus();
				return false;
			}
			
			var scaleIP = document.getElementById("scaleIP");
			scaleIP.value = scaleIP.value.trim();
			if(scaleIP.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_IP_Address") %>");
				scaleIP.focus();
				return false;
			}
		
			var scalePort = document.getElementById('scalePort'); 
			scalePort.value = scalePort.value.trim();
			if(scalePort.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Port") %>");
				scalePort.focus();
				return false;
			}
			
			var scaleStatus = document.getElementById("scaleStatus");
			scaleStatus.value = scaleStatus.value.trim();
			if(scaleStatus.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Status") %>");
				scaleStatus.focus();
				return false;
			}
			
			document.frm.submit();			
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageWeighingScaleProcess.jsp">
		<table border="0" cellpadding="1" cellspacing="1" width="100%">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Name") %></b></td>
				<td class="input">
					<input type="text" id="scaleId" name="scaleId" value="" maxlength="15" size="15" value="">
				</td>
			</tr>			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.IP_Address") %></b></td>
				<td class="input">
					<input type="text" id="scaleIP" name="scaleIP" maxlength="15" size="15" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Port") %></b></td>
				<td class="input">
					<input type="text" id="scalePort" name="scalePort" maxlength="4" size="4" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Status") %></b></td>
				<td class="input">
					<select id="scaleStatus" name="scaleStatus">
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
