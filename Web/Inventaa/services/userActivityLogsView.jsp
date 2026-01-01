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
		function searchUserLogs()
		{
			document.frm.target = "results";
			document.frm.submit();
		}
		
		function setDate()
		{
			var today = new Date();

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
			date.setDate(date.getDate()-1);	
			
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
	</script>
</head>

<body onLoad="setDate()">
	<form name="frm" method="post" target="results" action="userActivityLogResults.jsp">
		<input type="hidden" id="mode" name="mode" value="search">
		<table align="center" border="0" cellpadding="1" cellspacing="1">
			<tr>
				<td class="label" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.From_Date") %></td>
				<td>
					<input type="text" size="10" id="start_date" name="start_date" readonly>					
					<a href="#" onClick="setYears(2000, 2050);showCalender('a', 'start_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('start_date').value=''"><img src="../images/clear.png"></a>
				</td>

				<td class="label" id="b"><%= resourceBundle.getProperty("DataManager.DisplayText.To_Date") %></td>
				<td>
					<input type="text" size="10" id="end_date" name="end_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('b', 'end_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('end_date').value=''"><img src="../images/clear.png"></a>
				</td>
				
				<td>
					<input type="button" id="search" name="search" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Show_User_Logs") %>" onClick="searchUserLogs()">
				</td>
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
	
	<iframe name="results" src="userActivityLogResults.jsp" align="middle" frameBorder="0" width="100%" height="<%= winHeight * 0.85 %>px">
</body>
</html>