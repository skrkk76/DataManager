<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.rules.*" %>

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

		function addExpr()
		{
			var parameter = document.getElementById('parameter').value;
			if(parameter == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Parameter") %>");
				return false;
			}

			var operator = document.getElementById('operator').value;
			if(operator == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Arth_Op") %>");
				return false;
			}

			var paramValue = "";
			var txtValue = document.getElementById('txtValue').value.trim();
			if(txtValue == "")
			{
				paramValue = document.getElementById('paramValue').value;
				if(paramValue == "")
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Cmp_Value") %>");
					return false;
				}
			}
			
			var rule = document.getElementById('rule').value.trim();
			if(rule != "")
			{				
				var cmp = "";
				var cmpGrp = document.getElementsByName('cmp');
				for(var i=0; i<cmpGrp.length; i++) 
				{
					if(cmpGrp[i].checked == true)
					{
						cmp = cmpGrp[i].value;
					}
				}
				
				if(cmp == "")
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Log_Op") %>");
					return false;
				}
				
				rule += " " + cmp + " ";
			}
			
			rule += "(" + "'" + parameter + "'" + " " + operator + " ";
			if(txtValue != "")
			{
				rule += "'" + txtValue + "'";
			}
			else
			{
				rule += "'" + paramValue + "'";
			}
			
			rule += ")";
			
			document.getElementById('rule').value = rule;
		}
		
		function clearRule()
		{
			document.getElementById('rule').value = "";
		}
		
		function submitForm()
		{
			var rule = document.getElementById('rule').value.trim();
			if(rule == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Rule_Expr_Blank") %>");
				return false;
			}
			
			var desc = document.getElementById('desc').value.trim();
			if(desc == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Description") %>");
				return false;
			}
			
			document.frm.submit();
		}
	</script>
</head>

<%
	String oid = request.getParameter("oid");
	String sCntrlType = request.getParameter("cntrlType");
	
	RuleEngine ruleEngine = new RuleEngine();
	Map<String, String> mRule = ruleEngine.getUserRule(oid, sCntrlType);
	
	String expr = mRule.get(RDMServicesConstants.RULE_EXPRESSION);
	String desc = mRule.get(RDMServicesConstants.RULE_DESCRIPTION);
	String exec = mRule.get(RDMServicesConstants.RULE_EXECUTE);
%>

<body>
	<form name="frm" method="post" action="manageRulesProcess.jsp">
		<input type="hidden" id="mode" name="mode" value="edit">
		<input type="hidden" id="oid" name="oid" value="<%= oid %>">
		<input type="hidden" id="cntrlType" name="cntrlType" value="<%= sCntrlType %>">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="50%">
			<tr>
				<td colspan="4" align="center"><b><u><%= resourceBundle.getProperty("DataManager.DisplayText.Edit_Rule") %></u></b></td>
			</tr>
			<tr>
				<td align="center">
					<input type="radio" id="cmp" name="cmp" value="&&"><b><%= resourceBundle.getProperty("DataManager.DisplayText.And") %></b>
				</td>
				<td>&nbsp;</td>
				<td align="center">
					<input type="radio" id="cmp" name="cmp" value="||"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Or") %></b>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Parameter") %></b></td>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Operator") %></td>
				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Value") %></td>
			</tr>

			<tr>
				<td valign="top">
					<select id="parameter" name="parameter" multiple size="25">
<%
					StringList slParams = RDMServicesUtils.getParamGroup(sCntrlType);
					for(int i=0; i<slParams.size(); i++)
					{
%>
						<option value="<%= slParams.get(i) %>"><%= slParams.get(i) %></option>
<%
					}
%>
					</select>
				</td>
				
				<td valign="top">
					<select id="operator" name="operator">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
						<option value="==">=</option>
						<option value="!=">!=</option>
						<option value=">">&gt;</option>
						<option value="<">&lt;</option>
					</select>
				</td>

				<td valign="top">
					<input type="text" size="10" id="txtValue" name="txtValue"><br><b>&nbsp;<%= resourceBundle.getProperty("DataManager.DisplayText.Or") %>&nbsp;</b><br>
					<select id="paramValue" name="paramValue" multiple size="22">
<%
					for(int i=0; i<slParams.size(); i++)
					{
%>
						<option value="<%= slParams.get(i) %>"><%= slParams.get(i) %></option>
<%
					}
%>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="3" align="center">
					<input type="button" name="add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add") %>" onClick="addExpr()">
					<input type="button" name="Reset" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Reset") %>" onClick="reset()">
				</td>
			</tr>
			</br>
			<tr>
				<td colspan="3">
					<b><%= resourceBundle.getProperty("DataManager.DisplayText.Description") %>&nbsp;</b>
					<input type="text" id="desc" name="desc" size="79" value="<%= desc %>">
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<textarea id="rule" name="rule" rows="3" cols="70"><%= expr %></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2" valign="top">
					<select id="time" name="time">
						<option value="0" <%= "0".equals(exec) ? "selected" : "" %>><%= resourceBundle.getProperty("DataManager.DisplayText.Select_Duration") %></option>
						<option value="15" <%= "15".equals(exec) ? "selected" : "" %>>15 <%= resourceBundle.getProperty("DataManager.DisplayText.Minutes") %></option>
						<option value="30" <%= "30".equals(exec) ? "selected" : "" %>>30 <%= resourceBundle.getProperty("DataManager.DisplayText.Minutes") %></option>
						<option value="60" <%= "60".equals(exec) ? "selected" : "" %>>60 <%= resourceBundle.getProperty("DataManager.DisplayText.Minutes") %></option>
					</select>
				</td>
				<td align="right">
					<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" onClick="submitForm()">&nbsp;&nbsp;&nbsp;
					<input type="button" name="Clear" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Clear") %>" onClick="clearRule()">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
