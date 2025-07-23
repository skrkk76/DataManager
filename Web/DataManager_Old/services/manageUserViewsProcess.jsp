<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sErr = "";
	
	try
	{
		String sView = request.getParameter("view");
		String sHide = request.getParameter("hide");
		sHide = ("true".equals(sHide) ? sHide : "false");
		String[] saRole = request.getParameterValues("role");
		String[] saDept = request.getParameterValues("dept");
		
		String sRoles = "";		
		if(saRole != null)
		{
			for(int i=0; i<saRole.length; i++)
			{
				if(i > 0)
				{
					sRoles += ",";
				}
				sRoles += saRole[i];
			}
		}
		
		String sDepts = "";		
		if(saDept != null)
		{
			for(int i=0; i<saDept.length; i++)
			{
				if(i > 0)
				{
					sDepts += ",";
				}
				sDepts += saDept[i];
			}
		}
		
		Map<String, String> mInfo = new HashMap<String, String>();
		mInfo.put(RDMServicesConstants.VIEW_NAME, sView);
		mInfo.put(RDMServicesConstants.ROLE_NAME, sRoles);
		mInfo.put(RDMServicesConstants.DEPT_NAME, sDepts);
		mInfo.put(RDMServicesConstants.HIDE_VIEW, sHide);

		RDMServicesUtils.updateUserView(mInfo);
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
		if(sErr != "")
		{
			alert("Error: "+sErr);
			history.back(-1);
		}
		else
		{	
			top.opener.document.location.href = top.opener.document.location.href;
			top.close();
		}
	</script>

</html>