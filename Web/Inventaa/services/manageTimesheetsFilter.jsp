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
		function searchUsers()
		{
			if(document.getElementById('end_date').value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_End_Date") %>");
			}
			else
			{
				document.frm.target = "results";
				document.frm.submit();
			}
		}
		
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
	</script>
</head>

<body onLoad="javascript:setToDate()">
	<form name="frm" method="post" target="results" action="manageTimesheetsResults.jsp">
		<input type="hidden" id="mode" name="mode" value="search">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="70%">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.User_ID") %></b></td>
				<td class="input"><input type="text" id="userId" name="userId" value="" size="15"></td>
				
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.First_Name") %></b></td>
				<td class="input"><input type="text" id="FName" name="FName" value="" size="15"></td>

				<td class="label" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.Start_Date") %></td>
				<td class="input">
					<input type="text" size="10" id="start_date" name="start_date" readonly>
					<a href="#" onClick="setYears(2000, 2025);showCalender('a', 'start_date')"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('start_date').value=''"><img src="../images/clear.png"></a>
				</td>

				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_In") %></td>
				<td class="input">
					<input type="checkbox" id="loggedIn" name="loggedIn" value="Y" checked>
				</td>

				<td align="center">
					<input type="button" name="search" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Search_Users") %>" onClick="searchUsers()">
				</td>
			</tr>
<%
			Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
			List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
			Collections.sort(lDepartments, String.CASE_INSENSITIVE_ORDER);
			String sDeptName = null;
			StringList slUserDept = u.getDepartment();
%>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Department") %></b></td>
				<td class="input">
					<select id="dept" name="dept">
<%
					if(slUserDept.size() != 1)
					{
%>
						<option value="<%= ((slUserDept.size() == 0 || slUserDept.contains("HRM")) ? "" : slUserDept.join('|')) %>" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
					}
					else if(slUserDept.size() == 1 && slUserDept.contains("HRM"))
					{
%>
						<option value="" selected><%= resourceBundle.getProperty("DataManager.DisplayText.All") %></option>
<%
					}
					for(int j=0; j<lDepartments.size(); j++)
					{
						sDeptName = lDepartments.get(j);
						if(slUserDept.isEmpty() || slUserDept.contains("HRM") || slUserDept.contains(sDeptName))
						{
%>
							<option  value="<%= sDeptName %>"><%= sDeptName %></option>
<%
						}
					}
%>
					</select>
				</td>

				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Last_Name") %></b></td>
				<td class="input"><input type="text" id="LName" name="LName" value="" size="15"></td>

				<td class="label" id="b"><%= resourceBundle.getProperty("DataManager.DisplayText.End_Date") %></td>
				<td class="input">
					<input type="text" size="10" id="end_date" name="end_date" readonly>
					<a href="#" onClick="setYears(2000, 2025);showCalender('b', 'end_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('end_date').value=''"><img src="../images/clear.png"></a>
				</td>
				
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_Out") %></td>
				<td class="input">
					<input type="checkbox" id="loggedOut" name="loggedOut" value="Y">
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
	
	<iframe name="results" src="manageTimesheetsResults.jsp" align="middle" frameBorder="0" width="100%" height="<%= winHeight * 0.8 %>px">
</body>
</html>
