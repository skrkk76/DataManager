<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sAction = request.getParameter("mode");
	String sErr = "";
	
	try
	{
		String sName = request.getParameter("name");
		String sDesc = request.getParameter("desc");

		if("add".equals(sAction))
		{
			RDMServicesUtils.addCntrlGroup(sName, sDesc);
		}
		else if("edit".equals(sAction))
		{
			String newName = request.getParameter("newname");
			RDMServicesUtils.updateCntrlGroup(sName, newName, sDesc);
		}
		else if("delete".equals(sAction))
		{
			RDMServicesUtils.deleteCntrlGroup(sName);
		}
	}
	catch(Exception e)
	{
		sErr = e.getMessage();
		sErr = (sErr == null ? "null" : sErr.replaceAll("\"", "'").replaceAll("\r", " ").replaceAll("\n", " "));
	}
%>

	<script>
		var sErr = "<%= sErr %>";
		var mode = "<%= sAction %>";
		if(sErr != "")
		{
			alert("Error: "+sErr);
			history.back(-1);
		}
		else
		{
			if(mode == "add")
			{
				top.opener.document.location.href = top.opener.document.location.href;
				window.close();
			}
			else if(mode == "edit")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Group_Modified") %>");
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
			else if(mode == "delete")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Group_Deleted") %>");
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
		
	</script>

</html>