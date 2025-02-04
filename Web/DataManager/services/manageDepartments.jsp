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
		
		function editDepartment(i)
		{
			var name = document.getElementById('name_'+i);
			name.value = name.value.trim();
			if(name.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Name") %>");
				name.focus();
				return false;
			}
			
			var desc = document.getElementById('desc_'+i);
			desc.value = desc.value.trim();
			if(desc.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Description") %>");
				desc.focus();
				return false;
			}
			
			var status = document.getElementById('status_'+i).value;
			var editParams = document.getElementById('editParams_'+i).value;
			var oldName = document.getElementById('old_name_'+i).value;

			parent.frames['footer'].document.location.href = "manageDepartmentProcess.jsp?name="+name.value+"&oldName="+oldName+"&desc="+desc.value+"&status="+status+"&editParams="+editParams+"&mode=edit";
		}
		
		function addDepartment()
		{
			var retval = window.open('addDepartment.jsp', '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=250,width=300');
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="<%= winWidth * 0.2 %>">
			<tr>
				<td colspan="5" style="text-align: right;"><input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Department") %>" onClick="addDepartment()"></td>
			</tr>
			<tr>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Name") %></th>
				<th class="label" width="40%"><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Status") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.EditParameters") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			String sName = null;
			String sDesc = null;
			String sIsActive = null;
			String sEditParams = null;
			Map<String, String> mDepartment = null;
			MapList mlDepartments = RDMServicesUtils.getAllDepartments();
			for(int i=0; i<mlDepartments.size(); i++)
			{
				mDepartment = mlDepartments.get(i);
				sName = mDepartment.get(RDMServicesConstants.DEPARTMENT_NAME);
				sDesc = mDepartment.get(RDMServicesConstants.DESCRIPTION);
				sIsActive = mDepartment.get(RDMServicesConstants.DEPT_ISACTIVE);
				sEditParams = mDepartment.get(RDMServicesConstants.EDIT_PARAMS);
%>
				<tr>
<%
					if("Y".equals(sIsActive))
					{
%>
						<td class="input">
							<input type="text" id="name_<%= i %>" name="name_<%= i %>" maxlength="15" size="15" value="<%= sName %>">
						</td>
						<td class="input">
							<input type="text" id="desc_<%= i %>" name="desc_<%= i %>" size="100" value="<%= sDesc %>">
						</td>
<%
					}
					else
					{
%>
						<td class="input">
							<%= sName %>
							<input type="hidden" id="name_<%= i %>" name="name_<%= i %>" value="<%= sName %>">
						</td>
						<td class="input">
							<%= sDesc %>
							<input type="hidden" id="desc_<%= i %>" name="desc_<%= i %>" value="<%= sDesc %>">
						</td>
<%
					}
%>
					<td class="input">
						<select id="status_<%= i %>" name="status_<%= i %>">
							<option value="Y" <%= "Y".equals(sIsActive) ? "Selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Active") %></option>
							<option value="N" <%= "N".equals(sIsActive) ? "Selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Inactive") %></option>
						</select>
					</td>
					<td class="input">
						<select id="editParams_<%= i %>" name="editParams_<%= i %>">
							<option value="Y" <%= "Y".equals(sEditParams) ? "Selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Yes") %></option>
							<option value="N" <%= "N".equals(sEditParams) ? "Selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.No") %></option>
						</select>
					</td>
					<td class="input" style="text-align:center">
						<a href="javascript:editDepartment('<%= i %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
					</td>
					<input type="hidden" id="old_name_<%= i %>" name="old_name_<%= i %>" value="<%= sName %>">
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
