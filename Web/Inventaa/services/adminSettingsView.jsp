<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.db.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sCntrlType = request.getParameter("cntrlType");
	DataQuery qry = new DataQuery();
	
	Map<String, ParamSettings> mParamSettings = qry.getAdminSettings(sCntrlType);
	Map<String, String> mCntrlParams = RDMSession.getControllerParameters(sCntrlType);
	ArrayList<String[]> alStages = RDMServicesUtils.getControllerStages(sCntrlType);
	ArrayList<String> displayOrder = RDMServicesUtils.getDisplayOrder(sCntrlType);
	StringBuilder sbDelParams = new StringBuilder();
	
	Random randomGenerator = new Random();
	int randomInt = randomGenerator.nextInt(1000);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>

	<style>	
	th
	{
		background-color: #b3b7bb;
		color: #000000;
		font-family: Arial;
		font-size: 10pt;
		font-weight: normal;
	}
	</style>
	
	<script language="javascript">
		function checkAll (e, prefix) 
		{
			var check = e.checked;
			var val = "";
			if(check)
			{
				val = "Y";
			}
			else
			{
				val = "N";
			}

			var cnt = document.getElementById('PARAM_COUNT').value;
			for (var x=0; x<cnt; x++)
			{
				var sName = prefix + x;
				
				var e = document.getElementById(sName);
				e.checked = check;
				e.value = val;
			}
		}
		
		function checkOne (pid, chk) 
		{
			var elm = document.getElementById(pid);
			elm.checked = chk;
			
			if(chk)
			{
				elm.value = "Y";
			}
			else
			{
				elm.value = "N";
			}
		}
		
		function saveChanges()
		{
			document.forms[0].submit();
		}
		
		function setValue(pid, val) 
		{
			var elm = document.getElementById(pid);
			elm.value = val;
		}
		
		function setOptions(pid, val) 
		{
			var elm = document.getElementById(pid);
			for(i=0; i<elm.options.length; i++)
			{
				if(elm.options[i].value == val)
				{
					elm.options[i].selected = true;
				}
				else
				{
					elm.options[i].selected = false;
				}
			}
		}
		
		function toggleDisplay(divId)
		{
			var divs = document.getElementsByTagName("div");
			for(var i = 0; i < divs.length; i++)
			{
				if(divs[i].id == "master")
				{
					continue;
				}
				
				if(divs[i].id == divId)
				{
					var display = divs[i].style.display;
					if(display == "block")
					{
						display = "none";
					}
					else
					{
						display = "block";
					}
					divs[i].style.display = display;
				}
				else
				{
					divs[i].style.display = "none";
				}
			}
		}
		
		function exportSettings()
		{
			parent.frames['footer'].document.location.href = "../ExportAdminSettings?ControllerType=<%= sCntrlType %>";
		}
		
		function importSettings()
		{
			var idx = "<%= randomInt %>";
			POPUPW = window.open('importAdminSettings.jsp?ControllerType=<%= sCntrlType %>','POPUPW_'+idx,'menubar=no,toolbar=no,location=no,resizable=yes,scrollbars=yes,status=no,height=<%= winHeight * 0.2 %>px,width=<%= winWidth * 0.3 %>px');
		}
	</script>
</head>
<%
	ParamSettings mParam = null;
	String sName = null;
	String sDisplayOrder = null;
	String sGraphScale = null;
	String[] saStage = null;
	String sStage = null;
	String sOnOffValue = null;
	String sResetValue = null;
	String sRoomsOverview = null;
	String sMultiRoomsView = null;
	String sSingleRoomView = null;
	String sGraphView = null;
	String sViewerRead = null;
	String sViewerWrite = null;
	String sGrowerRead = null;
	String sGrowerWrite = null;
	String sManagerRead = null;
	String sManagerWrite = null;
	String sAdminRead = null;
	String sAdminWrite = null;
	String sSelected = null;
	String sSufix = null;
	String sParamGroup = null;
	String sPhase = null;
	String sUnit = null;
	int iDisplayOrder = 0;
	int iGraphScale = 0;
%>
<body>
	<table border="0" cellpadding="0" cellspacing="0" width="<%= winWidth * 0.95 %>">
		<tr>
			<td style="border:#ffffff; text-align:right">
				<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save_Changes") %>" onClick="javascript:saveChanges()">&nbsp;
				<input type="button" name="export" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Export_to_File") %>" onClick="javascript:exportSettings()">&nbsp;
				<input type="button" name="import" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Import_from_File") %>" onClick="javascript:importSettings()">
			</td>
		</tr>
	</table>
	<form name="adminForm" method="post" action="adminSettingsProcess.jsp" target="footer">
	<table border="1" cellpadding="0" cellspacing="0" width="<%= winWidth * 0.95 %>">
		<tr>
			<td>
				<table cellspacing="0" cellpadding="1" border="1" width="<%= winWidth * 0.95 %>">
					<tr>
						<th align="center" rowspan="2" width="2%">
							<input type="checkbox" id="CHECK_ALL" name="CHECK_ALL" value="" onClick="checkAll(this, 'CHECK_')">
						</th>
						<th align="center" width="25%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Name") %>
						</th>
						<th align="center" width="5%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Display_Order") %>
						</th>
						<th align="center" width="5%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Scale_Used") %>
						</th>
						<th align="center" width="4%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.On_Off") %>
						</th>
						<th align="center" width="4%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Reset") %>
						</th>
						<th align="center" width="11%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Stage") %>
						</th>
						<th align="center" width="4%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Rooms_View") %><br>
							<input type="checkbox" name="CHECK_ALL" value="" onClick="checkAll(this, 'ROOMS_OVERVIEW_')">
						</th>
						<th align="center" width="4%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Multi_Room") %><br>
							<input type="checkbox" name="CHECK_ALL" value="" onClick="checkAll(this, 'MULTIROOMS_VIEW_')">
						</th>
						<th align="center" width="4%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Single_Room") %><br>
							<input type="checkbox" name="CHECK_ALL" value="" onClick="checkAll(this, 'SINGLEROOM_VIEW_')">
						</th>
						<th align="center" width="4%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Graph_View") %><br>
							<input type="checkbox" name="CHECK_ALL" value="" onClick="checkAll(this, 'GRAPH_VIEW_')">
						</th>
						<th align="center" width="6%" colspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Helper") %></th>
						<th align="center" width="6%" colspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Supervisor") %></th>
						<th align="center" width="6%" colspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Manager") %></th>
						<th align="center" width="8%" colspan="2"><%= resourceBundle.getProperty("DataManager.DisplayText.Administrator") %></th>
						<th align="center" rowspan="2" width="1%">&nbsp;</th>
					</tr>
					<tr>
						<th align="center" width="3%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Read") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'HELPER_READ_')">
						</th>
						<th align="center" width="3%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Write") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'HELPER_WRITE_')">
						</th>
						<th align="center" width="3%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Read") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'SUPERVISOR_READ_')">
						</th>
						<th align="center" width="3%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Write") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'SUPERVISOR_WRITE_')">
						</th>
						<th align="center" width="3%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Read") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'MANAGER_READ_')">
						</th>
						<th align="center" width="3%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Write") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'MANAGER_WRITE_')">
						</th>
						<th align="center" width="4%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Read") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'ADMIN_READ_')">
						</th>
						<th align="center" width="4%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Write") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'ADMIN_WRITE_')">
						</th>
					</tr>
<%
					mParam = mParamSettings.get("BatchNo");
					if(mParam != null)
					{
						iDisplayOrder = mParam.getDisplayOrder();
						sDisplayOrder = ((iDisplayOrder <= 0 || iDisplayOrder == 999) ? "" : ""+iDisplayOrder);
						sRoomsOverview = mParam.getRoomsOverview();
						sMultiRoomsView = mParam.getMultiRoomView();
						sSingleRoomView = mParam.getSingleRoomView();
						sGraphView = mParam.getGraphView();
					}
					sDisplayOrder = ((sDisplayOrder == null) ? "" : sDisplayOrder);
%>
					<tr>
						<th width="2%">
							<input type="checkbox" id="batchNo" name="batchNo" value="" onClick="javacript:checkOne('batchNo', this.checked)">
						</th>
						<th style="text-align: left" width="25%"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></th>
						<td align="center" width="5%">
							<input type="text" id="DISPLAY_ORDER_BatchNo" name="DISPLAY_ORDER_BatchNo" size="3" maxlength="3" value="<%= sDisplayOrder %>" onBlur="javascript:setValue('DISPLAY_ORDER_BatchNo', this.value)">
						</td>
						<td align="center" width="5%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="11%">&nbsp;</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ROOMS_OVERVIEW_BatchNo" name="ROOMS_OVERVIEW_BatchNo" value="<%= sRoomsOverview %>" <%= ("Y".equals(sRoomsOverview) ? "checked" : "") %> onClick="javacript:checkOne('ROOMS_OVERVIEW_BatchNo', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MULTIROOMS_VIEW_BatchNo" name="MULTIROOMS_VIEW_BatchNo" value="<%= sMultiRoomsView %>" <%= ("Y".equals(sMultiRoomsView) ? "checked" : "") %> onClick="javacript:checkOne('MULTIROOMS_VIEW_BatchNo', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SINGLEROOM_VIEW_BatchNo" name="SINGLEROOM_VIEW_BatchNo" value="<%= sSingleRoomView %>" <%= ("Y".equals(sSingleRoomView) ? "checked" : "") %> onClick="javacript:checkOne('SINGLEROOM_VIEW_BatchNo', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="GRAPH_VIEW_BatchNo"  name="GRAPH_VIEW_BatchNo" value="<%= sGraphView %>" <%= ("Y".equals(sGraphView) ? "checked" : "") %> onClick="javacript:checkOne('GRAPH_VIEW_BatchNo', this.checked)">
						</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" style="border:#FFFFFF" width="1%">&nbsp;</td>
					</tr>
<%
					mParam = mParamSettings.get("Product");
					if(mParam != null)
					{
						iDisplayOrder = mParam.getDisplayOrder();
						sDisplayOrder = ((iDisplayOrder <= 0 || iDisplayOrder == 999) ? "" : ""+iDisplayOrder);
						sRoomsOverview = mParam.getRoomsOverview();
						sMultiRoomsView = mParam.getMultiRoomView();
						sSingleRoomView = mParam.getSingleRoomView();
						sGraphView = mParam.getGraphView();
					}
					sDisplayOrder = ((sDisplayOrder == null) ? "" : sDisplayOrder);
%>
					<tr>
						<th width="2%">
							<input type="checkbox" id="product" name="product" value="" onClick="javacript:checkOne('product', this.checked)">
						</th>
						<th style="text-align: left" width="25%"><%= resourceBundle.getProperty("DataManager.DisplayText.Product") %></th>							
						<td align="center" width="5%">
							<input type="text" id="DISPLAY_ORDER_Product" name="DISPLAY_ORDER_Product" size="3" maxlength="3" value="<%= sDisplayOrder %>" onBlur="javascript:setValue('DISPLAY_ORDER_Product', this.value)">
						</td>
						<td align="center" width="5%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="11%">&nbsp;</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ROOMS_OVERVIEW_Product" name="ROOMS_OVERVIEW_Product" value="<%= sRoomsOverview %>" <%= ("Y".equals(sRoomsOverview) ? "checked" : "") %> onClick="javacript:checkOne('ROOMS_OVERVIEW_Product', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MULTIROOMS_VIEW_Product" name="MULTIROOMS_VIEW_Product" value="<%= sMultiRoomsView %>" <%= ("Y".equals(sMultiRoomsView) ? "checked" : "") %> onClick="javacript:checkOne('MULTIROOMS_VIEW_Product', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SINGLEROOM_VIEW_Product" name="SINGLEROOM_VIEW_Product" value="<%= sSingleRoomView %>" <%= ("Y".equals(sSingleRoomView) ? "checked" : "") %> onClick="javacript:checkOne('SINGLEROOM_VIEW_Product', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="GRAPH_VIEW_Product"  name="GRAPH_VIEW_Product" value="<%= sGraphView %>" <%= ("Y".equals(sGraphView) ? "checked" : "") %> onClick="javacript:checkOne('GRAPH_VIEW_Product', this.checked)">
						</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" style="border:#FFFFFF" width="1%">&nbsp;</td>
					</tr>
<%
					mParam = mParamSettings.get("ViewImage");
					if(mParam != null)
					{
						sRoomsOverview = mParam.getRoomsOverview();
						sMultiRoomsView = mParam.getMultiRoomView();
						sSingleRoomView = mParam.getSingleRoomView();
						sGraphView = mParam.getGraphView();
					}
					sDisplayOrder = ((sDisplayOrder == null) ? "" : sDisplayOrder);
%>
					<tr>
						<th width="2%">
							<input type="checkbox" id="image" name="image" value="" onClick="javacript:checkOne('image', this.checked)">
						</th>
						<th style="text-align: left" width="25%"><%= resourceBundle.getProperty("DataManager.DisplayText.View_Image") %></th>
						<td align="center" width="5%">&nbsp;</td>
						<td align="center" width="5%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="11%">&nbsp;</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ROOMS_OVERVIEW_ViewImage" name="ROOMS_OVERVIEW_ViewImage" value="<%= sRoomsOverview %>" <%= ("Y".equals(sRoomsOverview) ? "checked" : "") %> onClick="javacript:checkOne('ROOMS_OVERVIEW_ViewImage', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MULTIROOMS_VIEW_ViewImage" name="MULTIROOMS_VIEW_ViewImage" value="<%= sMultiRoomsView %>" <%= ("Y".equals(sMultiRoomsView) ? "checked" : "") %> onClick="javacript:checkOne('MULTIROOMS_VIEW_ViewImage', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SINGLEROOM_VIEW_ViewImage" name="SINGLEROOM_VIEW_ViewImage" value="<%= sSingleRoomView %>" <%= ("Y".equals(sSingleRoomView) ? "checked" : "") %> onClick="javacript:checkOne('SINGLEROOM_VIEW_ViewImage', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="GRAPH_VIEW_ViewImage"  name="GRAPH_VIEW_ViewImage" value="<%= sGraphView %>" <%= ("Y".equals(sGraphView) ? "checked" : "") %> onClick="javacript:checkOne('GRAPH_VIEW_ViewImage', this.checked)">
						</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="3%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" width="4%">&nbsp;</td>
						<td align="center" style="border:#FFFFFF" width="1%">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div id="master" style="width:<%= winWidth * 0.95 %>px; height:<%= winHeight * 0.67 %>px; overflow:auto;">
					<table cellspacing="0" cellpadding="1" border="1" width="<%= winWidth * 0.95 %>">
<%
				int idx = 0;
				int iSz = displayOrder.size();
				for(int i=0; i<iSz; i++)
				{
					sName = (String)displayOrder.get(i);
					if("BatchNo".equals(sName) || "Product".equals(sName) || "ViewImage".equals(sName))
					{
						continue;
					}
					
					mParam = mParamSettings.get(sName);
					if(mParam == null)
					{
						if(sName.startsWith(">>>"))
						{
							if(i > 0)
							{
%>
											</table>
										</div>
									</td>
								</tr>
<%
							}
%>
							<tr>
								<td class="stage" align="center" colspan="18">
									<a href="javascript:toggleDisplay('div_<%= i %>')"><%= sName.replaceAll(">", " ").trim() %></a>
								</td>
							</tr>
							
							<tr>
								<td colspan="18">
									<div id="div_<%= i %>" style="<%= i== 0 ? "display:block" : "display:none"%>">
										<table cellspacing="0" cellpadding="1" border="1" width="<%= winWidth * 0.95 %>">
<%
						}
						continue;
					}
					
					if(mParam != null && (mCntrlParams.size() > 0 && !mCntrlParams.containsKey(sName)))
					{
						if(sbDelParams.length() > 1)
						{
							sbDelParams.append(",");
						}
						sbDelParams.append("'" + sName + "'");
						
						continue;
					}
					
					iDisplayOrder = mParam.getDisplayOrder();
					sDisplayOrder = ((iDisplayOrder <= 0 || iDisplayOrder == 999) ? "" : ""+iDisplayOrder);
					iGraphScale = mParam.getScaleOnGraph();
					sGraphScale = ((iGraphScale <= 1) ? "" : ""+iGraphScale);
					sStage = mParam.getStage();
					sOnOffValue = mParam.getOnOffValue();
					sResetValue = mParam.getResetValue();
					sRoomsOverview = mParam.getRoomsOverview();
					sMultiRoomsView = mParam.getMultiRoomView();
					sSingleRoomView = mParam.getSingleRoomView();
					sGraphView = mParam.getGraphView();
					sViewerRead = mParam.getHelperRead();
					sViewerWrite = mParam.getHelperWrite();
					sGrowerRead = mParam.getSupervisorRead();
					sGrowerWrite = mParam.getSupervisorWrite();
					sManagerRead = mParam.getManagerRead();
					sManagerWrite = mParam.getManagerWrite();
					sAdminRead = mParam.getAdminRead();
					sAdminWrite = mParam.getAdminWrite();
					sUnit = (mCntrlParams.containsKey(sName) ? mCntrlParams.get(sName) : mParam.getParamUnit());
%>
					<tr>
						<th width="2%">
							<input type="checkbox" id="CHECK_<%= idx %>" name="CHECK_<%= idx %>" value="" onClick="javacript:checkOne('CHECK_<%= idx %>', this.checked)">
						</th>
						<th style="text-align: left" width="25%"><%= sName %></th>
						<td align="center" width="5%">
							<input type="text" id="DISPLAY_ORDER_<%= idx %>" name="DISPLAY_ORDER_<%= idx %>" size="3" maxlength="3" value="<%= sDisplayOrder %>" onBlur="javascript:setValue('DISPLAY_ORDER_<%= idx %>', this.value)">
						</td>
						<td align="center" width="5%">
							<input type="text" id="GRAPH_SCALE_<%= idx %>" name="GRAPH_SCALE_<%= idx %>" size="3" maxlength="3" value="<%= sGraphScale %>" onBlur="javascript:setValue('GRAPH_SCALE_<%= idx %>', this.value)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ON_OFF_<%= idx %>" name="ON_OFF_<%= idx %>" value="<%= sOnOffValue %>" <%= ("Y".equals(sOnOffValue) ? "checked" : "") %> onClick="javacript:checkOne('ON_OFF_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="RESET_VALUE_<%= idx %>" name="RESET_VALUE_<%= idx %>" value="<%= sResetValue %>" <%= ("Y".equals(sResetValue) ? "checked" : "") %> onClick="javacript:checkOne('RESET_VALUE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="11%">
							<select id="STAGE_NAME_<%= idx %>" name="STAGE_NAME_<%= idx %>" onChange="javascript:setOptions('STAGE_NAME_<%= idx %>', this.value)">
								<option value="NA"><%= resourceBundle.getProperty("DataManager.DisplayText.NA") %></option>
<%
								sParamGroup = "";
								for(int x=0; x<alStages.size(); x++)
								{
									saStage = alStages.get(x);
									sSufix = ("empty".equals(saStage[1]) ? " empty" : (" " + saStage[0]));
									
									if("".equals(sParamGroup))
									{
										sParamGroup = getParamGroup(sName, saStage[1], saStage[0]);
									}
									
									sSelected = getStageSelection(sName, sStage, saStage[1], saStage[0]);
									sPhase = (saStage[0].equals(saStage[1]) ? saStage[0] : saStage[1]+"&nbsp;("+saStage[0]+")");
%>
									<option value="<%= saStage[0] %>" <%= sSelected %>><%= sPhase %></option>
<%
								}
%>
							</select>
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ROOMS_OVERVIEW_<%= idx %>" name="ROOMS_OVERVIEW_<%= idx %>" value="<%= sRoomsOverview %>" <%= ("Y".equals(sRoomsOverview) ? "checked" : "") %> onClick="javacript:checkOne('ROOMS_OVERVIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MULTIROOMS_VIEW_<%= idx %>" name="MULTIROOMS_VIEW_<%= idx %>" value="<%= sMultiRoomsView %>" <%= ("Y".equals(sMultiRoomsView) ? "checked" : "") %> onClick="javacript:checkOne('MULTIROOMS_VIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SINGLEROOM_VIEW_<%= idx %>" name="SINGLEROOM_VIEW_<%= idx %>" value="<%= sSingleRoomView %>" <%= ("Y".equals(sSingleRoomView) ? "checked" : "") %> onClick="javacript:checkOne('SINGLEROOM_VIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="GRAPH_VIEW_<%= idx %>"  name="GRAPH_VIEW_<%= idx %>" value="<%= sGraphView %>" <%= ("Y".equals(sGraphView) ? "checked" : "") %> onClick="javacript:checkOne('GRAPH_VIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="HELPER_READ_<%= idx %>" name="HELPER_READ_<%= idx %>" value="<%= sViewerRead %>" <%= ("Y".equals(sViewerRead) ? "checked" : "") %> onClick="javacript:checkOne('HELPER_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="HELPER_WRITE_<%= idx %>" name="HELPER_WRITE_<%= idx %>" value="<%= sViewerWrite %>" <%= ("Y".equals(sViewerWrite) ? "checked" : "") %> onClick="javacript:checkOne('HELPER_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="SUPERVISOR_READ_<%= idx %>" name="SUPERVISOR_READ_<%= idx %>" value="<%= sGrowerRead %>" <%= ("Y".equals(sGrowerRead) ? "checked" : "") %> onClick="javacript:checkOne('SUPERVISOR_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="SUPERVISOR_WRITE_<%= idx %>" name="SUPERVISOR_WRITE_<%= idx %>" value="<%= sGrowerWrite %>" <%= ("Y".equals(sGrowerWrite) ? "checked" : "") %> onClick="javacript:checkOne('SUPERVISOR_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="MANAGER_READ_<%= idx %>" name="MANAGER_READ_<%= idx %>" value="<%= sManagerRead %>" <%= ("Y".equals(sManagerRead) ? "checked" : "") %> onClick="javacript:checkOne('MANAGER_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="MANAGER_WRITE_<%= idx %>" name="MANAGER_WRITE_<%= idx %>" value="<%= sManagerWrite %>" <%= ("Y".equals(sManagerWrite) ? "checked" : "") %> onClick="javacript:checkOne('MANAGER_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ADMIN_READ_<%= idx %>" name="ADMIN_READ_<%= idx %>" value="<%= sAdminRead %>" <%= ("Y".equals(sAdminRead) ? "checked" : "") %> onClick="javacript:checkOne('ADMIN_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ADMIN_WRITE_<%= idx %>" name="ADMIN_WRITE_<%= idx %>" value="<%= sAdminWrite %>" <%= ("Y".equals(sAdminWrite) ? "checked" : "") %> onClick="javacript:checkOne('ADMIN_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" style="border:#FFFFFF" width="1%">&nbsp;</td>
						
						<input type="hidden" name="PARAM_NAME_<%= idx %>" value="<%= sName %>"/>
						<input type="hidden" name="ACTION_<%= idx %>" value="update"/>
						<input type="hidden" name="PARAM_GROUP_<%= idx %>" value="<%= sParamGroup %>"/>
						<input type="hidden" name="PARAM_UNIT_<%= idx %>" value="<%=  sUnit %>"/>
					</tr>
<%				
					idx++;
				}
%>
							</table>
						</div>
					</td>
				</tr>
<%
				boolean bShowHeader = true;
				Iterator<String> itr = mCntrlParams.keySet().iterator();
				while(itr.hasNext())
				{
					sName = itr.next();
					if(mParamSettings.containsKey(sName))
					{
						continue;
					}
					
					if(bShowHeader)
					{
						bShowHeader = false;
%>
						<tr>
							<td class="stage" align="center" colspan="18">
								<a href="javascript:toggleDisplay('NewParameters')"><%= resourceBundle.getProperty("DataManager.DisplayText.New_Controller_Params") %></a>
							</td>
						</tr>
						
						<tr>
							<td colspan="18">
								<div id="NewParameters" style="display:none">
									<table cellspacing="0" cellpadding="1" border="1" width="<%= winWidth * 0.95 %>">
<%
					}
%>
					<tr>
						<th width="2%">
							<input type="checkbox" id="CHECK_<%= idx %>" name="CHECK_<%= idx %>" value="" onClick="javacript:checkOne('CHECK_<%= idx %>', this.checked)">
						</th>
						<th style="text-align: left" width="25%"><%= sName %></th>
						<td align="center" width="5%">
							<input type="text" id="DISPLAY_ORDER_<%= idx %>" name="DISPLAY_ORDER_<%= idx %>" onBlur="javascript:setValue('DISPLAY_ORDER_<%= idx %>', this.value)" size="3" maxlength="3" value="">
						</td>
						<td align="center" width="5%">
							<input type="text" id="GRAPH_SCALE_<%= idx %>" name="GRAPH_SCALE_<%= idx %>" onBlur="javascript:setValue('GRAPH_SCALE_<%= idx %>', this.value)" size="3" maxlength="3" value="">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ON_OFF_<%= idx %>" name="ON_OFF_<%= idx %>" value="N" onClick="javacript:checkOne('ON_OFF_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="RESET_VALUE_<%= idx %>" name="RESET_VALUE_<%= idx %>" value="N" onClick="javacript:checkOne('RESET_VALUE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="11%">
							<select id="STAGE_NAME_<%= idx %>" name="STAGE_NAME_<%= idx %>" onChange="javascript:setOptions('STAGE_NAME_<%= idx %>', this.value)">
								<option value="NA"><%= resourceBundle.getProperty("DataManager.DisplayText.NA") %></option>
<%
								sParamGroup = "";
								for(int x=0; x<alStages.size(); x++)
								{
									saStage = alStages.get(x);
									sSufix = ("empty".equals(saStage[1]) ? " empty" : (" " + saStage[0]));
									
									if("".equals(sParamGroup))
									{
										sParamGroup = getParamGroup(sName, saStage[1], saStage[0]);
									}
									
									sSelected = getStageSelection(sName, "", saStage[1], saStage[0]);
									sPhase = (saStage[0].equals(saStage[1]) ? saStage[0] : saStage[1]+"&nbsp;("+saStage[0]+")");
%>
									<option value="<%= saStage[0] %>" <%= sSelected %>><%= sPhase %></option>
<%
								}
%>
							</select>
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ROOMS_OVERVIEW_<%= idx %>" name="ROOMS_OVERVIEW_<%= idx %>" value="" onClick="javacript:checkOne('ROOMS_OVERVIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MULTIROOMS_VIEW_<%= idx %>" name="MULTIROOMS_VIEW_<%= idx %>" value="" onClick="javacript:checkOne('MULTIROOMS_VIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SINGLEROOM_VIEW_<%= idx %>" name="SINGLEROOM_VIEW_<%= idx %>" value="" onClick="javacript:checkOne('SINGLEROOM_VIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="GRAPH_VIEW_<%= idx %>" name="GRAPH_VIEW_<%= idx %>" value="" onClick="javacript:checkOne('GRAPH_VIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="HELPER_READ_<%= idx %>" name="HELPER_READ_<%= idx %>" value="" onClick="javacript:checkOne('HELPER_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="HELPER_WRITE_<%= idx %>" name="HELPER_WRITE_<%= idx %>" value="" onClick="javacript:checkOne('HELPER_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="SUPERVISOR_READ_<%= idx %>" name="SUPERVISOR_READ_<%= idx %>" value="" onClick="javacript:checkOne('SUPERVISOR_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="SUPERVISOR_WRITE_<%= idx %>" name="SUPERVISOR_WRITE_<%= idx %>" value="" onClick="javacript:checkOne('SUPERVISOR_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="MANAGER_READ_<%= idx %>" name="MANAGER_READ_<%= idx %>" value="" onClick="javacript:checkOne('MANAGER_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="3%">
							<input type="checkbox" id="MANAGER_WRITE_<%= idx %>" name="MANAGER_WRITE_<%= idx %>" value="" onClick="javacript:checkOne('MANAGER_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ADMIN_READ_<%= idx %>" name="ADMIN_READ_<%= idx %>" value="" onClick="javacript:checkOne('ADMIN_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ADMIN_WRITE_<%= idx %>" name="ADMIN_WRITE_<%= idx %>" value="" onClick="javacript:checkOne('ADMIN_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" style="border:#FFFFFF" width="1%">
						
						<input type="hidden" name="PARAM_NAME_<%= idx %>" value="<%= sName %>"/>
						<input type="hidden" name="ACTION_<%= idx %>" value="insert"/>
						<input type="hidden" name="PARAM_GROUP_<%= idx %>" value="<%= sParamGroup %>"/>
						<input type="hidden" name="PARAM_UNIT_<%= idx %>" value="<%= sUnit %>"/>
					</tr>
<%
					idx++;
				}
%>
					<input type="hidden" id="PARAM_COUNT" name="PARAM_COUNT" value="<%= idx %>"/>
					<input type="hidden" id="CNTRL_TYPE" name="CNTRL_TYPE" value="<%= sCntrlType %>"/>
					<input type="hidden" id="DELETE_PARAMS" name="DELETE_PARAMS" value="<%= sbDelParams.toString() %>"/>
					
					</table>
				</div>
			</td>
		</tr>
	</table>
	</form>	
</body>
</html>

<%!
private String getParamGroup(String sName, String sPhase, String saStage)
{
	int idx = -1;
	String sParamGroup = "";

	if(sName.endsWith(" "+sPhase+" "+saStage))
	{
		idx = sName.indexOf(" "+sPhase+" "+saStage);
	}
	else  if(sName.endsWith(" phase "+saStage))
	{
		idx = sName.indexOf(" phase "+saStage);
	}
	else if(sName.endsWith(" phase empty"))
	{
		idx = sName.indexOf(" phase empty");
	}
	else if(sName.endsWith(" empty"))
	{
		idx = sName.indexOf(" empty");
	}
	
	if(idx > 0)
	{
		sParamGroup = sName.substring(0, idx).trim();
	}
	
	return sParamGroup;
}

private String getStageSelection(String sName, String sStage, String sPhase, String saStage)
{
	if(sStage.equals(saStage))
	{
		return "Selected";
	}
	else if(sName.endsWith(" "+sPhase+" "+saStage))
	{
		return "Selected";
	}
	else  if(sName.endsWith(" phase "+saStage))
	{
		return "Selected";
	}
	else if(sName.endsWith(" empty") && saStage.equals("0"))
	{
		return "Selected";
	}
	
	return "";
}
%>
