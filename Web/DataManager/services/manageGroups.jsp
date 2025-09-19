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
		
		function editGroup(idx)
		{
			var newname = document.getElementById(idx+'_Name');
			newname.value = newname.value.trim();
			if(newname.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Group_Name") %>");
				newname.focus();
				return false;
			}
			
			var name = document.getElementById(idx+'_OldName').value;
			var desc = document.getElementById(idx+'_Desc').value;
			parent.frames['hiddenFrame'].document.location.href = "manageGroupProcess.jsp?name="+name+"&newname="+newname.value+"&desc="+desc+"&mode=edit";
		}
		
		function deleteGroup(idx)
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Group") %>");
			if(conf == true)
			{
				var name = document.getElementById(idx+'_Name');
				name.value = name.value.trim();
				parent.frames['hiddenFrame'].document.location.href = "manageGroupProcess.jsp?name="+name.value+"&mode=delete";
			}
		}
		
		function addGroup()
		{
			var retval = window.open('addGroup.jsp', '', 'left=350,top=300,resizable=no,scrollbars=no,status=no,toolbar=no,height=150,width=450');
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="50%">
			<tr>
				<td colspan="3" style="text-align: right;">
					<input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Group") %>" onClick="addGroup()">
				</td>
			</tr>
			<tr>
				<th class="label" width="30%"><%= resourceBundle.getProperty("DataManager.DisplayText.Name") %></th>
				<th class="label" width="50%"><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			int i = 0;
			String sName = null;
			String sDesc = null;
			Map<String, String> mGroup = RDMServicesUtils.getCntrlGroups();
			for (Map.Entry<String, String> entry : mGroup.entrySet()) 
			{
				sName = entry.getKey();
				sDesc = entry.getValue();
%>
				<tr>
					<td class="input">
						<input type="text" id="<%= i %>_Name" name="<%= i %>_Name" value="<%= sName %>" size="20">
						<input type="hidden" id="<%= i %>_OldName" name="<%= i %>_OldName" value="<%= sName %>">
					</td>
					</td>
					<td class="input">
						<input type="text" id="<%= i %>_Desc" name="<%= i %>_Desc" value="<%= sDesc %>" size="50">
					</td>
					<td class="input" style="text-align:center">
						<a href="javascript:editGroup('<%= i %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteGroup('<%= i %>')">
							<img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>">
						</a>
					</td>
				</tr>
<%
				i++;
			}
%>
		</table>
		<input type="hidden" id="Groups" name="Groups" value="<%= i %>">
	</form>
</body>
</html>
