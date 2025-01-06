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
		function Map() {
			this.keys = new Array();
			this.data = new Object();

			this.put = function (key, value) {
				if (this.data[key] == null) {
					this.keys.push(key);
				}
				this.data[key] = value;
			};

			this.get = function (key) {
				return this.data[key];
			};

			this.each = function (fn) {
				if (typeof fn != 'function') {
					return;
				}
				var len = this.keys.length;
				for (var i = 0; i < len; i++) {
					var k = this.keys[i];
					fn(k, this.data[k], i);
				}
			};

			this.entrys = function () {
				var len = this.keys.length;
				var entrys = new Array(len);
				for (var i = 0; i < len; i++) {
					entrys[i] = {
						key: this.keys[i],
						value: this.data[i]
					};
				}
				return entrys;
			};
		}
	
		function validate()
		{
			if(document.getElementById('Month').value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select_Month") %>");
				return false;
			}
			
			if(document.getElementById('Year').value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Please_Enter_Year") %>");
				return false;
			}
			
			if(document.getElementById('CntrlType').value == "")
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Choose_Room_Type") %>");
				return false;
			}
			
			return true;
		}
		
		function showGraph()
		{
			if(validate())
			{
				document.frm.target = "results";
				document.frm.submit();
			}
		}
		
		var map = new Map();
<%
		String sDefProduct = resourceBundle.getProperty("DataManager.DisplayText.Default_Product");
		DefParamValues defParamVals = new DefParamValues();
		
		String sCntrl = null;
		StringList slDefTypes = null;
		String[] saCntrlTypes = new String[]{RDMServicesConstants.TYPE_BUNKER,RDMServicesConstants.TYPE_GROWER,RDMServicesConstants.TYPE_TUNNEL};

		for(int i=0; i<saCntrlTypes.length; i++)
		{
			sCntrl = saCntrlTypes[i];
			slDefTypes = defParamVals.getDefaultTypes(sCntrl);
%>
			var saDefTypes = new Array();
			saDefTypes[0] = "<%= sDefProduct %>";
<%
			for(int j=0; j<slDefTypes.size(); j++)
			{
%>	
				saDefTypes[<%= j + 1 %>] = "<%= slDefTypes.get(j) %>";
<%		
			}
%>
			map.put("<%= sCntrl %>", saDefTypes);
<%
		}
%>
		function setDefTypes(cntrl)
		{
			var sel = cntrl.value;
			var products = document.getElementById('defParamType');
			if(products.options != null)
			{
				while(products.options.length > 0)
				{
					products.remove(0);
				}
			}
			
			if(sel == "")
			{
				var opt = document.createElement('option');
				opt.value = "";
				opt.text = "<%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %>";
				products.options.add(opt);
			}
			
			var saDefTypes = map.get(sel);
			for(i=0; i<saDefTypes.length; i++)
			{
				var opt = document.createElement('option');
				opt.value = saDefTypes[i];
				opt.text = saDefTypes[i];
				products.options.add(opt);
			}
		}
	</script>
</head>

<body>
	<form name="frm" method="post" action="showBatchPhaseLoads.jsp">
		<table align="center" border="0" cellpadding="1" cellspacing="1" width="70%">
			<tr>
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Select_Month") %></b></td>
				<td class="input">
					<select id="Month" name="Month">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_Select") %></option>
						<option value="Jan"><%= resourceBundle.getProperty("DataManager.DisplayText.January") %></option>
						<option value="Feb"><%= resourceBundle.getProperty("DataManager.DisplayText.February") %></option>
						<option value="Mar"><%= resourceBundle.getProperty("DataManager.DisplayText.March") %></option>
						<option value="Apr"><%= resourceBundle.getProperty("DataManager.DisplayText.April") %></option>
						<option value="May"><%= resourceBundle.getProperty("DataManager.DisplayText.May") %></option>
						<option value="Jun"><%= resourceBundle.getProperty("DataManager.DisplayText.June") %></option>
						<option value="Jul"><%= resourceBundle.getProperty("DataManager.DisplayText.July") %></option>
						<option value="Aug"><%= resourceBundle.getProperty("DataManager.DisplayText.August") %></option>
						<option value="Sep"><%= resourceBundle.getProperty("DataManager.DisplayText.September") %></option>
						<option value="Oct"><%= resourceBundle.getProperty("DataManager.DisplayText.October") %></option>
						<option value="Nov"><%= resourceBundle.getProperty("DataManager.DisplayText.November") %></option>
						<option value="Dec"><%= resourceBundle.getProperty("DataManager.DisplayText.December") %></option>
					</select>
				</td>
				
				<td class="label"><b><%= resourceBundle.getProperty("DataManager.DisplayText.Enter_Year") %></b></td>
				<td class="input"><input type="text" id="Year" name="Year" value="" size="5"></td>

				<td class="label" id="a"><%= resourceBundle.getProperty("DataManager.DisplayText.Room_Type") %></td>
				<td class="input">
					<select id="CntrlType" name="CntrlType" onChange="javascript:setDefTypes(this)">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
						<option value="<%= RDMServicesConstants.TYPE_GROWER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></option>
						<option value="<%= RDMServicesConstants.TYPE_BUNKER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></option>
						<option value="<%= RDMServicesConstants.TYPE_TUNNEL %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></option>
					</select>
				</td>

				<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Product") %></td>
				<td class="input">
					<select id="defParamType" name="defParamType">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
					</select>
				</td>
				
				<td align="center">
					<input type="button" name="search" value="<%= resourceBundle.getProperty("DataManager.DisplayText.Show_Graph") %>" onClick="showGraph()">
				</td>
			</tr>
		</table>
	</form>
	
	<iframe name="results" src="showBatchPhaseLoads.jsp" align="middle" frameBorder="0" width="100%" height="<%= winHeight * 0.8 %>px">
</body>
</html>
