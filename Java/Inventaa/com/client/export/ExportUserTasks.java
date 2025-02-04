package com.client.export;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;

import com.client.db.DataQuery;
import com.client.util.LabelResourceBundle;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;
import com.client.views.UserTasks;

public class ExportUserTasks extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	
	private int rownum;
	private static LabelResourceBundle resourceBundle = null;
	private String[] saTaskAttrs = null;
	private static Map<String, String> mUsers = null;
	private static Map<String, String> mTasks = null;
	private static Map<String, String> mActualTW = null;
	private static final SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm");
	
	private UserTasks userTasks = null;
	
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
			
			Locale locale = request.getLocale();
			resourceBundle = new LabelResourceBundle(locale);
			mUsers = RDMServicesUtils.getUserNames(true);
			saTaskAttrs = getTaskAttrbutes(request);
			mTasks = RDMServicesUtils.listAdminTasks();
			userTasks = new UserTasks();
			
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
	
	private MapList getUserTasks(HttpServletRequest request) throws Exception
	{
		String sTaskName = request.getParameter("taskName");
		String sTaskId = request.getParameter("taskId");
		String sRoom = request.getParameter("room");
		String sOwner = request.getParameter("owner");
		String sAssignee = request.getParameter("assignee");
		String sFromDate = request.getParameter("start_date");
		String sToDate = request.getParameter("end_date");
		String sStatus = request.getParameter("status");
		String sBatch = request.getParameter("batch");
		String sStage = request.getParameter("stage");
		String sDept = request.getParameter("dept");
		String sSearchType = request.getParameter("searchType");
		boolean childTasks = "true".equals(request.getParameter("childTasks"));
		boolean parentTasks = "true".equals(request.getParameter("parentTasks"));
		boolean coOwners = "true".equals(request.getParameter("coOwners"));
		String sLimit = request.getParameter("limit");
		int limit = 0;
		if(sLimit != null && !"".equals(sLimit))
		{
			try
			{
				limit = Integer.parseInt(sLimit);
			}
			catch(NumberFormatException e)
			{
				limit = 0;
			}
		}
		
		boolean bDeliverables = (sTaskId == null || "".equals(sTaskId));
		
		DataQuery query = new DataQuery();
    	MapList mlTasks = query.searchUserTasks(sRoom, sTaskName, sTaskId, sDept, sOwner, sAssignee, 
    			sFromDate, sToDate, sStatus, sBatch, sStage, childTasks, parentTasks, coOwners, bDeliverables, bDeliverables, limit, sSearchType);
    	
    	if(sTaskName != null && !"".equals(sTaskName))
    	{
    		mlTasks.addAll(query.getChildTasks(sTaskName, true));
    	}
		
		return mlTasks;
	}
	
	private String[] getTaskAttrbutes(HttpServletRequest request) throws Exception
	{
		String sTaskId = request.getParameter("taskId");
		if(sTaskId != null && !"".equals(sTaskId))
		{
			Map<String, String> mTaskAttrs = RDMServicesUtils.getAdminTask(sTaskId);
			if(mTaskAttrs != null)
			{
				String sAttributes = mTaskAttrs.get(RDMServicesConstants.TASK_ATTRIBUTES);
				return sAttributes.split("\\|");
			}
		}
		return new String[]{};
	}
	
	private File writeToExcel(HttpServletRequest request) throws Exception 
	{
		String filepath = RDMServicesUtils.getClassLoaderpath("../../export");		
		File file = File.createTempFile("ExportUserTasksData", ".xls", new File(filepath));
		file.setReadable(true, false);
		file.setWritable(true, false);
		file.setExecutable(true, false);
		file.deleteOnExit();
		
		String sTaskId = request.getParameter("taskId");
		boolean bShowDeliverables = (sTaskId != null && !"".equals(sTaskId));

		HSSFWorkbook workbook = new HSSFWorkbook();
		HSSFSheet sheet = workbook.createSheet("Task Details");
		
		if(bShowDeliverables)
		{
			addFirstRowHeader(workbook, sheet, saTaskAttrs);
		}
		addHeaders(sheet, saTaskAttrs, bShowDeliverables);

		String sTaskName = null;
		Map<String, String> mTask = null;
		MapList mlTasks = getUserTasks(request);
		for(int i=0, iSz=mlTasks.size(); i<iSz; i++)
		{
			mTask = mlTasks.get(i);
			sTaskName = mTask.get(RDMServicesConstants.TASK_AUTONAME);

			addTaskDeliverables(sheet, sTaskName, mTask, bShowDeliverables);
		}
		
	    FileOutputStream out = new FileOutputStream(file);
	    workbook.write(out);
	    out.close();
		     
		return file;
	}
	
	private void addFirstRowHeader(HSSFWorkbook workbook, HSSFSheet sheet, String[] saTaskAttrs) throws Exception
	{
		Map<String, String> mAdminAttrs = new HashMap<String, String>();
		MapList mlAdminAttrs = RDMServicesUtils.getAdminAttributes();
		
		String sAttrName = null;
		String sAttrUnit = null;
		String sActualTW = null;
		Map<String, String> mInfo = null;
		mActualTW = new HashMap<String, String>();
		for(int i=0; i<mlAdminAttrs.size(); i++)
		{
			mInfo = mlAdminAttrs.get(i);
			sAttrName = mInfo.get(RDMServicesConstants.ATTRIBUTE_NAME);
			sAttrUnit = mInfo.get(RDMServicesConstants.ATTRIBUTE_UNIT);
			sActualTW = mInfo.get(RDMServicesConstants.TARE_WEIGHT);
			
			if(sAttrName != null && !"".equals(sAttrName))
			{
				mAdminAttrs.put(sAttrName, sAttrUnit);
				mActualTW.put(sAttrName, sActualTW);
			}
		}
		
		rownum = 0;
		Cell cell = null;
		Row row = sheet.createRow(rownum);
		
		CellStyle cellStyle = workbook.createCellStyle();
		cellStyle.setAlignment(CellStyle.ALIGN_CENTER);

		for (int i = 0; i < 21; i++)
		{
			cell = row.createCell(i);
			cell.setCellValue("");
		}

		int idx = 21;
		for (int i = 0; i < saTaskAttrs.length; i++)
		{
			sAttrName = saTaskAttrs[i];
			sAttrUnit = mAdminAttrs.get(sAttrName);

			sheet.addMergedRegion(new CellRangeAddress(0, 0, idx, (idx + 2)));

			cell = row.createCell(idx);
			cell.setCellValue(sAttrName + ("".equals(sAttrUnit) ? "" : " ("+sAttrUnit+")"));
			cell.setCellStyle(cellStyle);

			idx = idx + 3;
		}
		
		cell = row.createCell(idx);
		cell.setCellValue("");
	}
	
	private void addHeaders(HSSFSheet sheet, String[] saTaskAttrs, boolean bShowDeliverables) throws Exception
	{
		rownum = 1;
		Row row = sheet.createRow(rownum);

		Cell cell = row.createCell(0);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Task_Name"));
		
		cell = row.createCell(1);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Task_Id"));
		
		cell = row.createCell(2);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Status"));
		
		cell = row.createCell(3);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Notes"));
		
		cell = row.createCell(4);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Room_No"));
		
		cell = row.createCell(5);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Batch_No"));
		
		cell = row.createCell(6);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Stage"));
		
		cell = row.createCell(7);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Owner"));
		
		cell = row.createCell(8);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Assignee"));
		
		cell = row.createCell(9);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Parent_Task"));
		
		cell = row.createCell(10);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Estimated_Start"));
		
		cell = row.createCell(11);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Estimated_End"));
		
		cell = row.createCell(12);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Estimated_Duration"));
		
		cell = row.createCell(13);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Actual_Start"));
		
		cell = row.createCell(14);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Actual_End"));
		
		cell = row.createCell(15);
		cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Actual_Duration"));
		
		if(bShowDeliverables)
		{
			cell = row.createCell(16);
			cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Deliverable_Id"));
			
			cell = row.createCell(17);
			cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Created_On"));
			
			cell = row.createCell(18);
			cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Download"));
			
			cell = row.createCell(19);
			cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Download_By"));
			
			cell = row.createCell(20);
			cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Download_On"));
			
			int idx = 21;
			for(int i=0; i<saTaskAttrs.length; i++)
			{
				cell = row.createCell(idx);
				cell.setCellValue("Calculated Wt");
				idx++;
				
				cell = row.createCell(idx);
				cell.setCellValue("Actual TW");
				idx++;
				
				cell = row.createCell(idx);
				cell.setCellValue("Modified TW");
				idx++;
			}
			
			cell = row.createCell(idx);
			cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Overage"));
		}
		else
		{
			cell = row.createCell(16);
			cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.Total_Deliverables"));
			
			cell = row.createCell(17);
			cell.setCellValue(resourceBundle.getProperty("DataManager.DisplayText.WBS"));
		}
	}
	
	private void addTaskInfo(Row row, Map<String, String> mTask, boolean bShowDeliverables)
	{
		Cell cell = row.createCell(0);
		cell.setCellValue(mTask.get(RDMServicesConstants.TASK_AUTONAME));

		String sTaskId = mTask.get(RDMServicesConstants.TASK_ID);
		String sTaskAdmName = mTasks.get(sTaskId);
		cell = row.createCell(1);
		cell.setCellValue(sTaskId + (sTaskAdmName == null ? "" : " ("+sTaskAdmName+ ")"));
		
		cell = row.createCell(2);
		cell.setCellValue(mTask.get(RDMServicesConstants.STATUS));
		
		String sNotes = mTask.get(RDMServicesConstants.NOTES);
		sNotes = (sNotes != null ? sNotes.replace("\"", "").replace("'", "") : "");
		cell = row.createCell(3);
		cell.setCellValue(sNotes);

		cell = row.createCell(4);
		cell.setCellValue(mTask.get(RDMServicesConstants.ROOM_ID));
		
		cell = row.createCell(5);
		cell.setCellValue(mTask.get(RDMServicesConstants.BATCH_NO));		

		cell = row.createCell(6);
		cell.setCellValue(mTask.get(RDMServicesConstants.STAGE_NUMBER));
		
		String sOwner = mTask.get(RDMServicesConstants.OWNER);
		cell = row.createCell(7);
		cell.setCellValue(mUsers.get(sOwner) + " ("+sOwner+")");

		String sAssignee = mTask.get(RDMServicesConstants.ASSIGNEE);
		cell = row.createCell(8);
		cell.setCellValue(mUsers.get(sAssignee) + " ("+sAssignee+")");

		cell = row.createCell(9);
		cell.setCellValue(mTask.get(RDMServicesConstants.PARENT_TASK));

		String estStart = mTask.get(RDMServicesConstants.ESTIMATED_START);
		cell = row.createCell(10);
		cell.setCellValue(estStart);

		String estEnd = mTask.get(RDMServicesConstants.ESTIMATED_END);
		cell = row.createCell(11);
		cell.setCellValue(estEnd);
		
		cell = row.createCell(12);
		cell.setCellValue(calculateDuration(estStart, estEnd));

		String actStart = mTask.get(RDMServicesConstants.ACTUAL_START);
		cell = row.createCell(13);
		cell.setCellValue(actStart);

		String actEnd = mTask.get(RDMServicesConstants.ACTUAL_END);
		cell = row.createCell(14);
		cell.setCellValue(actEnd);
		
		cell = row.createCell(15);
		cell.setCellValue(calculateDuration(actStart, actEnd));
		
		if(!bShowDeliverables)
		{
			String sDelCnt = mTask.get(RDMServicesConstants.NOT_DOWNLOADED) + "(" + mTask.get(RDMServicesConstants.DELIVERABLE_CNT) + ")";
			cell = row.createCell(16);
			cell.setCellValue(sDelCnt);
			
			String sChildTaskCnt = mTask.get(RDMServicesConstants.NO_CHILD_TASKS) + "(" + mTask.get(RDMServicesConstants.NO_CHILD_TASKS_CLOSED) + ")";
			cell = row.createCell(17);
			cell.setCellValue(sChildTaskCnt);
		}
	}
	
	private void addTaskDeliverables(HSSFSheet sheet, String sTaskName, Map<String, String> mTask, boolean bShowDeliverables) throws Exception
	{		
		Cell cell = null;
		Row row = null;
		
		int iSz = 0;
		int cellnum = 0;
		double dOverage;
		String sAttrName = null;
		String sAttrValue = null;
		String sDownloadBy = null;
		String sActualTW = null;
		String sModifiedTW = null;
		String sOverage = null;
		String sfxModifiedTW = "_" + RDMServicesConstants.MODIFIED_TW;
		String sfxOverage = "_" + RDMServicesConstants.OVERAGE;
		String EMPTY = "";
		Map<String, String> mDeliverable = null;
		MapList mlDeliverables = null;
		
		if(bShowDeliverables)
		{
			mlDeliverables = userTasks.getTaskDeliverables(sTaskName);
			iSz = mlDeliverables.size();
		}
		
		if(iSz > 0)
		{
			for(int i=0; i<iSz; i++)
			{
				mDeliverable = mlDeliverables.get(i);
	
				rownum = rownum + 1;
				row = sheet.createRow(rownum);
				
				addTaskInfo(row, mTask, bShowDeliverables);
	
				cell = row.createCell(16);
				cell.setCellValue(mDeliverable.get(RDMServicesConstants.DELIVERABLE_ID));
				
				cell = row.createCell(17);
				cell.setCellValue(mDeliverable.get(RDMServicesConstants.CREATED_ON));
				
				cell = row.createCell(18);
				cell.setCellValue(mDeliverable.get(RDMServicesConstants.DOWNLOAD_FLAG));
				
				cell = row.createCell(19);
				sDownloadBy = mDeliverable.get(RDMServicesConstants.DOWNLOAD_BY);
				cell.setCellValue((sDownloadBy == null || EMPTY.equals(sDownloadBy)) ? EMPTY : (mUsers.get(sDownloadBy) + " ("+sDownloadBy+")"));
				
				cell = row.createCell(20);
				cell.setCellValue(mDeliverable.get(RDMServicesConstants.DOWNLOAD_ON));
		
				cellnum = 21;
				dOverage = 0;
				for(int j=0; j<saTaskAttrs.length; j++)
				{
					sAttrName = saTaskAttrs[j];
					sAttrValue = mDeliverable.get(sAttrName);
					
					if(sAttrValue == null || EMPTY.equals(sAttrValue))
					{
						cell = row.createCell(cellnum);
						cell.setCellType(Cell.CELL_TYPE_NUMERIC);
						cell.setCellValue(0);
						cellnum++;
						
						cell = row.createCell(cellnum);
						cell.setCellValue(EMPTY);
						cellnum++;
						
						cell = row.createCell(cellnum);
						cell.setCellValue(EMPTY);
						cellnum++;
					}
					else
					{
						cell = row.createCell(cellnum);
						cell.setCellType(Cell.CELL_TYPE_NUMERIC);
						cell.setCellValue(Double.parseDouble(sAttrValue));
						cellnum++;
						
						cell = row.createCell(cellnum);
						sActualTW = mActualTW.get(sAttrName);
						if(sActualTW == null || EMPTY.equals(sActualTW))
						{
							cell.setCellValue(EMPTY);
						}
						else
						{
							cell.setCellType(Cell.CELL_TYPE_NUMERIC);
							cell.setCellValue(Double.parseDouble(sActualTW));
						}
						cellnum++;
						
						cell = row.createCell(cellnum);
						sModifiedTW = mDeliverable.get(sAttrName + sfxModifiedTW);
						if(sModifiedTW == null || EMPTY.equals(sModifiedTW))
						{
							cell.setCellValue(EMPTY);
						}
						else
						{
							cell.setCellType(Cell.CELL_TYPE_NUMERIC);
							cell.setCellValue(Double.parseDouble(sModifiedTW));
						}
						cellnum++;
						
						sOverage = mDeliverable.get(sAttrName + sfxOverage);
						if(sOverage != null && !EMPTY.equals(sOverage))
						{
							dOverage = Double.parseDouble(sOverage);
						}
					}
				}
				
				if(saTaskAttrs.length > 0)
				{
					cell = row.createCell(cellnum);
					cell.setCellType(Cell.CELL_TYPE_NUMERIC);
					cell.setCellValue(dOverage);
				}
			}
		}
		else
		{
			rownum = rownum + 1;
			row = sheet.createRow(rownum);

			addTaskInfo(row, mTask, bShowDeliverables);
		}
	}
	
	private String calculateDuration(String sStartTime, String sEndTime)
	{
		try
		{
			if(sStartTime.isEmpty() || sEndTime.isEmpty())
			{
				return "";
			}
			
			Date dtStart = format.parse(sStartTime);
			Date dtEnd = format.parse(sEndTime);
	 
			long diff = dtEnd.getTime() - dtStart.getTime();
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
	
			return (diffHours + "h:" + diffMinutes + "m");
		}
		catch(Exception e)
		{
			return "";
		}
	}
} 
