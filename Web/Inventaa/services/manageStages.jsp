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
	<script language="javascript">
		if (!String.prototype.trim) 
		{
			String.prototype.trim = function() {
				return this.replace(/^\s+|\s+$/g,'');
			}
		}
		
		function editStage(stageId, type)
		{	
			var name = document.getElementById(stageId+'_'+type+'_name');
			name.value = name.value.trim();			
			var desc = document.getElementById(stageId+'_'+type+'_desc');			

			parent.frames['hiddenFrame'].document.location.href = "manageStageProcess.jsp?seqNum="+stageId+"&name="+name.value+"&desc="+desc.value+"&type="+type+"&mode=edit";
		}
		
		function addStage()
		{
			var retval = window.open('addStage.jsp', '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=250,width=400');
		}
		
		function deleteStage(stageId, type)
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Phase") %>");
			if(conf == true)
			{
				parent.frames['hiddenFrame'].document.location.href = "manageStageProcess.jsp?seqNum="+stageId+"&type="+type+"&mode=delete";
			}
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="<%= winWidth * 0.6 %>">
			<tr>
				<td colspan="5" style="text-align: right;">
					<input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Stage") %>" onClick="addStage()">
				</td>
			</tr>
			<tr>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Seq_Number") %></th>
				<th class="label" width="25%"><%= resourceBundle.getProperty("DataManager.DisplayText.Stage_Name") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Belongs_to") %></th>
				<th class="label" width="30%"><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			Map<String, String> mInfo = null;
			String stageSeqNo = null;
			String stageName = null;
			String stageType = null; 
			String stageDesc = null;
			String sHeader = null;
			StringList slHeaders = new StringList();
			MapList mlStages = RDMServicesUtils.getStageList();
			
			for(int i=0; i<mlStages.size(); i++)
			{
				mInfo = mlStages.get(i);
				stageSeqNo = mInfo.get(RDMServicesConstants.STAGE_NUMBER);
				stageName = mInfo.get(RDMServicesConstants.STAGE_NAME);
				stageName = ((stageName == null || "null".equals(stageName)) ? "" : stageName);
				stageType = mInfo.get(RDMServicesConstants.CNTRL_TYPE);
				stageDesc = mInfo.get(RDMServicesConstants.STAGE_DESC);
				stageDesc = ((stageDesc == null || "null".equals(stageDesc)) ? "" : stageDesc);
				
				sHeader = (stageType.startsWith("General") ? "General" : stageType);
				if(!slHeaders.contains(sHeader))
				{
					slHeaders.add(sHeader);
%>					
					<tr>
						<td colspan="5" align="center"><b><%= resourceBundle.getProperty("DataManager.DisplayText."+sHeader) %></b></td>
					</tr>
<%					
				}
%>
				<tr>
					<td class="input"><%= stageSeqNo %></td>
					<td class="input"><input type="text" id="<%= stageSeqNo %>_<%= stageType %>_name" name="<%= stageSeqNo %>_<%= stageType %>_name" value="<%= stageName %>"></td>
					<td class="input"><%= resourceBundle.getProperty("DataManager.DisplayText."+stageType) %></td>
					<td class="input"><input type="text" id="<%= stageSeqNo %>_<%= stageType %>_desc" size="40" name="<%= stageSeqNo %>_<%= stageType %>_desc" value="<%= stageDesc %>"></td>
					<td class="input" style="text-align:center">
						<a href="javascript:editStage('<%= stageSeqNo %>', '<%= stageType %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteStage('<%= stageSeqNo %>', '<%= stageType %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
