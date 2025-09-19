<%@page contentType="text/html;charset=UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.reports.*" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>

<%@include file="commonUtils.jsp" %>

<html>
<%
	boolean bErr = false;
	boolean bAllowUpdates = false;
	int iHeader = 0;
	int iFormula = 0;
	int iRanges = 0;
	int iReadOnlyCols = 0;
	String sReport = "";
	String sDesc = "";
	String sAction = "";
	String sTemplate = "";
	String sKeyColumn = "";
	StringList slReadAccess = new StringList();
	StringList slWriteAccess = new StringList();
	StringList slModifyAccess = new StringList();
	StringList slReadDept = new StringList();
	StringList slWriteDept = new StringList();
	StringList slModifyDept = new StringList();
	String sErr = "";

	try
	{
		FileItem item = null;
		String sField = "";
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		if (isMultipart)
		{
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
		
			List<FileItem> fields = upload.parseRequest(request);
			Iterator<FileItem> itr = fields.iterator();
			while (itr.hasNext()) 
			{
				item = (FileItem) itr.next();
				if (item.isFormField())
				{
					sField = item.getFieldName();

					if("report".equals(sField))
					{
						sReport = item.getString();
					}
					else if("desc".equals(sField))
					{
						sDesc = item.getString();
					}
					else if("mode".equals(sField))
					{
						sAction = item.getString();
					}
					else if("keyColumn".equals(sField))
					{
						sKeyColumn = item.getString();
					}
					else if("headerRow".equals(sField))
					{
						iHeader = Integer.parseInt(item.getString());
					}
					else if("formulaRow".equals(sField))
					{
						if(!"".equals(item.getString()))
						{
							iFormula = Integer.parseInt(item.getString());
						}
					}
					else if("rangesRow".equals(sField))
					{
						if(!"".equals(item.getString()))
						{
							iRanges = Integer.parseInt(item.getString());
						}
					}
					else if("readOnlyRow".equals(sField))
					{
						if(!"".equals(item.getString()))
						{
							iReadOnlyCols = Integer.parseInt(item.getString());
						}
					}
					else if("addDept".equals(sField))
					{
						slWriteDept.add(item.getString());
					}
					else if("modifyDept".equals(sField))
					{
						slModifyDept.add(item.getString());
					}
					else if("downloadDept".equals(sField))
					{
						slReadDept.add(item.getString());
					}
					else if("addRecd".equals(sField))
					{
						slWriteAccess.add(item.getString());
					}
					else if("updateRecd".equals(sField))
					{
						slModifyAccess.add(item.getString());
					}
					else if("downloadRecd".equals(sField))
					{
						slReadAccess.add(item.getString());
					}
					else if("allowUpdates".equals(sField))
					{
						bAllowUpdates = "Yes".equals(item.getString());
					}
				}
				else
				{
					sTemplate = item.getName();
					if(sTemplate != null && !"".equals(sTemplate))
					{
						File reportsDir = new File(getServletContext().getRealPath("/reports/templates")); 
						File reportTemlate = new File(reportsDir, sTemplate); 
						if(reportTemlate.exists())
						{
							reportTemlate.delete();
						}
						reportTemlate.createNewFile();
						item.write(reportTemlate);
					}
				}
			}
		}
		else
		{
			sAction = request.getParameter("mode");
			sReport = request.getParameter("report");
		}

		ReportDAO reportDAO = new ReportDAO();
		if("add".equals(sAction))
		{
			reportDAO.addReport(sReport, sTemplate, sDesc, sKeyColumn, iHeader, iFormula, iRanges, iReadOnlyCols, 
				slReadAccess, slReadDept, slWriteAccess, slWriteDept, slModifyAccess, slModifyDept, bAllowUpdates);
		}
		else if("edit".equals(sAction))
		{
			reportDAO.updateReport(sReport, sTemplate, sDesc, sKeyColumn, iHeader, iFormula, iRanges, iReadOnlyCols, 
				slReadAccess, slReadDept, slWriteAccess, slWriteDept, slModifyAccess, slModifyDept, bAllowUpdates);
		}
		else if("delete".equals(sAction))
		{
			reportDAO.deleteReport(sReport);
		}
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
		else if(mode == "add" || mode == "edit")
		{	
			top.opener.document.location.href = top.opener.document.location.href;
			window.close();
		}
		else if(mode == "delete")
		{				
			parent.frames['content'].document.location.href = parent.frames['content'].document.location.href;
		}
		
	</script>
</html>