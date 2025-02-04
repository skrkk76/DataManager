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
String[] saRooms = request.getParameterValues("lstController");
String sFromDate = request.getParameter("start_date");
String sToDate = request.getParameter("end_date");
String sCond = request.getParameter("cond");
String sYield = request.getParameter("yield");
String BNo = request.getParameter("BatchNo");
String mode = request.getParameter("mode");
String groupBy = request.getParameter("groupBy");
boolean bGrpByDate = "date".equals(groupBy);

StringBuilder sbRooms = new StringBuilder();
if(saRooms != null)
{
	for(int i=0; i<saRooms.length; i++)
	{
		if(i > 0)
		{
			sbRooms.append(",");
		}
		sbRooms.append(saRooms[i]);
	}
}

int iSz = 0;
MapList mlYields = null;
Yields yields = new Yields();
if(mode != null)
{
	BNo = ((BNo == null) ? "" : BNo.trim());
	BNo = BNo.replaceAll("\\s", ",").replaceAll(",,", ",");

	mlYields = yields.getYields(sbRooms.toString(), sFromDate, sToDate, sCond, sYield, BNo, bGrpByDate);
	iSz = mlYields.size();
}

boolean isAdmin = RDMServicesConstants.ROLE_ADMIN.equals(u.getRole());

SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
Date today = sdf.parse(sdf.format(new Date()));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>

	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
	function addYield()
	{
		var retval = window.open('manageYields.jsp?mode=add', 'Yields', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=325,width=475');
	}
	
	function deleteYield(roomId, onDate)
	{
		parent.frames['hiddenFrame'].document.location.href = "manageYieldsProcess.jsp?controller="+roomId+"&date="+onDate+"&mode=delete";
	}
	
	function editYield(roomId, onDate)
	{
		var retval = window.open('manageYields.jsp?controller='+roomId+'&date='+onDate+'&mode=edit', 'Yields', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=325,width=475');
	}
	
	function exportYields()
	{
		var url = "../ExportYields";
		url += "?lstController=<%= sbRooms.toString() %>";
		url += "&start_date=<%= sFromDate %>";
		url += "&end_date=<%= sToDate %>";
		url += "&cond=<%= sCond %>";
		url += "&yield=<%= sYield %>";
		url += "&BatchNo=<%= BNo %>";
		url += "&groupBy=<%= groupBy %>";

		document.location.href =  url;
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

	function showComments(divId)
	{
		document.getElementById(divId).style.display = "block";	
	}

	function hideComments(divId)
	{
		document.getElementById(divId).style.display = "none";
	}
	</script>
</head>

<body>
	<form name="frm">
		<table border="0" cellpadding="1" cellspacing="0" width="<%= winWidth * 0.75 %>">
			<tr>
				<td colspan="5" align="left">
					<input type="button" id="Yields" name="Yields" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Est_Yield") %>" onClick="javascript:addYield()">
				</td>
<%
			if(iSz > 0)
			{
%>
				<td colspan="4" align="right">
					<input type="button" id="expYields" name="expYields" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Export_to_File") %>" onClick="exportYields()">
				</td>
<%
			}
%>
			</tr>
			<tr>
				<th class="label" width="30%" colspan="3"><div id="estYield"></div></th>
				<th class="label" width="35%" colspan="3"><div id="actYield"></div></th>
				<th class="label" width="35%" colspan="3"><div id="packing"></div></th>
			</tr>
			<tr>
				<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></th>
				<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Stage") %></th>
				<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></th>
				<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Date") %></th>
				<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Est_Yield") %></th>
				<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Yield") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_By") %></th>
				<th class="label" width="30%"><%= resourceBundle.getProperty("DataManager.DisplayText.Comments") %></th>
				<th class="label" width="7%">&nbsp;</th>
			</tr>
<%
			if(mode != null)
			{				
				if(iSz > 0)
				{
					double dEstYield = 0.0;
					double dActYield = 0.0;
					double dTotalEstYield = 0.0;
					double dTotalActYield = 0.0;
					double[] dOverage = null;
					double[] dTotalOverage = new double[2];
					String sRoomId = "";
					String onDate = "";
					String sLoggedBy = "";
					String sEstYield = "";
					String sActYield = "";
					String sPrevDate = "";
					String sBatchNo = "";
					String sPrevBNo = "";
					String sNoDays = null;
					Map<String, String> mYield = null;
					Map<String, String> mUsers = RDMServicesUtils.getUserNames();
					StringList slInactiveCntrl = RDMSession.getInactiveControllers();
					DecimalFormat df2 = new DecimalFormat("#.###");
					DecimalFormat dfPercent = new DecimalFormat("#.##");
					SimpleDateFormat input = new SimpleDateFormat("MM/dd/yyyy", Locale.ENGLISH);
					SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);
					
					for(int i=0; i<iSz; i++)
					{
						mYield = mlYields.get(i);
						sRoomId = mYield.get(RDMServicesConstants.ROOM_ID);
						sBatchNo = mYield.get(RDMServicesConstants.BATCH_NO);
						onDate = mYield.get(RDMServicesConstants.ON_DATE);
						sLoggedBy = mYield.get(RDMServicesConstants.LOGGED_BY);
						if(mUsers.containsKey(sLoggedBy))
						{
							sLoggedBy = mUsers.get(sLoggedBy);
						}
						
						sEstYield = mYield.get(RDMServicesConstants.EST_YIELD);
						sActYield = mYield.get(RDMServicesConstants.DAILY_YIELD);
						
						sNoDays = mYield.get(RDMServicesConstants.RUNNING_DAY);
						sNoDays = ((sNoDays == null || "0".equals(sNoDays)) ? "" : " ("+sNoDays+")");

						if((bGrpByDate && !"".equals(sPrevDate) && !sPrevDate.equals(onDate))
							|| (!bGrpByDate && !"".equals(sPrevBNo) && !sPrevBNo.equals(sBatchNo)))
						{
%>
							<tr>
								<th class="label" colspan="4">&nbsp;</th>
								<th class="label"><%= df2.format(dEstYield) %></th>
								<th class="label"><%= df2.format(dActYield) %></th>
								<th class="label" colspan="3">
<%
								if(bGrpByDate && "".equals(BNo))
								{
									dOverage = yields.getPackedOverages(output.format(input.parse(sPrevDate)));
%>
									Packing:&nbsp;<%= df2.format(dOverage[0]) %>&nbsp;&nbsp;&nbsp;Overage:&nbsp;<%= df2.format(dOverage[1]) %>
										(<%= dOverage[0] == 0 ? 0 : dfPercent.format((dOverage[1] / dOverage[0]) * 100) %>%)
<%
								}
%>
								</th>
							</tr>
<%
							dTotalEstYield += dEstYield;
							dTotalActYield += dActYield;
							if(bGrpByDate && "".equals(BNo))
							{
								dTotalOverage[0] += dOverage[0];
								dTotalOverage[1] += dOverage[1];
							}
							dEstYield = 0;
							dActYield = 0;
							
							if(bGrpByDate)
							{
								sPrevDate = onDate;
							}
							else
							{
								sPrevBNo = sBatchNo;
							}
						}

						dEstYield += Double.parseDouble(sEstYield);
						dActYield += Double.parseDouble(sActYield);

						if(bGrpByDate)
						{
							if("".equals(sPrevDate))
							{
								sPrevDate = onDate;
							}
						}
						else
						{
							if("".equals(sPrevBNo))
							{
								sPrevBNo = sBatchNo;
							}
						}
%>
						<tr onmouseover="javascript:showComments('comments_<%= i %>')" onmouseout="javascript:hideComments('comments_<%= i %>')">
<%
							if(slInactiveCntrl.contains(sRoomId))
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
							<td class="input" style="text-align:center"><%= mYield.get(RDMServicesConstants.STAGE_NUMBER) %><%= sNoDays %></td>
							<td class="input"><%= sBatchNo %></td>
							<td class="input"><%= onDate %></td>
							<td class="input"><%= df2.format(Double.parseDouble(sEstYield)) %></td>
							<td class="input"><%= df2.format(Double.parseDouble(sActYield)) %></td>
							<td class="input"><%= sLoggedBy %></td>
							<td class="input">
								<div id="comments_<%= i %>" style="display:none">
									<%= mYield.get(RDMServicesConstants.COMMENTS).replaceAll("\n", "<br>") %>
								</div>
							</td>
							<td class="input" style="text-align:center">
<%
							
							if(today.compareTo(sdf.parse(onDate)) < 1)
							{
%>							
								<a href="javascript:editYield('<%= sRoomId %>', '<%= onDate %>')"><img border="0" width="20" height="20" src="../images/edit.jpg" alt	="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
<%
							}

							if(isAdmin)
							{
%>
								&nbsp;<a href="javascript:deleteYield('<%= sRoomId %>', '<%= onDate %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
<%
							}
%>
							</td>
						</tr>
<%
					}
					
					dTotalEstYield += dEstYield;
					dTotalActYield += dActYield;
%>
					<tr>
						<th class="label" colspan="4">&nbsp;</th>
						<th class="label"><%= df2.format(dEstYield) %></th>
						<th class="label"><%= df2.format(dActYield) %></th>
						<th class="label" colspan="3">
<%
						if(bGrpByDate && "".equals(BNo))
						{
							dOverage = yields.getPackedOverages(output.format(input.parse(sPrevDate)));
							dTotalOverage[0] += dOverage[0];
							dTotalOverage[1] += dOverage[1];
%>
							Packing:&nbsp;<%= df2.format(dOverage[0]) %>&nbsp;&nbsp;&nbsp;Overage:&nbsp;<%= df2.format(dOverage[1]) %>
								(<%= dOverage[0] == 0 ? 0 : dfPercent.format((dOverage[1] / dOverage[0]) * 100) %>%)
<%
						}
%>
						</th>
					</tr>
					<script language="javascript">
						document.getElementById('estYield').innerHTML = "<%= resourceBundle.getProperty("DataManager.DisplayText.Est_Yield") %>" + 
							":&nbsp;<%= df2.format(dTotalEstYield) %>";
						document.getElementById('actYield').innerHTML = "<%= resourceBundle.getProperty("DataManager.DisplayText.Yield") %>" + 
							":&nbsp;<%= df2.format(dTotalActYield) %>";
<%
						if(bGrpByDate && "".equals(BNo))
						{
%>
							document.getElementById('packing').innerHTML = "Packing:&nbsp;<%= df2.format(dTotalOverage[0]) %>&nbsp;&nbsp;&nbsp;Overage:&nbsp;<%= df2.format(dTotalOverage[1]) %>" + 
								"(<%= dfPercent.format((dTotalOverage[1] / dTotalOverage[0]) * 100) %>%)";
<%
						}
%>
					</script>
<%
				}
				else
				{
%>					
					<tr>
						<td class="input" style="text-align:center" colspan="9"><%= resourceBundle.getProperty("DataManager.DisplayText.No_Yields") %></td>
					</tr>
<%
				}
			}
			else
			{
%>
				<tr>
						<td class="input" style="text-align:center" colspan="9"><%= resourceBundle.getProperty("DataManager.DisplayText.Yields_Search_Msg") %></td>
				</tr>
<%
			}			
%>
		</table>
	</form>
</body>
</html>
