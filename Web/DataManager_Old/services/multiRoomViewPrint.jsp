<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%	
	String sRealTime = request.getParameter("realTime");
	boolean bRealTime = ("true".equalsIgnoreCase(sRealTime));	
	String sSelRange = request.getParameter("selRange");
	int iSelRange = Integer.parseInt(sSelRange);
	
	String sCntrlType = request.getParameter("cntrlType");

	StringList slCntrlSel = RDMSession.getControllersSelection(sCntrlType, 10);

	StringList slControllers = RDMSession.getControllers(iSelRange, 10, sCntrlType);
	Map<String, ParamSettings> mParamStgs = RDMServicesUtils.getMultiRoomViewParamaters(sCntrlType);
	ArrayList<String> displayOrder = RDMServicesUtils.getDisplayOrder(sCntrlType);
	
	String sRole = u.getRole();
	String sController = null;
	String[] saParamVal = null;
	String sAccess = null;
	String sParam = null;
	String sValue = null;
	String sUnit = null;
	String sLastRefresh = null;
	Map<String, Map<String, String[]>> mAllParams = new HashMap<String, Map<String, String[]>>();
	Map<String, String[]> mParams = null;	
	ParamSettings paramS = null;
	PLCServices client = null;
	
	boolean fg = true;
	for(int i=(slControllers.size()-1); i>=0; i--)
	{
		try
		{
			sController = slControllers.get(i);
		
			client = new PLCServices(RDMSession, sController);
			mParams = client.getControllerData(bRealTime);
			mAllParams.put(sController, mParams);
			
			if(fg)
			{
				sLastRefresh = (mParams.containsKey("Last Refresh") ? mParams.get("Last Refresh")[0] : "");
				fg = false;
			}
		}
		catch(Exception e)
		{
			slControllers.remove(sController);
		}
	}
	
	int iSZ = slControllers.size();
	StringList slOnOffValues = RDMServicesUtils.getOnOffParams(sCntrlType);
	
	NumberFormat decimalFormat = NumberFormat.getInstance(Locale.getDefault());
	decimalFormat.setMinimumFractionDigits(1);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
</head>

<body onLoad="javascript:window.print()">
	<table border="0" cellpadding="0" cellspacing="0" width="95%">
		<tr>
			<td style="font-family:Arial; font-size:0.8em; font-weight:bold; border:#ffffff; text-align:left">
				<%= resourceBundle.getProperty("DataManager.DisplayText.Rooms") %>:&nbsp;<%= slCntrlSel.get(iSelRange) %>
			</td>
			<td style="font-family:Arial; font-size:0.8em; font-weight:bold; border:#ffffff; text-align:right">
				<%= resourceBundle.getProperty("DataManager.DisplayText.Last_updated_on") %>:&nbsp;<font style="weight:normal; color:#FF0000"><%= sLastRefresh %></font>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	
	<table border="1" cellpadding="0" cellspacing="0">
		<tr>
			<td class="label"><%= resourceBundle.getProperty("DataManager.DisplayText.Parameter_Unit") %></td>
<%
			for(int i=0; i<iSZ; i++)
			{
				sController = slControllers.get(i);
				mParams = mAllParams.get(sController);
%>						
				<td class="label">
					<%= sController %>
				</td>
<%
			}
%>
		</tr>
<%
		for(int m=0; m<displayOrder.size(); m++)
		{
			sParam = displayOrder.get(m);
			if(!mParamStgs.containsKey(sParam))
			{
				if(sParam.startsWith(">>>"))
				{
%>						
					<tr>
						<td class="stage" align="center" colspan="<%= iSZ+1 %>">
							<%= sParam.replace(">", " ").trim() %>
						</td>
					</tr>
<%
				}
				continue;
			}
			
			paramS = mParamStgs.get(sParam);
			sAccess = u.getUserAccess(paramS);
			if(sAccess == null || RDMServicesConstants.ACCESS_NONE.equals(sAccess))
			{
				continue;
			}
%>
			<tr>
<%							
				for(int n=0; n<iSZ; n++)
				{
					sController = slControllers.get(n);
					if(sController == null) 
					{
						continue;
					}
					
					mParams = mAllParams.get(sController);
					saParamVal = mParams.get(sParam);
					
					if(saParamVal != null)
					{
						sValue = saParamVal[0];
						sUnit = saParamVal[1];
					}
					else
					{
						sValue = "";
						sUnit = "";
					}
					
					try
					{
						if(!("On".equals(sValue) || "Off".equals(sValue) || sValue.contains(":")))
						{
							sValue = numberFormat.format(Double.parseDouble(sValue));
						}
					}
					catch(Exception e)
					{
						//do nothing
					}

					if(n == 0)
					{
%>
						<td class="label"><%= sParam %>
<%
						if(!"".equals(sUnit))
						{
%>
							&nbsp;<label class="unit">(<%= sUnit %>)</label>
<%
						}
%>
						</td>
<%
					}
					
					if(sValue == null || "".equals(sValue))
					{
%>							
						<td>&nbsp;</td>
<%
					}
					else
					{
						if(slOnOffValues.contains(sParam))
						{
							if(sParam.contains("door.open"))
							{
								if("1".equals(sValue) || "On".equals(sValue))
								{
									sValue = "Open";
								}
								else if("0".equals(sValue) || "Off".equals(sValue))
								{
									sValue = "Close";
								}
							}
							else if("1".equals(sValue))
							{
								sValue = "On";
							}
							else if("0".equals(sValue))
							{
								sValue = "Off";
							}
						}
						else
						{
							if(java.util.regex.Pattern.matches("[0-9,.-]+", sValue))
							{
								try
								{
									sValue = decimalFormat.format(decimalFormat.parse(sValue));
								}
								catch(Exception e)
								{
									//do nothing
								}
							}
						}
%>
						<td class="text"><%= sValue %></td>
<%
					}
				}
%>							
			</tr>
<%
		}
%>
	</table>

</body>
</html>
