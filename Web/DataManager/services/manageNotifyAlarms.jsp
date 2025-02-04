<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.notify.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sCntrlType = request.getParameter("cntrlType");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>

	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
		function editNotification(alarm, group, notifyBy, notifyDuration)
		{
			var retval = window.open('updateNotifyAlarms.jsp?cntrlType=<%= sCntrlType %>&alarm='+alarm+'&group='+group+'&notifyBy='+notifyBy+'&notifyDuration='+notifyDuration, '', 'left=400,top=100,resizable=no,scrollbars=no,status=no,toolbar=no,height=200,width=500');
		}

		function addNotification()
		{
			var retval = window.open('addNotifyAlarms.jsp?cntrlType=<%= sCntrlType %>', '', 'left=400,top=100,resizable=no,scrollbars=no,status=no,toolbar=no,height=200,width=500');
		}

		function deleteNotification(alarm) 
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Notification") %>");
			if(conf == true)
			{
				parent.frames['footer'].document.location.href = "manageNotifyAlarmsProcess.jsp?cntrlType=<%= sCntrlType %>&alarm="+alarm+"&mode=delete";
			}
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="50%">
			<tr>
				<td colspan="11" style="text-align: right;"><input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Notification") %>" onClick="addNotification()"></td>
			</tr>

			<tr>
				<th class="label" width="25%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Alarm") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.NotificationGroup") %></th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_By") %></th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Duration") %>
					&nbsp;(<%= resourceBundle.getProperty("DataManager.DisplayText.Minutes") %>)</th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			Map<String, String> mAlarm = null;
			int iNotifyDuration = 0;
			String sAlarm = "";
			String sGroup = "";
			String sNotifyBy = "";
			Map<String, String> mUserNames = RDMServicesUtils.getUserNames(false);
			
			NotifyAlarms notifyAlarms = new NotifyAlarms();
			Map<String, Map<String, String>> mAlarms = notifyAlarms.listNotificationAlarms(sCntrlType);
			List<String> lAlarms = new ArrayList<String>(mAlarms.keySet());
			Collections.sort(lAlarms, String.CASE_INSENSITIVE_ORDER);
			
			for(int i=0; i<lAlarms.size(); i++)
			{
				sAlarm = lAlarms.get(i);
				mAlarm = mAlarms.get(sAlarm);
				sGroup = mAlarm.get(RDMServicesConstants.ALARM_GROUP);
				sNotifyBy = mAlarm.get(RDMServicesConstants.NOTIFY_BY);
				iNotifyDuration = Integer.parseInt(mAlarm.get(RDMServicesConstants.NOTIFY_DURATION));
%>
				<tr>
					<td class="input"><%= sAlarm %></td>
					<td class="input"><%= sGroup %></td>
					<td class="input"><%= sNotifyBy %></td>
					<td class="input"><%= iNotifyDuration %></td>

					<td class="input" style="text-align:center">
						<a href="javascript:editNotification('<%= sAlarm %>', '<%= sGroup %>', '<%= sNotifyBy %>', '<%= iNotifyDuration %>')">
						<img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteNotification('<%= sAlarm %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
