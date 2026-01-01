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
	<link type="text/css" href="../styles/superTables.css" rel="stylesheet" />
	<script language="javaScript" type="text/javascript" src="../scripts/calendar.js"></script>
	<script language="javascript">		
		var idx = 0;
		function showGraph()
		{
			var val = validate();
			if(val)
			{
				idx = idx + 1;
				document.frm.target = "POPUPW_"+idx;
				POPUPW = window.open('about:blank','POPUPW_'+idx,'menubar=no,toolbar=no,location=no,resizable=yes,scrollbars=yes,status=no,height=<%= winHeight * 0.85 %>px,width=<%= winWidth * 0.90 %>px');			
				document.frm.submit();
			}
			
			return false;
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
		
		function validate()
		{
			if(document.getElementById('lstController').value == "")
			{
				alert("Please select a Room");
				return false;
			}
			
			if(document.getElementById('lstParams').value == "")
			{
				alert("Please select the Parameters");
				return false;
			}
			
			if(document.getElementById('start_date').value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select_StartDate") %>");
				return false;
			}
			
			if(document.getElementById('end_date').value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select_EndDate") %>");
				return false;
			}
			
			var startDt = document.getElementById("start_date").value;
			var endDt = document.getElementById("end_date").value;
			var dt1  = parseInt(startDt.substring(0,2),10); 
			var mon1 = parseInt(startDt.substring(3,5),10);
			var yr1  = parseInt(startDt.substring(6,10),10); 
			var dt2  = parseInt(endDt.substring(0,2),10); 
			var mon2 = parseInt(endDt.substring(3,5),10); 
			var yr2  = parseInt(endDt.substring(6,10),10); 
			mon1 = mon1 - 1;
			mon2 = mon2 - 1;
			var date1 = new Date(yr1, mon1, dt1); 
			var date2 = new Date(yr2, mon2, dt2); 
			var today = new Date(); 

			if((date1 > today) || (date2 > today))
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Date_Invalid") %>");
				return false;
			}

			if (date1 > date2)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Start_date_Invalid") %>");
				return false;
			}
			
			return true;
		}
		
		function loadSavedParams()
		{
			var name = document.getElementById('lstGraphs').value;
			var type = document.getElementById('cntrlType').value;
			if(name != "")
			{
				parent.frames['hidden'].location.href = "loadSavedGraphParams.jsp?name="+name+"&type="+type;
			}
			else
			{
				document.getElementById('cntrlType').value = "";
				
				var rooms = document.getElementById('lstController');
				for(i=0; i<rooms.length; i++)
				{
					if(rooms[i].value == "")
					{
						rooms[i].selected = true;
					}
					else
					{
						rooms[i].selected = false;
					}
				}

				var lstParams = document.getElementById('lstParams');
				if(lstParams.options != null)
				{
					while(lstParams.options.length > 0)
					{
						lstParams.remove(0);
					}
				}
			}
		}
		
		function loadGraphParams()
		{
			var name = document.getElementById('lstController').value;
			var type = document.getElementById('cntrlType').value;
			if(name != "")
			{
				parent.frames['hidden'].location.href = "loadGraphParams.jsp?name="+name+"&type="+type;
			}
			else
			{
				document.getElementById('cntrlType').value = "";
				
				var graphs = document.getElementById('lstGraphs');
				for(i=0; i<graphs.length; i++)
				{
					if(graphs[i].value == "")
					{
						graphs[i].selected = true;
					}
					else
					{
						graphs[i].selected = false;
					}
				}

				var lstParams = document.getElementById('lstParams');
				if(lstParams.options != null)
				{
					while(lstParams.options.length > 0)
					{
						lstParams.remove(0);
					}
				}
			}
		}
		
		function deleteGraph()
		{
			var name = document.getElementById('lstGraphs').value;
			if(name == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Delete_Graph") %>");
				return;
			}

			parent.frames['hidden'].location.href = "deleteSavedGraph.jsp?savedGraph="+name;
		}
		
		function setSelected()
		{
			if(document.frm.yield.checked)
			{
				document.frm.yield.value = "Yes";
			}
			else
			{
				document.frm.yield.value = "No";
			}			
		}
	</script>
</head>

<%
	StringList slControllers = RDMSession.getControllers(u);	
	StringList slGraphs = u.getSavedGraphs();
%>

<body onLoad="setDate()">
	<form name="frm" method="post" action="showAttrDataGraph.jsp">
		<input type="hidden" id="cntrlType" name="cntrlType" value="">
		<table border="0" cellpadding="1" cellspacing="1">
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Saved_Graphs") %></td>
				<td class="input">
					<select id='lstGraphs' name='lstGraphs' onChange="loadSavedParams()">
						<option value="" ><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
<%
						String sGraph = "";
						for(int i=0; i<slGraphs.size(); i++)
						{
							sGraph = slGraphs.get(i);
%>
							<option value="<%= sGraph %>"><%= sGraph %></option>
<%
						}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></td>
				<td class="input">
					<select id="lstController" name="lstController" onChange="loadGraphParams()">
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
				<td class="label" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.Start_Date") %></td>
				<td class="input">
					<input type="text" size="10" id="start_date" name="start_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('a', 'start_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('start_date').value=''"><img src="../images/clear.png"></a>
				</td>
			</tr>
			<tr>
				<td class="label" id="b"><%= resourceBundle.getProperty("DataManager.DisplayText.End_Date") %></td>
				<td class="input">
					<input type="text" size="10" id="end_date" name="end_date" readonly>
					<a href="#" onClick="setYears(2000, 2050);showCalender('b', 'end_date');"><img src="../images/calender.png"></a>
					<a href="#" onClick="javascript:document.getElementById('end_date').value=''"><img src="../images/clear.png"></a>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Show_Yield") %></td>
				<td class="input">
					<input type="checkbox" id="yield" name="yield" value="No" onClick="javascript:setSelected()">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Yes") %>
				</td>
			</tr>
			<tr>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Parameters") %></td>
				<td class="text">
					<select id="lstParams" name="lstParams" size="25" style="width:200px" multiple>
					</select>
				</td>
			</tr>						
			<tr>
				<td class="label" rowspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Save_Graph_As") %></td>
				<td class="input">
					<input type="radio" id="access" name="access" value="Public"><%= resourceBundle.getProperty("DataManager.DisplayText.Public") %>
					<input type="radio" id="access" name="access" value="Private" checked><%= resourceBundle.getProperty("DataManager.DisplayText.Private") %>
				</td>
			</tr>
			<tr>
				<td class="input">
					<input type="text" size="25" id="saveAs" name="saveAs" value="">
				</td>
			</tr>
			<tr>
				<td align="left">
					<input type="button" name="ShowGraph" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Show_Graph") %>" onClick="showGraph()">
				</td>
				<td align="right">
					<input type="button" name="DeleteGraph" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Graph") %>" onClick="deleteGraph()">
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
</body>
</html>
