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
String sRoom = request.getParameter("lstController");
String sStage = request.getParameter("lstStage");
String BNo = request.getParameter("BatchNo");
String[] saAlarmTypes = request.getParameterValues("lstTypes");
String sFromDate = request.getParameter("start_date");
String sToDate = request.getParameter("end_date");
String showOpenAlarms = request.getParameter("openAlarms");
String mode = request.getParameter("mode");
MapList mlAlarms = null;

StringBuilder sbTypes = new StringBuilder();
if(saAlarmTypes != null)
{
	for(int i=0; i<saAlarmTypes.length; i++)
	{
		if(i > 0)
		{
			sbTypes.append(",");
		}
		sbTypes.append(saAlarmTypes[i]);
	}
}

BNo = ((BNo == null) ? "" : BNo.trim());
BNo = BNo.replaceAll("\\s", ",").replaceAll(",,", ",");

String limit = request.getParameter("limit");
int iLimit = 0;
if(limit != null && !"".equals(limit))
{
	iLimit = Integer.parseInt(limit.trim());
}

if(mode != null)
{	
	Alarms alarms = new Alarms();
	mlAlarms = alarms.getAlarmLogHistory(u, sRoom, sStage, BNo, sbTypes.toString(), sFromDate, sToDate, showOpenAlarms, iLimit);
}

Map<String, String> mUsers = RDMServicesUtils.getUserNames();

boolean bHideRoomView = !(u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
	function exportAlarms()
	{
		var url = "../ExportAlarms";
		url += "?lstController=<%= sRoom %>";
		url += "&lstTypes=<%= sbTypes.toString() %>";
		url += "&lstStage=<%= sStage %>";
		url += "&BatchNo=<%=  BNo %>"; 
		url += "&start_date=<%= sFromDate %>";
		url += "&end_date=<%= sToDate %>";
		url += "&openAlarms=<%= showOpenAlarms %>";
		url += "&limit=<%= iLimit %>";

		parent.frames['hidden'].document.location.href =  url;
	}
	
	function muteAlarm(roomId, serialId)
	{
		parent.frames['hidden'].document.location.href = "alarmClear.jsp?roomId="+roomId+"&serialId="+serialId+"&mute=Yes";
	}
	
	function closeAlarm(roomId, serialId)
	{
		parent.frames['hidden'].document.location.href = "alarmClear.jsp?roomId="+roomId+"&serialId="+serialId+"&clearAll=No";
	}
	
	function closeAll()
	{
		parent.frames['hidden'].document.location.href = "alarmClear.jsp?roomId=<%= sRoom %>&stage=<%= sStage %>&batch=<%= BNo %>&types=<%= sbTypes.toString() %>&fromDt=<%= sFromDate %>&toDt=<%= sToDate %>&clearAll=Yes";
	}
	
	function openController(sCntrl)
	{
		if(sCntrl == "General")
		{
			parent.document.location.href = "generalParamsView.jsp?controller="+sCntrl;
		}
		else
		{
			parent.document.location.href = "singleRoomView.jsp?controller="+sCntrl;
		}
	}
	</script>
</head>

<body>
	<table border="0" cellpadding="0" cellspacing="0" width="<%= winWidth * 0.65 %>">
<%
		if(mlAlarms != null && mlAlarms.size() > 0)
		{
			if(RDMServicesConstants.ROLE_ADMIN.equals(u.getRole()))
			{
%>	
				<tr>
					<td colspan="5" align="left">
						<input type="button" id="clearAlarms" name="clearAlarms" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Close_All_Alarms") %>" onClick="closeAll()">
					</td>
					<td>
						&nbsp;
					</td>
					<td colspan="5" align="right">
						<input type="button" id="expAlarms" name="expAlarms" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Export_to_File") %>" onClick="exportAlarms()">
					</td>
				</tr>
<%
			}
			else
			{
%>
				<tr>
					<td colspan="11" align="right">
						<input type="button" id="expAlarms" name="expAlarms" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Export_to_File") %>" onClick="exportAlarms()">
					</td>
				</tr>
<%
			}
		}
%>			
		<tr>
			<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Room_No") %></th>
			<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Stage") %></th>
			<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></th>
			<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Serial_No") %></th>
			<th class="label" width="17%"><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></th>
			<th class="label" width="12%"><%= resourceBundle.getProperty("DataManager.DisplayText.Occurred_On") %></th>
			<th class="label" width="12%"><%= resourceBundle.getProperty("DataManager.DisplayText.Cleared_On") %></th>
			<th class="label" width="14%"><%= resourceBundle.getProperty("DataManager.DisplayText.Accepted_By") %>
			&nbsp;/<br><%= resourceBundle.getProperty("DataManager.DisplayText.Muted_By") %></th>
			<th class="label" width="12%"><%= resourceBundle.getProperty("DataManager.DisplayText.Last_Notified") %>
			<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Close_Alarm") %></th>
			<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Mute_Alarm") %></th>
		</tr>
<%
		if(mode != null)
		{
			int iSz = mlAlarms.size();
			if(iSz > 0)
			{
				Map<String, String> mLog = null;
				String sRoomId = null;
				String sSerialId = null;
				String sClearedOn = null;
				String sAcceptedBy = null;
				String sMutedBy = null;
				String sBatchNo = null;
				String sLastNotified = null;
				StringList slInactiveCntrl = RDMSession.getInactiveControllers();

				for(int i=0; i<iSz; i++)
				{
					mLog = mlAlarms.get(i);
					sRoomId = mLog.get(RDMServicesConstants.ROOM_ID);
					sSerialId = mLog.get(RDMServicesConstants.SERIAL_ID);
					sClearedOn = mLog.get(RDMServicesConstants.CLEARED_ON);
					sAcceptedBy = mLog.get(RDMServicesConstants.ACCEPTED_BY);
					if(mUsers.containsKey(sAcceptedBy))
					{
						sAcceptedBy = mUsers.get(sAcceptedBy);
					}
					sMutedBy = mLog.get(RDMServicesConstants.MUTED_BY);
					if(mUsers.containsKey(sMutedBy))
					{
						sMutedBy = mUsers.get(sMutedBy);
					}
					sLastNotified = mLog.get(RDMServicesConstants.LAST_NOTIFIED);
					if(!"".equals(sLastNotified))
					{
						if(!"0".equals(mLog.get(RDMServicesConstants.LEVEL3_ATTEMPTS)))
						{
							sLastNotified = sLastNotified + "<br>(Level 3)";
						}
						else if(!"0".equals(mLog.get(RDMServicesConstants.LEVEL2_ATTEMPTS)))
						{
							sLastNotified = sLastNotified + "<br>(Level 2)";
						}
						else if(!"0".equals(mLog.get(RDMServicesConstants.LEVEL1_ATTEMPTS)))
						{
							sLastNotified = sLastNotified + "<br>(Level 1)";
						}
					}
					sBatchNo = mLog.get(RDMServicesConstants.BATCH_NO);
					sBatchNo = (sBatchNo.startsWith("auto_") ? "" : sBatchNo);
%>
					<tr>
<%
						if(slInactiveCntrl.contains(sRoomId) || bHideRoomView)
						{
%>
							<td class="input"><%= sRoomId %></td>
<%
						}
						else
						{
%>
							<td class="input"><a href="javascript:openController('<%= sRoomId %>')"><%= sRoomId %></a></td>
<%
						}
%>						
						<td class="input"><%= mLog.get(RDMServicesConstants.STAGE_NUMBER) %></td>
						<td class="input"><%= sBatchNo %></td>
						<td class="input"><%= sSerialId %></td>
						<td class="input"><%= mLog.get(RDMServicesConstants.ALARM_TEXT) %></td>
						<td class="input"><%= mLog.get(RDMServicesConstants.OCCURED_ON) %></td>
						<td class="input"><%= sClearedOn %></td>
						<td class="input"><%= (!"".equals(sAcceptedBy) ? sAcceptedBy : sMutedBy) %></td>
						<td class="input"><%= sLastNotified %></td>
<%
						if("".equals(sClearedOn))
						{
%>
							<td class="input" style="text-align:center"><a href="javascript:closeAlarm('<%= sRoomId %>', '<%= sSerialId %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a></td>
<%
						}
						else
						{
%>
							<td class="input">&nbsp;</td>
<%
						}

						if("TRUE".equals(mLog.get(RDMServicesConstants.NOTIFY_ALARM)) && "".equals(sMutedBy) && "".equals(sClearedOn))
						{
%>
							<td class="input" style="text-align:center"><a href="javascript:muteAlarm('<%= sRoomId %>', '<%= sSerialId %>')"><img border="0" src="../images/mute.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Mute") %>"></a></td>
<%
						}
						else
						{
%>
							<td class="input">&nbsp;</td>
<%
						}
%>
						
					</tr>
<%
				}
			}
			else
			{
%>					
				<tr>
					<td class="input" style="text-align:center" colspan="11">
						<%= resourceBundle.getProperty("DataManager.DisplayText.No_Alarms") %>
					</td>
				</tr>
<%
			}
		}
		else
		{
%>
			<tr>
					<td class="input" style="text-align:center" colspan="11">
						<%= resourceBundle.getProperty("DataManager.DisplayText.Alarms_Search_Msg") %>
					</td>
			</tr>
<%
		}
%>
	</table>
</body>
</html>
