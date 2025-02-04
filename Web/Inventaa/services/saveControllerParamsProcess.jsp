<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.db.*" %>

<%@include file="commonUtils.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
</head>

<%
	String sRoom = request.getParameter("lstController");
	String sFromDate = request.getParameter("start_date");
	String sToDate = request.getParameter("end_date");
	String sFromHr = request.getParameter("start_hr");
	String sFromMin = request.getParameter("start_min");
	String sToHr = request.getParameter("end_hr");
	String sToMin = request.getParameter("end_min");

	SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

	sFromDate = output.format(input.parse(sFromDate)) + "T" + (sFromHr+":"+sFromMin+":00");
	sToDate = output.format(input.parse(sToDate)) + "T" + (sToHr+":"+sToMin+":00");

	StringList slControllers = null;
	if("ALL".equals(sRoom))
	{
		slControllers = RDMSession.getControllers();
	}
	else
	{
		slControllers = new StringList();
		slControllers.add(sRoom);
	}
	
	boolean bErr = false;
	StringBuilder sbErr = new StringBuilder();
	for(int i=0; i<slControllers.size(); i++)
	{
		String sController = slControllers.get(i);
		try
		{
			PLCServices client = null;
			String sCntrlVersion = RDMSession.getControllerVersion(sController);
			if(com.client.util.RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion))
			{
				client = new PLCServices_oldHW(RDMSession, sController);
			}
			else if(com.client.util.RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion))
			{
				client = new PLCServices_newHW(RDMSession, sController);
			}

			client.saveLogData(sFromDate, sToDate);
		}
		catch(Exception e)
		{
			bErr = true;
			sbErr.append(sController);
			sbErr.append(" => <br>");
			sbErr.append(e.getLocalizedMessage());
			sbErr.append("<br>");
		}
	}	
%>

<body>
<script language="javascript">
<%
if(bErr)
{
%>
	parent.frames['content'].document.getElementById('msg').innerHTML = "<%= resourceBundle.getProperty("DataManager.DisplayText.Controller_Data_Error") %> <br> <%= sbErr.toString() %>";
<%
}
else
{
%>
	parent.frames['content'].document.getElementById('msg').innerHTML = "<%= resourceBundle.getProperty("DataManager.DisplayText.Controller_data_saved") %>";
<%
}
%>
</script>
</body>
</html>
