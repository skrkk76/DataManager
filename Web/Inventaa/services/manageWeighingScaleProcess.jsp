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
		String sScaleId = request.getParameter("scaleId");
		String sScaleIP = request.getParameter("scaleIP");
		String sScalePort = request.getParameter("scalePort");
		String sStatus = request.getParameter("scaleStatus");
		
		Map<String, String> mScaleInfo = new HashMap<String, String>();
		mScaleInfo.put(RDMServicesConstants.SCALE_ID, sScaleId);
		mScaleInfo.put(RDMServicesConstants.SCALE_IP, sScaleIP);
		mScaleInfo.put(RDMServicesConstants.SCALE_PORT, sScalePort);
		mScaleInfo.put(RDMServicesConstants.SCALE_STATUS, sStatus);

		if("add".equals(sAction))
		{
			RDMServicesUtils.addScale(mScaleInfo);
		}
		else if("edit".equals(sAction))
		{
			String sCurrScaleId = request.getParameter("scaleIdCurr");
			RDMServicesUtils.updateScale(sCurrScaleId, mScaleInfo);
		}
		else if("delete".equals(sAction))
		{
			RDMServicesUtils.deleteScale(sScaleId);
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
			if(mode == "add" || mode == "auth")
			{
				top.opener.document.location.href = top.opener.document.location.href;
				window.close();
			}
			else
			{				
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Scale_Updated") %>");
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
		
	</script>

</html>