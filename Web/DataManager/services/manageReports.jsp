<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.reports.*" %>

<%@include file="commonUtils.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>

	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">		
		function editReport(report)
		{			
			var retval = window.open('updateReports.jsp?report='+report, '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=610,width=450');
		}

		function addReport()
		{
			var retval = window.open('addReports.jsp', '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=610,width=450');
		}
		
		function deleteReport(report)
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Report") %>");
			if(conf == true)
			{
				parent.frames['footer'].document.location.href = "manageReportsProcess.jsp?report="+report+"&mode=delete";
			}
		}

		function downloadTemplate(report, template) 
		{
			var url = "../ExportReport";
			url += "?report="+report;
			url += "&template="+template;

			document.location.href =  url;
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="<%= winWidth * 0.8 %>">
			<tr>
				<td colspan="10" style="text-align: right;">
					<input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Report") %>" onClick="addReport()">
				</td>
			</tr>
			<tr>
				<th class="label" width="15%" rowspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Report") %></th>
				<th class="label" width="15%" rowspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></th>
				<th class="label" width="20%" colspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Add_Record") %></th>
				<th class="label" width="20%" colspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Update_Record") %></th>	
				<th class="label" width="20%" colspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Download_Records") %></th>	
				<th class="label" width="10%" rowspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
			<tr>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Role") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Departments") %></th>	
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Role") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Departments") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Role") %></th>	
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Departments") %></th>						
			</tr>
<%
			Map<String, String> mReport = null;
			String sReport = "";
			String sTemplate = "";
			String sDescription = "";
			String sReadAccess = "";
			String sWriteAccess = "";
			String sModifyAccess = "";
			String sReadDept = "";
			String sWriteDept = "";
			String sModifyDept = "";
			
			ReportDAO reportDAO = new ReportDAO();
			MapList mlReports = reportDAO.getReports(u.getUser());

			for(int i=0; i<mlReports.size(); i++)
			{
				mReport = mlReports.get(i);
				sReport = mReport.get(RDMServicesConstants.REPORT);
				sTemplate = mReport.get(RDMServicesConstants.TEMPLATE);
				sDescription = mReport.get(RDMServicesConstants.DESCRIPTION);
				sReadAccess = mReport.get(RDMServicesConstants.READ_ACCESS);
				sWriteAccess = mReport.get(RDMServicesConstants.WRITE_ACCESS);
				sModifyAccess = mReport.get(RDMServicesConstants.MODIFY_ACCESS);
				sReadDept = mReport.get(RDMServicesConstants.READ_DEPT);
				sWriteDept = mReport.get(RDMServicesConstants.WRITE_DEPT);
				sModifyDept = mReport.get(RDMServicesConstants.MODIFY_DEPT);
%>
				<tr>
					<td class="input"><%= sReport %></td>
					<td class="input"><%= sDescription %></td>
					<td class="input"><%= sWriteAccess.replaceAll("\\|", "<br>") %></td>
					<td class="input"><%= sWriteDept.replaceAll("\\|", "<br>") %></td>
					<td class="input"><%= sModifyAccess.replaceAll("\\|", "<br>") %></td>
					<td class="input"><%= sModifyDept.replaceAll("\\|", "<br>") %></td>
					<td class="input"><%= sReadAccess.replaceAll("\\|", "<br>") %></td>
					<td class="input"><%= sReadDept.replaceAll("\\|", "<br>") %></td>
					
					<td class="input" style="text-align:center">
						<a href="javascript:downloadTemplate('<%= sReport %>', '<%= sTemplate %>')"><img border="0" src="../images/attachments.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Download") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:editReport('<%= sReport %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteReport('<%= sReport %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
