<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.db.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String isChecked = "";
	String sAction = "";
	String sErr = "";

	MapList mlInsertSettings = new MapList();
	MapList mlUpdateSettings = new MapList();

	String sCount = request.getParameter("PARAM_COUNT");
	String sCntrlType = request.getParameter("CNTRL_TYPE");
	if(sCount != null && !"".equals(sCount) && !"null".equalsIgnoreCase(sCount))
	{
		try
		{
			int iCount = Integer.parseInt(sCount);
			for(int i=0; i<iCount; i++)
			{
				isChecked = request.getParameter("CHECK_"+i);
				if("Y".equals(isChecked))
				{
					sAction = request.getParameter("ACTION_"+i);
					if("insert".equals(sAction))
					{
						mlInsertSettings.add(createSettingsMap(request, i, sCntrlType));
					}
					else if("update".equals(sAction))
					{
						mlUpdateSettings.add(createSettingsMap(request, i, sCntrlType));
					}
				}
			}
		
			DataQuery qry = new DataQuery();
			if(mlInsertSettings.size() > 0)
			{
				qry.insertGeneralParamSettings(mlInsertSettings);
			}
			
			if(mlUpdateSettings.size() > 0)
			{
				qry.updateGeneralParamSettings(mlUpdateSettings);
			}
			
			String sDelParams = request.getParameter("DELETE_PARAMS");
			if(sDelParams != null && !"".equals(sDelParams))
			{
				qry.deleteGeneralParamSettings(sDelParams, sCntrlType);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace(System.out);
			sErr = e.getMessage();
			sErr = sErr.replaceAll("\n", "\\n");
		}
	}
%>

	<script>
		var sErr = "<%= sErr %>";
		if(sErr != "")
		{
			alert("Error: "+sErr);
		}
		
		parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
	</script>

</html>

<%!
	private Map createSettingsMap(ServletRequest request, int i, String sCntrlType) throws Exception
	{
		Map<String, String> mSettings = new HashMap<String, String>();
		
		mSettings.put(RDMServicesConstants.PARAM_NAME, request.getParameter("PARAM_NAME_"+i));
		mSettings.put(RDMServicesConstants.DISPLAY_ORDER, request.getParameter("DISPLAY_ORDER_"+i));
		mSettings.put(RDMServicesConstants.PARAM_UNIT, request.getParameter("PARAM_UNIT_"+i));
		mSettings.put(RDMServicesConstants.SCALE_ON_GRAPH, request.getParameter("GRAPH_SCALE_"+i));
		mSettings.put(RDMServicesConstants.ON_OFF_VALUE, getRequestValue(request, "ON_OFF_"+i));
		mSettings.put(RDMServicesConstants.GRAPH_VIEW, getRequestValue(request, "GRAPH_VIEW_"+i));
		mSettings.put(RDMServicesConstants.HELPER_READ, getRequestValue(request, "HELPER_READ_"+i));
		mSettings.put(RDMServicesConstants.HELPER_WRITE, getRequestValue(request, "HELPER_WRITE_"+i));
		mSettings.put(RDMServicesConstants.SUPERVISOR_READ, getRequestValue(request, "SUPERVISOR_READ_"+i));
		mSettings.put(RDMServicesConstants.SUPERVISOR_WRITE, getRequestValue(request, "SUPERVISOR_WRITE_"+i));
		mSettings.put(RDMServicesConstants.MANAGER_READ, getRequestValue(request, "MANAGER_READ_"+i));
		mSettings.put(RDMServicesConstants.MANAGER_WRITE, getRequestValue(request, "MANAGER_WRITE_"+i));
		mSettings.put(RDMServicesConstants.ADMIN_READ, getRequestValue(request, "ADMIN_READ_"+i));
		mSettings.put(RDMServicesConstants.ADMIN_WRITE, getRequestValue(request, "ADMIN_WRITE_"+i));
		mSettings.put(RDMServicesConstants.CNTRL_TYPE, sCntrlType);

		return mSettings;
	}
	
	private String getRequestValue(ServletRequest request, String key) throws Exception
	{
		String val = request.getParameter(key);
		val = ((val == null || "".equals(val)) ? "N" : val.trim());
		return val;
	}
%>