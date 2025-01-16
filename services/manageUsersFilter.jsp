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
	</script>
</head>

<body>
	<form name="frm" method="post" target="results" action="manageUsersResults.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="<%= winWidth * 0.6 %>">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.User_Name") %></b></td>
				<td class="input"><input type="textbox" id="username" name="username" value=""></td>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.User_Role") %></b></td>
				<td class="input">
					<select id="role" name="role">
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
						<option value="<%= RDMServicesConstants.ROLE_ADMIN %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Administrator") %></option>
						<option value="<%= RDMServicesConstants.ROLE_MANAGER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Manager") %></option>
						<option value="<%= RDMServicesConstants.ROLE_SUPERVISOR %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Supervisor") %></option>
						<option value="<%= RDMServicesConstants.ROLE_HELPER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Helper") %></option>
						<option value="<%= RDMServicesConstants.ROLE_TIMEKEEPER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.TimeKeeper") %></option>
					</select>
				</td>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Department") %></b></td>
				<td class="input">
					<select id="dept" name="dept">	
						<option  value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
						Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
						List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
						Collections.sort(lDepartments, String.CASE_INSENSITIVE_ORDER);
						String sDeptName = null;
						for(int j=0; j<lDepartments.size(); j++)
						{
							sDeptName = lDepartments.get(j);
%>
							<option  value="<%= sDeptName %>"><%= sDeptName %></option>
<%
						}
%>
					</select>
				</td>				
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Show_Blocked_Users") %></b></td>
				<td class="input">
					<input type="checkbox" id="blockedUsers" name="blockedUsers" value="yes">&nbsp;<b><%= resourceBundle.getProperty("DataManager.DisplayText.Yes") %></b>
				</td>
				<td>
					<input type="button" name="search" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Search_Users") %>" onClick="searchUsers()">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
