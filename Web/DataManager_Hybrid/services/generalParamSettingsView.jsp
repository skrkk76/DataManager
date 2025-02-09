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

	PLCServices client = null;
	String sCntrlVersion = RDMSession.getControllerVersion(sController);
	if(com.client.util.RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion))
	{
		client = new PLCServices_oldHW(RDMSession, sController);
	}
	else if(com.client.util.RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion))
	{
		client = new PLCServices_newHW(RDMSession, sController);
	}

	Map<String, ParamSettings> mParamSettings = qry.getGeneralParamAdminSettings(sCntrlType);
	ArrayList<String> displayOrder = qry.getGeneralParamDisplayOrder(sCntrlType);

	Map<String, String> mGenParams = client.getControllerParameters(sCntrlType);
	StringBuilder sbDelParams = new StringBuilder();
	
	Random randomGenerator = new Random();
	int randomInt = randomGenerator.nextInt(1000);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>

	<link type="text/css" href="../styles/superTables.css" rel="stylesheet" />
    <script type="text/javascript" src="../scripts/superTables.js"></script>
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
				document.getElementById(sName).checked = check;
				document.getElementById(sName).value = val;
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

<body>
	<table border="0" cellpadding="0" cellspacing="0" width="<%= winWidth * 0.8 %>">
		<tr>
			<td style="border:#ffffff; text-align:right">
				<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save_Changes") %>" onClick="javascript:saveChanges()">&nbsp;
				<input type="button" name="export" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Export_to_File") %>" onClick="javascript:exportSettings()">&nbsp;
				<input type="button" name="import" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Import_from_File") %>" onClick="javascript:importSettings()">
			</td>
		</tr>
	</table>
	<form name="adminForm" method="post" action="generalParamSettingsProcess.jsp" target="footer">
	<table border="1" cellpadding="0" cellspacing="0" width="<%= winWidth * 0.8 %>">
		<tr>
			<td>
				<table cellspacing="0" cellpadding="1" border="1" width="<%= winWidth * 0.8 %>">
					<tr>
						<th align="center" rowspan="2" width="2%" >
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'CHECK_')">
						</th>
						<th align="center" width="22%" rowspan="2">
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
						<th align="center" width="5%" rowspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Graph_View") %><br>
							<input type="checkbox" name="CHECK_ALL" value="" onClick="checkAll(this, 'GRAPH_VIEW_')">
						</th>
						<th align="center" width="8%" colspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Helper") %>
						</th>
						<th align="center" width="8%" colspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Supervisor") %>
						</th>
						<th align="center" width="8%" colspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Manager") %>
						</th>
						<th align="center" width="8%" colspan="2">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Administrator") %>
						</th>
						<th align="center" rowspan="2" width="1%">&nbsp;</th>
					</tr>
					<tr>
						<th align="center" width="4%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Read") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'HELPER_READ_')">
						</th>
						<th align="center" width="4%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Write") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'HELPER_WRITE_')">
						</th>
						<th align="center" width="4%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Read") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'SUPERVISOR_READ_')">
						</th>
						<th align="center" width="4%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Write") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'SUPERVISOR_WRITE_')">
						</th>
						<th align="center" width="4%">
							<%= resourceBundle.getProperty("DataManager.DisplayText.Read") %><br>
							<input type="checkbox" name="CHECK_ALL" onClick="checkAll(this, 'MANAGER_READ_')">
						</th>
						<th align="center" width="4%">
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
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div style="width:<%= winWidth * 0.8 %>px; height:<%= winHeight * 0.75 %>px; overflow:auto;">
					<table cellspacing="0" cellpadding="1" border="1" width="<%= winWidth * 0.8 %>">
<%
				ParamSettings mParam = null;
				String sName = null;
				String sDisplayOrder = null;
				String sGraphScale = null;
				String sOnOffValue = null;
				String sGraphView = null;
				String sViewerRead = null;
				String sViewerWrite = null;
				String sGrowerRead = null;
				String sGrowerWrite = null;
				String sManagerRead = null;
				String sManagerWrite = null;
				String sAdminRead = null;
				String sAdminWrite = null;
				int iDisplayOrder = 0;
				int iGraphScale = 0;
				
				int idx = 0;
				int iSz = displayOrder.size();
				for(int i=0; i<iSz; i++)
				{
					sName = (String)displayOrder.get(i);
					mParam = mParamSettings.get(sName);

					if(mParam != null && (mGenParams.size() > 0 && !mGenParams.containsKey(sName)))
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
					sOnOffValue = mParam.getOnOffValue();
					sGraphView = mParam.getGraphView();
					sViewerRead = mParam.getHelperRead();
					sViewerWrite = mParam.getHelperWrite();
					sGrowerRead = mParam.getSupervisorRead();
					sGrowerWrite = mParam.getSupervisorWrite();
					sManagerRead = mParam.getManagerRead();
					sManagerWrite = mParam.getManagerWrite();
					sAdminRead = mParam.getAdminRead();
					sAdminWrite = mParam.getAdminWrite();
%>
					<tr>
						<th width="2%">
							<input type="checkbox" id="CHECK_<%= idx %>" name="CHECK_<%= idx %>" value="" onClick="javacript:checkOne('CHECK_<%= idx %>', this.checked)">
						</th>
						<th style="text-align: left" width="22%"><%= sName %></th>
						<td align="center" width="5%">
							<input type="text" id="DISPLAY_ORDER_<%= idx %>" name="DISPLAY_ORDER_<%= idx %>" size="3" maxlength="3" value="<%= sDisplayOrder %>" onBlur="javascript:setValue('DISPLAY_ORDER_<%= idx %>', this.value)">
						</td>
						<td align="center" width="5%">
							<input type="text" id="GRAPH_SCALE_<%= idx %>" name="GRAPH_SCALE_<%= idx %>" size="3" maxlength="3" value="<%= sGraphScale %>" onBlur="javascript:setValue('GRAPH_SCALE_<%= idx %>', this.value)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ON_OFF_<%= idx %>" name="ON_OFF_<%= idx %>" value="<%= sOnOffValue %>" <%= ("Y".equals(sOnOffValue) ? "checked" : "") %> onClick="javacript:checkOne('ON_OFF_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="5%">
							<input type="checkbox" id="GRAPH_VIEW_<%= idx %>"  name="GRAPH_VIEW_<%= idx %>" value="<%= sGraphView %>" <%= ("Y".equals(sGraphView) ? "checked" : "") %> onClick="javacript:checkOne('GRAPH_VIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="HELPER_READ_<%= idx %>" name="HELPER_READ_<%= idx %>" value="<%= sViewerRead %>" <%= ("Y".equals(sViewerRead) ? "checked" : "") %> onClick="javacript:checkOne('HELPER_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="HELPER_WRITE_<%= idx %>" name="HELPER_WRITE_<%= idx %>" value="<%= sViewerWrite %>" <%= ("Y".equals(sViewerWrite) ? "checked" : "") %> onClick="javacript:checkOne('HELPER_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SUPERVISOR_READ_<%= idx %>" name="SUPERVISOR_READ_<%= idx %>" value="<%= sGrowerRead %>" <%= ("Y".equals(sGrowerRead) ? "checked" : "") %> onClick="javacript:checkOne('SUPERVISOR_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SUPERVISOR_WRITE_<%= idx %>" name="SUPERVISOR_WRITE_<%= idx %>" value="<%= sGrowerWrite %>" <%= ("Y".equals(sGrowerWrite) ? "checked" : "") %> onClick="javacript:checkOne('SUPERVISOR_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MANAGER_READ_<%= idx %>" name="MANAGER_READ_<%= idx %>" value="<%= sManagerRead %>" <%= ("Y".equals(sManagerRead) ? "checked" : "") %> onClick="javacript:checkOne('MANAGER_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MANAGER_WRITE_<%= idx %>" name="MANAGER_WRITE_<%= idx %>" value="<%= sManagerWrite %>" <%= ("Y".equals(sManagerWrite) ? "checked" : "") %> onClick="javacript:checkOne('MANAGER_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ADMIN_READ_<%= idx %>" name="ADMIN_READ_<%= idx %>" value="<%= sAdminRead %>" <%= ("Y".equals(sAdminRead) ? "checked" : "") %> onClick="javacript:checkOne('ADMIN_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ADMIN_WRITE_<%= idx %>" name="ADMIN_WRITE_<%= idx %>" value="<%= sAdminWrite %>" <%= ("Y".equals(sAdminWrite) ? "checked" : "") %> onClick="javacript:checkOne('ADMIN_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" style="border:#FFFFFF" width="1%">&nbsp;</th>
						
						<input type="hidden" name="PARAM_NAME_<%= idx %>" value="<%= sName %>">
						<input type="hidden" name="ACTION_<%= idx %>" value="update">
						<input type="hidden" name="PARAM_UNIT_<%= idx %>" value="<%= mGenParams.get(sName) %>">
					</tr>
<%				
					idx++;
				}
				
				boolean bShowHeader = true;
				Iterator<String> itr = mGenParams.keySet().iterator();
				while(itr.hasNext())
				{
					sName = itr.next();
					if(displayOrder.contains(sName))
					{
						continue;
					}
					
					if(bShowHeader)
					{
						bShowHeader = false;
%>
						<tr>
							<td class="stage" align="center" colspan="13">
								<%= resourceBundle.getProperty("DataManager.DisplayText.New_Parameters") %>
							</td>
						</tr>
<%
					}
%>
					<tr>
						<th width="2%">
							<input type="checkbox" id="CHECK_<%= idx %>" name="CHECK_<%= idx %>" value="" onClick="javacript:checkOne('CHECK_<%= idx %>', this.checked)">
						</th>
						<th style="text-align: left" width="22%"><%= sName %></th>
						<td align="center" width="5%">
							<input type="text" id="DISPLAY_ORDER_<%= idx %>" name="DISPLAY_ORDER_<%= idx %>" onBlur="javascript:setValue('DISPLAY_ORDER_<%= idx %>', this.value)" size="3" maxlength="3" value="">
						</td>
						<td align="center" width="5%">
							<input type="text" id="GRAPH_SCALE_<%= idx %>" name="GRAPH_SCALE_<%= idx %>" onBlur="javascript:setValue('GRAPH_SCALE_<%= idx %>', this.value)" size="3" maxlength="3" value="">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ON_OFF_<%= idx %>" name="ON_OFF_<%= idx %>" value="N" onClick="javacript:checkOne('ON_OFF_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="5%">
							<input type="checkbox" id="GRAPH_VIEW_<%= idx %>" name="GRAPH_VIEW_<%= idx %>" value="" onClick="javacript:checkOne('GRAPH_VIEW_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="HELPER_READ_<%= idx %>" name="HELPER_READ_<%= idx %>" value="" onClick="javacript:checkOne('HELPER_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="HELPER_WRITE_<%= idx %>" name="HELPER_WRITE_<%= idx %>" value="" onClick="javacript:checkOne('HELPER_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SUPERVISOR_READ_<%= idx %>" name="SUPERVISOR_READ_<%= idx %>" value="" onClick="javacript:checkOne('SUPERVISOR_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="SUPERVISOR_WRITE_<%= idx %>" name="SUPERVISOR_WRITE_<%= idx %>" value="" onClick="javacript:checkOne('SUPERVISOR_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MANAGER_READ_<%= idx %>" name="MANAGER_READ_<%= idx %>" value="" onClick="javacript:checkOne('MANAGER_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="MANAGER_WRITE_<%= idx %>" name="MANAGER_WRITE_<%= idx %>" value="" onClick="javacript:checkOne('MANAGER_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ADMIN_READ_<%= idx %>" name="ADMIN_READ_<%= idx %>" value="" onClick="javacript:checkOne('ADMIN_READ_<%= idx %>', this.checked)">
						</td>
						<td align="center" width="4%">
							<input type="checkbox" id="ADMIN_WRITE_<%= idx %>" name="ADMIN_WRITE_<%= idx %>" value="" onClick="javacript:checkOne('ADMIN_WRITE_<%= idx %>', this.checked)">
						</td>
						<td align="center" style="border:#FFFFFF" width="1%">&nbsp;</th>
						
						<input type="hidden" name="PARAM_NAME_<%= idx %>" value="<%= sName %>">
						<input type="hidden" name="ACTION_<%= idx %>" value="insert">
						<input type="hidden" name="PARAM_UNIT_<%= idx %>" value="<%= mGenParams.get(sName) %>">
					</tr>
<%
					idx++;
				}
%>
					<input type="hidden" id="PARAM_COUNT" name="PARAM_COUNT" value="<%= idx %>">
					<input type="hidden" id="CNTRL_TYPE" name="CNTRL_TYPE" value="<%= sCntrlType %>">
					<input type="hidden" id="DELETE_PARAMS" name="DELETE_PARAMS" value="<%= sbDelParams.toString() %>">
					</table>
				</div>
			</td>
		</tr>
	</table>
	</form>	
</body>
</html>
