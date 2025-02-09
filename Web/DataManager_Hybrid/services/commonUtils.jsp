<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.license.*" %>

<jsp:useBean id="RDMSession" scope="session" class="com.client.ServicesSession" />

<%
	com.client.util.User u = (com.client.util.User)session.getAttribute("currentSessionUser");
	if(u == null || !u.isLoggedIn())
	{
%>	
		<script>
			top.window.document.location.href = "../login.jsp";
		</script>
<%
		return;
	}

	Locale locale = u.getLocale();
	LabelResourceBundle resourceBundle = new LabelResourceBundle(locale);
	
	String sVerifyLicenseExpiry = (String)session.getAttribute("VerifyLicenseExpiry");
	if(sVerifyLicenseExpiry == null || "".equals(sVerifyLicenseExpiry))
	{
		String sExpiryDate = VerifyLicense.verifyLicenseExpiry();
		if(!"".equals(sExpiryDate))
		{
			String sWarning = resourceBundle.getProperty("DataManager.DisplayText.LicenseExpiryAlert");
			sWarning = String.format(sWarning, sExpiryDate);
%>	
			<script>
				alert("<%= sWarning %>");
			</script>
<%
		}
		session.setAttribute("VerifyLicenseExpiry", "TRUE");
	}

	String winW = request.getParameter("winW");
	String winH = request.getParameter("winH");
	if(winW != null && winH != null && !"".equals(winW) && !"".equals(winH))
	{	
		session.setAttribute("windowWidth", winW);
		session.setAttribute("windowHeight", winH);
	}
	
	int winWidth = Integer.parseInt((String)session.getAttribute("windowWidth"));
	int winHeight = Integer.parseInt((String)session.getAttribute("windowHeight"));
	
	NumberFormat numberFormat = NumberFormat.getInstance(Locale.getDefault());
	
	DecimalFormatSymbols dfSymbol = new DecimalFormatSymbols(Locale.getDefault());
	char cDecimal = dfSymbol.getDecimalSeparator();
	
	RDMSession.setContextUser(u);
%>

<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />