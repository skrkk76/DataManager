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
		
		function updateBNo(roomId, mode)
		{
			var batchNo = document.getElementById(roomId+'_BNO'); 
			batchNo.value = batchNo.value.trim();
			if(batchNo.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Batch_No") %>");
				batchNo.focus();
			}
			else
			{
				parent.parent.frames['hiddenFrame'].document.location.href = "manageBNoProcess.jsp?roomId="+roomId+"&BNo="+batchNo.value+"&mode="+mode;
			}
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="0" width="<%= winWidth * 0.65 %>">
			<tr>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Room_Name") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Product") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></th>
				<th class="label" width="17%"><%= resourceBundle.getProperty("DataManager.DisplayText.From_Date") %></th>
				<th class="label" width="17%"><%= resourceBundle.getProperty("DataManager.DisplayText.To_Date") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			boolean isInactive = false;
			boolean bActions = true;
			String roomId = null;
			String cntrlType = null;
			String batchNo = null;
			String startDt = null;
			String endDt = null;
			String sHeader = null;
			StringList slHeaders = new StringList();
			StringList slInactiveControllers = RDMSession.getInactiveControllers();
			Map<String, String> mBatchNo = null;
			MapList mlBatchNos = null;

			String sMonth = request.getParameter("Month");
			sMonth = (sMonth == null ? "" : sMonth);
			String sYear = request.getParameter("Year");
			sYear = (sYear == null ? "" : sYear);
			String sCntrlType = request.getParameter("CntrlType");
			sCntrlType = (sCntrlType == null ? "" : sCntrlType);
			String sDefParamType = request.getParameter("defParamType");
			sDefParamType = (sDefParamType == null ? "" : sDefParamType);

			if(!"".equals(sMonth) && !"".equals(sYear))
			{
				bActions = false;
				mlBatchNos = RDMServicesUtils.getBatchNos(sMonth, sYear, sCntrlType, sDefParamType);
			}
			else
			{
				mlBatchNos = RDMServicesUtils.getBatchNos(sCntrlType, sDefParamType);
			}
			
			for(int i=0; i<mlBatchNos.size(); i++)
			{
				mBatchNo = mlBatchNos.get(i);
				roomId = mBatchNo.get(RDMServicesConstants.ROOM_ID);
				if(RDMServicesUtils.isGeneralController(roomId))
				{
					continue;
				}
				
				batchNo = mBatchNo.get(RDMServicesConstants.BATCH_NO);
				batchNo = (batchNo.startsWith("auto_") ? "" : batchNo);
				startDt = mBatchNo.get(RDMServicesConstants.START_DT);
				endDt = mBatchNo.get(RDMServicesConstants.END_DT);
				cntrlType = mBatchNo.get(RDMServicesConstants.CNTRL_TYPE);
				
				sHeader = cntrlType;
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
					<td class="input"><%= roomId %></td>
					<td class="input"><%=  mBatchNo.get(RDMServicesConstants.DEF_VAL_TYPE) %></td>
					<td class="input">
<%
					if(bActions)
					{
%>
						<input type="text" id="<%= roomId %>_BNO" name="<%= roomId %>_BNO" value="<%= batchNo %>" maxlength="10">
<%
					}
					else
					{
%>
						<%= batchNo %>
<%
					}
%>
					</td>
					<td class="input"><%= startDt %></td>
					<td class="input"><%= endDt %></td>
					<td class="input" style="text-align:center">
<%
					if(bActions)
					{
						if("".equals(batchNo))
						{
							if(slInactiveControllers.contains(roomId))
							{
%>
								<a href="javascript:updateBNo('<%= roomId %>', 'add')"><img border="0" src="../images/unblocked.png" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Add") %>"></a>
<%
							}
						}
						else
						{
%>
							<a href="javascript:updateBNo('<%= roomId %>', 'edit')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
<%
							if(slInactiveControllers.contains(roomId))
							{
%>
								<a href="javascript:updateBNo('<%= roomId %>', 'close')"><img border="0" src="../images/delete.png" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Close") %>"></a>
<%
							}
						}
					}
					else
					{
%>
						&nbsp;
<%
					}
%>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
