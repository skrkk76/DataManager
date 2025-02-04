<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.views.*" %>

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
		
		function editDefType(i)
		{	
			var defType = document.getElementById(i+'_DefType');
			defType.value = defType.value.trim();
			if(defType.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Product") %>");
				defType.focus();
				return false;
			}

			var oldDefType = document.getElementById(i+'_Old_DefType').value;
			var cntrl = document.getElementById(i+'_Cntrl').value;
			var desc = document.getElementById(i+'_Desc').value;

			parent.frames['hiddenFrame'].document.location.href = "manageDefaultTypeProcess.jsp?cntrl="+cntrl+"&defType="+defType.value+"&oldDefType="+oldDefType+"&desc="+desc+"&mode=edit";
		}
		
		function addHeader()
		{
			var retval = window.open('addDefaultType.jsp', '', 'left=350,top=300,resizable=no,scrollbars=no,status=no,toolbar=no,height=200,width=400');
		}
		
		function deleteDefType(i)
		{
			var oldDefType = document.getElementById(i+'_Old_DefType').value;
			var cntrl = document.getElementById(i+'_Cntrl').value;
			
			parent.frames['hiddenFrame'].document.location.href = "manageDefaultTypeProcess.jsp?cntrl="+cntrl+"&oldDefType="+oldDefType+"&mode=delete";
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="60%">
			<tr>
				<td colspan="4" style="text-align: right;">
					<input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Product") %>" onClick="addHeader()">
				</td>
			</tr>
			<tr>
				<th class="label" width="30%"><%= resourceBundle.getProperty("DataManager.DisplayText.Product") %></th>
				<th class="label" width="60%"><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			String sDefType = null;
			String sCntrlType = null;
			String sDesc = null;
			StringList slCntrls = new StringList();
			Map<String, String> mDefValue = null;
			
			DefParamValues defParamVals = new DefParamValues();
			MapList mlDefValues = defParamVals.getDefaultTypes();	
			for(int i=0; i<mlDefValues.size(); i++)
			{
				mDefValue = (Map<String, String>)mlDefValues.get(i);

				sCntrlType = mDefValue.get(RDMServicesConstants.CNTRL_TYPE);
				sDefType = mDefValue.get(RDMServicesUtils.CNTRL_DEF_TYPE);
				sDesc = mDefValue.get(RDMServicesUtils.DESCRIPTION);

				if(!slCntrls.contains(sCntrlType))
				{
					slCntrls.add(sCntrlType);
%>					
					<tr>
						<td colspan="3" align="center"><b><%= resourceBundle.getProperty("DataManager.DisplayText."+sCntrlType) %></b></td>
					</tr>
<%					
				}
%>
				<tr>
					<td class="input">
						<input type="text" id="<%= i %>_DefType" name="<%= i %>_DefType" value="<%= sDefType %>">
					</td>
					<td class="input">
						<input type="text" id="<%= i %>_Desc" name="<%= i %>_Desc" value="<%= sDesc %>" size="50">
					</td>
					<input type="hidden" id="<%= i %>_Cntrl" name="<%= i %>_Cntrl" value="<%= sCntrlType %>">
					<input type="hidden" id="<%= i %>_Old_DefType" name="<%= i %>_Old_DefType" value="<%= sDefType %>">
					<td class="input" style="text-align:center">
						<a href="javascript:editDefType('<%= i %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteDefType('<%= i %>')">
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
