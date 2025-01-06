<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<%
String sTaskId = request.getParameter("taskId");
String sTaskAdmId = request.getParameter("taskAdmId");
String sDeliverableId = request.getParameter("deliverableId");
String sRoom = request.getParameter("room");
sRoom = ("".equals(sRoom) ? RDMServicesConstants.NO_ROOM : sRoom);

Map<String, String> mAdminTaskInfo = RDMServicesUtils.getAdminTask(sTaskAdmId);
String sTaskAttrs = mAdminTaskInfo.get(RDMServicesConstants.TASK_ATTRIBUTES);
String[] saTaskAttrs = sTaskAttrs.split("\\|");	
StringList slTaskAttrs = new StringList();
for(int i=0; i<saTaskAttrs.length; i++)
{
	if(saTaskAttrs[i] != null && !"".equals(saTaskAttrs[i]))
	{
		slTaskAttrs.add(saTaskAttrs[i]);
	}
}
slTaskAttrs.sort();

String sAttrName = null;
StringList slReadWeights = new StringList();
Map<String, String> mInfo = null;
Map<String, Map<String, String>> mAdminAttrs = new HashMap<String, Map<String, String>>();
MapList mlAdminAttrs = RDMServicesUtils.getAdminAttributes();
for(int i=0; i<mlAdminAttrs.size(); i++)
{
	mInfo = mlAdminAttrs.get(i);
	sAttrName = mInfo.get(RDMServicesConstants.ATTRIBUTE_NAME);
	mAdminAttrs.put(sAttrName, mInfo);

	if("true".equalsIgnoreCase(mInfo.get(RDMServicesConstants.READ_WEIGHTS)) && slTaskAttrs.contains(sAttrName))
	{
		slReadWeights.add(sAttrName);
	}
}

String mode = "add";
UserTasks userTasks = new UserTasks();

Map<String, String> mDeliverableInfo = new HashMap<String, String>();
if(sDeliverableId != null && !"".equals(sDeliverableId))
{
	mDeliverableInfo = userTasks.getDeliverableDetails(sDeliverableId);
	mode = "edit";
}

Map<String, String> mUserNames = RDMServicesUtils.getUserNames();

String sAdminTaskId = null;
String sTaskName = null;
String sKey = null;
Map<String, String> mTask = null;
Map<String, MapList> mUserTasks = new HashMap<String, MapList>();
MapList mlValues = null;

MapList mlTasks = userTasks.searchUserTasks(sRoom, "", u.getDepartment(), u.getUser(), "", "", "", RDMServicesConstants.TASK_STATUS_WIP, "", "", true, false, true, -1);
for(int i=0; i<mlTasks.size(); i++)
{
	mTask = mlTasks.get(i);
	sAdminTaskId = mTask.get(RDMServicesConstants.TASK_ID);
	sTaskName = mTask.get(RDMServicesConstants.TASK_NAME);
	
	sKey = sAdminTaskId+"("+sTaskName+")";
	mlValues = mUserTasks.get(sKey);
	if(mlValues == null)
	{
		mlValues = new MapList();
	}
	mlValues.add(mTask);
	mUserTasks.put(sKey, mlValues);
}

List<String> lKeys = new ArrayList<String>(mUserTasks.keySet());
Collections.sort(lKeys, String.CASE_INSENSITIVE_ORDER);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>

	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<link type="text/css" href="../styles/calendar.css" rel="stylesheet" />
	<style>
	img
	{
		vertical-align: middle;
	}
	</style>

	<script language="javaScript" type="text/javascript" src="../scripts/calendar.js"></script>
	<script language="javascript">
		if (!String.prototype.trim) 
		{
			String.prototype.trim = function() {
				return this.replace(/^\s+|\s+$/g,'');
			}
		}
		
		if ( typeof String.prototype.endsWith != 'function' )
		{
			String.prototype.endsWith = function( str ) {
				return this.substring( this.length - str.length, this.length ) === str;
			}
		};

		function getWeights(sAttrName)
		{
			var scale = document.getElementById('scale').value; 
			if(scale == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Scale") %>");
			}
			else
			{				
				var arrScale = scale.split("|");
				var scaleIP = arrScale[0];
				var port = arrScale[1];
				var scaleId = arrScale[2];

				parent.frames['hiddenFrame'].document.location.href = "readWeighingScale.jsp?scaleIP="+scaleIP+"&port="+port+"&attrName="+sAttrName+"&scaleId="+scaleId;
				
				document.getElementById(sAttrName+'_weights').style.display = "none";
				document.getElementById(sAttrName+'_loading').style.display = "block";
			}
		}

		function submitForm()
		{
			var fg = false;
			var inputs = document.getElementsByTagName("input");
			for(var i=0; i<inputs.length; i++)
			{
				var e = inputs[i];
				if(e.type == "text")
				{
					if(e.value.trim() != "")
					{
						var name = e.name;
						if(name.endsWith("_TW"))
						{
							if(isNaN(e.value))
							{
								alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Tare_Weight_NaN") %>");
							}
						}
						else
						{
							fg = true;
						}
					}
				}  
			}
		
			if(fg)
			{
				document.frm.submit();
			}
			else
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Deliverables") %>");
			}
		}
		
		function showTaskDeliverables()
		{
			var selTaskId = document.getElementById("selTaskId").value;
			var saTaskId = selTaskId.split("|");
			
			document.location.href = 'manageTaskDeliverable.jsp?taskId='+saTaskId[0]+'&taskAdmId='+saTaskId[1]+'&room=<%= sRoom %>';
		}
		
		function enableSubmit(e)
		{
			if(e.value > 0)
			{
				document.getElementById('save').disabled = false;
			}
		}
	</script>
</head>

<body>
	<form name="frm" method="post" target="hiddenFrame" action="manageTaskDeliverableProcess.jsp">
		<input type="hidden" id="mode" name="mode" value="<%= mode %>">
		<input type="hidden" id="taskId" name="taskId" value="<%= sTaskId %>">
		<input type="hidden" id="deliverableId" name="deliverableId" value="<%= sDeliverableId %>">
		<table border="0" cellpadding="1" cellspacing="0" width="80%" align="center">
			<tr>
				<td colspan="<%= (!slReadWeights.isEmpty() ? "4" : "3") %>" align="center" style="font-size:16px;font-weight:bold;font-family:Arial,sans-serif">
<%
				if(sDeliverableId == null || "".equals(sDeliverableId))
				{
%>
					<u><%= resourceBundle.getProperty("DataManager.DisplayText.Create_Deliverable") %></u>
<%
				}
				else
				{
%>
					<u><%= resourceBundle.getProperty("DataManager.DisplayText.Edit_Deliverable") %></u>
<%
				}
%>
				</td>
			</tr>
			<tr>
				<td colspan="<%= (!slReadWeights.isEmpty() ? "4" : "3") %>">&nbsp;</td>
			</tr>
			<tr>
<%
			if((sDeliverableId == null || "".equals(sDeliverableId)) && (mlTasks.size() > 0))
			{
%>
				<td colspan="<%= (!slReadWeights.isEmpty() ? "4" : "3") %>">
					<select id="selTaskId" name="selTaskId" onChange="javascript:showTaskDeliverables()">
<%
					String sTaskAutoId = null;
					String sTaskAssignee = null;
					for(int i=0; i<lKeys.size(); i++)
					{
						sKey = lKeys.get(i);
						mlValues = mUserTasks.get(sKey);
%>
						<optgroup label="<%= sKey %>">
<%
						for(int j=0; j<mlValues.size(); j++)
						{
							mTask = mlValues.get(j);					
							sTaskAutoId = mTask.get(RDMServicesConstants.TASK_AUTONAME);
							sTaskAssignee = mTask.get(RDMServicesConstants.ASSIGNEE);
							sAdminTaskId = mTask.get(RDMServicesConstants.TASK_ID);
%>
							<option value="<%= sTaskAutoId %>|<%= sAdminTaskId %>" <%= sTaskAutoId.equals(sTaskId) ? "selected" : "" %>><%= mUserNames.get(sTaskAssignee) %>&nbsp;(<%= sTaskAssignee %>)</option>
<%
						}
					}
%>
					</select>
				</td>
<%
			}

			if(!slReadWeights.isEmpty())
			{
				String sSelectedScale = (String)session.getAttribute("SelectedScale");
%>
				<tr>
					<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Weighing_Scale") %></b></td>
					<td class="input" colspan="2">
						<select id="scale" name="scale">
							<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						String scaleId = null;
						String scaleIP = null;
						String sPort = null; 
						String sStatus = null;
						MapList mlScales = RDMServicesUtils.getScalesList();
						
						for(int i=0; i<mlScales.size(); i++)
						{
							mInfo = mlScales.get(i);
							scaleId = mInfo.get(RDMServicesConstants.SCALE_ID);
							scaleIP = mInfo.get(RDMServicesConstants.SCALE_IP);
							sPort = mInfo.get(RDMServicesConstants.SCALE_PORT);
							sStatus = mInfo.get(RDMServicesConstants.SCALE_STATUS);

							if(RDMServicesConstants.ACTIVE.equals(sStatus))
							{
%>
								<option value="<%= scaleIP %>|<%= sPort %>|<%= scaleId %>" <%= scaleId.equals(sSelectedScale) ? "selected" : ""%>><%= scaleId %></option>
<%
							}
						}
%>
						</select>
					</td>
					<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Tare_Weight") %></b></td>
				</tr>
<%
			}

			String sAttrUnit = null;
			String sAttrField = null;
			String sAttrValue = null;
			String sReadWeights = null;
			String sTareWeight = null;
			for(int i=0; i<slTaskAttrs.size(); i++)
			{
				sAttrName = slTaskAttrs.get(i);
				mInfo = mAdminAttrs.get(sAttrName);
				sAttrUnit = mInfo.get(RDMServicesConstants.ATTRIBUTE_UNIT);
%>
				<tr>
					<td class="label" width="40%">
						<b><%= sAttrName %>
<%
						if(!"".equals(sAttrUnit))
						{
%>
							&nbsp;(<%= sAttrUnit %>)
<%
						}
%>
						</b>
					</td>
<%
					sAttrValue = mDeliverableInfo.get(sAttrName);
					sAttrValue = (sAttrValue == null ? "" : sAttrValue);
					if(slReadWeights.contains(sAttrName))
					{
						sTareWeight = (String)session.getAttribute(sAttrName+"_TW");
						sTareWeight = (sTareWeight == null ? mInfo.get(RDMServicesConstants.TARE_WEIGHT) : sTareWeight);
%>
						<td class="input" width="20%">
							<input type="text" id="<%= sAttrName %>" name="<%= sAttrName %>" value="<%= sAttrValue %>" size="12" readonly>
						</td>
						<td class="input" width="20%">
							<div id="<%= sAttrName %>_weights">
								<a href="javascript:getWeights('<%= sAttrName %>')"><img src="../images/readWeights.jpg" border="0"></a>
							</div>
							<div id="<%= sAttrName %>_loading" style="display:none">
								<img src="../images/loading_icon.gif" border="0">
							</div>
						</td>
						<td class="input" width="20%">
							<input type="text" id="<%= sAttrName %>_TW" name="<%= sAttrName %>_TW" value="<%= sTareWeight %>" size="5">
						</td>					
<%
					}
					else
					{
%>
						<td class="input" width="60%">
							<input type="text" id="<%= sAttrName %>" name="<%= sAttrName %>" value="<%= sAttrValue %>" onChange="javascript:enableSubmit(this)">
						</td>
<%
					}
%>
				</tr>
<%
			}
%>
			<tr>
				<td colspan="<%= (!slReadWeights.isEmpty() ? "4" : "3") %>">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="<%= (!slReadWeights.isEmpty() ? "4" : "3") %>" align="right">
<%
				if(slTaskAttrs.size() > 0)
				{
%>
					<input type="button" id="save" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" disabled onClick="submitForm()">&nbsp;&nbsp;&nbsp;
					<input type="button" id="close" name="Close" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Close") %>" onClick="javascript:top.window.close()">
<%
				}
%>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>