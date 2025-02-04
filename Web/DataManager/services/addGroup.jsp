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
			var name = document.getElementById("name");
			name.value = name.value.trim();
			if(name.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Group_Name") %>");
				name.focus();
				return false;
			}
			document.frm.submit();
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageGroupProcess.jsp">
		<table border="0" cellpadding="5" cellspacing="1" width="100%">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Name") %></b></td>
				<td class="input">
					<input type="text" id="name" name="name" value="" size="20">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></b></td>
				<td class="input">
					<input type="text" id="desc" name="desc" value="" size="50">
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
