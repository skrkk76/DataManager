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
UserTasks userTasks = new UserTasks();
Map<String, MapList> mTaskProductivity = userTasks.getProductivity();

double productivity;
long totalTime;
String sUserId = null;
Map<String, String> mProductivity = null;
Map<String, String> mUserNames = RDMServicesUtils.getUserNames();
DecimalFormat df = new DecimalFormat("#.###");

java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MMM-yyyy HH:mm");
String sDate = sdf.format(Calendar.getInstance().getTime());
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
	<meta http-equiv="refresh" content="300;url=userProductivity.jsp">
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<style>
		td.label
		{
			text-align: center;
			background-color: #888888;
			color: #ffffff;
			font-size:16px;
			font-weight:bold;
			font-family:Arial,sans-serif;
		}
		td.text
		{
			text-align: center;
			background-color: #008080;
			color: #ffffff;
			font-size:14px;
			font-weight:bold;
			font-family:Arial,sans-serif;
		}
		th.text
		{
			text-align: center;
			background-color: #ff0000;
			color: #ffffff;
			font-size:15px;
			font-weight:bold;
			font-family:Arial,sans-serif;
		}
	</style>

	<script language="javascript">
	
	</script>
</head>

<body>
	<table border="0" cellpadding="0" align="center" cellspacing="1" width="85%">
<%
		String sTask;
		MapList mlProductivity = null;
		
		Iterator<String> itr = mTaskProductivity.keySet().iterator();
		while(itr.hasNext())
		{
			sTask = itr.next();
			mlProductivity = mTaskProductivity.get(sTask);
%>
			<tr>
				<th class="text" style="text-align:left" colspan="5"><%= sTask.toUpperCase() %></th>
				<th class="text" style="text-align:right"><%= sDate %></th>
			</tr>			
			<tr>
				<td class="label" width="5%">Top 5</td>
<%			
			int i=0;
			int iSz = mlProductivity.size();
			for(; i<iSz; i++)
			{
				if(i < 5)
				{
					mProductivity = mlProductivity.get(i);
					sUserId = mProductivity.get(RDMServicesConstants.ASSIGNEE);
					totalTime = Long.parseLong(mProductivity.get(RDMServicesConstants.DURATION));
					productivity = Double.parseDouble(mProductivity.get(RDMServicesConstants.PRODUCTIVITY));
%>
					<td>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="text" height="120" width="200">
									<img src="../UserImages/<%= sUserId %>.jpg" height="120" width="150">
								</td>
							</tr>
							<tr>
								<td class="text" width="200">
									<%= mUserNames.get(mProductivity.get(RDMServicesConstants.ASSIGNEE)) %>
								</td>
							</tr>
							<tr>
								<td class="text" width="200">
									<%= (totalTime / 60) + " hr : " + (totalTime % 60) + " mm" %>
								</td>
							</tr>
							<tr>
								<td class="text" width="200">
									<%= df.format(productivity) %> kg
								</td>
							</tr>
						</table>
					</td>
<%			
				}
			}
%>
			</tr>			
			<tr>
				<td class="label" width="5%">Last 5</td>
<%
			i = iSz - 5;
			i = ((i < 5) ? 5 : i);
			for(; i<iSz; i++)
			{
				mProductivity = mlProductivity.get(i);
				sUserId = mProductivity.get(RDMServicesConstants.ASSIGNEE);
				totalTime = Long.parseLong(mProductivity.get(RDMServicesConstants.DURATION));
				productivity = Double.parseDouble(mProductivity.get(RDMServicesConstants.PRODUCTIVITY));
%>
				<td>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td class="text" height="120" width="200">
								<img src="../UserImages/<%= sUserId %>.jpg" height="120" width="150">
							</td>
						</tr>
						<tr>
							<td class="text" width="200">
								<%= mUserNames.get(mProductivity.get(RDMServicesConstants.ASSIGNEE)) %>
							</td>
						</tr>
						<tr>
							<td class="text" width="200">
								<%= (totalTime / 60) + " hr : " + (totalTime % 60) + " mm" %>
							</td>
						</tr>
						<tr>
							<td class="text" width="200">
								<%= df.format(productivity) %> kg
							</td>
						</tr>
					</table>
				</td>
<%			
			}
%>
			</tr>
<%
		}
		
		if(mTaskProductivity.isEmpty())
		{
%>
			<tr>
				<td class="text">
					<%= resourceBundle.getProperty("DataManager.DisplayText.No_In_Progress_Tasks") %>
				</td>
			</tr>
<%
		}
%>
	</table>
</body>
</html>
