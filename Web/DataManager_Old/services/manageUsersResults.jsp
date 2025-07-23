<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sRoleAllFilter = "";
	String sDeptAllFilter = "";
	if(!RDMServicesConstants.ROLE_ADMIN.equals(u.getRole()))
	{
		StringList slDepts = u.getDepartment();
		sDeptAllFilter = slDepts.join('|'); 

		StringList slRoles = u.getAllowedRoles();
		sRoleAllFilter = slRoles.join('|'); 
	}

	String sUsername = request.getParameter("username");
	sUsername = (sUsername == null ? "" : sUsername);
	String sRoleFilter = request.getParameter("role");
	sRoleFilter = (sRoleFilter == null ? sRoleAllFilter : sRoleFilter);
	String sDeptFilter = request.getParameter("dept");
	sDeptFilter = (sDeptFilter == null ? sDeptAllFilter : sDeptFilter);
	String sBlockedUsers = request.getParameter("blockedUsers");

	Map<String, String> mInfo= null;
	String userId = null;
	String role = null;
	String dept = null;
	String blocked = null;
	
	Map <String, String> mDepartments = RDMServicesUtils.getDepartments();
	List<String> lDepartments = new ArrayList<String>(mDepartments.keySet());
	Collections.sort(lDepartments, String.CASE_INSENSITIVE_ORDER);
	String sDeptName = null;
	
	com.client.util.User contextUser = (com.client.util.User)session.getAttribute("contextUser");
	
	MapList mlUsers = RDMServicesUtils.getUsers(sUsername, sRoleFilter, sDeptFilter, "yes".equals(sBlockedUsers));
	int iSz = mlUsers.size();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
	<script language="javascript">
		if (!String.prototype.trim)
		{
			String.prototype.trim = function() {
				return this.replace(/^\s+|\s+$/g,'');
			}
		}

		function editUser(userId)
		{
			var url = "manageUser.jsp?userId="+userId+"&mode=edit";
			var retval = window.open(url, '', 'left=400,top=200,resizable=no,scrollbars=no,status=no,toolbar=no,height=550,width=450');
		}
		
		function addUser()
		{
			var retval = window.open('manageUser.jsp?mode=add', '', 'left=300,top=200,resizable=no,scrollbars=no,status=no,toolbar=no,height=540,width=450');
		}
		
		function resetPwd(userId)
		{
			var email = document.getElementById(userId+'_email');
			email.value = email.value.trim();
			
			if(email.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Email_Addr_Empty") %>");
			}
			else
			{
				var url = "../Password?id="+userId+"&action=reset.password";
				parent.frames['hiddenFrame'].document.location.href = url;
			}
		}

		function blockUser(userId)
		{
			var retVal = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Confirm_Block_User") %> \n\n - "+userId);
			if( retVal == true )
			{
				parent.frames['hiddenFrame'].document.location.href = "manageUserProcess.jsp?userId="+userId+"&mode=block";
			}
		}

		function unblockUser(userId)
		{
			parent.frames['hiddenFrame'].document.location.href = "manageUserProcess.jsp?userId="+userId+"&mode=unblock";
		}
		
		function pushContext(userId)
		{
			top.window.document.location.href = "../LoginServlet?U="+userId+"&pushContext=yes";
		}
	</script>
</head>

<body>
	<form name="frm">
		<table border="0" cellpadding="1" align="center" cellspacing="1" width="<%= winWidth * 0.5 %>">
			<tr>
				<td colspan="5" style="text-align: right;">
					<input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_User") %>" onClick="addUser()">
				</td>
			</tr>
			<tr>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.User_ID") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.User_Name") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Role") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Department") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			for(int i=0; i<iSz; i++)
			{
				mInfo = mlUsers.get(i);
				userId = mInfo.get(RDMServicesConstants.USER_ID);
				role = mInfo.get(RDMServicesConstants.ROLE_NAME);
				dept = mInfo.get(RDMServicesConstants.DEPARTMENT_NAME);
				dept = (dept == null ? "" : dept);
				blocked = mInfo.get(RDMServicesConstants.BLOCKED);
%>
				<tr>
					<td class="input">
<%
					if("Y".equals(blocked))
					{
%>
						<a style="color:red" href="javascript:editUser('<%= userId %>')"><font style="color:red;font-weight:bold"><%= userId %></font></a>
<%
					}
					else
					{
%>
						<a href="javascript:editUser('<%= userId %>')"><%= userId %></a>
<%
					}
%>
					</a></td>
					<td class="input"><%= mInfo.get(RDMServicesConstants.LAST_NAME) %>,&nbsp;<%= mInfo.get(RDMServicesConstants.FIRST_NAME) %></td>
					<td class="input"><%= role %></td>
					<td class="input"><%= dept.replace("|", "<br>") %></td>
					<td class="input" style="text-align:center">
<%
						if("Y".equals(blocked))
						{
%>
							<a href="javascript:unblockUser('<%= userId %>')"><img border="0" height="24" width="24" src="../images/unblocked.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Unblock_User") %>"></a>
<%
						}
						else
						{
							if(contextUser == null)
							{
%>
								<a href="javascript:pushContext('<%= userId %>')"><img border="0" src="../images/SwitchUser.png" height="22"></a>&nbsp;&nbsp;
<%
							}
%>
							<a href="javascript:resetPwd('<%= userId %>')"><img border="0" src="../images/reset.png" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Reset_Password") %>"></a>&nbsp;&nbsp;
							<a href="javascript:blockUser('<%= userId %>')"><img border="0" height="20" width="20" src="../images/blocked.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Block_User") %>"></a>
<%
						}
%>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
