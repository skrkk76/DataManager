<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.db.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<%
String sFromDate = request.getParameter("start_date");
String sToDate = request.getParameter("end_date");
String mode = request.getParameter("mode");

MapList mlLogs = null;
if(mode != null)
{
	mlLogs = RDMServicesUtils.getUserActivityLog(sFromDate, sToDate);
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="0" cellspacing="0" width="<%= winWidth * 0.9 %>">
			<tr>
				<th class="label" width="25%"><%= resourceBundle.getProperty("DataManager.DisplayText.User") %></th>
				<th class="label" width="30%"><%= resourceBundle.getProperty("DataManager.DisplayText.Log_Details") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_On") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_Out") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Text") %></th>
			</tr>
<%
			if(mode != null)
			{	
				int iSz = mlLogs.size();
				if(iSz > 0)
				{
					Map<String, String> mLog = null;
					String sUserId = null;
					String sUserName = null;

					Map<String, String> mUsers = RDMServicesUtils.getUserNames();

					for(int i=0; i<iSz; i++)
					{
						mLog = mlLogs.get(i);
						sUserId = mLog.get(RDMServicesConstants.USER_ID);						
						sUserName = (mUsers.containsKey(sUserId) ? mUsers.get(sUserId) : "Unknown User");
%>
						<tr>
							<td class="input"><%= sUserName %>(<%= sUserId %>)</td>
							<td class="input"><%= mLog.get(RDMServicesConstants.USER_IP) %></td>
							<td class="input"><%= mLog.get(RDMServicesConstants.LOG_IN) %></td>
							<td class="input"><%= mLog.get(RDMServicesConstants.LOG_OUT) %></td>
							<td class="input"><%= mLog.get(RDMServicesConstants.LOG_TEXT) %></td>
						</tr>
<%
					}
				}
				else
				{
%>					
					<tr>
						<td class="input" style="text-align:center" colspan="5">
							<%= resourceBundle.getProperty("DataManager.DisplayText.No_Logs") %>
						</td>
					</tr>
<%
				}
			}
			else
			{
%>
				<tr>
						<td class="input" style="text-align:center" colspan="5">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Logs_Search_Msg") %>
						</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
