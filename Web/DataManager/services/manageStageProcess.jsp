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
		String sSeq = request.getParameter("seqNum");
		String sName = request.getParameter("name");
		sName = ((sName == null || "null".equals(sName)) ? "" : sName.trim());
		String sType = request.getParameter("type");
		String sDesc = request.getParameter("desc");
		sDesc = ((sDesc == null || "null".equals(sDesc)) ? "" : sDesc.trim());
		
		Map<String, String> mStageInfo = new HashMap<String, String>();
		mStageInfo.put(RDMServicesConstants.STAGE_NUMBER, sSeq);
		mStageInfo.put(RDMServicesConstants.STAGE_NAME, sName);
		mStageInfo.put(RDMServicesConstants.CNTRL_TYPE, sType);
		mStageInfo.put(RDMServicesConstants.STAGE_DESC, sDesc);

		if("add".equals(sAction))
		{		
			RDMServicesUtils.addStage(mStageInfo);
		}
		else if("edit".equals(sAction))
		{
			RDMServicesUtils.updateStage(mStageInfo);
		}
		else if("delete".equals(sAction))
		{
			RDMServicesUtils.deleteStage(sSeq, sType);
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
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Stage_Modified") %>");
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
			else if(mode == "delete")
			{				
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Stage_Deleted") %>");
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
		
	</script>

</html>