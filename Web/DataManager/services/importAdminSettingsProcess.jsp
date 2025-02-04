<%@page import="java.io.*" %>
<%@page import="java.util.*" %>
<%@page import="com.client.*" %>
<%@page import="com.client.util.*" %>
<%@page import="java.nio.file.*" %>
<%@page import="java.nio.file.attribute.*" %>
<%@page import="org.apache.commons.fileupload.FileItem" %>
<%@page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>

<%@include file="commonUtils.jsp" %>

<%
try
{
	String sCntrlType = "";
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
			if (fileItem.isFormField()) 
			{
				sCntrlType = fileItem.getString();
			} 
			else
			{
				String sFileName = fileItem.getName(); 
				if(sFileName != null && !"".equals(sFileName))
				{
					File inputFile = new File(getServletContext().getRealPath("/export"), sFileName);
					inputFile.createNewFile();
					fileItem.write(inputFile);
					sFilePath = inputFile.getAbsolutePath();

					Path path = Paths.get(sFilePath);
					Set<PosixFilePermission> perms = Files.readAttributes(path, PosixFileAttributes.class).permissions();
					perms.add(PosixFilePermission.OWNER_WRITE);
					perms.add(PosixFilePermission.OWNER_READ);
					perms.add(PosixFilePermission.OWNER_EXECUTE);
					perms.add(PosixFilePermission.GROUP_WRITE);
					perms.add(PosixFilePermission.GROUP_READ);
					perms.add(PosixFilePermission.GROUP_EXECUTE);
					perms.add(PosixFilePermission.OTHERS_WRITE);
					perms.add(PosixFilePermission.OTHERS_READ);
					perms.add(PosixFilePermission.OTHERS_EXECUTE);
					Files.setPosixFilePermissions(path, perms);
				}
			}
		}
		
		if(sFilePath == null || "".equals(sFilePath))
		{
			throw new Exception("Please select a file");
		}
		RDMServicesUtils.importAdminSettingsFromCSV(sCntrlType, sFilePath);
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