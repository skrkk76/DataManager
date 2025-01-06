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
		
		function editAttribute(i, currAttrName)
		{			
			var attrName = document.getElementById('attrName_'+i);
			var attrUnit = document.getElementById('attrUnit_'+i).value;
			var readWeights = document.getElementById('readWeights_'+i).value;
			var calculate = document.getElementById('calculate_'+i).value;
			
			attrName.value = attrName.value.trim();
			if(attrName.value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Attribute_Name") %>");
				attrName.focus();
				return false;
			}
			else
			{
				var tareWeight = "0.0";
				if(document.getElementById('tareWeight_'+i).disabled == false)
				{
					tareWeight = document.getElementById('tareWeight_'+i).value;
					if(tareWeight == '' || isNaN(tareWeight))
					{
						alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Tare_Weight_NaN") %>");
						return false;
					}
				}
				
				var maxWeight = "0.0";
				if(document.getElementById('maxWeight_'+i).disabled == false)
				{
					maxWeight = document.getElementById('maxWeight_'+i).value;
					if(isNaN(maxWeight))
					{
						alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Max_Weight_NaN") %>");
						return false;
					}

					if(maxWeight == '')
					{
						maxWeight = "0.0";
					}
				}
				
				parent.frames['footer'].document.location.href = "manageAdminAttributesProcess.jsp?attrName="+attrName.value+"&attrUnit="+attrUnit+"&readWeights="+readWeights+"&tareWeight="+tareWeight+"&maxWeight="+maxWeight+"&currAttrName="+currAttrName+"&calculate="+calculate+"&mode=edit";
			}
		}

		function addAttribute()
		{
			var retval = window.open('addAdminAttributes.jsp', '', 'left=250,top=250,resizable=no,scrollbars=no,status=no,toolbar=no,height=250,width=400');
		}

		function deleteAttribute(attrName) 
		{
			var conf = confirm("<%= resourceBundle.getProperty("DataManager.DisplayText.Delete_Attribute") %>");
			if(conf == true)
			{
				parent.frames['footer'].document.location.href = "manageAdminAttributesProcess.jsp?attrName="+attrName+"&mode=delete";
			}
		}
		
		function toggleWeights(i)
		{
			var tareWeight = document.getElementById('tareWeight_'+i);
			var maxWeight = document.getElementById('maxWeight_'+i);
			var readWeights = document.getElementById('readWeights_'+i).value;
			
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
	<form name="frm">
		<table align="center" border="0" cellpadding="2" cellspacing="1" width="<%= winWidth * 0.6 %>">
			<tr>
				<td colspan="7" style="text-align: right;"><input type="button" name="Add" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Add_Attribute") %>" onClick="addAttribute()"></td>
			</tr>
			<tr>
				<th class="label" width="25%"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Attribute") %></th>
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Task_Attr_Unit") %></th>				
				<th class="label" width="15%"><%= resourceBundle.getProperty("DataManager.DisplayText.Read_Weights") %></th>
				<th class="label" width="12%"><%= resourceBundle.getProperty("DataManager.DisplayText.Max_Weight") %></th>
				<th class="label" width="12%"><%= resourceBundle.getProperty("DataManager.DisplayText.Tare_Weight") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Calculate") %></th>
				<th class="label" width="10%"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %></th>
			</tr>
<%
			Iterator<String> itrAttr = null;
			Map<String, String> mAttr = null;
			String sAttrName = "";
			String sAttrUnit = "";
			String sReadWeights = "";
			String sTareWeight = "";
			String sMaxWeight = "";
			String sCalculate = "";

			MapList mlAttrs = RDMServicesUtils.getAdminAttributes();
			for(int i=0; i<mlAttrs.size(); i++)
			{
				mAttr = mlAttrs.get(i);
				sAttrName = mAttr.get(RDMServicesConstants.ATTRIBUTE_NAME);
				sAttrUnit = mAttr.get(RDMServicesConstants.ATTRIBUTE_UNIT);
				sMaxWeight = mAttr.get(RDMServicesConstants.MAX_WEIGHT);
				sReadWeights = mAttr.get(RDMServicesConstants.READ_WEIGHTS);
				sTareWeight = mAttr.get(RDMServicesConstants.TARE_WEIGHT);
				sTareWeight = ("true".equalsIgnoreCase(sReadWeights) ? sTareWeight : "");
				sCalculate = mAttr.get(RDMServicesConstants.CALCULATE);
%>
				<tr>
					<td class="input">
						<input type="text" id="attrName_<%= i %>" name="attrName_<%= i %>" value="<%= sAttrName %>">
					</td>
					<td class="input">
						<select id="attrUnit_<%= i %>" name="attrUnit_<%= i %>">
							<option value="NA" <%= "NA".equals(sAttrUnit) ? "selected" : "" %>></option>							
							<option value="EA" <%= "EA".equals(sAttrUnit) ? "selected" : "" %>>Each</option>
							<option value="Hr" <%= "Hr".equals(sAttrUnit) ? "selected" : "" %>>Hours</option>
							<option value="KG" <%= "KG".equals(sAttrUnit) ? "selected" : "" %>>Kilograms</option>
							<option value="Ltr" <%= "Ltr".equals(sAttrUnit) ? "selected" : "" %>>Litres</option>
							<option value="Mtr" <%= "Mtr".equals(sAttrUnit) ? "selected" : "" %>>Meters</option>
							<option value="Min" <%= "Min".equals(sAttrUnit) ? "selected" : "" %>>Minutes</option>
							<option value="SqF" <%= "SqF".equals(sAttrUnit) ? "selected" : "" %>>Sq Feet</option>
						</select>
					</td>
					<td class="input">
						<select id="readWeights_<%= i %>" name="readWeights_<%= i %>" onChange="toggleWeights('<%= i %>')">
							<option value="false" <%= "false".equalsIgnoreCase(sReadWeights) ? "selected" : "" %>>No</option>
							<option value="true" <%= "true".equalsIgnoreCase(sReadWeights) ? "selected" : "" %>>Yes</option>
						</select>
					</td>					
					<td class="input">
						<input type="text" id="maxWeight_<%= i %>" name="maxWeight_<%= i %>" value="<%= sMaxWeight %>" <%= "true".equalsIgnoreCase(sReadWeights) ? "" : "disabled" %> size="5">
					</td>
					<td class="input">
						<input type="text" id="tareWeight_<%= i %>" name="tareWeight_<%= i %>" value="<%= sTareWeight %>" <%= "true".equalsIgnoreCase(sReadWeights) ? "" : "disabled" %> size="5">
					</td>
					<td class="input">
						<select id="calculate_<%= i %>" name="calculate_<%= i %>">
							<option value="" <%= "".equals(sCalculate) ? "selected" : "" %>></option>							
							<option value="<%= RDMServicesConstants.OVERAGE %>" <%= RDMServicesConstants.OVERAGE.equals(sCalculate) ? "selected" : "" %>><%= RDMServicesConstants.OVERAGE %></option>
							<option value="<%= RDMServicesConstants.YIELD %>" <%= RDMServicesConstants.YIELD.equals(sCalculate) ? "selected" : "" %>><%= RDMServicesConstants.YIELD %></option>							
						</select>
					</td>
					<td class="input" style="text-align:center">
						<a href="javascript:editAttribute('<%= i %>', '<%= sAttrName %>')"><img border="0" src="../images/edit.jpg" height="20" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Edit") %>"></a>
						&nbsp;&nbsp;
						<a href="javascript:deleteAttribute('<%= sAttrName %>')"><img border="0" src="../images/delete.png" alt="<%= resourceBundle.getProperty("DataManager.DisplayText.Delete") %>"></a>
					</td>
				</tr>
<%
			}
%>
		</table>
	</form>
</body>
</html>
