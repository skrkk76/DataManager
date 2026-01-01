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
		function saveParams()
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
			else
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_From_date") %>");
				return false;
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
			else
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_To_date") %>");
				return false;
			}
			
			document.getElementById('msg').innerHTML = "<%= resourceBundle.getProperty("DataManager.DisplayText.Do_not_Close_Window") %>";
			document.frm.submit();
		}
	</script>
</head>

<%
	StringList slControllers = RDMSession.getControllers();

	String[] HOUR = new String[] {"00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", 
									"12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"};
	String[] MIN = new String[] {"00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"};
%>

<body>
	<form name="frm" method="post" target="hiddenFrame" action="saveControllerParamsProcess.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1">
			<tr>
				<th colspan="4"><%= resourceBundle.getProperty("DataManager.DisplayText.Save_Controller_Parameters") %></th>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></td>
				<td colspan="3">
					<select id="lstController" name="lstController">
						<option value="ALL" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All_Rooms") %></option>
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
				<td  class="label" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.From") %></td>
				<td colspan="3">
					<input type="text" size="10" id="start_date" name="start_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('a', 'start_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('start_date').value=''"><img src="../images/clear.png"></a>
				</td>
			</tr>
			<tr>
				<td class="label">HH</td>
				<td>
					<select id="start_hr" name="start_hr">
<%					
					for(int i=0; i<HOUR.length; i++)
					{
%>
						<option value="<%= HOUR[i] %>"><%= HOUR[i] %></option>
<%
					}
%>
					</select>
				</td>
				<td class="label">MM</td>
				<td>
					<select id="start_min" name="start_min">
<%					
					for(int i=0; i<MIN.length; i++)
					{
%>
						<option value="<%= MIN[i] %>"><%= MIN[i] %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label" id="b"><%= resourceBundle.getProperty("DataManager.DisplayText.To") %></td>
				<td colspan="3">
					<input type="text" size="10" id="end_date" name="end_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('b', 'end_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('end_date').value=''"><img src="../images/clear.png"></a>
				</td>
			</tr>
			<tr>
				<td class="label">HH</td>
				<td>
					<select id="end_hr" name="end_hr">
<%					
					for(int i=0; i<HOUR.length; i++)
					{
%>
						<option value="<%= HOUR[i] %>"><%= HOUR[i] %></option>
<%
					}
%>
					</select>
				</td>
				<td class="label">MM</td>
				<td>
					<select id="end_min" name="end_min">
<%					
					for(int i=0; i<MIN.length; i++)
					{
%>
						<option value="<%= MIN[i] %>"><%= MIN[i] %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<input type="button" name="saveCntrlData" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save_Data") %>" onClick="saveParams()">
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4"><div id="msg"></div></td>
			</tr>
		</table>
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
