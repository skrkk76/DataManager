<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sErr = "";
	String sAction = request.getParameter("mode");
	String sTaskId = request.getParameter("taskId");
	String sDeliverableId = request.getParameter("deliverableId");
	
	UserTasks userTasks = new UserTasks();
	try
	{
		Map<String, String[]> mTaskDeliverable = new HashMap<String, String[]>();

		String sAttrName = "";
		String sAttrValue = "";
		String sTareWeight = "";
		String sTareWeightClb = "";
		DecimalFormat df2 = new DecimalFormat("#.####");

		Enumeration enum1 = request.getParameterNames();
		while(enum1.hasMoreElements())
		{
			sAttrName = (String)enum1.nextElement();
			sAttrValue = request.getParameter(sAttrName);

			if("taskId".equals(sAttrName) || "selTaskId".equals(sAttrName) || "mode".equals(sAttrName) || 
				"scale".equals(sAttrName) || "deliverableId".equals(sAttrName) || sAttrName.endsWith("_TW") || sAttrName.endsWith("_TW_CLB"))
			{
				if("scale".equals(sAttrName))
				{
					session.setAttribute("SelectedScale", sAttrValue.split("\\|")[2]);
				}
				if(sAttrName.endsWith("_TW"))
				{
					session.setAttribute(sAttrName, sAttrValue);
				}
				continue;
			}
			
			if(sAttrValue != null && !"".equals(sAttrValue.trim()))
			{
				sTareWeight = request.getParameter(sAttrName+"_TW");
				sTareWeightClb = request.getParameter(sAttrName+"_TW_CLB");
				if(sTareWeight != null && !"".equals(sTareWeight.trim()))
				{
					sAttrValue = "" + df2.format((Double.parseDouble(sAttrValue) - Double.parseDouble(sTareWeight)));
				}
				
				if(!sTareWeightClb.equals(sTareWeight))
				{
					mTaskDeliverable.put(sAttrName, new String[] {sAttrValue, sTareWeight});
				}
				else
				{
					mTaskDeliverable.put(sAttrName, new String[] {sAttrValue, ""});
				}
			}
		}
		 

		if("add".equals(sAction) && !mTaskDeliverable.isEmpty())
		{
			userTasks.addDeliverable(sTaskId, mTaskDeliverable);
		}
		else if("edit".equals(sAction) && !mTaskDeliverable.isEmpty())
		{
			userTasks.updateDeliverable(sDeliverableId, mTaskDeliverable);
		}
		else if("delete".equals(sAction))
		{
			userTasks.deleteDeliverable(u.getUser(), sTaskId, sDeliverableId);
		}
	}
	catch(Exception e)
	{
		sErr = e.getMessage();
		sErr = (sErr == null ? "null" : sErr.replace("\"", "'").replace("\r", " ").replace("\n", " "));
	}
%>
<html>
	<script language="javascript">
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
				divMessage = parent.frames['content'].document.getElementById('added');
				divMessage.style.display = "block";
				setTimeout(() => {
					top.opener.parent.frames['content'].document.location.href = 'userTaskDeliverables.jsp?taskId=<%= sTaskId %>';
					parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
				}, 1000);
			}
			else if(mode == "edit")
			{
				top.opener.parent.frames['content'].document.location.href = top.opener.parent.frames['content'].document.location.href;
				top.close();
			}
			else
			{
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
	</script>
</html>