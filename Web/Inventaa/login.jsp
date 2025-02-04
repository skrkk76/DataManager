<%@page import="java.util.*" %>
<%@page import="com.client.util.*" %>

<%
	Locale locale = request.getLocale();
	LabelResourceBundle resourceBundle = new LabelResourceBundle(locale);

	String sLogin = request.getParameter("login");
%>
<!doctype html>
<html>
<head>	
	<style type="text/css">
		a.label
		{
		   font-size:12px;
		   font-family:Arial,sans-serif;
		   font-weight:bold;
		   color:#0000AA;
		   background-color:transparent;
		   border-color:transparent;
		   border-width:0px;
		}
	</style>
</head>
<body bgcolor="#999999" onLoad="javascript:setWinDim(); setLogData()">
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<form name="frm" method="post" action="LoginServlet">
	<table align="center" valign="center">
		<tr>
			<td>
				<font color="#800000" size="3"><b><%= resourceBundle.getProperty("DataManager.DisplayText.User_Name") %></b></font>
			</td>
			<td>
				<input type="text" id="U" name="U" size="16" maxlength="16">
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>
				<font color="#800000" size="3"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Password") %></b></font>
			</td>
			<td>
				<input type="password" id="P" name="P" size="16" maxlength="16">
			</td>
			<td>
				<input type="submit" id="S" name="S" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Login") %>">
			</td>
		</tr>
		<tr>
			<td colspan="3" align="right">
				<a class="label" href="javascript:forgotPwd()"><%= resourceBundle.getProperty("DataManager.DisplayText.Forgot_Password") %></a>
			</td>
		</tr>		
	</table>
	<input type="hidden" id="winW" name="winW" value="">
	<input type="hidden" id="winH" name="winH" value="">
	<input type="hidden" id="ip" name="ip" value="">
	<input type="hidden" id="hostname" name="hostname" value="">	
	<input type="hidden" id="city" name="city" value="">
	<input type="hidden" id="region" name="region" value="">
	<input type="hidden" id="country" name="country" value="">
</form>

<script language="javascript">
<%
	if("fail".equals(sLogin))
	{
%>
		alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Login_Failed") %>");
<%
	}
	else if("blocked".equals(sLogin))
	{
%>
		alert("<%= resourceBundle.getProperty("DataManager.DisplayText.User_Blocked") %>");
<%
	}
%>
	function forgotPwd()
	{
		var user = document.getElementById("U").value;
		if(user == "")
		{
			alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Retrive_Password") %>");
		}
		else
		{
			var url = "Password?id="+user+"&action=forgot.password";
			document.location.href = url;
		}
	}
	
	function setWinDim()
	{
		var winW = 630, winH = 460;
		if (document.body && document.body.offsetWidth) 
		{
			winW = document.body.offsetWidth;
			winH = document.body.offsetHeight;
		}
		if (document.compatMode == "CSS1Compat" && document.documentElement && document.documentElement.offsetWidth ) 
		{
			winW = document.documentElement.offsetWidth;
			winH = document.documentElement.offsetHeight;
		}
		if (window.innerWidth && window.innerHeight) 
		{
			winW = window.innerWidth;
			winH = window.innerHeight;
		}
		
		document.frm.winW.value = winW;
		document.frm.winH.value = winH;
	}
	
	function setLogData()
	{
		var script = document.createElement("script");
		script.type = "text/javascript";
		script.src = "http://ipinfo.io/?callback=apiResponse";
		document.getElementsByTagName("head")[0].appendChild(script);
	}

	function apiResponse(response) 
	{
		document.getElementById("ip").value = response.ip;
		document.getElementById("hostname").value = response.hostname;
		document.getElementById("city").value = response.city;
		document.getElementById("region").value = response.region;
		document.getElementById("country").value = response.country;
	}
</script>

</body>
</html>
