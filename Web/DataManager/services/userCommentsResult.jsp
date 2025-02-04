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
String sRoom = request.getParameter("lstController");
String sStage = request.getParameter("lstStage");
String BNo = request.getParameter("BatchNo");
String text = request.getParameter("abbr");
String dept = request.getParameter("dept");
String sFromDate = request.getParameter("start_date");
String sToDate = request.getParameter("end_date");
String sGlobal = request.getParameter("global");
boolean bGlobal = "Y".equals(sGlobal);
String sClosed = request.getParameter("closed");
boolean bClosed = "Y".equals(sClosed);
String sLogByMe = request.getParameter("logByMe");
String sLoggedBy = ("Y".equals(sLogByMe) ? u.getUser() : "");
String mode = request.getParameter("mode");

String limit = request.getParameter("limit");
int iLimit = 0;
if(limit != null && !"".equals(limit))
{
	iLimit = Integer.parseInt(limit.trim());
}

MapList mlComments = null;
int iSz = 0;
if(mode != null)
{
	BNo = ((BNo == null) ? "" : BNo.trim());
	BNo = BNo.replaceAll("\\s", ",").replaceAll(",,", ",");
	
	Comments comments = new Comments();
	mlComments = comments.getUserComments(sRoom, sStage, BNo, sFromDate, sToDate, sLoggedBy, text, dept, bGlobal, bClosed, iLimit);
	iSz = mlComments.size();
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>

	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
	function updateComments(id, bNo, bGlobal)
	{
		var retval = window.open('updateUserComments.jsp?cmtId='+id+'&bNo='+bNo+'&global='+bGlobal+'&from=commentsView', 'Comments', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=300,width=500');
	}
	
	function closeComments(id)
	{
		parent.frames['hiddenFrame'].document.location.href = "manageCommentsProcess.jsp?cmtId="+id+"&mode=close&from=commentsView";
	}
		
	function addComments()
	{
		var retval = window.open('addUserComments.jsp?from=commentsView', 'Comments', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=375,width=525');
	}
	
	function exportComments()
	{
		var url = "../ExportComments";
		url += "?lstController=<%= sRoom %>";
		url += "&lstStage=<%= sStage %>";
		url += "&BatchNo=<%=  BNo %>";
		url += "&abbr=<%= text %>"; 
		url += "&dept=<%= dept %>"; 
		url += "&start_date=<%= sFromDate %>";
		url += "&end_date=<%= sToDate %>";
		url += "&global=<%= sGlobal %>";
		url += "&closed=<%= sClosed %>";
		url += "&logByMe=<%= sLoggedBy %>";
		url += "&limit=<%= iLimit %>";

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
	
	function viewAttachments(taskname)
	{
		var url = "../ViewAttachments?folder="+taskname;
		document.location.href =  url;
	}
	</script>
</head>

<body>
	<form name="frm">
		<table border="0" cellpadding="0" cellspacing="0" width="<%= winWidth * 0.76 %>">
			<tr>
				<td colspan="5" align="left">
					<input type="button" id="Comments" name="Comments" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Comments") %>" onClick="javascript:addComments()">
				</td>
<%
				if(iSz > 0)
				{
%>
					<td colspan="6" align="right">
						<input type="button" id="expComments" name="expComments" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Export_to_File") %>" onClick="exportComments()">
					</td>
<%
				}
				else
				{
%>
					<td colspan="6">&nbsp;</td>
<%
				}
%>
			</tr>

			<tr>
				<th class="label" width="3%">ATT</th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Room") %></th>
				<th class="label" width="5%"><%= resourceBundle.getProperty("DataManager.DisplayText.Stage") %></th>
				<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_By") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_On") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Text") %></th>
				<th class="label" width="35%"><%= resourceBundle.getProperty("DataManager.DisplayText.Comments") %></th>
				<th class="label" width="8%"><%= resourceBundle.getProperty("DataManager.DisplayText.Department") %></th>
				<th class="label" width="6%">&nbsp;</th>
			</tr>
<%
			
			if(mode != null)
			{
				if(iSz > 0)
				{
					Map<String, String> mUsers = RDMServicesUtils.getUserNames();
					Map<String, String> mComment = null;
					String sCmtId = null;
					String sRoomId = null;
					String sBatchNo = null;
					String sNoDays = null;
					String sAttachments = null;
					StringList slInactiveCntrl = RDMSession.getInactiveControllers();
			
					for(int i=0; i<iSz; i++)
					{
						mComment = mlComments.get(i);
						bClosed = ("Y".equals(mComment.get(RDMServicesConstants.CLOSED_COMMENT)));
						bGlobal = ("Y".equals(mComment.get(RDMServicesConstants.GLOBAL_ALERT)));
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
							<td class="input">
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
							<td class="input" style="text-align:center"><%= mComment.get(RDMServicesConstants.STAGE_NUMBER) %><%= sNoDays %></td>
							<td class="input"><%= sBatchNo %></td>
							<td class="input"><%= sLoggedBy %></td>
							<td class="input" style="text-align:center"><%= mComment.get(RDMServicesConstants.LOGGED_ON) %></td>
							<td class="input"><%= mComment.get(RDMServicesConstants.CATEGORY) %>&nbsp;(<%= mComment.get(RDMServicesConstants.LOG_TEXT) %>)</td>	
							<td class="input"><%= mComment.get(RDMServicesConstants.REVIEW_COMMENTS) %></td>
							<td class="input"><%= (mComment.get(RDMServicesConstants.DEPARTMENT_NAME)).replaceAll("\\|", "<br>") %></td>
							<td class="input" style="text-align:center">
<%
							if((bGlobal && !bClosed))
							{
%>
								<a href="javascript:updateComments('<%= sCmtId %>', '<%= sBatchNo %>', '<%= bGlobal %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Update") %>"></a>
								<a href="javascript:closeComments('<%= sCmtId %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Close") %>"></a>
<%
							}
%>
							</td>
						</tr>
<%
					}
				}
				else
				{
%>					
					<tr>
						<td class="input" style="text-align:center" colspan="11"><%= resourceBundle.getProperty("DataManager.DisplayText.No_Comments") %></td>
					</tr>
<%
				}
			}
			else
			{
%>
				<tr>
						<td class="input" style="text-align:center" colspan="11"><%= resourceBundle.getProperty("DataManager.DisplayText.Comments_Search_Msg") %></td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
