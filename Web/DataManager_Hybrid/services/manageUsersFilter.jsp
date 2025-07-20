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
<%
String sRoleAllFilter = "";
String sDeptAllFilter = "";

StringList slRoles = u.getAllowedRoles();
StringList slDepts = new StringList();
if(RDMServicesConstants.ROLE_ADMIN.equals(u.getRole()))
{
	Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
	List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
	
	String[] saDepts = new String[lDepartments.size()];
	saDepts = lDepartments.toArray(saDepts);
	slDepts.addAll(saDepts);
}
else
{
	slDepts = u.getDepartment();
	sRoleAllFilter = slRoles.join('|'); 
	sDeptAllFilter = slDepts.join('|'); 
}
slDepts.sort();
%>
<body>
	<form name="frm" method="post" target="results" action="manageUsersResults.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="<%= winWidth * 0.6 %>">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.User_Name") %></b></td>
				<td class="input"><input type="textbox" id="username" name="username" value=""></td>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.User_Role") %></b></td>
				<td class="input">
					<select id="role" name="role">
						<option value="<%= sRoleAllFilter %>" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
					String sRole = null;
					for(int i=0; i<slRoles.size(); i++)
					{
						sRole = slRoles.get(i);
%>
						<option value="<%= sRole %>"><%= sRole %></option>
<%
					}
%>
					</select>
				</td>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Department") %></b></td>
				<td class="input">
					<select id="dept" name="dept">
						<option  value="<%= sDeptAllFilter %>" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
						String sDeptName = null;
						for(int j=0; j<slDepts.size(); j++)
						{
							sDeptName = slDepts.get(j);
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
