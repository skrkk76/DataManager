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
		
		function submitForm()
		{
			var attrName = document.getElementById("attrName");
			attrName.value = attrName.value.trim();
			if(attrName.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Attribute_Name") %>");
				attrName.focus();
				return;
			}
			
			var tareWeight = "0.0";
			if(document.getElementById('tareWeight').disabled == false)
			{
				tareWeight = document.getElementById('tareWeight').value;
				if(tareWeight == '' || isNaN(tareWeight))
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Tare_Weight_NaN") %>");
					return;
				}
			}
			
			var maxWeight = "0.0";
			if(document.getElementById('maxWeight').disabled == false)
			{
				maxWeight = document.getElementById('maxWeight').value;
				if(maxWeight == '' || isNaN(maxWeight))
				{
					alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Max_Weight_NaN") %>");
					return;
				}
			}
			
			document.frm.submit();
		}
		
		function toggleWeights()
		{
			var tareWeight = document.getElementById('tareWeight');
			var maxWeight = document.getElementById('maxWeight');
			var readWeights = document.getElementById('readWeights').value;
			
			tareWeight.value = "";
			maxWeight.value = "";
			if(readWeights == "true")
			{
				tareWeight.disabled = false;
				maxWeight.disabled = false;
			}
			else
			{
				tareWeight.disabled = true;
				maxWeight.disabled = true;
			}
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="manageAdminAttributesProcess.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="80%">			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Attribute") %></b></td>
				<td class="input">
					<input type="text" id="attrName" name="attrName" value="">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Attr_Unit") %></b></td>
				<td class="input">
					<select id="attrUnit" name="attrUnit">
						<option value="NA"></option>
						<option value="EA">Each</option>
						<option value="Hr">Hours</option>
						<option value="KG">Kilograms</option>
						<option value="Ltr">Litres</option>
						<option value="Mtr">Meters</option>
						<option value="Min">Minutes</option>
						<option value="SqF">Sq Feet</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Read_Weights") %></b></td>
				<td class="input">
					<select id="readWeights" name="readWeights" onChange="toggleWeights()">
						<option value="false" selected>No</option>
						<option value="true">Yes</option>
					</select>
				</td>
			</tr>			
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Max_Weight") %></b></td>
				<td class="input">
					<input type="text" id="maxWeight" name="maxWeight" value="" disabled size="5">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Tare_Weight") %></b></td>
				<td class="input">
					<input type="text" id="tareWeight" name="tareWeight" value="" disabled size="5">
				</td>
			</tr>
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Calculate") %></b></td>
				<td class="input">
					<select id="calculate" name="calculate">
						<option value="" selected></option>							
						<option value="<%= RDMServicesConstants.OVERAGE %>"><%= RDMServicesConstants.OVERAGE %></option>
						<option value="<%= RDMServicesConstants.YIELD %>"><%= RDMServicesConstants.YIELD %></option>							
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<input type="button" name="Save" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Save") %>" onClick="submitForm()">&nbsp;&nbsp;&nbsp;
					<input type="button" name="Cancel" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Cancel") %>" onClick="javascript:top.window.close()">
				</td>
			</tr>
		</table>
		<input type="hidden" id="mode" name="mode" value="add">
	</form>
</body>
</html>
