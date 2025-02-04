<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.util.*" %>
<%@page import="java.sql.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.db.*" %>
<%@page import="com.client.util.*" %>

<%@include file="commonUtils.jsp" %>

<%
DBConnectionPool connectionPool = null;
Connection conn = null;
Statement stmt = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try
{
	DecimalFormat df = new DecimalFormat("#.##");

	connectionPool = new DBConnectionPool();
	conn = connectionPool.getConnection();
	stmt = conn.createStatement();

	String sUpdate = "UPDATE rdm_admin.employee_in_out SET productive_hrs = ? WHERE user_id = ? and log_date = ?";
	pstmt = conn.prepareStatement(sUpdate);	
	
	String sSelect = "select assignee, Date(actual_start) as LogDate, (sum(DATE_PART('day', actual_end - actual_start) * 24 + DATE_PART('hour', actual_end - actual_start) * 60 + DATE_PART('minute', actual_end - actual_start)) / 60) as DURATION from rdm_admin.wbs_task_info where task_id = '301' or task_id = '302' group by assignee, Date(actual_start)";
	rs = stmt.executeQuery(sSelect);
	
	while (rs.next())
	{
		String assignee = rs.getString("assignee");
		String logDate = rs.getString("LogDate");
		String duration = df.format(rs.getDouble("DURATION"));			
		out.println(assignee+"  --  "+logDate+"  --  "+duration+"<br>");
		
		if(assignee != null && logDate != null && duration != null)
		{
			pstmt.setDouble(1, Double.valueOf(duration));
			pstmt.setString(2, assignee);
			pstmt.setDate(3, java.sql.Date.valueOf(logDate));
			pstmt.executeUpdate();
			pstmt.clearParameters();
		}
	}

	String sUpdate = "UPDATE rdm_admin.employee_in_out SET t_del_qty = ? WHERE user_id = ? and log_date = ?";
	pstmt = conn.prepareStatement(sUpdate);
	
	String sSelect = "SELECT a.task_id, sum(cast(a.ATTRIBUTE_VALUE as real)) as CNT, DATE(a.created_on) as CreatedOn, b.assignee FROM rdm_admin.TASK_DELIVERABLE_INFO a, rdm_admin.WBS_TASK_INFO b where (a.created_on >= '2010/10/01 01:00:00') and a.task_id = b.task_autoname group by a.task_id, a.created_on, b.assignee order by b.assignee, a.created_on";  
	rs = stmt.executeQuery(sSelect);
	
	boolean flag = true;
	double dCnt = 0.0;
	String sPrevAssignee = null;
	String sPrevCreatedOn = null;
	while (rs.next())
	{
		String assignee = rs.getString("assignee");
		String cnt = df.format(rs.getDouble("CNT"));
		String createdOn = rs.getString("CreatedOn");
		if(assignee != null && cnt != null && createdOn != null)
		{
			if(flag)
			{
				flag = false;
				dCnt = 0.0;
				sPrevAssignee = assignee;
				sPrevCreatedOn = createdOn;
			}
			
			if(!assignee.equals(sPrevAssignee) || !createdOn.equals(sPrevCreatedOn))
			{
				out.println(assignee+"  --  "+createdOn+"  --  "+dCnt+"<br>");
		
				pstmt.setDouble(1, Double.valueOf(dCnt));
				pstmt.setString(2, sPrevAssignee);
				pstmt.setDate(3, java.sql.Date.valueOf(sPrevCreatedOn));
				pstmt.executeUpdate();
				pstmt.clearParameters();
				
				dCnt = Double.parseDouble(cnt);
				sPrevAssignee = assignee;
				sPrevCreatedOn = createdOn;
			}
			else
			{
				dCnt = dCnt + Double.parseDouble(cnt);
			}
		}
	}
} 
catch(Exception e)
{
	out.println(e);
}
finally
{
	if(rs != null)
	{
		if(!rs.isClosed())
		{
			rs.close();
		}
	}
	
	if(stmt != null)
	{
		if(!stmt.isClosed())
		{
			stmt.close();
		}
	}
	
	if(pstmt != null)
	{
		if(!pstmt.isClosed())
		{
			pstmt.close();
		}
	}			
	
	if(connectionPool != null)
	{
		connectionPool.free(conn);
	}
}
%>