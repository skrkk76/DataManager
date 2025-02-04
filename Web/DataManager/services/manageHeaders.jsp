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
		
		function editHeader(loc, type)
		{	
			var name = document.getElementById(loc+'_'+type+'_Name');
			name.value = name.value.trim();
			if(name.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Header_Name") %>");
				name.focus();
				return false;
			}			
			
			var newLoc = document.getElementById(loc+'_'+type+'_Loc');
			newLoc.value = newLoc.value.trim();
			if(newLoc.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Header_Position") %>");
				newLoc.focus();
				return false;
			}
			
			if(isNaN(newLoc.value))
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Header_Number") %>");
				newLoc.focus();
				return false;
			}

			parent.frames['hiddenFrame'].document.location.href = "manageHeaderProcess.jsp?name="+name.value+"&loc="+newLoc.value+"&oldLoc="+loc+"&cntrlType="+type+"&mode=edit";
		}
		
		function addHeader()
		{
			var retval = window.open('addHeader.jsp', '', 'left=350,top=300,resizable=no,scrollbars=no,status=no,toolbar=no,height=200,width=400');
		}
		
		function deleteHeader(loc, type)
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Header") %>");
			if(conf == true)
			{
				parent.frames['hiddenFrame'].document.location.href = "manageHeaderProcess.jsp?loc="+loc+"&cntrlType="+type+"&mode=delete";
			}
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="50%">
			<tr>
				<td colspan="4" style="text-align: right;">
					<input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Header") %>" onClick="addHeader()">
				</td>
			</tr>
			<tr>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Display_Position") %></th>
				<th class="label" width="40%"><%= resourceBundle.getProperty("DataManager.DisplayText.Name") %></th>
				<th class="label" width="20%"><%= resourceBundle.getProperty("DataManager.DisplayText.Type") %></th>
				<th class="label" width="40%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			String sName = null;
			String sLoc = null;
			String sCntrlType = null;
			String sHeader = null;
			StringList slHeaders = new StringList();
			Map<String, String> mHeader = null;
			
			MapList mlHeaders = RDMServicesUtils.getHeaders();	
			for(int i=0; i<mlHeaders.size(); i++)
			{
				mHeader = (Map<String, String>)mlHeaders.get(i);

				sName = mHeader.get(RDMServicesUtils.HEADER_NAME);
				sLoc = mHeader.get(RDMServicesUtils.HEADER_LOC);
				sCntrlType = mHeader.get(RDMServicesUtils.CNTRL_TYPE);

				sHeader = (sCntrlType.startsWith("General") ? "General" : sCntrlType);
				if(!slHeaders.contains(sHeader))
				{
					slHeaders.add(sHeader);
%>					
					<tr>
						<td colspan="4" align="center"><b><%= resourceBundle.getProperty("DataManager.DisplayText."+sHeader) %></b></td>
					</tr>
<%					
				}
%>
				<tr>
					<td class="input">
						<input type="text" id="<%= sLoc %>_<%= sCntrlType %>_Loc" name="<%= sLoc %>_Loc" value="<%= sLoc %>" size="3">
					</td>
					<td class="input">
						<input type="text" id="<%= sLoc %>_<%= sCntrlType %>_Name" name="<%= sLoc %>_Name" value="<%= sName %>" size="30">
					</td>
					<td class="input">
						<%= resourceBundle.getProperty("DataManager.DisplayText."+sCntrlType) %>
					</td>
					<td class="input" style="text-align:center">
						<a href="javascript:editHeader('<%= sLoc %>', '<%= sCntrlType %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteHeader('<%= sLoc %>', '<%= sCntrlType %>')">
							<img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>">
						</a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
