<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.rules.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sAction = request.getParameter("mode");
	String sErr = "";
	
	try
	{
		String sRule = request.getParameter("rule");
		String sDesc = request.getParameter("desc");
		String sTime = request.getParameter("time");
		String oid = request.getParameter("oid");
		String sCntrlType = request.getParameter("cntrlType");
		
		RuleEngine ruleEngine = new RuleEngine();
		if("add".equals(sAction))
		{		
			ruleEngine.addUserRule(sRule, sTime, sDesc, sCntrlType);
		}
		else if("edit".equals(sAction))
		{
			ruleEngine.updateRule(oid, sRule, sTime, sDesc, sCntrlType);
		}
		else if("delete".equals(sAction))
		{
			ruleEngine.deleteRule(oid, sCntrlType);
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
			if(mode == "add" || mode == "edit")
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