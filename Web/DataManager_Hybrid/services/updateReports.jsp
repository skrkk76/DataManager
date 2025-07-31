<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.reports.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sReport = request.getParameter("report");

	ReportDAO reportDAO = new ReportDAO();
	Map<String, String> mReport = reportDAO.getReport(u.getUser(), sReport);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title><%= resourceBundle.getProperty("DataManager.DisplayText.Update_Report") %></title>

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
			var report = document.getElementById("report");
			if(report.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Report") %>");
				report.focus();
				return;
			}
			
			/*
			var template = document.getElementById("template");
			if(template.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Template") %>");
				template.focus();
				return;
			}
			*/
			
			var keyColumn = document.getElementById('keyColumn').value.trim();
			if(keyColumn == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_KeyColumn") %>");
				return;
			}
			
			var headers = document.getElementById('headerRow').value.trim();
			if(headers == "" || isNaN(headers))
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Report_Header_Row_NaN") %>");
				return;
			}
			
			var formula = document.getElementById('formulaRow').value.trim();
			if(formula != "" && isNaN(formula))
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Report_Formula_Row_NaN") %>");
				return;
			}
			else
			{
				formula = "100";
			}
			
			var ranges = document.getElementById('rangesRow').value.trim();
			if(ranges != "" && isNaN(ranges))
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Report_Ranges_Row_NaN") %>");
				return;
			}
			else
			{
				ranges = "200";
			}
			
			var readOnlyCols = document.getElementById('readOnlyRow').value.trim();
			if(readOnlyCols != "" && isNaN(readOnlyCols))
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Report_ReadOnly_Row_NaN") %>");
				return;
			}
			else
			{
				readOnlyCols = "300";
			}
			
			if(headers == formula || headers == ranges || headers == readOnlyCols || formula == ranges || formula == readOnlyCols || ranges == readOnlyCols)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Report_Rows_Unique") %>");
				return;
			}

			var fg = false;
			var addRecd = document.getElementsByName('addRecd');
			for(var i=0; i<addRecd.length; i++)
			{
				if(addRecd[i].checked)
				{
					fg = true;
				}
			}
			
			if(!fg)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Add_Record_Access") %>");
				return;
			}
			
			var fg = false;
			var updateRecd = document.getElementsByName('updateRecd');
			for(var i=0; i<updateRecd.length; i++)
			{
				if(updateRecd[i].checked)
				{
					fg = true;
				}
			}
			
			if(!fg)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Update_Record_Access") %>");
				return;
			}
			
			var fg = false;
			var downloadRecd = document.getElementsByName('downloadRecd');
			for(var i=0; i<downloadRecd.length; i++)
			{
				if(downloadRecd[i].checked)
				{
					fg = true;
				}
			}
			
			if(!fg)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Download_Record_Access") %>");
				return;
			}

			document.frm.submit();
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageReportsProcess.jsp" enctype="multipart/form-data">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="100%">	
			<tr>
				<td colspan="3">
					<font color="red" size="2pt"><i><b>
						<%= resourceBundle.getProperty("DataManager.DisplayText.manage_Report_Assumption1") %><br>
						<%= resourceBundle.getProperty("DataManager.DisplayText.manage_Report_Assumption2") %>
					</b><i></font>
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Report") %></b></td>
				<td class="input" width="70%" colspan="2">
					<input type="text" id="report" name="report" value="<%= sReport %>" size="25">
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></b></td>
				<td class="input" width="70%" colspan="2">
					<textarea id="desc" name="desc"><%= mReport.get(RDMServicesConstants.DESCRIPTION) %></textarea>
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Template") %></b></td>
				<td class="input" width="70%" colspan="2">
					<input type="file" id="template" name="template" accept="application/vnd.ms-excel">
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.manage_Report_KeyColumn") %></b></td>
				<td class="input" width="70%" colspan="2">
					<input type="text" id="keyColumn" name="keyColumn" value="<%= mReport.get(RDMServicesConstants.KEY_COLUMN) %>">
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.manage_Report_Header_Row") %></b></td>
				<td class="input" width="70%" colspan="2">
					<input type="text" id="headerRow" name="headerRow" value="<%= mReport.get(RDMServicesConstants.HEADER_ROW) %>">
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.manage_Report_Formula_Row") %></b></td>
				<td class="input" width="70%" colspan="2">
					<input type="text" id="formulaRow" name="formulaRow" value="<%= mReport.get(RDMServicesConstants.FORMULA_ROW) %>">
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.manage_Report_Ranges_Row") %></b></td>
				<td class="input" width="70%" colspan="2">
					<input type="text" id="rangesRow" name="rangesRow" value="<%= mReport.get(RDMServicesConstants.RANGES_ROW) %>">
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.manage_Report_ReadOnly_Row") %></b></td>
				<td class="input" width="70%" colspan="2">
					<input type="text" id="readOnlyRow" name="readOnlyRow" value="<%= mReport.get(RDMServicesConstants.EDITABLE_ROW) %>">
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Allow_Multiple_Updates") %></b></td>
				<td class="input" width="70%" colspan="2">
					<input type="checkbox" id="allowUpdates" name="allowUpdates" value="Yes" <%= "TRUE".equals(mReport.get(RDMServicesConstants.ALLOW_MULTIPLE_UPDATES)) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Yes") %>
				</td>
			</tr>
<%
			String[] saReadAccess = mReport.get(RDMServicesConstants.READ_ACCESS).split("\\|");
			StringList slReadAccess = new StringList();
			slReadAccess.addAll(saReadAccess);
			
			String[] saReadDepts = mReport.get(RDMServicesConstants.READ_DEPT).split("\\|");
			StringList slReadDepts = new StringList();
			slReadDepts.addAll(saReadDepts);
			
			String[] saModifyAccess = mReport.get(RDMServicesConstants.MODIFY_ACCESS).split("\\|");
			StringList slModifyAccess = new StringList();
			slModifyAccess.addAll(saModifyAccess);
			
			String[] saModifyDepts = mReport.get(RDMServicesConstants.MODIFY_DEPT).split("\\|");
			StringList slModifyDepts = new StringList();
			slModifyDepts.addAll(saModifyDepts);
			
			String[] saWriteAccess = mReport.get(RDMServicesConstants.WRITE_ACCESS).split("\\|");
			StringList slWriteAccess = new StringList();
			slWriteAccess.addAll(saWriteAccess);
			
			String[] saWriteDepts = mReport.get(RDMServicesConstants.WRITE_DEPT).split("\\|");
			StringList slWriteDepts = new StringList();
			slWriteDepts.addAll(saWriteDepts);
			
			Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
			List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
			Collections.sort(lDepartments, String.CASE_INSENSITIVE_ORDER);
			String sDeptName = null;
%>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Add_Record") %></b></td>
				<td class="input" width="35%">
					<input type="checkbox" id="addRecd" name="addRecd" value="<%= RDMServicesConstants.ROLE_MANAGER %>" <%= slWriteAccess.contains(RDMServicesConstants.ROLE_MANAGER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Manager") %><br>
					<input type="checkbox" id="addRecd" name="addRecd" value="<%= RDMServicesConstants.ROLE_SUPERVISOR %>" <%= slWriteAccess.contains(RDMServicesConstants.ROLE_SUPERVISOR) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Supervisor") %><br>
					<input type="checkbox" id="addRecd" name="addRecd" value="<%= RDMServicesConstants.ROLE_HELPER %>" <%= slWriteAccess.contains(RDMServicesConstants.ROLE_HELPER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Helper") %><br>
					<input type="checkbox" id="addRecd" name="addRecd" value="<%= RDMServicesConstants.ROLE_TIMEKEEPER %>" <%= slWriteAccess.contains(RDMServicesConstants.ROLE_TIMEKEEPER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.TimeKeeper") %>
				</td>
				<td class="input" width="35%">
					<select id="addDept" name="addDept" multiple size="5">
<%					
					for(int j=0; j<lDepartments.size(); j++)
					{
						sDeptName = lDepartments.get(j);
%>
						<option  value="<%= sDeptName %>" <%= slWriteDepts.contains(sDeptName) ? "selected" : "" %>><%= sDeptName %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Update_Record") %></b></td>
				<td class="input" width="35%">
					<input type="checkbox" id="updateRecd" name="updateRecd" value="<%= RDMServicesConstants.ROLE_MANAGER %>" <%= slModifyAccess.contains(RDMServicesConstants.ROLE_MANAGER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Manager") %><br>
					<input type="checkbox" id="updateRecd" name="updateRecd" value="<%= RDMServicesConstants.ROLE_SUPERVISOR %>" <%= slModifyAccess.contains(RDMServicesConstants.ROLE_SUPERVISOR) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Supervisor") %><br>
					<input type="checkbox" id="updateRecd" name="updateRecd" value="<%= RDMServicesConstants.ROLE_HELPER %>" <%= slModifyAccess.contains(RDMServicesConstants.ROLE_HELPER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Helper") %><br>
					<input type="checkbox" id="updateRecd" name="updateRecd" value="<%= RDMServicesConstants.ROLE_TIMEKEEPER %>" <%= slModifyAccess.contains(RDMServicesConstants.ROLE_TIMEKEEPER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.TimeKeeper") %>
				</td>
				<td class="input" width="35%">
					<select id="modifyDept" name="modifyDept" multiple size="5">
<%					
					for(int j=0; j<lDepartments.size(); j++)
					{
						sDeptName = lDepartments.get(j);
%>
						<option  value="<%= sDeptName %>" <%= slModifyDepts.contains(sDeptName) ? "selected" : "" %>><%= sDeptName %></option>
<%
					}
%>
					</select>
				</td>				
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Download_Records") %></b></td>
				<td class="input" width="35%">
					<input type="checkbox" id="downloadRecd" name="downloadRecd" value="<%= RDMServicesConstants.ROLE_MANAGER %>" <%= slReadAccess.contains(RDMServicesConstants.ROLE_MANAGER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Manager") %><br>
					<input type="checkbox" id="downloadRecd" name="downloadRecd" value="<%= RDMServicesConstants.ROLE_SUPERVISOR %>" <%= slReadAccess.contains(RDMServicesConstants.ROLE_SUPERVISOR) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Supervisor") %><br>
					<input type="checkbox" id="downloadRecd" name="downloadRecd" value="<%= RDMServicesConstants.ROLE_HELPER %>" <%= slReadAccess.contains(RDMServicesConstants.ROLE_HELPER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Helper") %><br>
					<input type="checkbox" id="downloadRecd" name="downloadRecd" value="<%= RDMServicesConstants.ROLE_TIMEKEEPER %>" <%= slReadAccess.contains(RDMServicesConstants.ROLE_TIMEKEEPER) ? "checked" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.TimeKeeper") %>
				</td>
				<td class="input" width="35%">
					<select id="downloadDept" name="downloadDept" multiple size="5">
<%
					for(int j=0; j<lDepartments.size(); j++)
					{
						sDeptName = lDepartments.get(j);
%>
						<option  value="<%= sDeptName %>" <%= slReadDepts.contains(sDeptName) ? "selected" : "" %>><%= sDeptName %></option>
<%
					}
%>
					</select>
				</td>				
			</tr>
			<tr>
				<td colspan="3" align="right">
					<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" onClick="submitForm()">&nbsp;&nbsp;&nbsp;
					<input type="button" name="Cancel" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Cancel") %>" onClick="javascript:top.window.close()">
				</td>
			</tr>
		</table>
		<input type="hidden" id="mode" name="mode" value="edit">
	</form>
</body>
</html>
