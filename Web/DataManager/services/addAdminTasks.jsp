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
			var taskId = document.getElementById("taskId");
			taskId.value = taskId.value.trim();
			if(taskId.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Task_Id") %>");
				taskId.focus();
				return false;
			}
			
			var taskName = document.getElementById("taskName");
			taskName.value = taskName.value.trim();
			if(taskName.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Task_Name") %>");
				taskName.focus();
				return false;
			}
			
			document.frm.submit();
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageAdminTasksProcess.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="80%">			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Id") %></b></td>
				<td class="input">
					<input type="text" id="taskId" name="taskId" maxlength="3" size="3" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Name") %></b></td>
				<td class="input">
					<input type="text" id="taskName" name="taskName" size="20" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Departments") %></b></td>
				<td class="input">
					<select id="taskDepts" name="taskDepts" multiple size="5">
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
