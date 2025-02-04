<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<html>
<script language="javascript">
<%
Locale locale = request.getLocale();
LabelResourceBundle resourceBundle = new LabelResourceBundle(locale);

String flag = request.getParameter("flag");
if("success".equals(flag))
{
%>
	alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Password_Reset_success") %>");
<%
}
else if("nomail".equals(flag))
{
%>
	alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Email_Id_Empty") %>");
<%
}
%>
</script>
</html>
