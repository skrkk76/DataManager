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
		String sStatus = request.getParameter("status");
		String sEditParams = request.getParameter("editParams");

		Map<String, String> mDepartment = new HashMap<String, String>();
		mDepartment.put(RDMServicesConstants.DEPARTMENT_NAME, sName);
		mDepartment.put(RDMServicesConstants.DESCRIPTION, sDesc);
		mDepartment.put(RDMServicesConstants.EDIT_PARAMS, sEditParams);

		if("add".equals(sAction))
		{
			RDMServicesUtils.addDepartment(mDepartment);
		}
		else if("edit".equals(sAction))
		{
			mDepartment.put(RDMServicesConstants.DEPT_ISACTIVE, sStatus);
			mDepartment.put("OLD_DEPT_NAME", request.getParameter("oldName"));
			RDMServicesUtils.updateDepartment(mDepartment);
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