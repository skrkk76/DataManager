<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sCommentId = request.getParameter("cmtId");
	String sFrom = request.getParameter("from");
	String sBatchNo = request.getParameter("bNo");
	String bGlobal = request.getParameter("global");
%>

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
		
		function submitForm()
		{			
			var comments = document.getElementById("comments");
			if(comments != undefined && comments != null)
			{
				comments.value = comments.value.trim();
				if(comments.value == "")
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Comments") %>");
					comments.focus();
					return false;
				}
			}
			
			var fileaction = document.getElementsByName("fileaction");
			for(var i=0; i<fileaction.length; i++)
			{
				if(fileaction[i].checked)
				{
					document.getElementById("replace").value = fileaction[i].value;
				}
			}
			document.frm.submit();
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="processAttachments.jsp" enctype="multipart/form-data">
		<input type="hidden" id="cmtId" name="cmtId" value="<%= sCommentId %>">
		<input type="hidden" id="mode" name="mode" value="update">
		<input type="hidden" id="from" name="from" value="<%= sFrom %>">		
		<input type="hidden" id="folder" name="folder" value="<%= sCommentId %>">
		<input type="hidden" id="replace" name="replace" value="">
		<input type="hidden" id="processPage" name="processPage" value="manageCommentsProcess.jsp">
		
		<table border="0" cellpadding="1" cellspacing="1" width="100%">
			<tr>
				<td colspan="2" align="center"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Update_Comments") %></b></td>
			</tr>
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Review_Comments") %></b></td>
				<td class="input" width="70%">
					<textarea id="comments" name="comments" rows="5" cols="35"></textarea>
				</td>
			</tr>
			
			<tr>
				<td class="label" width="30%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Attachments") %></b></td>
				<td class="input" width="70%">
					<input type="file" id="attachment" name="attachment"><br>
					<input type="radio" id="fileaction" name="fileaction" value="yes" checked><%= resourceBundle.getProperty("DataManager.DisplayText.Replace") %>
					<input type="radio" id="fileaction" name="fileaction" value="no"><%= resourceBundle.getProperty("DataManager.DisplayText.Append") %>
				</td>
			</tr>
			
			<tr>
				<td colspan="2">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" onClick="submitForm()">&nbsp;&nbsp;&nbsp;
					<input type="button" name="Cancel" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Cancel") %>" onClick="javascript:top.window.close()">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
