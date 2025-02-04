<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="com.client.*" %>

<%@include file="commonUtils.jsp" %>

<html>
	<frameset rows="99%,1%" frameborder="0">
		<frameset cols="30%,30%,40%" frameborder="0">
			<frame name="select" src="attrDataGraphSelection.jsp" />
			<frame name="legend" src="graphLegend.jsp" />
			<frame name="custom" src="viewCustomGraph.jsp" />
		</frameset>
		<frame name="hidden" src="blank.jsp" />
	</frameset>
</html>