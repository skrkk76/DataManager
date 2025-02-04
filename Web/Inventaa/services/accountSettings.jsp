<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%
	Map<String, String> mAcctCredentials = RDMServicesUtils.getAccountCredentials();
	String sHost = mAcctCredentials.get(RDMServicesConstants.MAIL_HOST);
	String sPort = mAcctCredentials.get(RDMServicesConstants.MAIL_PORT);
	String sFromAddr = mAcctCredentials.get(RDMServicesConstants.FROM_ADDRESS);
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
		
		function submitForm()
		{
			var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
			if(document.getElementById('mailType').checked)
			{
				var mailHost = document.getElementById('mailHost').value;
				var mailPort = document.getElementById('mailPort').value;
				var mailFrom = document.getElementById('mailFrom').value;
				
				if(mailHost == "" || mailPort == "" || mailFrom == "")
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_SMTP_Details") %>");
					return false;
				}
				else
				{
					if (!filter.test(mailFrom)) 
					{
						alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Email_Addr_Invalid") %>");
						return false;
					}
				}
			}
			else
			{
				var gmailId = document.getElementById('gmailId').value;
				var gmailPwd = document.getElementById('gmailPwd').value;
				
				if(gmailId == "" || gmailPwd == "")
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_GMAIL_Details") %>");
					return false;
				}
				else
				{
					if (!filter.test(gmailId)) 
					{
						alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Email_Addr_Invalid") %>");
						return false;
					}
				}
			}
			
			document.frm.submit();
		}
		
		function toggle(mailType)
		{
			if(mailType == "SMTP")
			{
				document.getElementById('gmailId').value = "";
				document.getElementById('gmailPwd').value = "";
			}
			else if(mailType == "GMAIL")
			{
				document.getElementById('mailHost').value = "";
				document.getElementById('mailPort').value = "";
				document.getElementById('mailFrom').value = "";
			}
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="accountSettingsProcess.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="40%">
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="label" colspan="2" style="font-size:16px;text-align:center">
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.Controller_Credentials") %></b>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Controller_UserUID") %></b></td>
				<td class="input">
					<input type="text" id="cntrlId" name="cntrlId" value="<%= mAcctCredentials.get(RDMServicesConstants.CNTRL_UID) %>" size="50">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Controller_Password") %></b></td>
				<td class="input">
					<input type="password" id="cntrlPwd" name="cntrlPwd" value="<%= mAcctCredentials.get(RDMServicesConstants.CNTRL_PWD) %>" size="50">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="label" colspan="2" style="font-size:16px;text-align:center">
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.TwilioSetup") %></b>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.AccountSID") %></b></td>
				<td class="input">
					<input type="text" id="accountSID" name="accountSID" value="<%= mAcctCredentials.get(RDMServicesConstants.ACCT_SID) %>" size="50">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.AuthCode") %></b></td>
				<td class="input">
					<input type="text" id="authCode" name="authCode" value="<%= mAcctCredentials.get(RDMServicesConstants.AUTH_CODE) %>" size="50">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.RegNumber") %></b></td>
				<td class="input">
					<input type="text" id="regNumber" name="regNumber" value="<%= mAcctCredentials.get(RDMServicesConstants.REG_NUMBER) %>" size="50">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="label" colspan="2" style="font-size:16px;text-align:center">
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.MailSetup") %></b>
				</td>
			</tr>
			<tr>
				<td class="label" colspan="2" style="font-size:16px;text-align:center">
					<input type="radio" id="mailType" name="mailType" value="SMTP" onClick="toggle('SMTP')" <%= (!"".equals(sHost) && !"".equals(sPort)) ? "checked" : "" %>>
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.SMTP_Mail_Server") %></b>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.MailHost") %></b></td>
				<td class="input">
					<input type="text" id="mailHost" name="mailHost" value="<%= sHost %>" size="50">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.MailPort") %></b></td>
				<td class="input">
					<input type="text" id="mailPort" name="mailPort" value="<%= sPort %>" size="50">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.MailFrom") %></b></td>
				<td class="input">
					<input type="text" id="mailFrom" name="mailFrom" value="<%= (!"".equals(sHost) && !"".equals(sPort)) ? sFromAddr : "" %>" size="50">
				</td>
			</tr>
			<tr>
				<td class="label" colspan="2" style="font-size:16px;text-align:center">
					<input type="radio" id="mailType" name="mailType" value="GMAIL" onClick="toggle('GMAIL')" <%= ("".equals(sHost) || "".equals(sPort)) ? "checked" : "" %>>
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.GMAIL") %></b>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.GMAIL_ID") %></b></td>
				<td class="input">
					<input type="text" id="gmailId" name="gmailId" value="<%= ("".equals(sHost) || "".equals(sPort)) ? sFromAddr : "" %>" size="50">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.GMAIL_Password") %></b></td>
				<td class="input">
					<input type="password" id="gmailPwd" name="gmailPwd" value="<%= mAcctCredentials.get(RDMServicesConstants.MAILID_PWD) %>" size="50">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" onClick="submitForm()">&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
