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
		String sAttrName = request.getParameter("attrName");
		String sAttrUnit = request.getParameter("attrUnit");
		String sReadWeights = request.getParameter("readWeights");
		String sTareWeight = request.getParameter("tareWeight");
		sTareWeight = (sTareWeight == null ? "0.0" : sTareWeight);
		String sMaxWeight = request.getParameter("maxWeight");
		String sCalculate = request.getParameter("calculate");

		Map<String, String> mAttr = new HashMap<String, String>();
		mAttr.put(RDMServicesConstants.ATTRIBUTE_NAME, sAttrName);
		mAttr.put(RDMServicesConstants.ATTRIBUTE_UNIT, sAttrUnit);
		mAttr.put(RDMServicesConstants.READ_WEIGHTS, sReadWeights);
		mAttr.put(RDMServicesConstants.TARE_WEIGHT, sTareWeight);
		mAttr.put(RDMServicesConstants.MAX_WEIGHT, sMaxWeight);
		mAttr.put(RDMServicesConstants.CALCULATE, sCalculate);

		if("add".equals(sAction))
		{
			RDMServicesUtils.addAdminAttribute(mAttr);
		}
		else if("edit".equals(sAction))
		{
			mAttr.put("OLD_ATTRIBUTE_NAME", request.getParameter("currAttrName"));
			RDMServicesUtils.updateAdminAttribute(mAttr);
		}
		else if("delete".equals(sAction))
		{
			RDMServicesUtils.deleteAdminAttribute(sAttrName);
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
			else
			{				
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
		
	</script>

</html>