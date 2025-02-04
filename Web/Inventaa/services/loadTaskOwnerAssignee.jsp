<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.db.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sTaskId = request.getParameter("taskId");
		
	String sTaskDept = RDMServicesUtils.getAdminTask(sTaskId).get(RDMServicesConstants.DEPARTMENT_NAME);
	StringList slTaskDepts = StringList.split(sTaskDept, "\\|");
%>

<html>
<script language="javascript">
	var owner = parent.frames['content'].document.getElementById('owner');	
	if(owner.options != null)
	{
		while(owner.options.length > 0)
		{
			owner.remove(0);
		}
	}

	var coOwners = parent.frames['content'].document.getElementById('CoOwners');	
	if(coOwners.options != null)
	{
		while(coOwners.options.length > 0)
		{
			coOwners.remove(0);
		}
	}
	
	var assignee = parent.frames['content'].document.getElementById('assignee');	
	if(assignee.options != null)
	{
		while(assignee.options.length > 0)
		{
			assignee.remove(0);
		}
	}
	
	var opt1 = parent.frames['content'].document.createElement('option');
	opt1.value = "";
	opt1.text = "<%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %>";
	owner.options.add(opt1);
<%
	String userId = null;
	String userName = null;
	Map<String, String> mInfo = null;
	Map<String, String> mOwners = new HashMap<String, String>();
	Map<String, String> mAssignees = new HashMap<String, String>();	

	MapList mlOwners = RDMServicesUtils.getTaskOwners(slTaskDepts, false);	
	for(int j=0, iSz=mlOwners.size(); j<iSz; j++)
	{
		mInfo = mlOwners.get(j);
		userId = mInfo.get(RDMServicesConstants.USER_ID);
		userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
		if(!userId.equals(u.getUser()))
		{
			mOwners.put(userId, userName);
		}
	}
		
	MapList mlAssignees = RDMServicesUtils.getAssigneeList(slTaskDepts, false);
	for(int j=0, iSz=mlAssignees.size(); j<iSz; j++)
	{
		mInfo = mlAssignees.get(j);
		userId = mInfo.get(RDMServicesConstants.USER_ID);
		userName = mInfo.get(RDMServicesConstants.DISPLAY_NAME);
		if(!userId.equals(u.getUser()))
		{
			mAssignees.put(userId, userName);
		}			
	}

	List<String> lUsers = new ArrayList<String>(mOwners.keySet());
	Collections.sort(lUsers, String.CASE_INSENSITIVE_ORDER);
	for(int j=0, iSz=lUsers.size(); j<iSz; j++)
	{
		userId = lUsers.get(j);
		userName = mOwners.get(userId);
%>			
		var opt1 = parent.frames['content'].document.createElement('option');
		opt1.value = "<%= userId %>";
		opt1.text = "<%= userName %>(<%= userId %>)";
		owner.options.add(opt1);
		
		var opt2 = parent.frames['content'].document.createElement('option');
		opt2.value = "<%= userId %>";
		opt2.text = "<%= userName %>(<%= userId %>)";
		coOwners.options.add(opt2);
<%
	}
	
	lUsers = new ArrayList<String>(mAssignees.keySet());
	Collections.sort(lUsers, String.CASE_INSENSITIVE_ORDER);
	for(int j=0, iSz=lUsers.size(); j<iSz; j++)
	{
		userId = lUsers.get(j);
		userName = mAssignees.get(userId);
%>			
		var opt = parent.frames['content'].document.createElement('option');
		opt.value = "<%= userId %>";
		opt.text = "<%= userName %>(<%= userId %>)";
		assignee.options.add(opt);
<%
	}
%>
</script>
</html>