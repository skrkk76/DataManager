<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.db.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>

	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
	function updateComments(id, bNo, bGlobal)
	{
		var retval = window.open('updateUserComments.jsp?cmtId='+id+'&bNo='+bNo+'&global='+bGlobal+'&from=homeView', 'Comments', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=300,width=500');
	}
	
	function closeComments(id)
	{
		parent.frames['hiddenFrame'].document.location.href = "manageCommentsProcess.jsp?cmtId="+id+"&mode=close&from=homeView";
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
	
	function viewAttachments(taskname)
	{
		var url = "../ViewAttachments?folder="+taskname;
		document.location.href =  url;
	}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="1" cellspacing="0" width="100%">
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<th class="label" width="2%">ATT</th>
				<th class="label" width="7%"><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Stage") %></th>
				<th class="label" width="7%"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_By") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_On") %></th>
				<th class="label" width="12%"><%= resourceBundle.getProperty("DataManager.DisplayText.Text") %></th>
				<th class="label" width="35%"><%= resourceBundle.getProperty("DataManager.DisplayText.Comments") %></th>
				<th class="label" width="7%"><%= resourceBundle.getProperty("DataManager.DisplayText.Department") %></th>
				<th class="label" width="5%">&nbsp;</th>
			</tr>
<%
			boolean bHideRoomView = !(u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM));

			Comments comments = new Comments();
			MapList mlComments = comments.getGlobalAlerts(u);
			int iSz = mlComments.size();
			if(iSz > 0)
			{
				StringList slInactiveCntrl = RDMSession.getInactiveControllers();

				Map<String, String> mUsers = RDMServicesUtils.getUserNames();
				Map<String, String> mComment = null;
				String sCmtId = null;
				String sRoomId = null;
				String sBatchNo = null;
				String sLoggedBy = null;
				String sNoDays = null;
				String sAttachments = null;
				for(int i=0; i<iSz; i++)
				{
					mComment = mlComments.get(i);
					sCmtId = mComment.get(RDMServicesConstants.COMMENT_ID);
					sRoomId = mComment.get(RDMServicesConstants.ROOM_ID);
					sBatchNo = mComment.get(RDMServicesConstants.BATCH_NO);
					sBatchNo = (sBatchNo.startsWith("auto_") ? "" : sBatchNo);
					sLoggedBy = mComment.get(RDMServicesConstants.LOGGED_BY);
					if(mUsers.containsKey(sLoggedBy))
					{
						sLoggedBy = mUsers.get(sLoggedBy);
					}
					sNoDays = mComment.get(RDMServicesConstants.RUNNING_DAY);
					sNoDays = ((sNoDays == null || "0".equals(sNoDays)) ? "" : " ("+sNoDays+")");
					sAttachments = mComment.get(RDMServicesConstants.ATTACHMENTS);
					sAttachments = ((sAttachments == null || "null".equals(sAttachments)) ? "" : sAttachments);
%>
					<tr>
						<td class="input" width="2%">
<%
							if(!"".equals(sAttachments))
							{
%>
								<a href="javascript:viewAttachments('<%= sCmtId %>')"><img src="../images/attachments.png"></img></a>
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
						if(slInactiveCntrl.contains(sRoomId) || bHideRoomView)
						{
%>
							<td class="input" width="7%"><%= sRoomId %></td>
<%
						}
						else
						{
%>
							<td class="input" width="7%"><a href="javascript:openController('<%= sRoomId %>')"><%= sRoomId %></a></td>
<%
						}
%>
						<td class="input" width="5%" style="text-align:center"><%= mComment.get(RDMServicesConstants.STAGE_NUMBER) %><%= sNoDays %></td>
						<td class="input" width="7%"><%= sBatchNo %></td>
						<td class="input" width="10%"><%= sLoggedBy %></td>
						<td class="input" width="10%"><%= mComment.get(RDMServicesConstants.LOGGED_ON) %></td>
						<td class="input" width="12%" style="WORD-BREAK:BREAK-ALL"><%= mComment.get(RDMServicesConstants.CATEGORY) %>&nbsp;(<%= mComment.get(RDMServicesConstants.LOG_TEXT) %>)</td>
						<td class="input" width="35%" style="WORD-BREAK:BREAK-ALL"><%= mComment.get(RDMServicesConstants.REVIEW_COMMENTS) %></td>
						<td class="input" width="7%"><%= (mComment.get(RDMServicesConstants.DEPARTMENT_NAME)).replaceAll("\\|", "<br>") %></td>
						<td class="input" width="5%" style="text-align:center">
							<a href="javascript:updateComments('<%= sCmtId %>', '<%= sBatchNo %>', 'true')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Update") %>"></a>
							&nbsp;&nbsp;
							<a href="javascript:closeComments('<%= sCmtId %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Close") %>"></a>
						</td>
					</tr>
<%
				}
			}
			else
			{
%>					
				<tr>
					<td class="input" style="text-align:center" colspan="10"><%= resourceBundle.getProperty("DataManager.DisplayText.No_Alerts") %></td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
