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
		String sLoc = request.getParameter("loc");
		int iLoc = Integer.parseInt(sLoc);
		String sName = request.getParameter("name");
		String sCntrlType = request.getParameter("cntrlType");		
		
		Map<String, String> mHeaderInfo = new HashMap<String, String>();
		mHeaderInfo.put(RDMServicesConstants.HEADER_LOC, sLoc);
		mHeaderInfo.put(RDMServicesConstants.HEADER_NAME, sName);
		mHeaderInfo.put(RDMServicesConstants.CNTRL_TYPE, sCntrlType);		

		if("add".equals(sAction))
		{		
			RDMServicesUtils.addHeader(sCntrlType, mHeaderInfo);
		}
		else if("edit".equals(sAction))
		{
			String sOldLoc = request.getParameter("oldLoc");
			mHeaderInfo.put("OLD_HEADER_LOC", sOldLoc);
			RDMServicesUtils.updateHeader(sCntrlType, mHeaderInfo);
		}
		else if("delete".equals(sAction))
		{
			RDMServicesUtils.deleteHeader(sCntrlType, iLoc);
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
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Header_Modified") %>");
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
			else if(mode == "delete")
			{				
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Header_Deleted") %>");
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
		
	</script>

</html>