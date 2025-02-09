<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="com.client.imports.*" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>

<%@include file="commonUtils.jsp" %>

<%
try
{
    String sFilePath = "";
    FileItem fileItem = null;

	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	if (isMultipart)
	{
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
	
		List<FileItem> fields = upload.parseRequest(request);
		Iterator<FileItem> itr = fields.iterator();
		while (itr.hasNext()) 
		{
			fileItem = itr.next();
			String sFileName = fileItem.getName(); 
			if(sFileName != null && !"".equals(sFileName))
			{
				File inputFile = new File(getServletContext().getRealPath("/export"), sFileName);
				inputFile.createNewFile();
				fileItem.write(inputFile);
				
				sFilePath = inputFile.getAbsolutePath();
			}
		}
		
		if(sFilePath == null || "".equals(sFilePath))
		{
			throw new Exception("Please select a file");
		}
		ImportUsers importUsers = new ImportUsers();
		importUsers.importUsers(sFilePath);
	}
%>
	<script language="javascript">
		top.opener.parent.location.href = top.opener.parent.location.href;
		top.window.close();
	</script>
<%
}
catch(Exception e)
{
	e.printStackTrace(System.out);
%>
	<script language="javascript">
		alert("Error : <%= e.getMessage().replaceAll("\r", " ").replaceAll("\n", " ").replaceAll("\"", "'") %>");
		history.back(-1);
	</script>
<%
}
%>