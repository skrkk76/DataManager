package com.client.export;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

import com.client.util.LabelResourceBundle;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;

public class ExportAttendance extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	
	private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy", Locale.ENGLISH);
	private static final SimpleDateFormat input = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.ENGLISH);
	private static final SimpleDateFormat output = new SimpleDateFormat("dd-MMM HH:mm", Locale.ENGLISH);

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		doPost(request, response);
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		FileInputStream fileInputStream = null;
		PrintWriter out = null;
		try
		{
			out = response.getWriter();
			
			File file = writeToExcel(request);
			fileInputStream = new FileInputStream(file);
			
			response.setHeader("Content-Type", "application/octet-stream");
			response.setHeader("Content-Disposition","attachment; filename=\"" + file.getName() + "\"");
			
			int i;
			while ((i = fileInputStream.read()) != -1)
			{
				out.write(i); 
			}
		}
		catch(Exception e)
		{
			e.printStackTrace(System.out);
		}
		finally
		{
			if(fileInputStream != null)
			{
				fileInputStream.close();
			}
			if(out != null)
			{
				out.close();
			}
		}
	}
	
	private File writeToExcel(HttpServletRequest request) throws Exception 
	{
		String filepath = RDMServicesUtils.getClassLoaderpath("../../export");		
		File file = File.createTempFile("ExportAttendanceData", ".xls", new File(filepath));
		file.setReadable(true, false);
		file.setWritable(true, false);
		file.setExecutable(true, false);
		file.deleteOnExit();

		String sUserId = request.getParameter("userId");
		String sFName = request.getParameter("FName");
		String sLName = request.getParameter("LName");
		
		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("Employee Attendance");
		
		addHeaders(sheet);
		addAttendance(sheet, sUserId, sFName, sLName);
		
	    FileOutputStream out = new FileOutputStream(file);
	    workbook.write(out);
	    out.close();
		     
		return file;
	}
	
	private void addHeaders(HSSFSheet sheet)
	{
		Row row = sheet.createRow(0);
		
		Cell cell = row.createCell(0);
		cell.setCellValue("User ID");
		
		cell = row.createCell(1);
		cell.setCellValue("User Name");
		
		cell = row.createCell(2);
		cell.setCellValue("Role");
		
		cell = row.createCell(3);
		cell.setCellValue("Department");

		cell = row.createCell(4);
		cell.setCellValue("In Time");
		
		cell = row.createCell(5);
		cell.setCellValue("Out Time");
		
		cell = row.createCell(6);
		cell.setCellValue("Shift");
	}
	
	private void addAttendance(HSSFSheet sheet, String sUserId, String sFName, String sLName) throws Exception
	{
		int rownum = 1;
		Row row = null;
		Cell cell = null;
		
		LabelResourceBundle resourceBundle = new LabelResourceBundle();
		
		MapList mlUsers = RDMServicesUtils.getUsers(sUserId, sFName, sLName, "", false);
		int iSz = mlUsers.size();
		if(iSz ==0)
		{
			return;
		}

		Map<String, String> mInfo = null;
		Map<String, Map<String, String>> mUsers = new HashMap<String, Map<String, String>>();
		for(int i=0; i<iSz; i++)
		{
			mInfo = mlUsers.get(i);
			sUserId = mInfo.get(RDMServicesConstants.USER_ID);
			mUsers.put(sUserId, mInfo);
		}
		
		boolean fg = false;
		boolean bLog = false;
		int diff = 0;
		Calendar logCal = Calendar.getInstance();
		Date sDate = null;
		String role = null;
		String dept = null;
		String sInTime = null;
		String sOutTime = null;
		String shiftCode = null;
		String[] saLogs = null;
		List<String> lUsers = null;
		Map<String, String[]> mLog = null;

		String sCurrDate = sdf.format(new java.util.Date());
		Calendar currCal = Calendar.getInstance();
		currCal.setTime(new java.util.Date());
		currCal.add(Calendar.DAY_OF_YEAR, -1);
		int currDay = currCal.get(Calendar.DAY_OF_YEAR);

		Map<Date, Map<String, String[]>> mUserLog = RDMServicesUtils.getUserLogs();
		Iterator<Date> itr = mUserLog.keySet().iterator();
		while(itr.hasNext())
		{
			sDate = itr.next();
			if(sCurrDate.equals(sdf.format(sDate)))
			{
				fg = true;
			}
		}
		
		if(!fg)
		{
			mUserLog.put(new java.util.Date(), new HashMap<String, String[]>());
		}
		
		List<Date> lDates = new ArrayList<Date>(mUserLog.keySet());
		Collections.sort(lDates);
		for(int i=0; i<lDates.size(); i++)
		{
			sDate = lDates.get(i);
			mLog = mUserLog.get(sDate);
			
			fg = true;
			bLog = true;
			if(sCurrDate.equals(sdf.format(sDate)))
			{
				lUsers = new ArrayList<String>(mUsers.keySet());
			}
			else
			{
				logCal.setTime(sDate);
				diff = currDay - logCal.get(Calendar.DAY_OF_YEAR);
				if(diff != 0)
				{
					bLog = false;
				}
				lUsers = new ArrayList<String>(mLog.keySet());
			}
			
			Collections.sort(lUsers, String.CASE_INSENSITIVE_ORDER);
			for(int j=0; j<lUsers.size(); j++)
			{
				sUserId = lUsers.get(j);
				if(!mUsers.containsKey(sUserId))
				{
					continue;
				}
				
				mInfo = mUsers.get(sUserId);
				role = mInfo.get(RDMServicesConstants.ROLE_NAME);
				dept = mInfo.get(RDMServicesConstants.DEPARTMENT_NAME);
				dept = (dept == null ? "" : dept);
			
				saLogs = mLog.get(sUserId);
				sInTime = ""; sOutTime = ""; shiftCode = "";
				if(saLogs != null)
				{
					sInTime = (!"".equals(saLogs[1]) ? output.format(input.parse(saLogs[1])) : "");
					sOutTime = (!"".equals(saLogs[2]) ? output.format(input.parse(saLogs[2])) : "");
					shiftCode = saLogs[3];

					if(bLog && !"".equals(sInTime) && !"".equals(sOutTime))
					{
						sInTime = "";
						sOutTime = "";
						shiftCode = "";
					}
				}
				
				if(fg)
				{
					row = sheet.createRow(rownum);
					
					cell = row.createCell(0);
					cell.setCellValue("");
					
					cell = row.createCell(1);
					cell.setCellValue("");
					
					cell = row.createCell(2);
					cell.setCellValue("");
					
					cell = row.createCell(3);
					cell.setCellValue(sdf.format(sDate));
					
					cell = row.createCell(4);
					cell.setCellValue("");
					
					cell = row.createCell(5);
					cell.setCellValue("");
					
					cell = row.createCell(6);
					cell.setCellValue("");
					
					rownum++;
				}

				row = sheet.createRow(rownum);
				
				cell = row.createCell(0);
				cell.setCellValue(sUserId);
				
				cell = row.createCell(1);
				cell.setCellValue(mInfo.get(RDMServicesConstants.LAST_NAME)+", "+mInfo.get(RDMServicesConstants.FIRST_NAME));
				
				cell = row.createCell(2);
				cell.setCellValue(role);
				
				cell = row.createCell(3);
				cell.setCellValue(dept);
				
				cell = row.createCell(4);
				cell.setCellValue(sInTime);
				
				cell = row.createCell(5);
				cell.setCellValue(sOutTime);
				
				cell = row.createCell(6);
				if("".equals(shiftCode.trim()))
				{
					cell.setCellValue("");
				}
				else
				{
					cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText."+shiftCode+"_Shift"));
				}
				
				rownum++;
				fg = false;
			}
		}
	}
} 
