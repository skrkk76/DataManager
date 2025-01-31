<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.text.*" %>
<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<%!
	Map<String, ParamSettings> mViewParams = null;
	Map<String, String[]> mParams = null;
	StringList slOnOffValues = null;
	String TEXT_OPEN = "Open";
	String TEXT_CLOSE = "Close";
	String TEXT_ON = "On";
	String TEXT_OFF = "Off";
	String sfxStage1 = "";
	String sfxStage2 = "";
	
	NumberFormat decimalFormat = NumberFormat.getInstance(Locale.getDefault());
%>

<%
	String sController = request.getParameter("controller");
	PLCServices client = new PLCServices(RDMSession, sController);

	mParams = client.getControllerData(true);

	String sCurrentPhase = (mParams.containsKey("current phase") ? mParams.get("current phase")[0] : "");
	String sPhase = new String(sCurrentPhase);

	String sCntrlType = client.getControllerType();
	String stageName = RDMServicesUtils.getStageName(sCntrlType, sPhase);
	StringList slControllers = RDMSession.getControllers(u);

	TreeMap<String, Map<String, String>> mDisplayParams = null;
	mViewParams = RDMServicesUtils.getRoomImageParamaters(sCntrlType);
	slOnOffValues = RDMServicesUtils.getOnOffParams(sCntrlType);
	
	StringList slGraphs = u.getSavedGraphs();
	
	Random randomGenerator = new Random();
	int randomInt = randomGenerator.nextInt(1000);
	
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy", Locale.ENGLISH);
	Calendar cal = Calendar.getInstance();
	String endDate = sdf.format(cal.getTime());
	cal.add(Calendar.DAY_OF_YEAR, -1);
	String startDate = sdf.format(cal.getTime());
	
	String sStgSeq = new String(sCurrentPhase);
	if(sStgSeq.endsWith(".0"))
	{
		sStgSeq = sStgSeq.substring(0, sStgSeq.indexOf("."));
	}
	if("0".equalsIgnoreCase(sStgSeq))
	{
		sfxStage1 = " " + stageName;
		sfxStage2 = " " + "phase" + " " + stageName;
	}
	else
	{
		sfxStage1 = " " + stageName + " " + sStgSeq;
		sfxStage2 = " " + "phase" + " " + sStgSeq;
	}
	
	decimalFormat.setMinimumFractionDigits(1);
%>

<!DOCTYPE html>
<html>
	<head>
		<title></title>	
		<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
		
		<script language="javascript">
		var prevId = "";
		
		if (!String.prototype.trim) 
		{
			String.prototype.trim = function() {
				return this.replace(/^\s+|\s+$/g,'');
			}
		}
		
		if ( typeof String.prototype.startsWith != 'function' ) {
			String.prototype.startsWith = function( str ) {
				return str.length > 0 && this.substring( 0, str.length ) === str;
			}
		};
		
		if ( typeof String.prototype.endsWith != 'function' ) {
			String.prototype.endsWith = function( str ) {
				return str.length > 0 && this.substring( this.length - str.length, this.length ) === str;
			}
		};

		function showMode(divId)
		{
			var idx1 = divId.indexOf("_");
			var str1 = divId.substring(0, idx1);
			
			if(prevId != "")
			{
				var idx2 = prevId.indexOf("_");
				var str2 = prevId.substring(0, idx2);
				
				if((str1 == str2) && prevId.endsWith("_Edit"))
				{
					return;
				}
			}

			if(prevId != "" && prevId != divId)
			{
				document.getElementById(prevId).style.display = "none";
			}
			if(divId != "")
			{
				document.getElementById(divId).style.display = "block";
			}			
			prevId = divId;
		}

		function hideMode(divId)
		{
			document.getElementById(divId).style.display = "none";
			prevId = "";
		}
		
		function changeController(obj)
		{
			var sCntrl = obj.value;
			if(sCntrl == "Bunker" || sCntrl == "Tunnel" || sCntrl == "Grower")
			{
				parent.location.href = "defaultParamsView.jsp?controller="+sCntrl;
			}
			else
			{
				parent.location.href = "roomImageView.jsp?controller="+sCntrl;
			}
		}
	
		function showAlarms()
		{
			var retval = window.open('showAlarms.jsp?controller=<%= sController %>', 'Alarms', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=500,width=620');
		}
		
		function addComments()
		{
			var retval = window.open('addUserComments.jsp?controller=<%= sController %>', 'Comments', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=375,width=525');
		}

		function showAllParams()
		{
			parent.document.location.href = "singleRoomView.jsp?controller=<%=sController%>";
		}
		
		function setValue(pid, obj) 
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
				if(document.getElementById(pid+"_OldVal").value != obj.value.trim())
				{
					obj.style.background = '#00FF00';
				}
				elm.value = obj.value.trim();
			}
		}
		
		function saveChanges()
		{
			document.forms[0].submit();
		}
		
		function showGraph()
		{
			idx = "<%= randomInt %>";
			document.grp.target = "POPUPW_"+idx;
			POPUPW = window.open('about:blank','POPUPW_'+idx,'menubar=no,toolbar=no,location=no,resizable=yes,scrollbars=yes,status=no,height=<%= winHeight * 0.85 %>px,width=<%= winWidth * 0.90 %>px');
			document.grp.submit();
		}
		
		function reloadValues()
		{
			document.location.href = document.location.href;
		}
		</script>
		
		<script type="text/javascript">
		//<![CDATA[
		window.onkeypress = enter;
		function enter(e)
		{
			if (e.keyCode == 13)
			{
				document.getElementById('controller').focus();
				setTimeout("saveChanges()", 1000);
			}
		}
		//]]>
	</script>
	</head>
	
	<body>
		<table border="0" cellspacing="2" cellpadding="2" width="90%">
			<tr>
				<td style="font-family:Arial; font-size:9pt; font-weight:bold; text-align:right">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Room") %>:&nbsp;
					<select id="controller" name="controller" onChange="javascript:changeController(this)">
<%
					if(RDMServicesConstants.ROLE_ADMIN.equals(u.getRole()))
					{
%>
						<optgroup label="<%= resourceBundle.getProperty("DataManager.DisplayText.Default_Values") %>">
<%
						boolean bViewGrwDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER);
						if(bViewGrwDB && (RDMSession.getControllers(RDMServicesConstants.TYPE_GROWER).size() > 0))
						{
%>
							<option value="<%= RDMServicesConstants.TYPE_GROWER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></option>
<%
						}
						boolean bViewBnkDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER);
						if(bViewBnkDB && (RDMSession.getControllers(RDMServicesConstants.TYPE_BUNKER).size() > 0))
						{
%>
							<option value="<%= RDMServicesConstants.TYPE_BUNKER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></option>
<%
						}
						boolean bViewTnlDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL);
						if(bViewTnlDB && (RDMSession.getControllers(RDMServicesConstants.TYPE_TUNNEL).size() > 0))
						{
%>
							<option value="<%= RDMServicesConstants.TYPE_TUNNEL %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></option>
<%
						}
%>
						<optgroup label="<%= resourceBundle.getProperty("DataManager.DisplayText.Controllers") %>">
<%
					}

					String sCntrlName = "";
					String sSelected = "";
					for(int i=0; i<slControllers.size(); i++)
					{
						sCntrlName = slControllers.get(i);
						sSelected = (sCntrlName.equals(sController) ? "selected" : "");
%>
						<option value="<%= sCntrlName %>" <%= sSelected %>><%= sCntrlName %></option>
<%
					}
%>
					</select>
				</td>
				
				<td style="font-family:Arial; font-size:9pt; font-weight:bold; text-align:right">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Running_Phase") %>:&nbsp;<%= sPhase %>(<%= stageName %>)
				</td>	

				<td width="10%">&nbsp;</td>

				<td style="font-family:Arial; font-size:0.8em; text-align:right">
					<input type="button" id="alarms" name="alarms" value="<%= resourceBundle.getProperty("DataManager.DisplayText.View_Alarms") %>" onClick="javascript:showAlarms()">&nbsp;
					<input type="button" id="singleRoom" name="singleRoom" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Single_Room") %>" onClick="javascript:showAllParams()">&nbsp;
<%
					String sParams = "";
					if(slGraphs.contains("Bunker Dashboard"))
					{
						Map<String, String> mGraphParams = u.getGraphParams("Bunker Dashboard");
						sParams = mGraphParams.get("PARAMS").replaceAll(",", "\\|");
%>
						<input type="button" id="graph" name="graph" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Show_Graph") %>" onClick="javascript:showGraph()">
<%
					}
					else
					{
%>
						<input type="button" id="graph" name="graph" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Show_Graph") %>">
<%
					}

					if(!RDMServicesConstants.ROLE_HELPER.equals(u.getRole()))
					{
%>
						<input type="button" id="comments" name="comments" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Comments") %>" onClick="javascript:addComments()">&nbsp;
<%
					}
%>
					<input type="button" id="Refresh" name="Refresh" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Reload_Values") %>" onClick="javascript:reloadValues()">
				</td>
			</tr>
		</table>
		
		<form name="frm" method="post" action="setParametersProcess.jsp" target="hiddenFrame">
			<input type="hidden" id="controller" name="controller" value="<%= sController %>">
			<input type="hidden" id="cntrlType" name="cntrlType" value="<%= sCntrlType %>">
			<table width="1300px" height="900px" cellspacing="0" cellpadding="0" border="0" align="left" background="../images/BunkerView.jpg" style="background-repeat:no-repeat">
				<tr>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('Outside.Params_Edit')" ondblClick="hideMode('Outside.Params_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Outside.Params", sCurrentPhase);
%>
						<div id="Outside.Params_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Outside.Params_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('Fan_Edit')" ondblClick="hideMode('Fan_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Fan", sCurrentPhase);
%>
						<div id="Fan_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Fan_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('Airvalve_Edit')" ondblClick="hideMode('Airvalve_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Airvalve", sCurrentPhase);
%>
						<div id="Airvalve_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Airvalve_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('Ammonia_Edit')" ondblClick="hideMode('Ammonia_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Ammonia", sCurrentPhase);
%>
						<div id="Ammonia_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Ammonia_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('Temp.O2_Edit')" ondblClick="hideMode('Temp.O2_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Temp.O2", sCurrentPhase);
%>
						<div id="Temp.O2_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Temp.O2_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('Inlet.Temp_Edit')" ondblClick="hideMode('Inlet.Temp_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Inlet.Temp", sCurrentPhase);
%>
						<div id="Inlet.Temp_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Inlet.Temp_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="100" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('Comp.Temp.1_Edit')" ondblClick="hideMode('Comp.Temp.1_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Comp.Temp.1", sCurrentPhase);
%>
						<div id="Comp.Temp.1_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Comp.Temp.1_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('Comp.Temp.2_Edit')" ondblClick="hideMode('Comp.Temp.2_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Comp.Temp.2", sCurrentPhase);
%>
						<div id="Comp.Temp.2_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Comp.Temp.2_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('Comp.Temp.3_Edit')" ondblClick="hideMode('Comp.Temp.3_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Comp.Temp.3", sCurrentPhase);
%>
						<div id="Comp.Temp.3_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Comp.Temp.3_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('Comp.Temp.4_Edit')" ondblClick="hideMode('Comp.Temp.4_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Comp.Temp.4", sCurrentPhase);
%>
						<div id="Comp.Temp.4_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Comp.Temp.4_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('Comp.Temp.Ave_Edit')" ondblClick="hideMode('Comp.Temp.Ave_Edit')">
<%
						mDisplayParams = client.getImageControllerData(mParams, "Comp.Temp.Ave", sCurrentPhase);
%>
						<div id="Comp.Temp.Ave_View" style="display:block; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, false) %>
						</div>
						<div id="Comp.Temp.Ave_Edit" style="display:none; z-index:5; position:absolute;">
							<%= getHTMLText(mDisplayParams, u, sCntrlType, true) %>
						</div>
					</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
				</tr>
				<tr>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
					<td width="100" height="60" onClick="showMode('')">&nbsp;</td>
				</tr>
			</table>
		</form>
		
		<form name="grp" method="grp" action="showAttrDataGraph.jsp">
			<input type="hidden" id="saveAs" name="saveAs" value="">
			<input type="hidden" id="lstController" name="lstController" value="<%= sController %>">
			<input type="hidden" id="Parameters" name="Parameters" value="<%= sParams %>">
			<input type="hidden" id="start_date" name="start_date" value="<%= startDate %>">
			<input type="hidden" id="end_date" name="end_date" value="<%= endDate %>">
			<input type="hidden" id="yield" name="yield" value="">
			<input type="hidden" id="access" name="access" value="">
		</form>
	</body>
</html>

<%!
	private String getHTMLText(TreeMap<String, Map<String, String>> mDisplayParams, User user, String sCntrlType, boolean bEdit)
	{
		StringBuilder sbHTMLText = new StringBuilder();
		try
		{
			boolean bOpen = false;
			String sParam = null;
			String sValue = null;
			String sUnit = null;
			String sMin = null;
			String sMax = null;
			String sAccess = null;
			String bgColor = null;
			Map<String, String> mParamVal = null;
			ParamSettings paramSettings = null;
			NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());
			
			sbHTMLText.append("<table border='1' cellpadding='1' cellspacing='0'>");
			Iterator<String> itr = mDisplayParams.keySet().iterator();
			while(itr.hasNext())
			{
				sParam = itr.next();
				paramSettings = mViewParams.get(sParam);
				if(paramSettings == null)
				{
					continue;
				}
				
				sAccess = user.getUserAccess(paramSettings);
				if(sAccess == null || RDMServicesConstants.ACCESS_NONE.equals(sAccess))
				{
					continue;
				}
				
				String sDisplay = new String(sParam);
				if(sParam.startsWith("max ") || sParam.startsWith("min ") || sParam.startsWith("set "))
				{
					if(sParam.endsWith(sfxStage1))
					{
						sDisplay = sParam.substring(0, sParam.indexOf(sfxStage1));
					}
					else if(sParam.endsWith(sfxStage2))
					{
						sDisplay = sParam.substring(0, sParam.indexOf(sfxStage2));
					}
					else
					{
						continue;
					}
				}
				
				mParamVal = mDisplayParams.get(sParam);
				sValue = mParamVal.get("value");
				sUnit = mParamVal.get("unit");
				sMin = mParamVal.get("min");
				sMax = mParamVal.get("max");
				
				sbHTMLText.append("<tr>");
				sbHTMLText.append("	<th class='label' height='25' nowrap style='text-align:left'>" + sDisplay);
				if(!"".equals(sUnit))
				{
					sbHTMLText.append("	&nbsp;<label class='unit'>(" + sUnit +")</label>");
				}
				sbHTMLText.append("	</th>");

				bgColor = "#FFFFFF";
				if(sMin != null && sMax != null)
				{
					if(Double.parseDouble(sValue) < Double.parseDouble(sMin) || 
						Double.parseDouble(sValue) > Double.parseDouble(sMax))
					{
						bgColor = "#FF0000";
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

				if(RDMServicesConstants.ACCESS_WRITE.equals(sAccess) && bEdit)
				{
					bOpen = sParam.contains("door.open");
					
					sbHTMLText.append("	<td class='text'>");
					if("On".equals(sValue) || "Off".equals(sValue))
					{
						sbHTMLText.append("	<select id='"+sParam+"' name='"+sParam+"'>");
						sbHTMLText.append("	<option value='On' "+("On".equals(sValue) ? "selected" : "")+">"+(bOpen ? TEXT_OPEN : TEXT_ON)+"</option>");
						sbHTMLText.append("	<option value='Off' "+("Off".equals(sValue) ? "selected" : "")+">"+(bOpen ? TEXT_CLOSE : TEXT_OFF)+"</option>");
						sbHTMLText.append("	</select>");
					}
					else if(slOnOffValues.contains(sParam))
					{
						sbHTMLText.append("	<select id='"+sParam+"' name='"+sParam+"'>");
						sbHTMLText.append("	<option value='1' "+("1".equals(sValue) ? "selected" : "")+">"+(bOpen ? TEXT_OPEN : TEXT_ON)+"</option>");
						sbHTMLText.append("	<option value='0' "+("0".equals(sValue) ? "selected" : "")+">"+(bOpen ? TEXT_CLOSE : TEXT_OFF)+"</option>");
						sbHTMLText.append("	</select>");
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
						sbHTMLText.append("	<input type='text' id='"+sParam+"' name='"+sParam+"' value='"+sValue+"' size='8' style='background:"+bgColor+"' onBlur='javascript:setValue(\""+sParam+"\", this)'>");
					}

					sbHTMLText.append("	<input type='hidden' id='"+sParam+"_OldVal' name='"+sParam+"_OldVal' value='"+sValue+"'>");
					if(sMin != null && sMax != null)
					{
						sbHTMLText.append("	<input type='hidden' id='"+sParam+"_MinVal' name='"+sParam+"_MinVal' value='"+numberFormat.format(Double.parseDouble(sMin))+"'>");
						sbHTMLText.append("	<input type='hidden' id='"+sParam+"_MaxVal' name='"+sParam+"_MaxVal' value='"+numberFormat.format(Double.parseDouble(sMax))+"'>");
					}
					sbHTMLText.append("	</td>");
				}
				else
				{
					if(slOnOffValues.contains(sParam))
					{
						if(bOpen)
						{
							if("1".equals(sValue) || "On".equals(sValue))
							{
								sValue = TEXT_OPEN;
							}
							else if("0".equals(sValue) || "Off".equals(sValue))
							{
								sValue = TEXT_CLOSE;
							}
						}
						else if("1".equals(sValue))
						{
							sValue = TEXT_ON;
						}
						else if("0".equals(sValue))
						{
							sValue = TEXT_OFF;
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
					sbHTMLText.append("	<td class='text'>");
					sbHTMLText.append("	<label style='display:inline-block; width:50px'>"+sValue+"</label>");
					sbHTMLText.append("	</td>");
				}
				sbHTMLText.append("	</tr>");
			}
			sbHTMLText.append("	</table>");
		}
		catch(Exception e)
		{
			//do nothing
		}
		return sbHTMLText.toString();
	}
%>