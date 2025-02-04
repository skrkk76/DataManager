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
	<link type="text/css" href="../styles/calendar.css" rel="stylesheet" />
	<script language="javaScript" type="text/javascript" src="../scripts/calendar.js"></script>
	<script language="javascript">	
		function searchUsers()
		{
			document.frm.target = "results";
			document.frm.submit();
		}
		function exportAttendance()
		{
			var url = "../ExportAttendance";
			url += "?userId="+document.frm.userId.value;
			url += "&FName="+document.frm.FName.value;
			url += "&LName="+document.frm.LName.value;
			document.location.href = url;
		}
	</script>
</head>

<body>
	<form name="frm" method="post" target="results" action="employeeInOutResults.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="<%= winWidth * 0.65 %>">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.User_ID") %></b></td>
				<td class="input"><input type="text" id="userId" name="userId" value=""></td>
				
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.First_Name") %></b></td>
				<td class="input"><input type="text" id="FName" name="FName" value=""></td>

				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Last_Name") %></b></td>
				<td class="input"><input type="text" id="LName" name="LName" value=""></td>

				<td>
					<input type="button" name="search" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Search_Users") %>" onClick="searchUsers()">
				</td>
				<td>
					<div id="exportBtn" style="display:none;">
						<input type="button" name="export" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Export_to_File") %>" onClick="exportAttendance()">
					</div>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
