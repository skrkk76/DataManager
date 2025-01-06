<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.license.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sErr = "";	
	try
	{
		Map<String, String> mInfo = new HashMap<String, String>();
		
		String cntrlId = request.getParameter("cntrlId").trim();
		String cntrlPwd = request.getParameter("cntrlPwd").trim();
		String accountSID = request.getParameter("accountSID").trim();
		String authCode = request.getParameter("authCode").trim();
		String regNumber = request.getParameter("regNumber").trim();
		String mailHost = request.getParameter("mailHost").trim();
		String mailPort = request.getParameter("mailPort").trim();
		String mailFrom = request.getParameter("mailFrom").trim();
		String gmailId = request.getParameter("gmailId").trim();
		String gmailPwd = request.getParameter("gmailPwd").trim();

		Map<String, String> mAcctCredentials = new HashMap<String, String>();
		mAcctCredentials.put(RDMServicesConstants.CNTRL_UID, cntrlId);
		mAcctCredentials.put(RDMServicesConstants.CNTRL_PWD, cntrlPwd);
		mAcctCredentials.put(RDMServicesConstants.ACCT_SID, accountSID);
		mAcctCredentials.put(RDMServicesConstants.AUTH_CODE, authCode);
		mAcctCredentials.put(RDMServicesConstants.REG_NUMBER, regNumber);
		mAcctCredentials.put(RDMServicesConstants.MAIL_HOST, mailHost);
		mAcctCredentials.put(RDMServicesConstants.MAIL_PORT, mailPort);
		mAcctCredentials.put(RDMServicesConstants.FROM_ADDRESS, (!"".equals(mailFrom) ? mailFrom : gmailId));
		mAcctCredentials.put(RDMServicesConstants.MAILID_PWD, gmailPwd);
		
		RDMServicesUtils.setAccountCredentials(mAcctCredentials);
	}
	catch(Exception e)
	{
		sErr = e.getMessage();
		e.printStackTrace(System.out);
	}
%>

	<script>
		var sErr = "<%= sErr %>";
		if(sErr != "")
		{
			alert("Error: "+sErr);
		}
		document.location.href = "accountSettings.jsp";
	</script>

</html>