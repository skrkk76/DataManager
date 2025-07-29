<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.polsoft.*" %>

<%@include file="../services/commonUtils.jsp" %>

<%
	Map<String, String[]> mParams = null;
	Map<String, Map<String, String[]>> mAllParams = new HashMap<String, Map<String, String[]>>();
	String sRoom = null;
	String sLogDate = null;
	StringList slRooms = new StringList();
	
	PolsoftClient polsoft = new PolsoftClient();
	Map<String, Map<String, String>> mLogData = polsoft.getLogData();
	
	ArrayList<String> alRooms = new ArrayList<String>(mLogData.keySet());
	int iSz = alRooms.size();
	for(int i=0; i<iSz; i++)
	{
		sRoom = alRooms.get(i);
		slRooms.add(sRoom);
		
		PLCServices client = null;
		String sCntrlVersion = RDMSession.getControllerVersion(sRoom);
		if(com.client.util.RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion))
		{
			client = new PLCServices_oldHW(RDMSession, sRoom);
		}
		else if(com.client.util.RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion))
		{
			client = new PLCServices_newHW(RDMSession, sRoom);
		}
	
		mParams = client.getControllerData(false);
		mAllParams.put(sRoom, mParams);
	}
	
	slRooms.sort();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<title></title>
	<meta http-equiv="refresh" content="300;url=polmonDL120Details.jsp">
	<link type="text/css" href="../styles/superTables.css" rel="stylesheet" />
    <script type="text/javascript" src="../scripts/superTables.js"></script>
	<style>
	#scrollDiv 
	{	
		margin: 2px 2px; 
		width: <%= winWidth * 0.95 %>px; 
		height: <%= winHeight * 0.8 %>px; 
		overflow: hidden; 
		font-size: 0.85em;
	}
	a:link
	{
		text-decoration:  underline;
		color:            black;
	} 
	a:visited
	{
		text-decoration:  underline;
		color:            black;
	} 
	a:hover
	{
		text-decoration:  underline;
		color:            black;
	}
	</style>
	
	<script language="javascript">
		
	</script>
</head>

<body>
	<div id="scrollDiv">
		<table id="freezeHeaders" border="1" cellpadding="1" cellspacing="0">
<%
		for(int iCnt=1; iCnt<=2; iCnt++)
		{
			int start = (iCnt * 12) - 12;
			int end = iCnt * 12;
			if(start >= iSz)
			{
				continue;
			}
%>
			<tr>
				<th>&nbsp;</th>
<%
				for(int i=start; i<end; i++)
				{
					if(i >= iSz)
					{
						continue;
					}
%>
					<th style="text-align: center; height:25px">
						<a href="../services/singleRoomView.jsp?controller=<%= slRooms.get(i) %>"><%= slRooms.get(i) %></a>
					</th>
<%
				}
%>
			</tr>
			<tr>
				<th align="left"><%= resourceBundle.getProperty("DataManager.DisplayText.Batch_No") %></th>
<%
				for(int i=start; i<end; i++)
				{
					if(i >= iSz)
					{
						continue;
					}
					mParams = mAllParams.get(slRooms.get(i));
%>
					<td class="text" align="left">
						<%= mParams.get("BatchNo")[0] %>
					</td>
<%
				}
%>
			</tr>
			<tr>
				<th align="left">Current Phase</th>
<%
				for(int i=start; i<end; i++)
				{
					if(i >= iSz)
					{
						continue;
					}
					mParams = mAllParams.get(slRooms.get(i));
%>
					<td class="text" align="left">
						<%= RDMServicesUtils.getStageName("Grower", mParams.get("current phase")[0]) %><br>(<%= mParams.get("current phase")[0] %>)
					</td>
<%
				}
%>
			</tr>
<%
			float fVal1;
			float fVal2;
			DecimalFormat df = new DecimalFormat("#.##");
			String sLabel = null;
			String sKey = null;
			String sValue = null;
			String saDisplayValues[][] = PolsoftConstants.DISPLAY_VALUES;
			Map<String, String> mData = null;

			for(int i=0; i<saDisplayValues.length; i++)
			{
				sLabel = saDisplayValues[i][0];
				sKey = saDisplayValues[i][1];
%>
				<tr>
					<th align="left"><%= sLabel %></th>
<%
					for(int j=start; j<end; j++)
					{
						if(j >= iSz)
						{
							continue;
						}
						mData = mLogData.get(slRooms.get(j));
						sLogDate = mData.get(PolsoftConstants.LOGDATE);
						
						sValue = mData.get(sKey);
						if(sValue == null)
						{
							sValue = "";
							mParams = mAllParams.get(slRooms.get(j));
							if(mParams.containsKey(sKey))
							{
								sValue = mParams.get(sKey)[0];
							}
						}
%>
						<td class="text" align="left"><font color='<%= sValue.startsWith("Err") ? "red" : "black" %>'><%= sValue %></font></td>
<%
					}
%>
				</tr>
<%
			}
		}
		
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
		SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MMM-yyyy HH:mm", Locale.ENGLISH);
		String sLastRefresh = ((sLogDate != null && !"".equals(sLogDate)) ? sdf2.format(sdf1.parse(sLogDate)) : "");
%>
		</table>
	</div>

	<table border="0" cellpadding="0" cellspacing="0" width="95%">
		<tr>
			<td style="font-family:Arial; font-size:0.8em; font-weight:bold; border:#ffffff; text-align:center">
				<%= resourceBundle.getProperty("DataManager.DisplayText.Last_updated_on") %>:&nbsp;
				<font style="weight:normal; color:#FF0000"><%= sLastRefresh %></font>
			</td>
		</tr>
	</table>

	<script type="text/javascript">		
		var myST = new superTable("freezeHeaders", {
			cssSkin : "sGrey",
			headerRows : 1,
			fixedCols : 1
		});
	</script>

</body>
</html>
