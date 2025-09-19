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
			var seqNum = document.getElementById("seqNum");
			seqNum.value = seqNum.value.trim();
			if(seqNum.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Seq_Number") %>");
				seqNum.focus();
				return false;
			}
			
			var type = document.getElementById("type");
			if(type.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Phase_Type") %>");
				type.focus();
				return false;
			}
			
			document.frm.submit();
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageStageProcess.jsp">
		<table border="0" cellpadding="1" cellspacing="1" width="100%">			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Seq_Number") %></b></td>
				<td class="input">
					<input type="text" id="seqNum" name="seqNum" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Phase_Name") %></b></td>
				<td class="input">
					<input type="text" id="name" name="name" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Belongs_to") %></b></td>
				<td class="input">
					<select id="type" name="type">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
						<option value="<%= RDMServicesConstants.TYPE_GROWER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></option>
						<option value="<%= RDMServicesConstants.TYPE_BUNKER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></option>
						<option value="<%= RDMServicesConstants.TYPE_TUNNEL %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></b></td>
				<td class="input">
					<input type="text" id="desc" name="desc" value="">
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
