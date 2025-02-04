<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.views.*" %>

<%@include file="commonUtils.jsp" %>

<%
String sMonth = request.getParameter("Month");
String sYear = request.getParameter("Year");
String sCntrlType = request.getParameter("CntrlType");
String sDefParamType = request.getParameter("defParamType");
StringList slBatches = new StringList();

BatchPhaseLoad graph = new BatchPhaseLoad();
String sGraphCSV = "";
if(sMonth != null && sYear != null)
{
	sGraphCSV = graph.loadBatchPhaseGraph(sMonth, sYear, sCntrlType, sDefParamType, slBatches);
}
else
{
	return;
}

String sSeq = null;
String sStage = null;
String sDisplayLabel = "";
String[] saStage = null;
StringBuilder sbStages = new StringBuilder();
ArrayList<String[]> alPhases = RDMServicesUtils.getControllerStages(sCntrlType);
for(int i=0; i<alPhases.size(); i++)
{
	saStage = alPhases.get(i);
	sSeq = saStage[0];
	sStage = saStage[1];
	
	if(i > 0)
	{
		sbStages.append(",");
		sDisplayLabel += ", ";
	}
	sbStages.append("\"");
	sbStages.append(sSeq);
	if(sStage != "")
	{
		sbStages.append("(");
		sbStages.append(sStage);
		sbStages.append(")");
	}
	sbStages.append("\"");
	
	sDisplayLabel += "{v:"+i+", label:'"+sSeq+"'}";
}

%>

<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE6; IE=EmulateIE7; IE=EmulateIE8; IE=EmulateIE9">
		<title></title>
		<link type="text/css" href="../styles/dygraph.css" rel="stylesheet" />
		<script type="text/javascript" src="../scripts/excanvas.js"></script>
		<script type="text/javascript" src="../scripts/dygraph-combined.js"></script>
		<script type="text/javascript">

		function exportGraph()
		{
			var url = "../ExportBatchPhaseLoad";
			url += "?Month=<%= sMonth %>";
			url += "&Year=<%= sYear %>";
			url += "&CntrlType=<%= sCntrlType %>";
			url += "&ProductType=<%= sDefParamType %>";
			url += "&Yield=Yes";

			document.location.href =  url;
		}
		
		var arrStages = new Array(<%= sbStages.toString() %>);
		</script>
	</head>

	<body>
		<table>
			<tr>
				<td valign="top">
					<div id="graphdiv" style="width:<%= winWidth * 0.75 %>px; height:<%= winHeight * 0.75 %>px;"></div>
				</td>
				<td valign="top">
					<table>						
						<tr>
							<td style="font-family:Arial; font-size:1.0em; font-weight:bold; color:#0000FF">
								<a href="javascript:exportGraph()"><%= resourceBundle.getProperty("DataManager.DisplayText.Export_Graph_Data") %></a>
							</td>
						</tr>
						<tr>
							<br><td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Parameter_Values") %></td>
						</tr>
						<tr>
							<td>
								<div id="status" style="width:150px; font-size:0.8em; padding-top:5px;"></div>
							</td>
						</tr>						
						<tr>
							<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Select_Batch") %></td>
						</tr>
						<tr>
							<td valign="top">
<%							
								for(int i=0; i<slBatches.size(); i++)
								{
%>
									<tr>
										<td>
											<input type="checkbox" id="<%= i %>" onClick="change(this)" checked>
											<label style="font-family:Arial,sans-serif; font-size:12px;" for="<%= i %>"><%= slBatches.get(i) %>&nbsp;</label>
										</td>
									</tr>
<%
								}
%>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<script type="text/javascript">			
			var g = new Dygraph(document.getElementById("graphdiv"),
				'../graphs/ControllerData/<%= sGraphCSV %>',
				{
					labelsDiv: document.getElementById('status'),					
					labelsSeparateLines: true,
					labelsKMB: true,
					legend: 'always',
					colors: ["Red",
							"Brown",
							"DeepPink",
							"DarkGreen",
							"Magenta",
							"Blue",
							"Orange",
							"Violet",
							"Crimson",
							"Purple"],
					drawPoints:true,
					pointSize:2,
					highlightCircleSize:4,
					xlabel: '<%= resourceBundle.getProperty("DataManager.DisplayText.Stage") %>',
					ylabel: '<%= resourceBundle.getProperty("DataManager.DisplayText.Duration_Hours") %>',
					axisLineColor: 'black',
					axes: {
						x: {
							valueFormatter: function(x) {
								return '<b>'+arrStages[x]+'</b>';
							},
							axisLabelFormatter: function(x) {
								return x; 
							},
							ticker: function(min, max, pixels, opts, dygraph, vals) {
								return [<%= sDisplayLabel %>];
							}
						}
					}						
				}
			);
			
			function change(el)
			{				
				g.setVisibility(el.id, el.checked);
			}
		</script>
	</body>
</html>