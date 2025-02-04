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
	<link type="text/css" href="../styles/calendar.css" rel="stylesheet" />
	<script language="javaScript" type="text/javascript" src="../scripts/calendar.js"></script>
	<script language="javascript">	
		function submitAction()
		{
			var selAction = "";
			var actions = document.getElementsByName('selAction');
			for(i=0; i<actions.length; i++)
			{
				if(actions[i].checked == true)
				{
					selAction = actions[i].value;
				}
			}			
			
			if(document.getElementById('report').value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Report") %>");
				return false;
			}
			
			if(selAction == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Invalid_Action") %>");
				return false;
			}
			else
			{
				if(selAction == "addRecord")
				{
					document.frm.target = "content";
					document.frm.submit();
				}
				else if(selAction == "addMultiRecords")
				{
					addMultiRecords();
				}
				else if(selAction == "downloadTemplate")
				{
					downloadTemplate();
				}
			}
		}
		
		function search()
		{		
			var selAction = "";
			var actions = document.getElementsByName('selAction');
			for(i=0; i<actions.length; i++)
			{
				if(actions[i].checked == true)
				{
					selAction = actions[i].value;
				}
			}
			
			if(document.getElementById('report').value != "" && (selAction == "getRecords" || selAction == "viewRecord" || selAction == "updateRecord"))
			{						
				var report = document.getElementById('report').value;
				var reportTemplate = report.split("|");
				
				if(selAction == "getRecords")
				{
					var access = document.getElementById(reportTemplate[0]+"_Download").value;
					if(access == "false")
					{
						resetSearch();
						alert("<%= resourceBundle.getProperty("DataManager.DisplayText.No_Download_Record_Access") %>");
						return;
					}
				}
				else if(selAction == "updateRecord")
				{					
					var access = document.getElementById(reportTemplate[0]+"_Update").value;
					if(access == "false")
					{
						resetSearch();
						alert("<%= resourceBundle.getProperty("DataManager.DisplayText.No_Update_Record_Access") %>");
						return;
					}					
				}
				
				parent.frames['search'].document.location.href = "viewReportSearchCriteria.jsp?report="+reportTemplate[0]+"&template="+reportTemplate[1]+"&action="+selAction;			
			}
		}
		
		function resetSearch()
		{			
			parent.frames['search'].document.location.href = "blank.jsp";
		}
		
		function downloadTemplate(report, template) 
		{
			var report = document.getElementById('report').value;
			var reportTemplate = report.split("|");
			
			var url = "../ExportReport";
			url += "?report="+reportTemplate[0];
			url += "&template="+reportTemplate[1];

			document.location.href =  url;
		}
		
		function addMultiRecords()
		{			
			var records = document.getElementById("records");
			if(records.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Upload_Records") %>");
				records.focus();
				return;
			}
			
			document.frm.target = "content";
			document.frm.submit();
		}
	</script>
</head>

<%
	Map<String, String> mReport = null;
	String sReport = "";
	String sTemplate = "";
	String sDescription = "";
	String sRole = u.getRole();	
	String sReadAccess = null;
	String sReadDept = null;
	String sModifyAccess = null;
	String sModifyDept = null;
	StringList slDept = u.getDepartment();
	Map<String, String> mDownloadAccess = new HashMap<String, String>();
	Map<String, String> mUpdateAccess = new HashMap<String, String>();

	ReportDAO reportDAO = new ReportDAO();
	MapList mlReports = reportDAO.getReports(u.getUser());
%>

<body>
	<form name="frm" method="post" target="content" action="addPreReportRecords.jsp" enctype="multipart/form-data">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="100%">			
			<tr>
				<td class="input"><%= resourceBundle.getProperty("DataManager.DisplayText.Report") %></td>
				<td>
					<select id="report" name="report" style="width:250px" onChange="javascript:search()">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
<%
						for(int i=0; i<mlReports.size(); i++)
						{
							mReport = mlReports.get(i);
							sReport = mReport.get(RDMServicesConstants.REPORT);
							sTemplate = mReport.get(RDMServicesConstants.TEMPLATE);
							
							sReadAccess = mReport.get(RDMServicesConstants.READ_ACCESS);
							sReadDept = mReport.get(RDMServicesConstants.READ_DEPT);
							sModifyAccess = mReport.get(RDMServicesConstants.MODIFY_ACCESS);
							sModifyDept = mReport.get(RDMServicesConstants.MODIFY_DEPT);
							
							mDownloadAccess.put(sReport, (((sReadAccess.contains(sRole) && (slDept.isEmpty() || slDept.contains(StringList.split(sReadDept, "\\|")))) || RDMServicesConstants.ROLE_ADMIN.equals(sRole)) ? "true" : "false"));
							mUpdateAccess.put(sReport, (((sModifyAccess.contains(sRole) && (slDept.isEmpty() || slDept.contains(StringList.split(sModifyDept, "\\|")))) || RDMServicesConstants.ROLE_ADMIN.equals(sRole)) ? "true" : "false"));
%>
							<option value="<%= sReport %>|<%= sTemplate %>"><%= sReport %></option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="input" width="40%"><%= resourceBundle.getProperty("DataManager.DisplayText.Action") %></td>
				<td class="text" width="60%">
<%
				if(!RDMServicesConstants.ROLE_ADMIN.equals(sRole))
				{
%>
					<input type="radio" id="selAction" name="selAction" value="addRecord" onClick="javascript:resetSearch()"><%= resourceBundle.getProperty("DataManager.DisplayText.Add_Record") %><br>
<%
					if(RDMServicesConstants.ROLE_MANAGER.equals(sRole) || RDMServicesConstants.ROLE_SUPERVISOR.equals(sRole))
					{
%>
						<input type="radio" id="selAction" name="selAction" value="addMultiRecords" onClick="javascript:resetSearch()"><%= resourceBundle.getProperty("DataManager.DisplayText.Add_Multi_Records") %><br>
<%
					}
				}
%>
					<input type="radio" id="selAction" name="selAction" value="viewRecord" onClick="javascript:search()"><%= resourceBundle.getProperty("DataManager.DisplayText.View_Record") %><br>
					
					<input type="radio" id="selAction" name="selAction" value="updateRecord" onClick="javascript:search()"><%= resourceBundle.getProperty("DataManager.DisplayText.Update_Record") %><br>
					
					<input type="radio" id="selAction" name="selAction" value="getRecords" onClick="javascript:search()"><%= resourceBundle.getProperty("DataManager.DisplayText.Download_Records") %>
<%
				if(!RDMServicesConstants.ROLE_HELPER.equals(sRole))
				{
%>
					<br>
					<input type="radio" id="selAction" name="selAction" value="downloadTemplate" onClick="javascript:resetSearch()"><%= resourceBundle.getProperty("DataManager.DisplayText.Download_Template") %>
<%
				}
%>
				</td>
			</tr>
<%
			if(RDMServicesConstants.ROLE_MANAGER.equals(sRole) || RDMServicesConstants.ROLE_SUPERVISOR.equals(sRole))
			{
%>
				<tr>
					<td class="label" colspan="2"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Add_Multi_Records") %></b></td>
				</tr>
				<tr>
					<td class="input"><%= resourceBundle.getProperty("DataManager.DisplayText.Upload_Records") %></td>
					<td>
						<input type="file" id="records" name="records" accept="application/vnd.ms-excel">
					</td>
				</tr>
				<tr>
					<td colspan="2" class="input"><b>Date Format:</b> dd-MMM-yyyy hh:mm a<br>  e.g., 14-Oct-2008 10:30 AM</td>
				</tr>
<%
			}
%>
			<tr>
				<td align="left" colspan="2">
					<input type="button" name="btn" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Submit") %>" onClick="javascript:submitAction()">
				</td>
			</tr>
		</table>
<%
		Iterator<String> itr = mDownloadAccess.keySet().iterator();
		while(itr.hasNext())
		{
			sReport = itr.next();
			sReadAccess = mDownloadAccess.get(sReport);
%>
			<input type="hidden" id="<%= sReport %>_Download" name="<%= sReport %>_Download" value="<%= sReadAccess %>">
<%
		}
		
		itr = mUpdateAccess.keySet().iterator();
		while(itr.hasNext())
		{
			sReport = itr.next();
			sModifyAccess = mUpdateAccess.get(sReport);
%>
			<input type="hidden" id="<%= sReport %>_Update" name="<%= sReport %>_Update" value="<%= sModifyAccess %>">
<%
		}
%>
	</form>
	<table id="calenderTable">
		<tbody id="calenderTableHead">
			<tr>
				<td colspan="4" align="center">
					<select onChange="showCalenderBody(createCalender(document.getElementById('selectYear').value, this.selectedIndex, false));" id="selectMonth">
						<option value="0"><%= resourceBundle.getProperty("DataManager.DisplayText.January") %></option>
						<option value="1"><%= resourceBundle.getProperty("DataManager.DisplayText.February") %></option>
						<option value="2"><%= resourceBundle.getProperty("DataManager.DisplayText.March") %></option>
						<option value="3"><%= resourceBundle.getProperty("DataManager.DisplayText.April") %></option>
						<option value="4"><%= resourceBundle.getProperty("DataManager.DisplayText.May") %></option>
						<option value="5"><%= resourceBundle.getProperty("DataManager.DisplayText.June") %></option>
						<option value="6"><%= resourceBundle.getProperty("DataManager.DisplayText.July") %></option>
						<option value="7"><%= resourceBundle.getProperty("DataManager.DisplayText.August") %></option>
						<option value="8"><%= resourceBundle.getProperty("DataManager.DisplayText.September") %></option>
						<option value="9"><%= resourceBundle.getProperty("DataManager.DisplayText.October") %></option>
						<option value="10"><%= resourceBundle.getProperty("DataManager.DisplayText.November") %></option>
						<option value="11"><%= resourceBundle.getProperty("DataManager.DisplayText.December") %></option>

					</select>
				</td>
				<td colspan="2" align="center">
					<select onChange="showCalenderBody(createCalender(this.value, document.getElementById('selectMonth').selectedIndex, false));" id="selectYear">
					</select>
				</td>
				<td align="center">
					<a href="#" onClick="closeCalender();"><font color="#003333" size="2">X</font></a>
				</td>
			</tr>
		</tbody>
		<tbody id="calenderTableDays">
			<tr style="">
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Sunday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Monday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Tuesday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Wednesday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Thursday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Friday") %></td>
				<td><%= resourceBundle.getProperty("DataManager.DisplayText.Saturday") %></td>
			</tr>
		</tbody>
		<tbody id="calender"></tbody>
	</table>
</body>
</html>
