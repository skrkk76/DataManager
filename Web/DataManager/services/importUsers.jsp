<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@page language="java" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.views.*" %>
<%@include file="commonUtils.jsp" %>
<HTML>
<HEAD>
	<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
</HEAD>  
<BODY>
	<table border="0" width="80%">
		<FORM id="frm" name="frm" ENCTYPE="multipart/form-data" ACTION="importUsersProcess.jsp" METHOD="POST">
            <tr>
				<th class="label" style="text-align: center; height:25px">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Import_Users") %>
				</th>
			</tr>
			<tr>
				<td><INPUT TYPE="file" id="F1"  NAME="F1" value=""></td>
			</tr>
			<tr>
				<td align="right">
					<INPUT TYPE="submit" name="submit" VALUE="<%= resourceBundle.getProperty("DataManager.DisplayText.Load_Users") %>">
				</td>
			</tr>
		</FORM>
	<table>
</BODY>
</HTML>