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
		
		function editNotificationGroup(name, notifyFirst, notifySecond, notifyThird, level1Duration, level2Duration, level3Duration)
		{
			var retval = window.open('updateNotificationGroup.jsp?name='+name+'&notifyFirst='+notifyFirst+'&notifySecond='+notifySecond+'&notifyThird='+notifyThird+'&level1Duration='+level1Duration+'&level2Duration='+level2Duration+'&level3Duration='+level3Duration, '', 'left=400,top=100,resizable=no,scrollbars=no,status=no,toolbar=no,height=300,width=500');
		}
		
		function addNotificationGroup()
		{
			var retval = window.open('addNotificationGroup.jsp', '', 'left=400,top=100,resizable=no,scrollbars=no,status=no,toolbar=no,height=300,width=500');
		}
		
		function deleteNotificationGroup(name)
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_NotificationGroup") %>");
			if(conf == true)
			{
				parent.frames['footer'].document.location.href = "manageNotificationGroupProcess.jsp?name="+name+"&mode=delete";
			}
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="90%">
			<tr>
				<td colspan="8" style="text-align: right;"><input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_NotificationGroup") %>" onClick="addNotificationGroup()"></td>
			</tr>
			<tr>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Name") %></th>
				<th class="label" width="13%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_First") %></th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_First_Attempts") %>
				<th class="label" width="13%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Second") %></th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Second_Attempts") %>
				<th class="label" width="13%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Third") %></th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Third_Attempts") %>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			String sName = null;
			String sDesc = null;
			String sIsActive = null;
			String sNotifyFirst = "";
			String sNotifySecond = "";
			String sNotifyThird = "";
			int iLevel1Duration = 0;
			int iLevel2Duration = 0;
			int iLevel3Duration = 0;
			
			Map<String, String> mNotificationGroup = null;
			Map<String, String> mUserNames = RDMServicesUtils.getUserNames(false);
			MapList mlNotificationGroups = RDMServicesUtils.getNotificationGroups();
			for(int i=0; i<mlNotificationGroups.size(); i++)
			{
				mNotificationGroup = mlNotificationGroups.get(i);
				sName = mNotificationGroup.get(RDMServicesConstants.ALARM_GROUP);
				sNotifyFirst = mNotificationGroup.get(RDMServicesConstants.NOTIFY_LEVEL1);
				sNotifySecond = mNotificationGroup.get(RDMServicesConstants.NOTIFY_LEVEL2);
				sNotifySecond = (sNotifySecond == null ? "" : sNotifySecond);
				sNotifyThird = mNotificationGroup.get(RDMServicesConstants.NOTIFY_LEVEL3);
				sNotifyThird = (sNotifyThird == null ? "" : sNotifyThird);
				iLevel1Duration = Integer.parseInt(mNotificationGroup.get(RDMServicesConstants.LEVEL1_ATTEMPTS));
				iLevel2Duration = Integer.parseInt(mNotificationGroup.get(RDMServicesConstants.LEVEL2_ATTEMPTS));
				iLevel3Duration = Integer.parseInt(mNotificationGroup.get(RDMServicesConstants.LEVEL3_ATTEMPTS));
%>
				<tr>
					<td class="input"><%= sName %></td>
					<td class="input"><%= mUserNames.get(sNotifyFirst) %>&nbsp;(<%= sNotifyFirst %>)</td>
					<td class="input"><%= ((iLevel1Duration == 0) ? "" : ((iLevel1Duration == 999) ? "Infinite" : iLevel1Duration)) %></td>
					<td class="input"><%= (!"".equals(sNotifySecond) ? mUserNames.get(sNotifySecond)+"&nbsp;("+sNotifySecond+")" : "") %></td>
					<td class="input"><%= ((iLevel2Duration == 0) ? "" : ((iLevel2Duration == 999) ? "Infinite" : iLevel2Duration)) %></td>
					<td class="input"><%= (!"".equals(sNotifyThird) ? mUserNames.get(sNotifyThird)+"&nbsp;("+sNotifyThird+")" : "") %></td>
					<td class="input"><%= ((iLevel3Duration == 0) ? "" : ((iLevel3Duration == 999) ? "Infinite" : iLevel3Duration)) %></td>
					<td class="input" style="text-align:center">
						<a href="javascript:editNotificationGroup('<%= sName %>', '<%= sNotifyFirst %>', '<%= sNotifySecond %>', '<%= sNotifyThird %>', '<%= iLevel1Duration %>', '<%= iLevel2Duration %>', '<%= iLevel3Duration %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
<%
						boolean bAdmin = RDMServicesConstants.ROLE_ADMIN.equals(u.getRole());
						if(bAdmin)
						{
%>
							&nbsp;&nbsp;
							<a href="javascript:deleteNotificationGroup('<%= sName %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
<%
						}
%>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
