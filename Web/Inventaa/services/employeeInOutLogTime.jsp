<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="org.apache.commons.fileupload.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sErr = "";
	try
	{
		String sAction = request.getParameter("type");
		String sUserId = request.getParameter("userId");
		String sOID = request.getParameter("OID");
		String shift = request.getParameter("shift");
		shift = (shift == null ? "" : shift);

		if("in".equals(sAction))
		{	
			User.logInTime(sUserId, sOID, shift);
		}
		else if("out".equals(sAction))
		{		
			User.logOutTime(sUserId, sOID, shift);
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
		if(sErr != "")
		{
			alert("Error: "+sErr);
			history.back(-1);
		}
		else
		{	
			top.opener.parent.frames['filter'].searchUsers();
			top.window.close();
		}
		
	</script>
</html>
