<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%
String sDept = request.getParameter("dept");
sDept = ((sDept == null) ? "" : sDept);
%>

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
		
		function editTask(taskId)
		{	
			var retval = window.open('updateAdminTasks.jsp?taskId='+taskId, '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=350,width=400');
		}

		function addTask()
		{
			var retval = window.open('addAdminTasks.jsp', '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=350,width=400');
		}

		function deleteTask(taskId) 
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Task") %>");
			if(conf == true)
			{
				parent.frames['footer'].document.location.href = "manageAdminTasksProcess.jsp?taskId="+taskId+"&mode=delete";
			}
		}
		
		function selectDeptTasks()
		{
			var dept = document.getElementById('dept').value;
			document.location.href = "manageAdminTasks.jsp?dept="+dept;
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="1" cellspacing="0" width="<%= winWidth * 0.5 %>">
			<tr>
				<th class="label" style="text-align: left;">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Department") %>
				</th>
				<td colspan="2" style="text-align: left;">
					<select id="dept" name="dept" onChange="javascript:selectDeptTasks()">
						<option  value=""><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
						Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
						List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
						Collections.sort(lDepartments, String.CASE_INSENSITIVE_ORDER);
						String sDeptName = null;
						for(int j=0; j<lDepartments.size(); j++)
						{
							sDeptName = lDepartments.get(j);
%>
							<option  value="<%= sDeptName %>" <%= sDeptName.equals(sDept) ? "selected" : "" %>><%= sDeptName %></option>
<%
						}
%>
					</select>
				</td>
				<td colspan="3" style="text-align: right;">
					<input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Task") %>" onClick="addTask()">
				</td>
			</tr>
			<tr>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Id") %></th>
				<th class="label" width="30%"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Name") %></th>
				<th class="label" width="30%"><%= resourceBundle.getProperty("DataManager.DisplayText.Departments") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			Iterator<String> itrTask = null;
			Map<String, String> mTask = null;
			String sTaskId = "";
			String sTaskName = "";
			String sTaskDepts = "";
			
			MapList mlTasks = RDMServicesUtils.getAdminTasks(sDept);
			for(int i=0; i<mlTasks.size(); i++)
			{
				mTask = mlTasks.get(i);
				sTaskId = mTask.get(RDMServicesConstants.TASK_ID);
				sTaskName = mTask.get(RDMServicesConstants.TASK_NAME);
				sTaskDepts = mTask.get(RDMServicesConstants.DEPARTMENT_NAME).replaceAll("\\|", "<br>");
%>
				<tr>
					<td class="input"><%= sTaskId %></td>
					<td class="input"><%= sTaskName %></td>
					<td class="input"><%= sTaskDepts %></td>
					<td class="input" style="text-align:center">
						<a href="javascript:editTask('<%= sTaskId %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteTask('<%= sTaskId %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
