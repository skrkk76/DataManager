<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sRealTime = request.getParameter("realTime");
	sRealTime = ((sRealTime == null || "".equals(sRealTime)) ? "false" : sRealTime);
	boolean bRealTime = ("true".equalsIgnoreCase(sRealTime));
	
	String sCntrlType = request.getParameter("cntrlType");
	
	String sSelRange = request.getParameter("selRange");
	int iSelRange = (sSelRange == null || "".equals(sSelRange)) ? 0 : Integer.parseInt(sSelRange);

	StringList slCntrlPhases = RDMServicesUtils.sortControllerPhases(RDMSession);
	StringList slCntrlSel = RDMSession.getControllersSelection(slCntrlPhases, 10);
	if(slCntrlSel.size() == 0)
	{
		return;
	}

	StringList slControllers = RDMSession.getControllers(iSelRange, 10, slCntrlPhases);
	Map<String, ParamSettings> mParamStgs = RDMServicesUtils.getMultiRoomViewParamaters(sCntrlType);
	ArrayList<String> displayOrder = RDMServicesUtils.getDisplayOrder(sCntrlType);

	boolean bShowSaveReset = false;
	String sRole = u.getRole();
	String sController = null;
	String[] saParamVal = null;
	String sAccess = null;
	String sParam = null;
	String sValue = null;
	String sUnit = null;
	String sStage = null;
	String sLastRefresh = null;
	Map<String, Map<String, String[]>> mAllParams = new HashMap<String, Map<String, String[]>>();
	Map<String, String[]> mParams = null;
	ParamSettings paramS = null;
	PLCServices client = null;

	boolean fg = true;
	for(int i=(slControllers.size()-1); i>=0; i--)
	{
		try
		{
			sController = slControllers.get(i);
		
			String sCntrlVersion = RDMSession.getControllerVersion(sController);
			if(com.client.util.RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion))
			{
				client = new PLCServices_oldHW(RDMSession, sController);
			}
			else if(com.client.util.RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion))
			{
				client = new PLCServices_newHW(RDMSession, sController);
			}

			mParams = client.getControllerData(bRealTime);
			mAllParams.put(sController, mParams);

			if(fg)
			{
				sLastRefresh = (mParams.containsKey("Last Refresh") ? mParams.get("Last Refresh")[0] : "");
				fg = false;
			}
		}
		catch(Exception e)
		{
			slControllers.remove(sController);
		}
	}
	
	int iSZ = slControllers.size();
	StringList slOnOffValues = RDMServicesUtils.getOnOffParams(sCntrlType);
	
	String sParams = "";
	StringList slGraphs = u.getSavedGraphs();
	
	Random randomGenerator = new Random();
	int randomInt = randomGenerator.nextInt(1000);
	
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH);
	Calendar cal = Calendar.getInstance();
	String endDate = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_YEAR, -1);
	String startDate = sdf.format(cal.getTime());
	
	NumberFormat decimalFormat = NumberFormat.getInstance(Locale.getDefault());
	decimalFormat.setMinimumFractionDigits(1);
	
	StringList userDepts = u.getDepartment();
	boolean bCanEdit = userDepts.isEmpty();
	Map<String, String> activeDepts = RDMServicesUtils.getDepartments();
	for (Map.Entry<String, String> entry : activeDepts.entrySet()) 
	{
		String dept = entry.getKey();
		String editParams = entry.getValue();
		if("Y".equals(editParams) && userDepts.contains(dept))
		{
			bCanEdit = true;
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
	<meta http-equiv="refresh" content="300;url=multiRoomView.jsp?realTime=false&selRange=<%= iSelRange %>&cntrlType=<%= sCntrlType %>">
	
	<link type="text/css" href="../styles/superTables.css" rel="stylesheet" />
	<script type="text/javascript" src="../scripts/superTables.js"></script>
	<style>
	#scrollDiv 
	{
		margin: 2px 2px; 
		width: <%= winWidth * 0.95 %>px; 
		height: <%= winHeight * 0.8 %>px; 
		overflow: hidden; 
		font-size: 0.85em;
	}
	</style>
	
	<script language="javascript">
		function refreshDetails()
		{
			var url = "multiRoomParameters.jsp?realTime=true&selRange=<%= iSelRange %>&cntrlType=<%= sCntrlType %>";
			document.location.href = url;
		}

		function changeController(obj)
		{
			document.location.href = "multiRoomParameters.jsp?realTime=false&cntrlType=<%= sCntrlType %>&selRange="+obj.value;
		}
		
		function printView()
		{
			var retval = window.open('multiRoomViewPrint.jsp?realTime=<%= sRealTime %>&selRange=<%= iSelRange %>&cntrlType=<%= sCntrlType %>', '', 'left=250,top=250,resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=800');
		}
		
		function saveChanges()
		{
			document.getElementById("loading").style.display = "block";

			var fg = false;
			var inputs = document.getElementsByTagName("input");  
			for (var i=0; i<inputs.length; i++)
			{   
				if (inputs[i].type == "checkbox")
				{   
					if (inputs[i].checked)
					{   
						fg = true;
					}
				}   
			}   
			
			if(fg)
			{
				document.forms[0].submit();
			}
			else
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Room") %>");
				document.getElementById("loading").style.display = "none";
			}
		}
		
		function addComments()
		{
			var retval = window.open('addUserComments.jsp', 'Comments', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=375,width=525');
		}
		
		function setValue(pid, obj) 
		{
			var elm = document.getElementById(pid);
			elm.value = obj.value;
		}
		
		function setOnOff(pid, obj)
		{
			var sel = obj.value;
			if(sel == "On" || sel == "1")
			{
				document.getElementById(pid).selectedIndex = 1;
				document.getElementById(pid).value = sel;
			}
			else if(sel == "Off" || sel == "0")
			{
				document.getElementById(pid).selectedIndex = 2;
				document.getElementById(pid).value = sel;
			}
			else
			{
				document.getElementById(pid).selectedIndex = 0;
				document.getElementById(pid).value = "";
			}
		}
		
		function initOnOff()
		{
			var options = document.getElementsByTagName("SELECT"); 
			for(var i=0; i<options.length; i++) 
			{
				var id = options[i].id;
				if(id != "selRange")
				{
					setOnOff(id, options[i]);
				}
			}
		}
		
		function setSelected(obj)
		{
			if(obj.checked)
			{
				obj.value = "Yes";
			}
			else
			{
				obj.value = "No";
			}
		}
		
		function showGraph(room)
		{
			document.frm2.lstController.value = room;

			var idx = "<%= randomInt %>";
			document.frm2.target = "POPUPW_"+idx;
			POPUPW = window.open('about:blank','POPUPW_'+idx,'menubar=no,toolbar=no,location=no,resizable=yes,scrollbars=yes,status=no,height=<%= winHeight * 0.85 %>px,width=<%= winWidth * 0.90 %>px');
			document.frm2.submit();
		}
	</script>
<%
	if(bCanEdit)
	{
%>
	<script type="text/javascript">
		//<![CDATA[
		document.onkeypress = enter;
		function enter(e)
		{
			if (e.keyCode == 13)
			{
				document.getElementById('Save').focus();
				saveChanges();
			}
		}
		//]]>
	</script>
<%
	}
%>
</head>

<body onLoad="javascript:initOnOff()">
	<table border="0" cellpadding="0" cellspacing="0" width="95%">
		<tr>
			<td style="font-family:Arial; font-size:0.8em; font-weight:bold; border:#ffffff; text-align:left">
				<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Rooms") %>:&nbsp;
				<select id="selRange" name="selRange" onChange="javascript:changeController(this)">
<%
				for(int i=0; i<slCntrlSel.size(); i++)
				{
%>
					<option value="<%= i %>" <%= (i == iSelRange ? "selected" : "") %>><%= slCntrlSel.get(i) %></option>
<%
				}
%>
				</select>
			</td>

			<td style="font-family:Arial; font-size:0.8em; font-weight:bold; border:#ffffff; text-align:right">
				<div id="loading" style="display:none"><image src="../images/loading_icon.gif"></div>
				<input type="button" id="Comments" name="Comments" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Comments") %>" onClick="javascript:addComments()">
<%
				if(bCanEdit)
				{
%>
					<input type="button" id="Save" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save_Changes") %>" onClick="javascript:saveChanges()">
<%
				}
%>
				<input type="button" id="Refresh" name="Refresh" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Reload_Values") %>" onClick="javascript:refreshDetails()">
				<input type="button" id="Print" name="Print" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Print") %>" onClick="javascript:printView()">
			</td>
		</tr>
	</table>
	
	<form name="frm1" method="post" action="setMultiRoomParameters.jsp" target="hiddenFrame">
		<input type="hidden" id="selControllers" name="selControllers" value="<%= iSelRange %>">
		<input type="hidden" id="cntrlType" name="cntrlType" value="<%= sCntrlType %>">
		<div id="scrollDiv">
			<table id="freezeHeaders" border="1" cellpadding="2" cellspacing="0">
				<tr>
					<th style="border-right:0px"><%= resourceBundle.getProperty("DataManager.DisplayText.Parameter_Unit") %></th>
					<th style="border-left:0px">&nbsp;</th>
					<th align="center"><%= resourceBundle.getProperty("DataManager.DisplayText.Set_Value") %></th>
<%
					paramS = mParamStgs.get("ViewImage");
					boolean bViewImage = ((paramS != null) && RDMServicesConstants.ACCESS_READ.equals(u.getUserAccess(paramS)));
					
					for(int i=0; i<iSZ; i++)
					{
						sController = slControllers.get(i);
						mParams = mAllParams.get(sController);
%>						
						<th style="text-align: center; height:25px">
							<input type="checkbox" id="<%= sController %>" name="<%= sController %>" value="No" onClick="javascript:setSelected(this)"><br>
							<a href="singleRoomView.jsp?controller=<%=sController%>"><%= sController %></a><br>
<%
							if(bViewImage)
							{
%>
								<a href="roomImageView.jsp?controller=<%=sController%>"><%= resourceBundle.getProperty("DataManager.DisplayText.View_Image") %></a><br>
<%
							}
							if(slGraphs.contains(sCntrlType+" Dashboard"))
							{
								Map<String, String> mGrpParams = u.getGraphParams(sCntrlType+" Dashboard");
								sParams = mGrpParams.get("PARAMS").replace(",", "|");
%>
								<a href="javascript:showGraph('<%=sController%>')"><%= resourceBundle.getProperty("DataManager.DisplayText.Show_Graph") %></a>
<%
							}
							else
							{
%>
								<%= resourceBundle.getProperty("DataManager.DisplayText.Show_Graph") %>
<%
							}
%>
						</th>
<%
					}
%>
				</tr>
<%
					for(int m=0; m<displayOrder.size(); m++)
					{
						sParam = displayOrder.get(m);
						if(!"time".equals(sParam))
						{
							if(!mParamStgs.containsKey(sParam))
							{
								if(sParam.startsWith(">>>"))
								{
%>
									<tr>
										<td class="stage" align="center" colspan="<%= iSZ+3 %>">
											<%= sParam.replace(">", " ").trim() %>
										</td>
									</tr>
<%
								}
								continue;
							}
					
							paramS = mParamStgs.get(sParam);
							sAccess = u.getUserAccess(paramS);
							if(sAccess == null || RDMServicesConstants.ACCESS_NONE.equals(sAccess))
							{
								continue;
							}
						}
%>
						<tr>
<%
						for(int n=0; n<iSZ; n++)
						{
							sController = slControllers.get(n);
							
							mParams = mAllParams.get(sController);
							if(sParam.equals("time"))
							{
								saParamVal = mParams.get("time " + mParams.get("current phase")[0]);
							}
							else
							{
								saParamVal = mParams.get(sParam);
							}
							
							if(saParamVal == null || saParamVal.length == 0)
							{
								saParamVal = new String[] {"", ""};
							}
							
							sValue = ""; sUnit = "";
							if(saParamVal != null)
							{
								sValue = saParamVal[0];
								sUnit = saParamVal[1];
							}
							
							if(sParam.equals("current phase"))
							{
								if(sValue.endsWith(".0"))
								{
									sValue = sValue.substring(0, sValue.indexOf("."));
								}
								sStage = RDMServicesUtils.getStageName(sCntrlType, sValue);
								if(!("".equals(sStage) || "-".equals(sStage)))
								{
									mParams.put("current phase", new String[] {((sStage + " " + sValue).replace(".", " ")), ""});
									sValue = sStage + "&nbsp;("+ sValue + ")";
								}
							}
							
							try
							{
								if(!("On".equals(sValue) || "Off".equals(sValue) || sValue.contains(":")))
								{
									sValue = numberFormat.format(Double.parseDouble(sValue));
								}
							}
							catch(Exception e)
							{
								//do nothing
							}

							if(n == 0)
							{
%>
								<th style="text-align: left;border-right:0px"><%= ("time".equals(sParam) ? "current phase running time" : sParam) %>
<%
								if(!"".equals(sUnit))
								{
%>
									&nbsp;<label class="unit">(<%= sUnit %>)</label>
<%
								}
%>
								</th>
								<th style="border-left:0px">
									<img src="../images/info.png" height="18" width="18">
								</th>
								<td align="center" bgcolor="#FFFFFF">
<%

								if(RDMServicesConstants.ACCESS_WRITE.equals(sAccess) && bCanEdit && 
									!("phase selector".equals(sParam) || sParam.startsWith("start phase ") || sParam.startsWith("reset ")))
								{
									bShowSaveReset = true;
									if("On".equals(sValue) || "Off".equals(sValue))
									{
%>
										<select id="<%= sParam %>" name="<%= sParam %>" onChange="javascript:setOnOff('<%= sParam %>', this);">
											<option value="" selected></option>
											<option value="On"><%= (sParam.contains("door.open") ? resourceBundle.getProperty("DataManager.DisplayText.Open") : resourceBundle.getProperty("DataManager.DisplayText.On")) %></option>
											<option value="Off"><%= (sParam.contains("door.open") ? resourceBundle.getProperty("DataManager.DisplayText.Close") : resourceBundle.getProperty("DataManager.DisplayText.Off")) %></option>
										</select>
<%
									}
									else if(slOnOffValues.contains(sParam))
									{
%>
										<select id="<%= sParam %>" name="<%= sParam %>" onChange="javascript:setOnOff('<%= sParam %>', this);">
											<option value="" selected></option>
											<option value="1"><%= (sParam.contains("door.open") ? resourceBundle.getProperty("DataManager.DisplayText.Open") : resourceBundle.getProperty("DataManager.DisplayText.On")) %></option>
											<option value="0"><%= (sParam.contains("door.open") ? resourceBundle.getProperty("DataManager.DisplayText.Close") : resourceBundle.getProperty("DataManager.DisplayText.Off")) %></option>
										</select>
<%
									}
									else
									{
%>
										<input type="text" id="<%= sParam %>" name="<%= sParam %>" value="" size="8" onBlur="javascript:setValue('<%= sParam %>', this);" onclick="this.focus();this.select()">
<%
									}
								}
%>
								</td>
<%
							}
							
							if(sValue == null || "".equals(sValue))
							{
%>
								<td>&nbsp;</td>
<%
							}
							else
							{
								if(slOnOffValues.contains(sParam))
								{
									if(sParam.contains("door.open"))
									{
										if("1".equals(sValue) || "On".equals(sValue))
										{
											sValue = "Open";
										}
										else if("0".equals(sValue) || "Off".equals(sValue))
										{
											sValue = "Close";
										}
									}
									else if("1".equals(sValue))
									{
										sValue = "On";
									}
									else if("0".equals(sValue))
									{
										sValue = "Off";
									}
								}
								else
								{
									if(java.util.regex.Pattern.matches("[0-9,.-]+", sValue))
									{
										try
										{
											sValue = decimalFormat.format(decimalFormat.parse(sValue));
										}
										catch(Exception e)
										{
											//do nothing
										}
									}
								}
%>
								<td class="text">
									<%= sValue %>
								</td>
<%
							}
						}
%>
						</tr>
<%
					}
%>
			</table>
		</div>
		
		<table border="0" cellpadding="0" cellspacing="0" width="95%">
			<tr>
				<td style="font-family:Arial; font-size:0.8em; font-weight:bold; border:#ffffff; text-align:center">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Last_updated_on") %>:&nbsp;
					<font style="weight:normal; color:#FF0000"><%= sLastRefresh %></font>
				</td>
			</tr>
		</table>
	</form>
	
	<form name="frm2" method="post" action="showAttrDataGraph.jsp">
		<input type="hidden" id="saveAs" name="saveAs" value="">
		<input type="hidden" id="lstController" name="lstController" value="">
		<input type="hidden" id="Parameters" name="Parameters" value="<%= sParams %>">
		<input type="hidden" id="start_date" name="start_date" value="<%= startDate %>">
		<input type="hidden" id="end_date" name="end_date" value="<%= endDate %>">
		<input type="hidden" id="yield" name="yield" value="">
		<input type="hidden" id="access" name="access" value="">
	</form>

	<script type="text/javascript">
		var myST = new superTable("freezeHeaders", {
			cssSkin : "sGrey",
			headerRows : 1,
			fixedCols : 3
		});
	</script>
	
<%
if(!bShowSaveReset)
{
%>
	<script language="javascript">
		document.getElementById('Save').style.visibility = 'hidden';
		
		var inputs = document.getElementsByTagName("input");
		for(var i=0; i<inputs.length; i++)
		{
			var e = inputs[i];
			if(e.type == "checkbox")
			{
				e.disabled = true;
			}  
		}
	</script>
<%
}
%>
</body>
</html>
