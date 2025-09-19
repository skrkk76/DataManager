<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@include file="commonUtils.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
	<link rel="stylesheet" href="../styles/navstyle.css">
	<style type="text/css">
		a.label
		{
		   font-size:12px;
		   font-family:Arial,sans-serif;
		   font-weight:bold;
		   color:#FFFFFF;
		   background-color:transparent;
		   border-color:transparent;
		   border-width:0px;
		}

		td.label
		{
		   font-size:14px;
		   font-family:Arial,sans-serif;
		   font-weight:bold;
		   color:#FFFFFF;
		   background-color:grey;
		   border-color:transparent;
		   border-width:0px;
		}
	</style>

	<script language="javascript">
		window.onresize = function() {
			var winW = 630, winH = 460;
			if(top.document.body && top.document.body.offsetWidth)
			{
				winW = top.document.body.offsetWidth;
				winH = top.document.body.offsetHeight;
			}
			if(top.document.compatMode == "CSS1Compat" && top.document.documentElement && top.document.documentElement.offsetWidth)
			{
				winW = top.document.documentElement.offsetWidth;
				winH = top.document.documentElement.offsetHeight;
			}
			if(top.window.innerWidth && top.window.innerHeight)
			{
				winW = top.window.innerWidth;
				winH = top.window.innerHeight;
			}

			//var url = frames['displaycontent'].location.href;
			//frames['displaycontent'].location.href = "commonUtils.jsp?winW="+winW+"&winH="+winH;
			//setTimeout("loadContent('"+url+"')", 500);
		};
	</script>

	<script type="text/javascript">
		function setLogData()
		{
			var script = document.createElement("script");
			script.type = "text/javascript";
			script.src = "http://ipinfo.io/?callback=apiResponse";
			document.getElementsByTagName("head")[0].appendChild(script);
		}

		function apiResponse(response)
		{
			document.getElementById("ip").value = response.ip;
			document.getElementById("hostname").value = response.hostname;
			document.getElementById("city").value = response.city;
			document.getElementById("region").value = response.region;
			document.getElementById("country").value = response.country;
		}
	</script>

	<script language="javascript">
		function loadContent(url)
		{
			frames['displaycontent'].location.href = url;
		}

		function reloadHeader(url)
		{
			parent.frames['header'].location.href = "header.jsp?showContent="+url;
		}

		function popupContent(url, h, w)
		{
			var retval = window.open(url, '', 'left=200,top=100,resizable=no,scrollbars=no,status=no,toolbar=no,height='+h+',width='+w);
		}

		function logout()
		{
			document.frm.submit();
		}

		function resetContext(userId)
		{
			top.window.document.location.href = "../LoginServlet?U="+userId+"&resetContext=yes";
		}
	</script>
</head>

<%
String showContent = request.getParameter("showContent");
if(showContent == null || "".equals(showContent))
{
	String sHomePage = u.getHomePage();
	sHomePage = (sHomePage == null || "".equals(sHomePage) ? RDMServicesConstants.HOME : sHomePage);

	Map<String, String> mHomePage = new HashMap<String, String>();
	mHomePage.put(RDMServicesConstants.HOME, "showGlobalAlertsView.jsp");
	mHomePage.put(RDMServicesConstants.SHORTLINKS, "viewShortLinks.jsp");
	mHomePage.put(RDMServicesConstants.ACTIONS_UPDATE_BNO, "manageBatchNosView.jsp");
	mHomePage.put(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER, "dashboardView.jsp?cntrlType=Grower");
	mHomePage.put(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER, "dashboardView.jsp?cntrlType=Bunker");
	mHomePage.put(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL, "dashboardView.jsp?cntrlType=Tunnel");
	mHomePage.put(RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM, "singleRoomView.jsp");
	mHomePage.put(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_GROWER, "multiRoomView.jsp?cntrlType=Grower");
	mHomePage.put(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_BUNKER, "multiRoomView.jsp?cntrlType=Bunker");
	mHomePage.put(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_TUNNEL, "multiRoomView.jsp?cntrlType=Tunnel");
	mHomePage.put(RDMServicesConstants.VIEWS_GRAPH_ATTRDATA, "attrDataGraphView.jsp");
	mHomePage.put(RDMServicesConstants.VIEWS_ALARMS, "alarmView.jsp");
	mHomePage.put(RDMServicesConstants.VIEWS_LOGS, "logView.jsp");
	mHomePage.put(RDMServicesConstants.VIEWS_COMMENTS, "userCommentsView.jsp");
	mHomePage.put(RDMServicesConstants.VIEWS_REPORTS, "viewReportsView.jsp");

	showContent = mHomePage.get(sHomePage);
}
%>
<body onLoad="javascript:loadContent('<%= showContent %>'); setLogData()">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr bgcolor="grey">
			<td width="75%">
				<div id="wrapper">
					<nav id="nav">
						<ul id="navigation">
								<li><a href="javascript:reloadHeader('showGlobalAlertsView.jsp')" class="first">
									<%= resourceBundle.getProperty("DataManager.DisplayText.Home") %></a>
								</li>
								<li><a href="javascript:reloadHeader('viewShortLinks.jsp')">
									<%= resourceBundle.getProperty("DataManager.DisplayText.Short_Links") %></a>
								</li>
<%
							boolean bUpdateBNO = u.hasViewAccess(RDMServicesConstants.ACTIONS_UPDATE_BNO);
							if(bUpdateBNO)
							{
%>
								<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Actions") %> &raquo;</a>
									<ul>
										<li><a href="javascript:reloadHeader('manageBatchNosView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Update_Batch_Nos") %></a></li>
									</ul>
								</li>
<%
							}

							boolean bViewGrwDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_GROWER);
							boolean bViewBnkDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_BUNKER);
							boolean bViewTnlDB = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_DASHBOARD_TUNNEL);
							boolean bViewSingle = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_SINGLE_ROOM);
							boolean bViewMultiGrw = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_GROWER);
							boolean bViewMultiBnk = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_BUNKER);
							boolean bViewMultiTnl = u.hasViewAccess(RDMServicesConstants.ROOMS_VIEW_MULTI_ROOM_TUNNEL);

							if((bViewGrwDB || bViewBnkDB || bViewTnlDB) || bViewSingle || (bViewMultiGrw || bViewMultiBnk || bViewMultiTnl))
							{
%>
								<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Rooms_View") %> &raquo;</a>
									<ul>
<%
									if(bViewGrwDB || bViewBnkDB || bViewTnlDB)
									{
%>
										<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Dashboard") %> &raquo;</a>
											<ul>
<%
											if(bViewGrwDB)
											{
%>
												<li><a href="javascript:reloadHeader('dashboardView.jsp?cntrlType=Grower')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></a>
												</li>
<%
											}
											if(bViewBnkDB)
											{
%>
												<li><a href="javascript:reloadHeader('dashboardView.jsp?cntrlType=Bunker')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></a>
												</li>
<%
											}
											if(bViewTnlDB)
											{
%>
												<li><a href="javascript:reloadHeader('dashboardView.jsp?cntrlType=Tunnel')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></a>
												</li>
<%
											}
%>
											</ul>
										</li>
<%
									}

									if(bViewSingle)
									{
%>
										<li><a href="javascript:reloadHeader('singleRoomView.jsp')">
											<%= resourceBundle.getProperty("DataManager.DisplayText.Single_Room") %></a>
										</li>
<%
									}

									if(bViewMultiGrw || bViewMultiBnk || bViewMultiTnl)
									{
%>
										<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Multi_Room") %> &raquo;</a>
											<ul>
<%
											if(bViewMultiGrw)
											{
%>
												<li><a href="javascript:reloadHeader('multiRoomView.jsp?cntrlType=Grower')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></a>
												</li>
<%
											}
											if(bViewMultiBnk)
											{
%>
												<li><a href="javascript:reloadHeader('multiRoomView.jsp?cntrlType=Bunker')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></a>
												</li>
<%
											}
											if(bViewMultiTnl)
											{
%>
												<li><a href="javascript:reloadHeader('multiRoomView.jsp?cntrlType=Tunnel')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></a>
												</li>
<%
											}
%>
											</ul>
										</li>
<%
									}
%>
									</ul>
								</li>
<%
							}

							boolean bViewAttrGraph = u.hasViewAccess(RDMServicesConstants.VIEWS_GRAPH_ATTRDATA);
							boolean bViewAlarms = u.hasViewAccess(RDMServicesConstants.VIEWS_ALARMS);
							boolean bViewLogs = u.hasViewAccess(RDMServicesConstants.VIEWS_LOGS);
							boolean bViewComments = u.hasViewAccess(RDMServicesConstants.VIEWS_COMMENTS);
							boolean bViewReports = u.hasViewAccess(RDMServicesConstants.VIEWS_REPORTS);
							
							if(bViewAttrGraph || bViewAlarms || bViewLogs || bViewComments || bViewReports)
							{
%>
								<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Views") %> &raquo;</a>
									<ul>
<%
									if(bViewAttrGraph)
									{
%>
										<li><a href="javascript:reloadHeader('attrDataGraphView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Graph") %></a></li>
<%
									}
									if(bViewAlarms)
									{
%>
										<li><a href="javascript:reloadHeader('alarmView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Alarms") %></a></li>
<%
									}
									if(bViewLogs)
									{
%>
										<li><a href="javascript:reloadHeader('logView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Logs") %></a></li>
<%
									}
									if(bViewComments)
									{
%>
										<li><a href="javascript:reloadHeader('userCommentsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Comments") %></a></li>
<%
									}	
									if(bViewReports)
									{
%>
										<li><a href="javascript:reloadHeader('viewReportsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Reports") %></a></li>
<%
									}
%>
									</ul>
								</li>
<%
							}

							if(RDMServicesConstants.ROLE_ADMIN.equals(u.getRole()))
							{
%>
								<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Admin") %> &raquo;</a>
									<ul>
										<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Set_Views") %> &raquo;</a>
											<ul>
												<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Controllers") %> &raquo;</a>
													<ul>
														<li><a href="javascript:reloadHeader('adminView.jsp?cntrlType=Grower')">
															<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></a>
														</li>
														<li><a href="javascript:reloadHeader('adminView.jsp?cntrlType=Bunker')">
															<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></a>
														</li>
														<li><a href="javascript:reloadHeader('adminView.jsp?cntrlType=Tunnel')">
															<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></a>
														</li>
													</ul>
												</li>
												<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.General") %> &raquo;</a>
													<ul>
														<li><a href="javascript:reloadHeader('generalParamsAdminView.jsp?cntrlType=General.Grower')">
															<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></a>
														</li>
														<li><a href="javascript:reloadHeader('generalParamsAdminView.jsp?cntrlType=General.Bunker')">
															<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></a>
														</li>
														<li><a href="javascript:reloadHeader('generalParamsAdminView.jsp?cntrlType=General.Tunnel')">
															<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></a>
														</li>
													</ul>
												</li>
											</ul>
										</li>
										<li><a href="javascript:reloadHeader('manageHeaderView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Headers") %></a></li>
										<li><a href="javascript:reloadHeader('manageRoomsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Rooms") %></a></li>
										<li><a href="javascript:reloadHeader('manageGroupView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Groups") %></a></li>
										<li><a href="javascript:reloadHeader('manageStagesView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Phases") %></a></li>
										<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Rules") %> &raquo;</a>
											<ul>
												<li><a href="javascript:reloadHeader('manageRulesView.jsp?cntrlType=Grower')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></a>
												</li>
												<li><a href="javascript:reloadHeader('manageRulesView.jsp?cntrlType=Bunker')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></a>
												</li>
												<li><a href="javascript:reloadHeader('manageRulesView.jsp?cntrlType=Tunnel')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></a>
												</li>
											</ul>
										</li>
										<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Alarms") %> &raquo;</a>
											<ul>
												<li><a href="javascript:reloadHeader('manageNotificationGroupsView.jsp')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.NotificationGroups") %></a>
												</li>
												<li><a href="javascript:reloadHeader('manageNotifyAlarmsView.jsp?cntrlType=Grower')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %></a>
												</li>
												<li><a href="javascript:reloadHeader('manageNotifyAlarmsView.jsp?cntrlType=Bunker')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %></a>
												</li>
												<li><a href="javascript:reloadHeader('manageNotifyAlarmsView.jsp?cntrlType=Tunnel')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %></a>
												</li>
											</ul>
										</li>
										<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.User_Management") %> &raquo;</a>
											<ul>
												<li><a href="javascript:reloadHeader('manageUsersView.jsp')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Manage_Users") %>
												</a></li>
												<li><a href="javascript:reloadHeader('manageDepartmentsView.jsp')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Departments") %>
												</a></li>
												<li><a href="javascript:reloadHeader('manageUserViews.jsp')">
													<%= resourceBundle.getProperty("DataManager.DisplayText.Manage_User_Views") %>
												</a></li>
											</ul>
										</li>
										<li><a href="javascript:reloadHeader('manageAdminTasksView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.ManageTasks") %></a></li>
										<li><a href="javascript:reloadHeader('manageDefaultTypeView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Manage_Products") %></a></li>
										<li><a href="javascript:reloadHeader('manageReportsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Manage_Reports") %></a></li>
										<li><a href="javascript:reloadHeader('saveParametersView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.Save_Parameters") %></a></li>
										<li><a href="javascript:reloadHeader('accountSettings.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.AcctSettings") %></a></li>
										<li><a href="javascript:reloadHeader('userActivityLogsView.jsp')"><%= resourceBundle.getProperty("DataManager.DisplayText.User_Activity_Logs") %></a></li>
									</ul>
								</li>
<%
							}
							else if(u.manageAlarms() || u.manageUsers())
							{
%>
								<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Admin") %> &raquo;</a>
									<ul>
<%
								if(u.manageAlarms())
								{
%>
									<li><a href="#"><%= resourceBundle.getProperty("DataManager.DisplayText.Notify_Alarms") %> &raquo;</a>
										<ul>
											<li><a href="javascript:reloadHeader('manageNotificationGroupsView.jsp')">
												<%= resourceBundle.getProperty("DataManager.DisplayText.NotificationGroups") %>
											</a></li>
											<li><a href="javascript:reloadHeader('manageNotifyAlarmsView.jsp?cntrlType=Grower')">
												<%= resourceBundle.getProperty("DataManager.DisplayText.Grower") %>
											</a></li>
											<li><a href="javascript:reloadHeader('manageNotifyAlarmsView.jsp?cntrlType=Bunker')">
												<%= resourceBundle.getProperty("DataManager.DisplayText.Bunker") %>
											</a></li>
											<li><a href="javascript:reloadHeader('manageNotifyAlarmsView.jsp?cntrlType=Tunnel')">
												<%= resourceBundle.getProperty("DataManager.DisplayText.Tunnel") %>
											</a></li>
										</ul>
									</li>
<%
								}
								if(u.manageUsers())
								{
%>
									<li><a href="javascript:reloadHeader('manageUsersView.jsp')">
										<%= resourceBundle.getProperty("DataManager.DisplayText.Manage_Users") %>
									</a></li>
<%
								}
%>
									</ul>
								</li>
<%
							}
%>
							<li><a href="javascript:logout()" class="last"><%= resourceBundle.getProperty("DataManager.DisplayText.Logout") %></a></li>
						</ul>
					</nav>
				</div><!--end wrapper-->
			</td>
<%
			String sUserLoggedIn = (String)session.getAttribute("UserLoggedIn");
			if(sUserLoggedIn == null || "".equals(sUserLoggedIn))
			{
				java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd-MMM HH:mm");
				sUserLoggedIn = sdf.format(Calendar.getInstance().getTime());

				session.setAttribute("UserLoggedIn", sUserLoggedIn);
			}

			com.client.util.User contextUser = (com.client.util.User)session.getAttribute("contextUser");
			if(contextUser != null)
			{
%>
				<td align="right" class="label" width="25%">
					<%= u.getLastName() %>,&nbsp;<%= u.getFirstName() %><br>
					<a href="javascript:resetContext('<%= contextUser.getUser() %>');" class="label">(<%= contextUser.getLastName() %>,&nbsp;<%= contextUser.getFirstName() %>&nbsp;<img border="0" src="../images/SwitchUser.png" height="20">)</a>
				</td>
<%
			}
			else
			{
%>
				<td align="right" class="label" width="25%">
					<%= u.getLastName() %>,&nbsp;<%= u.getFirstName() %>&nbsp;
					<a href="javascript:popupContent('changePassword.jsp', '200', '320');" class="label">(<%= resourceBundle.getProperty("DataManager.DisplayText.Change_Password") %>)</a><br>
					<font size="2px"><%= resourceBundle.getProperty("DataManager.DisplayText.Logged_On") %>:&nbsp;<%= sUserLoggedIn %></font>
				</td>
<%
			}
%>
			<td align="right" class="label">
				<img src="../images/banner.jpg" height="43" width="100">
			</td>
		</tr>
	</table>
	<form name="frm" method="post" action="../LogoutServlet" target="_top">
		<input type="hidden" id="ip" name="ip" value="">
		<input type="hidden" id="hostname" name="hostname" value="">
		<input type="hidden" id="city" name="city" value="">
		<input type="hidden" id="region" name="region" value="">
		<input type="hidden" id="country" name="country" value="">
	</form>
	<iframe name="displaycontent" src="" width="100%" height="<%= winHeight * 0.9 %>px"/>
</body>
</html>
