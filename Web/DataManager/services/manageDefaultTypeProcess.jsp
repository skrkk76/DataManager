<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sAction = request.getParameter("mode");
	String sErr = "";
	
	try
	{
		String sDefType = request.getParameter("defType");
		String sDesc = request.getParameter("desc");
		String sCntrl = request.getParameter("cntrl");	
		String sOldDefType = request.getParameter("oldDefType");

		DefParamValues defParamVals = new DefParamValues();
		if("add".equals(sAction))
		{		
			defParamVals.addDefaultType(sCntrl, sDefType, sDesc);
		}
		else if("edit".equals(sAction))
		{
			defParamVals.updateDefaultType(sCntrl, sDefType, sOldDefType, sDesc);
		}
		else if("delete".equals(sAction))
		{
			defParamVals.deleteDefaultType(sCntrl, sOldDefType);
		}
	}
	catch(Exception e)
	{
		e.printStackTrace(System.out);
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
			else
			{				
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
		
	</script>

</html>