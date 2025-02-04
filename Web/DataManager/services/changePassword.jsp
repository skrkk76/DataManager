<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

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
	
		function chngPwd()
		{
			if(!checkPassword())
			{
				return false;
			}
			
			document.frm.submit();
		}
		
		function checkPassword()
		{
			var password = document.getElementById("password");
			password.value = password.value.trim();

			if(password.value.length < 6)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Password_length_Mismatch") %>");
				password.focus();
				return false;
			}
			
			var CPassword = document.getElementById("CPassword");
			CPassword.value = CPassword.value.trim();
			
			if(password.value != CPassword.value)
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Password_Mismatch") %>");
				password.focus();
				return false;
			}
			
			return true;
		}

		function passwordChanged()
		{
			var strongRegex = new RegExp("^(?=.{10,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
			var mediumRegex = new RegExp("^(?=.{8,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
			var weakRegex = new RegExp("(?=.{6,}).*", "g");
			
			var strength = document.getElementById("strength");
			var pwd = document.getElementById("password");
			pwd.value = pwd.value.trim();
			if (pwd.value.length == 0) 
			{
				strength.innerHTML = "";
			} 
			else if (strongRegex.test(pwd.value)) 
			{
				strength.innerHTML = '<span style="color:green"><b>Strong</b></span>';
			} 
			else if (mediumRegex.test(pwd.value))
			{
				strength.innerHTML = '<span style="color:blue"><b>Medium</b></span>';
			} 
			else if (weakRegex.test(pwd.value))
			{
				strength.innerHTML = '<span style="color:red"><b>Weak</b></span>';
			}
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageUserProcess.jsp">
		<table border="0" cellpadding="1" cellspacing="1" width="100%">
			<tr>
				<td class="label" width="40%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.New_Password") %></b></td>
				<td class="input" width="60%">
					<input type="password" id="password" name="password" maxlength="15" size="15" onkeyup="return passwordChanged();" value="">
					<span id="strength"></span>
				</td>
			</tr>
			<tr>
				<td class="label" width="40%"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Confirm_Password") %></b></td>
				<td class="input" width="60%">
					<input type="password" id="CPassword" name="CPassword"  maxlength="15" size="15" value="">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<input type="button" name="changePassword" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Change_Password") %>" onClick="chngPwd()">
				</td>
			</tr>
		</table>
		<input type="hidden" id="mode" name="mode" value="chgPwd">
	</form>
</body>
</html>
