<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.rules.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sCntrlType = request.getParameter("cntrlType");
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
		
		function addRule()
		{
			var retval = window.open('addRule.jsp?cntrlType=<%= sCntrlType %>', '', 'left=50,top=50,resizable=no,scrollbars=yes,status=no,toolbar=no,height=675,width=625');
		}
		
		function editRule(oid)
		{
			var retval = window.open('editRule.jsp?oid='+oid+'&cntrlType=<%= sCntrlType %>', '', 'left=50,top=50,resizable=no,scrollbars=yes,status=no,toolbar=no,height=675,width=625');
		}
		
		function deleteRule(oid)
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Rule") %>");
			if(conf == true)
			{
				parent.frames['hiddenFrame'].document.location.href = "manageRulesProcess.jsp?oid="+oid+"&cntrlType=<%= sCntrlType %>&mode=delete";
			}
		}
	</script>
</head>

<body>
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="<%= winWidth * 0.7 %>">
			<tr>
				<td colspan="4" style="text-align: right;">
				<input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Rule") %>" onClick="addRule()">
				</td>
			</tr>
			<tr>
				<th class="label" width="40%"><%= resourceBundle.getProperty("DataManager.DisplayText.Expression") %></th>
				<th class="label" width="40%"><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Duration_time") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			Map<String, String> mRule = null;
			String expr = null;
			String desc = null;
			String exec = null;
			String oid = null;
			
			RuleEngine ruleEngine = new RuleEngine();
			MapList mlRules = ruleEngine.getUserRules(sCntrlType);
			
			for(int i=0; i<mlRules.size(); i++)
			{
				mRule = mlRules.get(i);
				oid = mRule.get(RDMServicesConstants.RULE_OID);
				expr = mRule.get(RDMServicesConstants.RULE_EXPRESSION);
				desc = mRule.get(RDMServicesConstants.RULE_DESCRIPTION);
				exec = mRule.get(RDMServicesConstants.RULE_EXECUTE);
%>
				<tr>
					<td class="input"><%= expr %></td>
					<td class="input"><%= desc %></td>
					<td class="input"><%= ("0".equals(exec) ? "" : exec) %></td>
					<td class="input" style="text-align:center">
						<a href="javascript:editRule('<%= oid %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteRule('<%= oid %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
