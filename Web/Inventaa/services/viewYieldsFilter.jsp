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
		function setDate()
		{			
			var today = new Date();
			today.setDate(today.getDate()+2);	

			var dd1 = today.getDate();
			if(dd1 < 10)
			{
				dd1 = '0' + dd1;
			}
			
			var mm1 = today.getMonth() + 1;
			if(mm1 < 10)
			{
				mm1 = '0' + mm1;
			}
			
			var yy1 = today.getFullYear();
			
			var date = new Date();
			date.setDate(date.getDate()-5);	
			
			var dd2 = date.getDate();
			if(dd2 < 10)
			{
				dd2 = '0' + dd2;
			}
			
			var mm2 = date.getMonth() + 1;
			if(mm2 < 10)
			{
				mm2 = '0' + mm2;
			}
			
			var yy2 = date.getFullYear();

			document.getElementById('end_date').value = dd1 + "-" + mm1 + "-" + yy1;
			document.getElementById('start_date').value = dd2 + "-" + mm2 + "-" + yy2;
		}
		
		function showYields()
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
				
				if(fg)
				{
					if (date1 > date2)
					{
						alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Start_date_Invalid") %>");
						return false;
					}
				}
			}
			
			var yield = document.getElementById('yield').value;
			if(yield != "")
			{
				if(isNaN(yield))
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Yield_NAN") %>");
					return false;
				}				
			}
			
			document.frm.target = "results";
			document.frm.submit();
		}
	</script>
</head>

<%
	StringList slControllers = RDMSession.getControllers();
	slControllers.addAll(RDMSession.getInactiveControllers());
	slControllers.sort();
%>

<body onLoad="setDate()">
	<form name="frm" method="post" target="results" action="viewYieldsResult.jsp">
		<table border="0" cellpadding="1" cellspacing="1">
			<tr>
				<th class="label" colspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Search_Yields") %></th>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></td>
				<td>
					<select id="lstController" name="lstController" multiple size="5">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.All_Rooms") %></option>
						<optgroup label="<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Rooms") %>">
<%
						String sCntrl = "";
						for(int i=0; i<slControllers.size(); i++)
						{
							sCntrl =  slControllers.get(i);
							if(!RDMServicesUtils.isGeneralController(sCntrl))
							{
%>
								<option value="<%= sCntrl %>" ><%= sCntrl %></option>
<%
							}
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %><br>
					<font color="blue">(<%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No_New_line") %>)</font>
				</td>
				<td>
					<textarea id="BatchNo" name="BatchNo" rows="5" cols="15"></textarea>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Yield") %></td>
				<td nowrap>
					<select id="cond" name="cond">
						<option value="equals"></option>
						<option value="morethan"><%= resourceBundle.getProperty("DataManager.DisplayText.More_Than") %></option>
						<option value="lessthan"><%= resourceBundle.getProperty("DataManager.DisplayText.Less_Than") %></option>&nbsp;
					</select>
					<input type="text" id="yield" name="yield" value="" size="5">
				</td>
			</tr>
			<tr>
				<td class="label" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.From_Date") %></td>
				<td>
					<input type="text" size="10" id="start_date" name="start_date" readonly>
					<a href="#" onClick="setYears(2000, 2025);showCalender('a', 'start_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('start_date').value=''"><img src="../images/clear.png"></a>
				</td>
			</tr>
			<tr>
				<td class="label" id="b"><%= resourceBundle.getProperty("DataManager.DisplayText.To_Date") %></td>
				<td>
					<input type="text" size="10" id="end_date" name="end_date" readonly>
					<a href="#" onClick="setYears(2000, 2025);showCalender('b', 'end_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('end_date').value=''"><img src="../images/clear.png"></a>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Group_By") %></td>
				<td nowrap>
					<input type="radio" name="groupBy" id="groupBy" value="batch">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Batch") %>
					&nbsp;&nbsp;
					<input type="radio" name="groupBy" id="groupBy" value="date" checked>
					<%= resourceBundle.getProperty("DataManager.DisplayText.Date") %>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="left">
					<input type="button" name="ViewYields" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Show_Yields") %>" onClick="showYields()">
				</td>
			</tr>
		</table>
		<input type="hidden" id="mode" name="mode" value="searchYields">
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
