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
	<link type="text/css" href="../styles/calendar.css" rel="stylesheet" />
	<script language="javaScript" type="text/javascript" src="../scripts/calendar.js"></script>
	<script language="javascript">
		function setToDate()
		{
			var today = new Date();
			
			var dd = today.getDate();
			if(dd < 10)
			{
				dd = '0' + dd;
			}
			
			var mm = today.getMonth() + 1;
			if(mm < 10)
			{
				mm = '0' + mm;
			}
			
			var yy = today.getFullYear();

			document.getElementById('end_date').value = dd + "-" + mm + "-" + yy;
		}
		
		function showLogs()
		{
			var date1;
			var fg = false;
			var today = new Date();
			
			if(document.getElementById('start_date').value != "")
			{
				var startDt = document.getElementById("start_date").value;
				var dt1  = parseInt(startDt.substring(0,2),10); 
				var mon1 = parseInt(startDt.substring(3,5),10);
				var yr1  = parseInt(startDt.substring(6,10),10); 
				mon1 = mon1 - 1;
				date1 = new Date(yr1, mon1, dt1);

				if(date1 > today)
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Date_Invalid") %>");
					return false;
				}
				fg = true;
			}
			
			if(document.getElementById('end_date').value != "")
			{
				var endDt = document.getElementById("end_date").value;
				var dt2  = parseInt(endDt.substring(0,2),10); 
				var mon2 = parseInt(endDt.substring(3,5),10); 
				var yr2  = parseInt(endDt.substring(6,10),10); 
				mon2 = mon2 - 1;
				var date2 = new Date(yr2, mon2, dt2); 
				
				if(date2 > today)
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Date_Invalid") %>");
					return false;
				}
				
				if(fg)
				{
					if (date1 > date2)
					{
						alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Start_date_Invalid") %>");
						return false;
					}
				}
			}
			
			document.frm.target = "results";
			document.frm.submit();
		}
		
		function setSelected()
		{
			if(document.frm.sysLogs.checked)
			{
				document.frm.sysLogs.value = "Yes";
				document.frm.params.value = "";
				document.frm.params.disabled = true;
			}
			else
			{
				document.frm.sysLogs.value = "No";
				document.frm.params.disabled = false;
			}			
		}
	</script>
</head>

<%
	StringList slControllers = RDMSession.getControllers(u);
	Map<String, ArrayList<String[]>> mTypePhases = RDMServicesUtils.getControllerTypeStages();
%>

<body onLoad="setToDate()">
	<form name="frm" method="post" target="results" action="logResults.jsp">
		<table border="0" cellpadding="1" cellspacing="1">
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></td>
				<td>
					<select id="lstController" name="lstController">
						<option value="" ><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
<%
						String sCntrlName = "";
						for(int i=0; i<slControllers.size(); i++)
						{
							sCntrlName = slControllers.get(i);
%>
							<option value="<%= sCntrlName %>" ><%= sCntrlName %></option>
<%
						}
%>
					</select>
				</td>
			</tr>
						<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Stage") %></td>
				<td>
					<select id="lstStage" name="lstStage">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
<%
						String sPhaseSeq = "";
						String stageName = "";
						String sPhase = "";
						String sCntrlType = "";
						ArrayList<String[]> alPhases = null;

						Iterator<String> itr = mTypePhases.keySet().iterator();
						while(itr.hasNext())
						{
							sCntrlType = itr.next();
							alPhases = mTypePhases.get(sCntrlType);
%>
							<optgroup label="<%= resourceBundle.getProperty("DataManager.DisplayText."+sCntrlType) %>">
<%
							for(int i=0; i<alPhases.size(); i++)
							{
								sPhaseSeq = alPhases.get(i)[0];
								stageName = alPhases.get(i)[1];
								sPhase = (sPhaseSeq.equals(stageName) ? sPhaseSeq : stageName+"&nbsp;("+sPhaseSeq+")");
%>					
								<option value="<%= sPhaseSeq %>|<%= sCntrlType %>"><%= sPhase %></option>
<%
							}
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %><br>
					<font color="blue"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No_New_line") %></font>
				</td>
				<td>
					<textarea id="BatchNo" name="BatchNo" rows="5" cols="15"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.From_Date") %></td>
				<td>
					<input type="text" size="10" id="start_date" name="start_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('a', 'start_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('start_date').value=''"><img src="../images/clear.png"></a>
				</td>
			</tr>
			<tr>
				<td class="label" id="b"><%= resourceBundle.getProperty("DataManager.DisplayText.To_Date") %></td>
				<td>
					<input type="text" size="10" id="end_date" name="end_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('b', 'end_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('end_date').value=''"><img src="../images/clear.png"></a>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Search_Parameters") %><br>
					<font color="blue"><%= resourceBundle.getProperty("DataManager.DisplayText.Parameter_new_line") %></font>
				</td>
				<td>
					<textarea id="params" name="params" rows="5" cols="25"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.View_System_Logs") %></td>
				<td>
					<input type="checkbox" id="sysLogs" name="sysLogs" value="No" onClick="javascript:setSelected()">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Yes") %>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Limit_Results") %></td>
				<td>
					<input type="text" id="limit" name="limit" size="5" value="500">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="left">
					<input type="button" name="ViewLogs" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Show_Logs") %>" onClick="showLogs()">
				</td>
			</tr>
		</table>
		<input type="hidden" id="mode" name="mode" value="searchLogs">
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
