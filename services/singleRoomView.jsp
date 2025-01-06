<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<%
	String sController = request.getParameter("controller");
	sController = (sController == null ? "" : sController);
	
	StringList slAllControllers = RDMSession.getControllers(u);	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<%
if("".equals(sController))
{
%>
	<head>
		<script language="javascript">			
			function selectController(obj)
			{
				var sCntrl = obj.value;
				if(sCntrl == "Bunker" || sCntrl == "Tunnel" || sCntrl == "Grower")
				{
					document.location.href = "defaultParamsView.jsp?controller="+sCntrl;
				}
				else
				{
					document.location.href = "singleRoomView.jsp?controller="+sCntrl;
				}
			}
		</script>
	</head>
	<body>
		<table border="0" cellpadding="0" cellspacing="0" width="85%">		
			<tr>
				<td style="font-family:Arial; font-size:0.8em; font-weight:bold; border:#ffffff; text-align:left">
					<%= resourceBundle.getProperty("DataManager.DisplayText.Select_Room") %>:&nbsp;
					<select id="SelController" name="SelController" onChange="javascript:selectController(this)">
						<option value=""><%= resourceBundle.getProperty("DataManager.DisplayText.Please_choose_one") %></option>
<%
						if(RDMServicesConstants.ROLE_ADMIN.equals(u.getRole()) || RDMServicesConstants.ROLE_MANAGER.equals(u.getRole()))
						{
%>
							<optgroup label="<%= resourceBundle.getProperty("DataManager.DisplayText.Default_Values") %>">
<%
							boolean bViewGrwDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER);
							if(bViewGrwDB && (RDMSession.getControllers(RDMServicesConstants.TYPE_GROWER).size() > 0))
							{
%>
								<option value="<%= RDMServicesConstants.TYPE_GROWER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></option>
<%
							}
							boolean bViewBnkDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER);
							if(bViewBnkDB && (RDMSession.getControllers(RDMServicesConstants.TYPE_BUNKER).size() > 0))
							{
%>
								<option value="<%= RDMServicesConstants.TYPE_BUNKER %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></option>
<%
							}
							boolean bViewTnlDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL);
							if(bViewTnlDB && (RDMSession.getControllers(RDMServicesConstants.TYPE_TUNNEL).size() > 0))
							{
%>
								<option value="<%= RDMServicesConstants.TYPE_TUNNEL %>"><%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></option>
<%
							}
%>
							<optgroup label="<%= resourceBundle.getProperty("DataManager.DisplayText.Controllers") %>">
<%
						}

						String sCntrlName = "";
						String sSelected = "";
						for(int i=0; i<slAllControllers.size(); i++)
						{
							sCntrlName = slAllControllers.get(i);
							sSelected = (sCntrlName.equals(sController) ? "selected" : "");
%>
							<option value="<%= sCntrlName %>" <%= sSelected %>><%= sCntrlName %></option>
<%
						}
%>
					</select>
				</td>
			</tr>
		</table>
	</body>
<%
}
else
{
	String url = "";
	if(RDMServicesUtils.isGeneralController(sController))
	{
%>
		<script language="javascript">	
			document.location.href = "generalParamsView.jsp?controller=<%= sController %>";
		</script>
<%
	}
	else
	{
%>
	<frameset rows="99%,1%" frameborder="0">
		<frame name="content" src="roomParameters.jsp?controller=<%= sController %>" />
		<frame name="hiddenFrame" src="blank.jsp" />
	</frameset>
<%
	}
}
%>
</html>