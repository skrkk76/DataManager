package com.client.export;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

import com.client.db.DataQuery;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;

public class ExportUsers extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	doPost(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	FileInputStream fileInputStream = null;
	PrintWriter out = null;
	try {
	    out = response.getWriter();

	    File file = writeToExcel(request);
	    fileInputStream = new FileInputStream(file);

	    response.setHeader("Content-Type", "application/octet-stream");
	    response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

	    int i;
	    while ((i = fileInputStream.read()) != -1) {
		out.write(i);
	    }
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	} finally {
	    if (fileInputStream != null) {
		fileInputStream.close();
	    }
	    if (out != null) {
		out.close();
	    }
	}
    }

    private File writeToExcel(HttpServletRequest request) throws Exception {
	String filepath = RDMServicesUtils.getClassLoaderpath("../../export");
	File file = File.createTempFile("ExportUserData", ".xls", new File(filepath));
	file.setReadable(true, false);
	file.setWritable(true, false);
	file.setExecutable(true, false);
	file.deleteOnExit();

	DataQuery query = new DataQuery();
	MapList mlUsers = query.getUserList();

	HSSFWorkbook workbook = new HSSFWorkbook();
	HSSFSheet sheet = workbook.createSheet("Users");

	HSSFDataFormat dataFormat = workbook.createDataFormat();

	HSSFCellStyle dateStyle = workbook.createCellStyle();
	dateStyle.setDataFormat(dataFormat.getFormat("dd-MM-yyyy"));

	HSSFCellStyle textStyle = workbook.createCellStyle();
	textStyle.setDataFormat(dataFormat.getFormat("@"));

	addHeaders(sheet);
	addUsers(sheet, mlUsers, dateStyle, textStyle);

	FileOutputStream out = new FileOutputStream(file);
	workbook.write(out);
	out.close();

	return file;
    }

    private void addHeaders(HSSFSheet sheet) {
	Row row = sheet.createRow(0);

	Cell cell = row.createCell(0);
	cell.setCellValue("User Id");

	cell = row.createCell(1);
	cell.setCellValue("First Name");

	cell = row.createCell(2);
	cell.setCellValue("Last Name");

	cell = row.createCell(3);
	cell.setCellValue("Gender");

	cell = row.createCell(4);
	cell.setCellValue("Date of Birth");

	cell = row.createCell(5);
	cell.setCellValue("Date of Join");

	cell = row.createCell(6);
	cell.setCellValue("Designation");

	cell = row.createCell(7);
	cell.setCellValue("User Role");

	cell = row.createCell(8);
	cell.setCellValue("Department");

	cell = row.createCell(9);
	cell.setCellValue("Group");

	cell = row.createCell(10);
	cell.setCellValue("Address");

	cell = row.createCell(11);
	cell.setCellValue("Phone Number");

	cell = row.createCell(12);
	cell.setCellValue("Email");

	cell = row.createCell(13);
	cell.setCellValue("Qualification");

	cell = row.createCell(14);
	cell.setCellValue("Needs Training");

	cell = row.createCell(15);
	cell.setCellValue("Blocked");
    }

    private void addUsers(HSSFSheet sheet, MapList mlUsers, HSSFCellStyle dateStyle, HSSFCellStyle textStyle)
	    throws Exception {
	int rownum = 1;
	Row row = null;
	Cell cell = null;

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	Map<String, String> mUser = null;
	for (int i = 0, iSz = mlUsers.size(); i < iSz; i++) {
	    mUser = mlUsers.get(i);

	    row = sheet.createRow(rownum++);

	    cell = row.createCell(0);
	    cell.setCellValue(mUser.get(RDMServicesConstants.USER_ID));
	    cell.setCellStyle(textStyle);

	    cell = row.createCell(1);
	    cell.setCellValue(mUser.get(RDMServicesConstants.FIRST_NAME));

	    cell = row.createCell(2);
	    cell.setCellValue(mUser.get(RDMServicesConstants.LAST_NAME));

	    cell = row.createCell(3);
	    cell.setCellValue(mUser.get(RDMServicesConstants.GENDER));

	    cell = row.createCell(4);
	    String dob = mUser.get(RDMServicesConstants.DATE_OF_BIRTH);
	    if (RDMServicesUtils.isNotNullAndNotEmpty(dob)) {
		cell.setCellValue(sdf.parse(dob));
	    }
	    cell.setCellStyle(dateStyle);

	    cell = row.createCell(5);
	    String doj = mUser.get(RDMServicesConstants.DATE_OF_JOIN);
	    if (RDMServicesUtils.isNotNullAndNotEmpty(doj)) {
		cell.setCellValue(sdf.parse(doj));
	    }
	    cell.setCellStyle(dateStyle);

	    cell = row.createCell(6);
	    cell.setCellValue(mUser.get(RDMServicesConstants.DESIGNATION));

	    cell = row.createCell(7);
	    cell.setCellValue(mUser.get(RDMServicesConstants.ROLE_NAME));

	    cell = row.createCell(8);
	    cell.setCellValue((mUser.get(RDMServicesConstants.DEPARTMENT_NAME)).replace("|", ","));

	    cell = row.createCell(9);
	    cell.setCellValue((mUser.get(RDMServicesConstants.GROUP_NAME)).replace("|", ","));

	    cell = row.createCell(10);
	    cell.setCellValue(mUser.get(RDMServicesConstants.ADDRESS));

	    cell = row.createCell(11);
	    cell.setCellValue(mUser.get(RDMServicesConstants.CONTACT_NO));
	    cell.setCellStyle(textStyle);

	    cell = row.createCell(12);
	    cell.setCellValue(mUser.get(RDMServicesConstants.EMAIL));

	    cell = row.createCell(13);
	    cell.setCellValue(mUser.get(RDMServicesConstants.QUALIFICATION));

	    cell = row.createCell(14);
	    cell.setCellValue(mUser.get(RDMServicesConstants.TRAINING));

	    cell = row.createCell(15);
	    cell.setCellValue(mUser.get(RDMServicesConstants.BLOCKED));
	}
    }
}
