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
			var role = document.getElementById("role").value;
			var dept = document.getElementById("dept").value;
			var hide = document.getElementById("hide").checked;

			if(!hide && role == "" && dept == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Role_Dept_Access") %>");
				return false;
			}

			document.frm.submit();
		}
		
		function clearAccess()
		{
			var roles = document.getElementById('role');
			for(i=0; i<roles.length; i++)
			{
				roles[i].selected = false;
			}
			
			var depts = document.getElementById('dept');
			for(i=0; i<depts.length; i++)
			{
				depts[i].selected = false;
			}
		}
	</script>
</head>
<%
	String sView = request.getParameter("view");
	Map<String, Object> mView = RDMServicesUtils.getViewAccess(sView);
	
	String sHide = (String)mView.get(RDMServicesConstants.HIDE_VIEW);
	StringList slRole = (StringList)mView.get(RDMServicesConstants.ROLE_NAME);
	slRole = (slRole == null ? new StringList() : slRole);
	StringList slDept = (StringList)mView.get(RDMServicesConstants.DEPT_NAME);
	slDept = (slDept == null ? new StringList() : slDept);
	
	Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
	List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
	Collections.sort(lDepartments, String.CASE_INSENSITIVE_ORDER);
%>
<body>
	<form name="frm" method="post" action="manageUserViewsProcess.jsp">
		<input type="hidden" id="view" name="view" value="<%= sView %>">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="80%">			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.View") %></b></td>
				<td class="input"><%= sView %></td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Hide") %></b></td>
				<td class="input">
					<input type="checkbox" id="hide" name="hide" value="true" <%= "true".equalsIgnoreCase(sHide) ? "checked" : "" %> onClick="javascript:clearAccess()">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.User_Role") %></b></td>
				<td class="input">
					<select id="role" name="role" multiple size="5">
						<option value="<%= RDMServicesConstants.ROLE_ADMIN %>" <%= slRole.contains(RDMServicesConstants.ROLE_ADMIN) ? "selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Administrator") %></option>
						<option value="<%= RDMServicesConstants.ROLE_MANAGER %>" <%= slRole.contains(RDMServicesConstants.ROLE_MANAGER) ? "selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Manager") %></option>
						<option value="<%= RDMServicesConstants.ROLE_SUPERVISOR %>" <%= slRole.contains(RDMServicesConstants.ROLE_SUPERVISOR) ? "selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Supervisor") %></option>
						<option value="<%= RDMServicesConstants.ROLE_HELPER %>" <%= slRole.contains(RDMServicesConstants.ROLE_HELPER) ? "selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Helper") %></option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Departments") %></b></td>
				<td class="input">
					<select id="dept" name="dept" multiple size="5">
<%
						String sDeptName = null;
						for(int j=0; j<lDepartments.size(); j++)
						{
							sDeptName = lDepartments.get(j);
%>
							<option  value="<%= sDeptName %>" <%= slDept.contains(sDeptName) ? "selected" : "" %>><%= sDeptName %></option>
<%
						}
%>
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
	</form>
</body>
</html>
