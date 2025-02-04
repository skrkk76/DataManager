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
			var loc = document.getElementById("loc");
			loc.value = loc.value.trim();
			if(loc.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Header_Position") %>");
				loc.focus();
				return false;
			}
			
			if(isNaN(loc.value))
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Header_Number") %>");
				loc.focus();
				return false;
			}
			
			var name = document.getElementById("name");
			name.value = name.value.trim();
			if(name.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Header_Name") %>");
				name.focus();
				return false;
			}
			
			var type = document.getElementById("cntrlType");
			type.value = type.value.trim();
			if(type.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Type") %>");
				type.focus();
				return false;
			}
			
			document.frm.submit();
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageHeaderProcess.jsp">
		<table border="0" cellpadding="1" cellspacing="1" width="100%">			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Display_Position") %></b></td>
				<td class="input">
					<input type="text" id="loc" name="loc" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Name") %></b></td>
				<td class="input">
					<input type="text" id="name" name="name" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Type") %></b></td>
				<td class="input">
					<select id="cntrlType" name="cntrlType">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
						<option value="<%= RDMServicesConstants.TYPE_GROWER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></option>
						<option value="<%= RDMServicesConstants.TYPE_BUNKER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></option>
						<option value="<%= RDMServicesConstants.TYPE_TUNNEL %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></option>
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
