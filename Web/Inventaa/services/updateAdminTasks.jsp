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
			var taskName = document.getElementById("taskName");
			taskName.value = taskName.value.trim();
			if(taskName.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Task_Name") %>");
				taskName.focus();
				return false;
			}
			
			var duration = document.getElementById('duration').value;
			if(duration != '' && isNaN(duration))
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Alert_Duration_NaN") %>");
				return;
			}
			
			document.frm.submit();
		}
	</script>
</head>
<%
	String sAttrName = "";
	String sAttrUnit = "";
	String sTaskId = request.getParameter("taskId");

	Map<String, String> mAttribute = null;
	Map<String, String> mTask = RDMServicesUtils.getAdminTask(sTaskId);
	MapList mlAttributes = RDMServicesUtils.getAdminAttributes();
	
	Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
	List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
	Collections.sort(lDepartments, String.CASE_INSENSITIVE_ORDER);
	
	String sTaskName = mTask.get(RDMServicesConstants.TASK_NAME);
	String sTaskAttrs = mTask.get(RDMServicesConstants.TASK_ATTRIBUTES);
	String sTaskDepts = mTask.get(RDMServicesConstants.DEPARTMENT_NAME);
	
	String[] saTaskAttrs = sTaskAttrs.split("\\|");	
	StringList slTaskAttrs = new StringList();	
	for(int i=0; i<saTaskAttrs.length; i++)
	{
		slTaskAttrs.add(saTaskAttrs[i]);
	}
	
	String[] saTaskDepts = sTaskDepts.split("\\|");	
	StringList slTaskDepts = new StringList();	
	for(int i=0; i<saTaskDepts.length; i++)
	{
		slTaskDepts.add(saTaskDepts[i]);
	}
	
	String sDuration = mTask.get(RDMServicesConstants.DURATION_ALERT);
	sDuration = ("0".equals(sDuration) ? "" : sDuration);
	
	boolean bProductivityView = "true".equals(mTask.get(RDMServicesConstants.PRODUCTIVITY_TASK));
%>
<body>
	<form name="frm" method="post" action="manageAdminTasksProcess.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="80%">			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Id") %></b></td>
				<td class="input"><%= sTaskId %></td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Name") %></b></td>
				<td class="input">
					<input type="text" id="taskName" name="taskName" size="20" value="<%= sTaskName %>">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Attributes") %></b></td>
				<td class="input">
					<select id="taskAttrs" name="taskAttrs" size="5" multiple>
<%
					for(int i=0; i<mlAttributes.size(); i++)
					{
						mAttribute = mlAttributes.get(i);
						sAttrName = mAttribute.get(RDMServicesConstants.ATTRIBUTE_NAME);
						sAttrUnit = mAttribute.get(RDMServicesConstants.ATTRIBUTE_UNIT);
%>
						<option value="<%= sAttrName %>" <%= slTaskAttrs.contains(sAttrName) ? "selected" : "" %>><%= sAttrName %>&nbsp;(<%= sAttrUnit %>)</option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Departments") %></b></td>
				<td class="input">
					<select id="taskDepts" name="taskDepts" multiple size="5">
<%
						String sDeptName = null;
						for(int j=0; j<lDepartments.size(); j++)
						{
							sDeptName = lDepartments.get(j);
%>
							<option  value="<%= sDeptName %>" <%= slTaskDepts.contains(sDeptName) ? "selected" : "" %>><%= sDeptName %></option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Alert_Duration") %></b></td>
				<td class="input">
					<input type="text" id="duration" name="duration" value="<%= sDuration %>">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Productivity_View") %></b></td>
				<td class="input">
					<input type="checkbox" id="productivityView" name="productivityView" value="TRUE" <%= bProductivityView ? "checked" : "" %>>
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
		<input type="hidden" id="taskId" name="taskId" value="<%= sTaskId %>">
		<input type="hidden" id="mode" name="mode" value="edit">
	</form>
</body>
</html>
