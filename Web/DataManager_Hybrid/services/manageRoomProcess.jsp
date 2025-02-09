<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	String sAction = request.getParameter("mode");
	String sErr = "";
	
	try
	{
		String sRoomId = request.getParameter("roomId");
		String sRoomIP = request.getParameter("roomIP");
		String sType = request.getParameter("roomType");
		String sStatus = request.getParameter("roomStatus");
		String sGroup = request.getParameter("roomGroup");
		String cntrlVersion = request.getParameter("cntrlVersion");
		
		Map<String, String> mRoomInfo = new HashMap<String, String>();
		mRoomInfo.put(RDMServicesConstants.ROOM_ID, sRoomId);
		mRoomInfo.put(RDMServicesConstants.ROOM_IP, sRoomIP);
		mRoomInfo.put(RDMServicesConstants.CNTRL_TYPE, sType);
		mRoomInfo.put(RDMServicesConstants.ROOM_STATUS, sStatus);
		mRoomInfo.put(RDMServicesConstants.GROUP_NAME, sGroup);
		mRoomInfo.put(RDMServicesConstants.CNTRL_VERSION, cntrlVersion);

		if("add".equals(sAction))
		{
			/*
			String sUserId = request.getParameter("userId");
			String sPassword = request.getParameter("password");
			mRoomInfo.put(RDMServicesConstants.ROOM_USERID, sUserId);
			mRoomInfo.put(RDMServicesConstants.ROOM_PASSWORD, sPassword);
			*/
			RDMServicesUtils.addRoom(RDMSession, mRoomInfo);
		}
		else if("edit".equals(sAction))
		{
			RDMServicesUtils.updateRoom(RDMSession, sRoomId, mRoomInfo);
		}
		/*
		else if("auth".equals(sAction))
		{
			String sUserId = request.getParameter("userId");
			String sPassword = request.getParameter("password");
			
			RDMServicesUtils.changeRoomAuth(sRoomId, sUserId, sPassword);
		}
		*/
	}
	catch(Exception e)
	{
		e.printStackTrace(System.out);
		sErr = e.getMessage();
		sErr = (sErr == null ? "null" : sErr.replaceAll("\"", "'").replaceAll("\r", " ").replaceAll("\n", " "));
	}
%>

	<script>
		var sErr = "<%= sErr %>";
		var mode = "<%= sAction %>";
		if(sErr != "")
		{
			alert("Error: "+sErr);
			history.back(-1);
		}
		else
		{
			if(mode == "add" || mode == "auth")
			{
				top.opener.document.location.href = top.opener.document.location.href;
				window.close();
			}
			else
			{
				alert("<%= resourceBundle.getProperty("DataManager.DisplayText.Room_Updated") %>");
				parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
			}
		}
		
	</script>

</html>