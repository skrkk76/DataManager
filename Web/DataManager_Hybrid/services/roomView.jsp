<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%
	int iHeaderRows = 3;
	String sController = null;
	String sName = null;
	String sValue = null;
	String sUnit = null;
	String bgColor = null;
	String sManual = null;
	String sLastRefresh = null;
	ParamSettings paramSettings = null;

	Map<String, String> mParamInfo = null;
	Map<String, Map<String, String>> mParams = null;
	Map<String, Map<String, Map<String, String>>> mAllParams = new HashMap<String, Map<String, Map<String, String>>>();
	Map<String, String> mAllAlarms = new HashMap<String, String>();

	int iSelRange = -1;
	PLCServices client = null;
	StringList slControllers = null;
	ArrayList<String> alParams = null;

	String sSelRange = request.getParameter("selRange");
	sSelRange = (sSelRange == null ? "" : sSelRange);

	String sRealTime = request.getParameter("realTime");
	sRealTime = ((sRealTime == null || "".equals(sRealTime)) ? "false" : sRealTime);

	String sCntrlType = request.getParameter("cntrlType");
	Map<String, ParamSettings> mViewParams = RDMServicesUtils.getRoomsOverViewParamaters(sCntrlType);

	StringList slCntrlSel = RDMSession.getControllersSelection(sCntrlType, 10);
	if(slCntrlSel.size() == 0)
	{
		return;
	}

	if(!"".equals(sSelRange))
	{
		iSelRange = Integer.parseInt(sSelRange);
		boolean bRealTime = ("true".equalsIgnoreCase(sRealTime));

		slControllers = RDMSession.getControllers(iSelRange, 10, sCntrlType);
		alParams = new ArrayList<String>(RDMServicesUtils.getDisplayOrder(sCntrlType));

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

				mParams = client.getRoomViewParams(u, bRealTime);
				mAllParams.put(sController, mParams);

				bgColor = (client.hasOpenAlarms() ? "#FF0000" : "#00FF00");
				mAllAlarms.put(sController, bgColor);

				if(fg)
				{
					sLastRefresh = (mParams.containsKey("Last Refresh") ? mParams.get("Last Refresh").get(RDMServicesConstants.PARAM_VALUE) : "");
					alParams.retainAll(mParams.keySet());

					paramSettings = mViewParams.get("BatchNo");
					if((paramSettings != null) && RDMServicesConstants.ACCESS_READ.equals(u.getUserAccess(paramSettings)))
					{
						iHeaderRows++;
					}
					paramSettings = mViewParams.get("Product");
					if((paramSettings != null) && RDMServicesConstants.ACCESS_READ.equals(u.getUserAccess(paramSettings)))
					{
						iHeaderRows++;
					}
					fg = false;
				}
			}
			catch(Exception e)
			{
				slControllers.remove(sController);
			}
		}
	}

	int iSz = slControllers.size();
	String sParams = "";
	StringList slGraphs = u.getSavedGraphs();

	Random randomGenerator = new Random();
	int randomInt = randomGenerator.nextInt(1000);

	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH);
	Calendar cal = Calendar.getInstance();
	String endDate = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_YEAR, -1);
	String startDate = sdf.format(cal.getTime());

	String sHeader = null;
	StringList slHeaders = new StringList();
	Map<String, String> mParamHeaders = RDMServicesUtils.displayHeaders(sCntrlType);

	Map<Integer, String> mDisplayHeaders = RDMServicesUtils.getHeaders(sCntrlType);
	ArrayList<Integer> alDisplayOrder = new ArrayList<Integer>();
	alDisplayOrder.addAll(mDisplayHeaders.keySet());
	Collections.sort(alDisplayOrder);
	
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
<%
	if(iSelRange > -1)
	{
%>
		<meta http-equiv="refresh" content="300;url=roomView.jsp?realTime=false&selRange=<%= iSelRange %>&cntrlType=<%= sCntrlType %>">
<%
	}
%>
	<link type="text/css" href="../styles/superTables.css" rel="stylesheet" />
    <script type="text/javascript" src="../scripts/superTables.js"></script>
	<style>
	#scrollDiv
	{
		margin: 2px 2px;
		width: <%= winWidth * 0.95 %>px;
		height: <%= winHeight * 0.80 %>px;
		overflow: hidden;
		font-size: 0.85em;
	}
	</style>

	<script language="javascript">
		if (!String.prototype.trim)
		{
			String.prototype.trim = function() {
				return this.replace(/^\s+|\s+$/g,'');
			}
		}

		function refreshDetails()
		{
			var url = "roomView.jsp?realTime=true&selRange=<%= iSelRange %>&cntrlType=<%= sCntrlType %>";
			document.location.href = url;
		}

		function changeControllers(obj)
		{
			var sCntrl = obj.value;
			if(sCntrl != "")
			{
				document.location.href = "roomView.jsp?realTime=false&cntrlType=<%= sCntrlType %>&selRange="+sCntrl;
			}
		}

		function printView()
		{
			var retval = window.open('roomViewPrint.jsp?realTime=<%= sRealTime %>&selRange=<%= iSelRange %>&cntrlType=<%= sCntrlType %>', '', 'left=250,top=250,resizable=yes,scrollbars=yes,status=no,toolbar=no,height=600,width=800');
		}

		function showAlarms(sController)
		{
			var retval = window.open('showAlarms.jsp?controller='+sController, 'Alarms', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=500,width=620');
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

		function setValue(pid, pg, obj)
		{
			var val = obj.value.trim();
			if('<%= cDecimal %>' == '.')
			{
				val = val.replace(/,/g, "");
			}
			else if('<%= cDecimal %>' == ',')
			{
				val = val.replace(/\./g, "");
			}

			var elm = document.getElementById(pid);
			var minValue = document.getElementById(pid+"_MinVal");
			var maxValue = document.getElementById(pid+"_MaxVal");

			var err = false;
			if(minValue != null && minValue != "undefined")
			{
				var minVal = minValue.value.trim();
				if(minVal != "")
				{
					if('<%= cDecimal %>' == '.')
					{
						minVal = minVal.replace(/,/g, "");
					}
					else if('<%= cDecimal %>' == ',')
					{
						minVal = minVal.replace(/\./g, "");
					}

					if(parseFloat(val) < parseFloat(minVal))
					{
						err = true;
					}
				}
			}

			if(maxValue != null && maxValue != "undefined")
			{
				var maxVal = maxValue.value.trim();
				if(maxVal != "")
				{
					if('<%= cDecimal %>' == '.')
					{
						maxVal = maxVal.replace(/,/g, "");
					}
					else if('<%= cDecimal %>' == ',')
					{
						maxVal = maxVal.replace(/\./g, "");
					}

					if(parseFloat(val) > parseFloat(maxVal))
					{
						err = true;
					}
				}
			}

			if(err)
			{
				obj.style.background = '#FF0000';
				obj.value = document.getElementById(pid+"_OldVal").value;
				elm.value = document.getElementById(pid+"_OldVal").value;
				alert("The value entered should be between '"+minValue.value+" to '"+maxValue.value+"'");
			}
			else
			{
				obj.style.background = '#FFFFFF';
				val = obj.value.trim();
				elm.value = val;
				
				if(document.getElementById(pid+"_OldVal").value != val)
				{
					selectDiv(pg);
					obj.style.background = '#00FF00';
				}
			}
		}

		function setOnOff(pid, obj)
		{
			var sel = obj.value;
			if(sel == "On" || sel == "1")
			{
				document.getElementById(pid).selectedIndex = 0;
				document.getElementById(pid).value = sel;
			}
			else if(sel == "Off" || sel == "0")
			{
				document.getElementById(pid).selectedIndex = 1;
				document.getElementById(pid).value = sel;
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
			document.frm3.lstController.value = room;

			var idx = "<%= randomInt %>";
			document.frm3.target = "POPUPW_"+idx;
			POPUPW = window.open('about:blank','POPUPW_'+idx,'menubar=no,toolbar=no,location=no,resizable=yes,scrollbars=yes,status=no,height=<%= winHeight * 0.85 %>px,width=<%= winWidth * 0.90 %>px');
			document.frm3.submit();
		}

		function addComments()
		{
			var retval = window.open('addUserComments.jsp', 'Comments', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=375,width=525');
		}
		
		function selectDiv(e)
		{
			document.getElementById(e).style.backgroundColor = '#00ff00';
		}

		function unselectDiv(e)
		{
			document.getElementById(e).style.backgroundColor = '#b3b7bb';
		}
	</script>
<%
	if(bCanEdit)
	{
%>
	<script type="text/javascript">
		//<![CDATA[
		window.onkeypress = enter;
		function enter(e)
		{
			if (e.keyCode == 13)
			{
				document.getElementById('selRange').focus();
				setTimeout("saveChanges()", 1000);
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
				<select id="selRange" name="selRange" onChange="javascript:changeControllers(this)">
					<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
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
<%
			if(iSelRange > -1)
			{
%>
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
<%
			}
%>
			</td>
		</tr>
	</table>
<%
if(iSelRange > -1)
{
	boolean bHasRange = false;
	boolean bShowSaveReset = false;
	boolean bDispOrd = false;
	int iDispOrd = 0;
	String sMinVal = "";
	String sMaxVal = "";
	String sUserAccess = "";
	String sParamName = "";
	Map<String, String> mParamMaxMinVal = new HashMap<String, String>();
	StringList slOnOffValues = RDMServicesUtils.getOnOffParams(sCntrlType);
%>
	<form name="frm1" method="post" action="setRoomViewParameters.jsp" target="hiddenFrame">
		<input type="hidden" id="selControllers" name="selControllers" value="<%= iSelRange %>">
		<input type="hidden" id="cntrlType" name="cntrlType" value="<%= sCntrlType %>">
		<div id="scrollDiv">
			<table id="freezeHeaders" border="1" cellpadding="1" cellspacing="0">
				<tr>
					<th style="text-align:left;border-right:0px"><%= resourceBundle.getProperty("DataManager.DisplayText.Rooms") %></th>
					<th style="border-left:0px">&nbsp;</th>
<%
					paramSettings = mViewParams.get("ViewImage");
					boolean bViewImage = ((paramSettings != null) && RDMServicesConstants.ACCESS_READ.equals(u.getUserAccess(paramSettings)));

					for(int i=0; i<iSz; i++)
					{
						sController = slControllers.get(i);
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
								sParams = mGrpParams.get("PARAMS").replaceAll(",", "\\|");
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

				<tr>
					<th style="text-align:left;border-right:0px"><%= resourceBundle.getProperty("DataManager.DisplayText.Alarms") %></th>
					<th style="border-left:0px">&nbsp;</th>
<%
					for(int i=0; i<iSz; i++)
					{
						sController = slControllers.get(i);
						bgColor = mAllAlarms.get(sController);
%>
						<td bgcolor="<%= bgColor %>" style="border-top:solid 1px #888888;border-bottom:solid 1px #888888;border-right:solid 1px #888888;border-left:solid 1px #888888;text-align:center">
<%
						if("#FF0000".equals(bgColor))
						{
%>
							<a href="javascript:showAlarms('<%=sController%>')"><b><%= resourceBundle.getProperty("DataManager.DisplayText.View") %></b></a>
<%
						}
						else
						{
%>
							&nbsp;
<%
						}
%>
						</td>
<%
					}
%>
				</tr>
				<tr>
					<th style="text-align:left;border-right:0px"><%= resourceBundle.getProperty("DataManager.DisplayText.Manual") %></th>
					<th style="border-left:0px">&nbsp;</th>
<%
					for(int i=0; i<iSz; i++)
					{
						sController = slControllers.get(i);
						mParams = mAllParams.get(sController);
						sManual = (mParams.containsKey("manual.sl") ? mParams.get("manual.sl").get(RDMServicesConstants.PARAM_VALUE) : "");
						bgColor = ("On".equals(sManual) ? "#0000ff" : "#ffffff");
%>
						<td bgcolor="<%= bgColor %>" style="border-top:solid 1px #888888;border-bottom:solid 1px #888888;border-right:solid 1px #888888;border-left:solid 1px #888888;"><%= sManual %></td>
<%
					}
%>
				</tr>
<%
				if(mViewParams.containsKey("current phase"))
				{
					iHeaderRows++;
%>
					<tr>
						<th style="text-align:left;border-right:0px">current phase</th>
						<th style="border-left:0px">&nbsp;</th>
<%
						for(int i=0; i<iSz; i++)
						{
							sController = slControllers.get(i);
							mParams = mAllParams.get(sController);
							sValue = (mParams.containsKey("current phase") ? mParams.get("current phase").get(RDMServicesConstants.PARAM_VALUE) : "");
							if(sValue.endsWith(".0"))
							{
								sValue = sValue.substring(0, sValue.indexOf("."));
							}
							sName = RDMServicesUtils.getStageName(sCntrlType, sValue);
							if(!("".equals(sName) || "-".equals(sName)))
							{
								sValue = sName.replaceAll(" ", "<br>") + "&nbsp;("+ sValue + ")";
							}
%>
							<td class="text" align="left"><%= sValue %></td>
<%
						}
%>
					</tr>
<%
				}
				
				for(int i=0, iCnt=alParams.size(); i<iCnt; i++)
				{
					sName = alParams.get(i);
					if("current phase".equals(sName))
					{
						continue;
					}
					
					iDispOrd = -1;
					paramSettings = mViewParams.get(sName);
					if(paramSettings != null)
					{
						iDispOrd = paramSettings.getDisplayOrder();
					}

					bDispOrd = false;
					for(int n=alDisplayOrder.size()-1; n>=0; n--)
					{
						if(iDispOrd >= alDisplayOrder.get(n))
						{
							iDispOrd = alDisplayOrder.get(n);
							//alDisplayOrder.remove(n);
							bDispOrd = true;
							break;
						}
					}

					if(bDispOrd)
					{
						sHeader = mDisplayHeaders.get(iDispOrd);
						if(!slHeaders.contains(sHeader))
						{
%>
							<tr>
								<th align="center" colspan="12">
									<%= sHeader %>
								</th>
							</tr>
<%
							alDisplayOrder.remove(0);
							slHeaders.add(sHeader);
						}
					}
%>
					<tr>
<%
					for(int j=0; j<iSz; j++)
					{
						sController = slControllers.get(j);
						mParams = mAllParams.get(sController);
						mParamInfo = mParams.get(sName);

						sValue = "&nbsp;";
						sUserAccess = "";
						if(mParamInfo != null && !mParamInfo.isEmpty())
						{
							sUnit = mParamInfo.get(RDMServicesConstants.PARAM_UNIT);
							if(j == 0)
							{
%>
								<th class="input" style="text-align: left;border-right:0px">
									<div id="<%= sName %>">
										<%= sName %>
<%
										if(RDMServicesUtils.isNotNullAndNotEmpty(sUnit))
										{
%>
											&nbsp;<label class="unit">(<%= sUnit %>)</label>
<%
										}
%>
									</div>
								</th>
								<th style="border-left:0px">
									<img src="../images/info.png" height="18" width="18">
								</th>
<%
							}

							sValue = mParamInfo.get(RDMServicesConstants.PARAM_VALUE);
							sValue = (sValue == null ? "&nbsp;" : sValue);

							sMinVal = mParamInfo.get(RDMServicesConstants.MIN_PARAM_VALUE);
							sMaxVal = mParamInfo.get(RDMServicesConstants.MAX_PARAM_VALUE);

							bgColor = "#ffffff";
							bHasRange = ((sMinVal != null && !"".equals(sMinVal.trim())) && (sMaxVal != null && !"".equals(sMaxVal.trim())));
							if(bHasRange && !"".equals(sValue))
							{
								try
								{
									if(Double.parseDouble(sValue) < Double.parseDouble(sMinVal) ||
										Double.parseDouble(sValue) > Double.parseDouble(sMaxVal))
									{
										bgColor = "#FF0000";
									}
								}
								catch(Exception e)
								{
									//do nothing
								}
							}

							sUserAccess = mParamInfo.get(RDMServicesConstants.USER_ACCESS);
						}
						else
						{
							if(j == 0)
							{
%>								
								<th class="input" style="text-align: left;border-right:0px">
									<div id="<%= sName %>">
										<%= sName %>
<%
										if(RDMServicesUtils.isNotNullAndNotEmpty(sUnit))
										{
%>
											&nbsp;<label class="unit">(<%= sUnit %>)</label>
<%
										}
%>
									</div>
								</th>
								<th style="border-left:0px">
									<img src="../images/info.png" height="18" width="18">
								</th>
<%
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
%>
						<td class="text" align="left" bgcolor="<%= bgColor %>">
<%
						if(RDMServicesConstants.ACCESS_WRITE.equals(sUserAccess) && bCanEdit)
						{
							bShowSaveReset = true;
							sParamName = sController+"_"+mParamInfo.get(RDMServicesConstants.PARAM_NAME);
							if(bHasRange)
							{
								try
								{
									mParamMaxMinVal.put(sParamName+"_MinVal", numberFormat.format(Double.parseDouble(sMinVal)));
									mParamMaxMinVal.put(sParamName+"_MaxVal", numberFormat.format(Double.parseDouble(sMaxVal)));
								}
								catch(Exception e)
								{
									//do nothing
								}
							}

							if("On".equals(sValue) || "Off".equals(sValue))
							{
%>
								<select id="<%= sParamName %>" name="<%= sParamName %>" onclick="javascript:selectDiv('<%= sName %>'); this.focus();this.select()" onChange="javascript:setOnOff('<%= sParamName %>', this);" onBlur="javascript:unselectDiv('<%= sName %>'); setValue('<%= sParamName %>', '<%= sName %>', this);">
									<option value="On" <%= "On".equals(sValue) ? "selected" : "" %>><%= (sParamName.contains("door.open") ? resourceBundle.getProperty("DataManager.DisplayText.Open") : resourceBundle.getProperty("DataManager.DisplayText.On")) %></option>
									<option value="Off" <%= "Off".equals(sValue) ? "selected" : "" %>><%= (sParamName.contains("door.open") ? resourceBundle.getProperty("DataManager.DisplayText.Close") : resourceBundle.getProperty("DataManager.DisplayText.Off")) %></option>
								</select>
<%
							}
							else if(slOnOffValues.contains(mParamInfo.get(RDMServicesConstants.PARAM_NAME)))
							{
%>
								<select id="<%= sParamName %>" name="<%= sParamName %>" onclick="javascript:selectDiv('<%= sName %>'); this.focus();this.select()" onChange="javascript:setOnOff('<%= sParamName %>', this);" onBlur="javascript:unselectDiv('<%= sName %>'); setValue('<%= sParamName %>', '<%= sName %>', this);">
									<option value="1" <%= "1".equals(sValue) ? "selected" : "" %>><%= (sParamName.contains("door.open") ? resourceBundle.getProperty("DataManager.DisplayText.Open") : resourceBundle.getProperty("DataManager.DisplayText.On")) %></option>
									<option value="0" <%= "0".equals(sValue) ? "selected" : "" %>><%= (sParamName.contains("door.open") ? resourceBundle.getProperty("DataManager.DisplayText.Close") : resourceBundle.getProperty("DataManager.DisplayText.Off")) %></option>
								</select>
<%
							}
							else
							{
								try
								{
									if(java.util.regex.Pattern.matches("[0-9,.-]+", sValue))
									{
										sValue = decimalFormat.format(decimalFormat.parse(sValue));
									}
								}
								catch(Exception e)
								{
									//do nothing
								}
%>
								<input type="text" id="<%= sParamName %>" name="<%= sParamName %>" value="<%= sValue %>" style="background:<%= bgColor %>" size="8" onBlur="javascript:unselectDiv('<%= sName %>'); setValue('<%= sParamName %>', '<%= sName %>', this);" onclick="javascript:selectDiv('<%= sName %>'); this.focus();this.select()">
<%
							}
%>
							<input type="hidden" id="<%= sParamName %>_OldVal" name="<%= sParamName %>_OldVal" value="<%= sValue %>">
<%
						}
						else if(RDMServicesConstants.ACCESS_READ.equals(sUserAccess))
						{
							if(slOnOffValues.contains(mParamInfo.get(RDMServicesConstants.PARAM_NAME)))
							{
								if(mParamInfo.get(RDMServicesConstants.PARAM_NAME).contains("door.open"))
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
								try
								{
									if(java.util.regex.Pattern.matches("[0-9,.-]+", sValue))
									{
										sValue = decimalFormat.format(decimalFormat.parse(sValue));
									}
								}
								catch(Exception e)
								{
									//do nothing
								}
							}
%>
							<label><%= sValue %></label>
<%
						}
						else
						{
%>
							&nbsp;
<%
						}
%>
						</td>
<%
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

	<form name="frm2">
<%
	String sKey = "";
	String sVal = "";
	Iterator<String> itr = mParamMaxMinVal.keySet().iterator();
	while(itr.hasNext())
	{
		sKey = itr.next();
		sVal = mParamMaxMinVal.get(sKey);
%>
		<input type="hidden" id="<%= sKey %>" name="<%= sKey %>" value="<%= sVal %>">
<%
	}
%>
	</form>

	<form name="frm3" method="post" action="showAttrDataGraph.jsp">
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
			headerRows : <%= iHeaderRows %>,
			fixedCols : 2
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
}
%>
</body>
</html>
