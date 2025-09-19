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
			
			isChecked = request.getParameter("batchNo");
			if("Y".equals(isChecked))
			{
				mlUpdateSettings.add(updateGeneralSettings(request, "BatchNo", sCntrlType));
			}
			
			isChecked = request.getParameter("product");
			if("Y".equals(isChecked))
			{
				mlUpdateSettings.add(updateGeneralSettings(request, "Product", sCntrlType));
			}
			
			isChecked = request.getParameter("image");
			if("Y".equals(isChecked))
			{
				mlUpdateSettings.add(updateGeneralSettings(request, "ViewImage", sCntrlType));
			}
			
			DataQuery qry = new DataQuery();
			if(mlInsertSettings.size() > 0)
			{
				qry.insertAdminSettings(mlInsertSettings);
			}
			
			if(mlUpdateSettings.size() > 0)
			{
				qry.updateAdminSettings(mlUpdateSettings);
			}
			
			String sDelParams = request.getParameter("DELETE_PARAMS");
			if(sDelParams != null && !"".equals(sDelParams))
			{
				qry.deleteAdminSettings(sDelParams, sCntrlType);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace(System.out);
			sErr = e.getMessage();
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
		mSettings.put(RDMServicesConstants.SCALE_ON_GRAPH, request.getParameter("GRAPH_SCALE_"+i));
		mSettings.put(RDMServicesConstants.STAGE_NAME, request.getParameter("STAGE_NAME_"+i));	
		mSettings.put(RDMServicesConstants.ROOMS_OVERVIEW, getRequestValue(request, "ROOMS_OVERVIEW_"+i));
		mSettings.put(RDMServicesConstants.MULTIROOMS_VIEW, getRequestValue(request, "MULTIROOMS_VIEW_"+i));
		mSettings.put(RDMServicesConstants.SINGLEROOM_VIEW, getRequestValue(request, "SINGLEROOM_VIEW_"+i));
		mSettings.put(RDMServicesConstants.GRAPH_VIEW, getRequestValue(request, "GRAPH_VIEW_"+i));
		mSettings.put(RDMServicesConstants.HELPER_READ, getRequestValue(request, "HELPER_READ_"+i));
		mSettings.put(RDMServicesConstants.HELPER_WRITE, getRequestValue(request, "HELPER_WRITE_"+i));
		mSettings.put(RDMServicesConstants.SUPERVISOR_READ, getRequestValue(request, "SUPERVISOR_READ_"+i));
		mSettings.put(RDMServicesConstants.SUPERVISOR_WRITE, getRequestValue(request, "SUPERVISOR_WRITE_"+i));
		mSettings.put(RDMServicesConstants.MANAGER_READ, getRequestValue(request, "MANAGER_READ_"+i));
		mSettings.put(RDMServicesConstants.MANAGER_WRITE, getRequestValue(request, "MANAGER_WRITE_"+i));
		mSettings.put(RDMServicesConstants.ADMIN_READ, getRequestValue(request, "ADMIN_READ_"+i));
		mSettings.put(RDMServicesConstants.ADMIN_WRITE, getRequestValue(request, "ADMIN_WRITE_"+i));
		mSettings.put(RDMServicesConstants.PARAM_UNIT, request.getParameter("PARAM_UNIT_"+i));
		mSettings.put(RDMServicesConstants.PARAM_GROUP, request.getParameter("PARAM_GROUP_"+i));
		mSettings.put(RDMServicesConstants.ON_OFF_VALUE, getRequestValue(request, "ON_OFF_"+i));
		mSettings.put(RDMServicesConstants.RESET_VALUE, getRequestValue(request, "RESET_VALUE_"+i));
		mSettings.put(RDMServicesConstants.PARAM_INFO, getRequestValue(request, "PARAM_INFO_"+i));
		mSettings.put(RDMServicesConstants.CNTRL_TYPE, sCntrlType);

		return mSettings;
	}
	
	private Map updateGeneralSettings(ServletRequest request, String sName, String sCntrlType) throws Exception
	{
		String displayOrder = request.getParameter("DISPLAY_ORDER_"+sName);
		displayOrder = ((displayOrder == null || "".equals(displayOrder)) ? "0" : displayOrder);
		
		Map<String, String> mSettings = new HashMap<String, String>();
		mSettings.put(RDMServicesConstants.PARAM_NAME, sName);
		mSettings.put(RDMServicesConstants.DISPLAY_ORDER, displayOrder);
		mSettings.put(RDMServicesConstants.SCALE_ON_GRAPH, "0");
		mSettings.put(RDMServicesConstants.STAGE_NAME, "NA");
		mSettings.put(RDMServicesConstants.ROOMS_OVERVIEW, getRequestValue(request, "ROOMS_OVERVIEW_"+sName));
		mSettings.put(RDMServicesConstants.MULTIROOMS_VIEW, getRequestValue(request, "MULTIROOMS_VIEW_"+sName));
		mSettings.put(RDMServicesConstants.SINGLEROOM_VIEW, getRequestValue(request, "SINGLEROOM_VIEW_"+sName));
		mSettings.put(RDMServicesConstants.GRAPH_VIEW, getRequestValue(request, "GRAPH_VIEW_"+sName));
		mSettings.put(RDMServicesConstants.HELPER_READ, "Y");
		mSettings.put(RDMServicesConstants.HELPER_WRITE, "N");
		mSettings.put(RDMServicesConstants.SUPERVISOR_READ, "Y");
		mSettings.put(RDMServicesConstants.SUPERVISOR_WRITE, "N");
		mSettings.put(RDMServicesConstants.MANAGER_READ, "Y");
		mSettings.put(RDMServicesConstants.MANAGER_WRITE, "N");
		mSettings.put(RDMServicesConstants.ADMIN_READ, "Y");
		mSettings.put(RDMServicesConstants.ADMIN_WRITE, "N");
		mSettings.put(RDMServicesConstants.PARAM_UNIT, "");
		mSettings.put(RDMServicesConstants.PARAM_GROUP, "");
		mSettings.put(RDMServicesConstants.ON_OFF_VALUE, "N");
		mSettings.put(RDMServicesConstants.RESET_VALUE, "N");
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