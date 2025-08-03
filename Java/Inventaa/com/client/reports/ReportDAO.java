package com.client.reports;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

import org.apache.commons.lang3.math.NumberUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.client.db.DataQuery;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;
import com.client.util.StringList;

public class ReportDAO extends RDMServicesConstants {
    private static final DecimalFormat df = new DecimalFormat("#.###");
    private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a", Locale.getDefault());
    private static final ScriptEngineManager manager = new ScriptEngineManager();
    private static final ScriptEngine engine = manager.getEngineByName("js");

    public ReportDAO() {

    }

    public void addReport(String sReport, String sTemplate, String sDesc, String sKeyColumn, int iHeader, int iFormula,
	    int iRanges, int iEditCols, StringList slReadAccess, StringList slReadDept, StringList slWriteAccess,
	    StringList slWriteDept, StringList slModifyAccess, StringList slModifyDept, boolean bAllowUpdates)
	    throws Exception {
	manageReport(sReport, sTemplate, sDesc, sKeyColumn, iHeader, iFormula, iRanges, iEditCols, slReadAccess,
		slReadDept, slWriteAccess, slWriteDept, slModifyAccess, slModifyDept, bAllowUpdates, true);
    }

    public void updateReport(String sReport, String sTemplate, String sDesc, String sKeyColumn, int iHeader,
	    int iFormula, int iRanges, int iEditCols, StringList slReadAccess, StringList slReadDept,
	    StringList slWriteAccess, StringList slWriteDept, StringList slModifyAccess, StringList slModifyDept,
	    boolean bAllowUpdates) throws Exception {
	if (sTemplate != null && !"".equals(sTemplate)) {
	    manageReport(sReport, sTemplate, sDesc, sKeyColumn, iHeader, iFormula, iRanges, iEditCols, slReadAccess,
		    slReadDept, slWriteAccess, slWriteDept, slModifyAccess, slModifyDept, bAllowUpdates, false);
	} else {
	    DataQuery query = new DataQuery();
	    query.updateReport(sReport, sDesc, sKeyColumn, iHeader, iFormula, iRanges, iEditCols, slReadAccess,
		    slReadDept, slWriteAccess, slWriteDept, slModifyAccess, slModifyDept, bAllowUpdates);
	}
    }

    private void manageReport(String sReport, String sTemplate, String sDesc, String sKeyColumn, int iHeader,
	    int iFormula, int iRanges, int iEditCols, StringList slReadAccess, StringList slReadDept,
	    StringList slWriteAccess, StringList slWriteDept, StringList slModifyAccess, StringList slModifyDept,
	    boolean bAllowUpdates, boolean bAdd) throws Exception {
	File file = null;
	FileInputStream fis = null;

	try {
	    String filepath = RDMServicesUtils.getClassLoaderpath("../../reports/templates");
	    file = new File(filepath, sTemplate);
	    fis = new FileInputStream(file);

	    HSSFWorkbook workbook = new HSSFWorkbook(fis);
	    HSSFSheet worksheet = workbook.getSheetAt(0);
	    HSSFRow row = worksheet.getRow(iHeader - 1);
	    HSSFCell cell = null;
	    HSSFCellStyle cellStyle = null;
	    HSSFFont cellFont = null;

	    StringList slColumns = new StringList();
	    StringList slSearchCols = new StringList();

	    int iSz = row.getLastCellNum();
	    iSz = ((iSz > 52) ? 52 : iSz);
	    String sValue = null;

	    for (int i = 0; i < iSz; i++) {
		cell = row.getCell(i);
		if (cell == null) {
		    continue;
		}

		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		sValue = cell.getStringCellValue();
		sValue = (sValue == null ? "" : sValue.trim());
		if (!"".equals(sValue)) {
		    if (sValue.equalsIgnoreCase(REMARKS)) {
			slColumns.add(REMARKS);
		    } else if (sValue.equalsIgnoreCase(LOGGEDBY)) {
			slColumns.add(LOGGEDBY);
		    } else if (sValue.equalsIgnoreCase(MODIFIEDBY)) {
			slColumns.add(MODIFIEDBY);
		    } else if (sValue.equalsIgnoreCase(MODIFIEDON)) {
			slColumns.add(MODIFIEDON);
		    } else {
			slColumns.add(sValue);
		    }
		}

		cellStyle = cell.getCellStyle();
		cellFont = workbook.getFontAt(cellStyle.getFontIndex());
		if ((int) cellFont.getColor() == 10) {
		    slSearchCols.add(sValue);
		}
	    }

	    if (!slColumns.contains(REMARKS)) {
		slColumns.add(REMARKS);
	    }

	    if (!slColumns.contains(LOGGEDBY)) {
		slColumns.add(LOGGEDBY);
	    }

	    if (!slColumns.contains(MODIFIEDBY)) {
		slColumns.add(MODIFIEDBY);
	    }

	    if (!slColumns.contains(MODIFIEDON)) {
		slColumns.add(MODIFIEDON);
	    }

	    Map<String, String> mColumnHeaders = getReportColumns(sReport, slColumns, bAdd);

	    String sBasedOn = "";
	    Map<String, String> mFormulae = new HashMap<String, String>();
	    if (iFormula > 0) {
		String sFormula = null;
		row = worksheet.getRow(iFormula - 1);
		for (int i = 0; i < iSz; i++) {
		    cell = row.getCell(i);
		    if (cell == null) {
			continue;
		    }

		    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    sFormula = cell.getStringCellValue();
		    if (sFormula != null && !"".equals(sFormula)) {
			sFormula = sFormula.replace(" ", "");
			if (BASEDON.equalsIgnoreCase(sFormula)) {
			    sBasedOn = mColumnHeaders.get(slColumns.get(i));
			} else {
			    mFormulae.put(slColumns.get(i), getFormatedFormula(iHeader, sFormula));
			}
		    }
		}
	    }

	    Map<String, String> mRanges = new HashMap<String, String>();
	    if (iRanges > 0) {
		String sRanges = null;
		row = worksheet.getRow(iRanges - 1);
		for (int i = 0; i < iSz; i++) {
		    cell = row.getCell(i);
		    if (cell == null) {
			continue;
		    }

		    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    sRanges = cell.getStringCellValue();
		    if (sRanges != null && !"".equals(sRanges)) {
			mRanges.put(slColumns.get(i), sRanges);
		    }
		}
	    }

	    StringList slReadOnlyCols = new StringList();
	    if (iEditCols > 0) {
		row = worksheet.getRow(iEditCols - 1);
		for (int i = 0; i < iSz; i++) {
		    cell = row.getCell(i);
		    if (cell == null) {
			continue;
		    }

		    cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		    if ("NO".equalsIgnoreCase(cell.getStringCellValue())) {
			slReadOnlyCols.add(slColumns.get(i));
		    }
		}
	    }

	    fis.close();

	    String sColumnName = mColumnHeaders.get(sKeyColumn);
	    String[] saKeyColumn = new String[] { sKeyColumn, sColumnName };

	    DataQuery query = new DataQuery();
	    query.manageReport(sReport, sTemplate, sDesc, saKeyColumn, slColumns, mColumnHeaders, slSearchCols,
		    mFormulae, mRanges, slReadOnlyCols, sBasedOn, iHeader, iFormula, iRanges, iEditCols, slReadAccess,
		    slReadDept, slWriteAccess, slWriteDept, slModifyAccess, slModifyDept, bAllowUpdates, bAdd);
	} catch (IOException e) {
	    fis.close();
	    file.delete();
	}
    }

    public void deleteReport(String sReport) throws Exception {
	DataQuery query = new DataQuery();
	query.deleteReport(sReport);
    }

    public MapList getReports(String sUser) throws Exception {
	DataQuery query = new DataQuery();
	return query.getReports(sUser);
    }

    public Map<String, String> getReport(String sReport) throws Exception {
	DataQuery query = new DataQuery();
	return query.getReport(sReport);
    }

    public Map<String, String> getReport(String sUser, String sReport) throws Exception {
	DataQuery query = new DataQuery();
	MapList mlReports = query.getReports(sUser);

	Map<String, String> mReport = null;
	for (int i = 0; i < mlReports.size(); i++) {
	    mReport = mlReports.get(i);
	    if (sReport.equals(mReport.get(REPORT))) {
		return mReport;
	    }
	}

	return new HashMap<String, String>();
    }

    public void insertRecords(String sUser, String sReport, String sRecordsFile) throws Exception {
	File file = null;
	FileInputStream fis = null;
	StringBuilder sbError = new StringBuilder();

	try {
	    String sValue = null;
	    StringList slValues = new StringList();
	    Map<String, String> mRecord = null;
	    Map<String, String> mReport = null;
	    MapList mlRecords = new MapList();

	    DataQuery query = new DataQuery();

	    String[] saColumn = query.getReportKeyColumn(sReport);
	    String sKeyColumn = saColumn[0];
	    String sColumnName = saColumn[1];
	    if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
		throw new SQLException("Missing Column name for Record Entry Time");
	    }

	    Map<String, String> mReportCols = query.getReportColumnHeaders(sReport, false);
	    String sLoggedByCol = mReportCols.get(LOGGEDBY);

	    int iHeader = 0;
	    MapList mlReports = query.getReports(sUser);
	    for (int i = 0; i < mlReports.size(); i++) {
		mReport = mlReports.get(i);
		if (mReport.get(RDMServicesConstants.REPORT).equals(sReport)) {
		    iHeader = Integer.parseInt(mReport.get(RDMServicesConstants.HEADER_ROW));
		}
	    }

	    String filepath = RDMServicesUtils.getClassLoaderpath("../../reports/records");
	    file = new File(filepath, sRecordsFile);
	    fis = new FileInputStream(file);

	    HSSFWorkbook workbook = new HSSFWorkbook(fis);
	    HSSFSheet worksheet = workbook.getSheetAt(0);
	    HSSFRow row = worksheet.getRow(iHeader - 1);
	    HSSFCell cell = null;

	    int iRows = worksheet.getLastRowNum();
	    iRows = ((iRows > 1024) ? 1024 : iRows);
	    int iCols = row.getLastCellNum();
	    iCols = ((iCols > 52) ? 52 : iCols);

	    for (int i = 0; i < iCols; i++) {
		cell = row.getCell(i);
		if (cell == null) {
		    continue;
		}

		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		sValue = cell.getStringCellValue();
		sValue = (sValue == null ? "" : sValue.trim());
		if (!"".equals(sValue)) {
		    if (sValue.equalsIgnoreCase(REMARKS)) {
			slValues.add(REMARKS);
		    } else if (sValue.equalsIgnoreCase(LOGGEDBY)) {
			slValues.add(LOGGEDBY);
		    } else {
			slValues.add(sValue);
		    }
		}
	    }

	    if (!slValues.contains(REMARKS)) {
		slValues.add(REMARKS);
	    }

	    if (!slValues.contains(LOGGEDBY)) {
		slValues.add(LOGGEDBY);
	    }

	    for (int i = iHeader; i <= iRows; i++) {
		row = worksheet.getRow(i);
		if (row == null) {
		    continue;
		}

		mRecord = new HashMap<String, String>();
		if (!mRecord.containsKey(sLoggedByCol)) {
		    mRecord.put(sLoggedByCol, sUser);
		}

		sValue = "";
		cell = row.getCell(0);
		if (cell != null) {
		    try {
			sValue = sdf.format(cell.getDateCellValue());
		    } catch (Exception e) {
			sValue = cell.getStringCellValue();
		    }
		}
		mRecord.put(mReportCols.get(slValues.get(0)), sValue);

		for (int j = 1, iSz = slValues.size(); j < iSz; j++) {
		    sValue = "";
		    cell = row.getCell(j);
		    if (cell != null) {
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			sValue = cell.getStringCellValue();
		    }
		    mRecord.put(mReportCols.get(slValues.get(j)), sValue.trim());
		}

		mlRecords.add(mRecord);
	    }

	    if (sbError.length() > 1) {
		throw new Exception(sbError.toString());
	    } else {
		query.insertReportRecord(sReport, sColumnName, mlRecords);
	    }
	} finally {
	    fis.close();
	    file.delete();
	}
    }

    public void insertRecord(String sUser, String sReport, Map<String, String> mRecord) throws Exception {
	DataQuery query = new DataQuery();

	String[] saColumn = query.getReportKeyColumn(sReport);
	String sKeyColumn = saColumn[0];
	String sColumnName = saColumn[1];
	if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
	    throw new SQLException("Missing Column name for Record Entry Time");
	}

	Calendar cal = Calendar.getInstance();
	String sLogTime = sdf.format(cal.getTime());
	mRecord.put(sColumnName, sLogTime);

	Map<String, String> mReportCols = query.getReportColumnHeaders(sReport, false);
	mRecord.put(mReportCols.get(LOGGEDBY), sUser);

	mRecord = getPreviousRecord(sReport, sColumnName, mRecord);

	MapList mlRecords = new MapList();
	mlRecords.add(mRecord);

	query.insertReportRecord(sReport, sColumnName, mlRecords);
    }

    public void updateRecord(String sUser, String sReport, Map<String, String> mRecord) throws Exception {
	DataQuery query = new DataQuery();

	String[] saColumn = query.getReportKeyColumn(sReport);
	String sKeyColumn = saColumn[0];
	String sColumnName = saColumn[1];
	if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
	    throw new SQLException("Missing Column name for Record Entry Time");
	}

	mRecord = getPreviousRecord(sReport, sColumnName, mRecord);

	Map<String, String> mReportCols = query.getReportColumnHeaders(sReport, false);
	mRecord.put(mReportCols.get(MODIFIEDBY), sUser);
	mRecord.put(mReportCols.get(MODIFIEDON), sdf.format(Calendar.getInstance().getTime()));

	query.updateReportRecord(sReport, sColumnName, mRecord);
    }

    public void deleteRecord(String sReport, String sDateTime) throws Exception {
	DataQuery query = new DataQuery();

	String[] saColumn = query.getReportKeyColumn(sReport);
	String sKeyColumn = saColumn[0];
	String sColumnName = saColumn[1];
	if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
	    throw new SQLException("Missing Column name for Record Entry Time");
	}

	query.deleteReportRecord(sReport, sColumnName, sDateTime);
    }

    private Map<String, String> getPreviousRecord(String sReport, String sKeyColumn, Map<String, String> mRecord)
	    throws Exception {
	String sColumn = null;
	DataQuery query = new DataQuery();

	Map<String, String> mReport = getReport(sReport);
	String sBasedOnCol = mReport.get(CALC_BASED_ON);
	sBasedOnCol = (sBasedOnCol == null ? "" : sBasedOnCol);
	String sBasedOnVal = (!"".equals(sBasedOnCol) ? mRecord.get(sBasedOnCol) : "");

	Map<String, String> mValues = query.getReportLastRecord(sReport, sKeyColumn, mRecord.get(sKeyColumn),
		sBasedOnCol, sBasedOnVal);
	Iterator<String> itr = mRecord.keySet().iterator();
	while (itr.hasNext()) {
	    sColumn = itr.next();
	    mValues.put("CURR." + sColumn, mRecord.get(sColumn));
	}

	String sFormula = null;
	String sResult = null;
	Map<String, String> mReportFormulae = query.getReportColumnFormulae(sReport);
	StringList slColumns = query.getReportColumns(sReport);
	for (int i = 1; i < slColumns.size(); i++) {
	    sColumn = slColumns.get(i);
	    if (mReportFormulae.containsKey(sColumn)) {
		sFormula = mReportFormulae.get(sColumn);
		sResult = evalFormula(sFormula, mValues);

		mRecord.put(sColumn, sResult);
		if (!mValues.containsKey("CURR." + sColumn)) {
		    mValues.put("CURR." + sColumn, sResult);
		}
	    }
	}
	return mRecord;
    }

    public MapList getRecords(String sReport, String sFromDate, String sToDate) throws Exception {
	DataQuery query = new DataQuery();
	return query.getRecords(sReport, sFromDate, sToDate);
    }

    public MapList getRecords(String sReport, Map<String, String> mSearchCriteria) throws Exception {
	DataQuery query = new DataQuery();
	return query.getRecords(sReport, mSearchCriteria);
    }

    public Map<String, String> getRecord(String sReport, String sDateTime) throws Exception {
	DataQuery query = new DataQuery();
	return query.getRecord(sReport, sDateTime);
    }

    public StringList getRecordTimestamps(String sReport, String sDate) throws Exception {
	DataQuery query = new DataQuery();
	return query.getRecordTimestamps(sReport, sDate);
    }

    public StringList getRecordTimestamps(String sReport, Map<String, String> mSearchCriteria) throws Exception {
	DataQuery query = new DataQuery();
	return query.getRecordTimestamps(sReport, mSearchCriteria);
    }

    public StringList getReportColumns(String sReport) throws Exception {
	DataQuery query = new DataQuery();
	return query.getReportColumns(sReport);
    }

    public Map<String, String> getReportColumnHeaders(String sReport) throws Exception {
	DataQuery query = new DataQuery();
	return query.getReportColumnHeaders(sReport, true);
    }

    public Map<String, String> getReportColumnFormulae(String sReport) throws Exception {
	DataQuery query = new DataQuery();
	return query.getReportColumnFormulae(sReport);
    }

    public Map<String, String[]> getReportColumnRanges(String sReport) throws Exception {
	DataQuery query = new DataQuery();
	return query.getReportColumnRanges(sReport);
    }

    public StringList getReportSearchColumns(String sReport) throws Exception {
	DataQuery query = new DataQuery();
	return query.getReportSearchColumns(sReport);
    }

    public StringList getReadOnlyColumns(String sReport) throws Exception {
	DataQuery query = new DataQuery();
	return query.getReadOnlyColumns(sReport);
    }

    private Map<String, String> getReportColumns(String sReport, StringList slColumns, boolean bAdd) throws Exception {
	Map<String, String> mColumns = new HashMap<String, String>();

	int iSz = 0;
	DataQuery query = new DataQuery();
	StringList slReportCols = null;
	Map<String, String> mReportCols = null;
	if (!bAdd) {
	    mReportCols = query.getReportColumnHeaders(sReport, false);
	    iSz = mReportCols.size();

	    String sReportTab = sReport.replace(" ", "_");
	    slReportCols = query.getColumnParameters(sReportTab);
	}

	String sColumn = null;
	String sColumnKey = null;

	for (int i = 0; i < slColumns.size(); i++) {
	    sColumn = slColumns.get(i);

	    if (bAdd) {
		sColumnKey = "Column" + (i + 1);
	    } else {
		if (mReportCols.containsKey(sColumn)) {
		    sColumnKey = mReportCols.get(sColumn);
		} else {
		    do {
			iSz++;
			sColumnKey = "Column" + iSz;
		    } while (slReportCols.contains("COLUMN" + iSz));
		}
	    }

	    mColumns.put(sColumn, sColumnKey);
	}

	return mColumns;
    }

    private static String getFormatedFormula(int iHeader, String sFormula) {
	int i = 1;
	int idx = iHeader + 2;
	String sResolvedFormula = sFormula.toUpperCase();
	for (char ch = 'A'; ch <= 'Z'; ++ch) {
	    String currRef1 = "" + ch + idx;
	    String currRef2 = "A" + ch + idx;
	    String currColumn = "'CURR.Column" + i + "'";

	    if (sResolvedFormula.contains(currRef1)) {
		sResolvedFormula = sResolvedFormula.replace(currRef1, currColumn);
	    } else if (sResolvedFormula.contains(currRef2)) {
		sResolvedFormula = sResolvedFormula.replace(currRef2, currColumn);
	    } else {
		currRef1 = "" + ch + (idx - 1);
		currRef2 = "A" + ch + (idx - 1);

		if (sResolvedFormula.contains(currRef1)) {
		    sResolvedFormula = sResolvedFormula.replace(currRef1, currColumn);
		} else if (sResolvedFormula.contains(currRef2)) {
		    sResolvedFormula = sResolvedFormula.replace(currRef2, currColumn);
		}
	    }

	    String prevRef1 = "" + ch + (idx - 2);
	    String prevRef2 = "A" + ch + (idx - 2);
	    String prevColumn = "'PREV.Column" + i + "'";

	    if (sResolvedFormula.contains(prevRef1)) {
		sResolvedFormula = sResolvedFormula.replace(prevRef1, prevColumn);
	    } else if (sResolvedFormula.contains(prevRef2)) {
		sResolvedFormula = sResolvedFormula.replace(prevRef2, prevColumn);
	    } else {
		prevRef1 = "" + ch + (idx - 1);
		prevRef2 = "A" + ch + (idx - 1);

		if (sResolvedFormula.contains(prevRef1)) {
		    sResolvedFormula = sResolvedFormula.replace(prevRef1, prevColumn);
		} else if (sResolvedFormula.contains(prevRef2)) {
		    sResolvedFormula = sResolvedFormula.replace(prevRef2, prevColumn);
		}
	    }

	    i++;
	}

	if (sResolvedFormula.contains("+")) {
	    sResolvedFormula = sResolvedFormula.replace("+", " + ");
	}
	if (sResolvedFormula.contains("-")) {
	    sResolvedFormula = sResolvedFormula.replace("-", " - ");
	}
	if (sResolvedFormula.contains("*")) {
	    sResolvedFormula = sResolvedFormula.replace("*", " * ");
	}
	if (sResolvedFormula.contains("/")) {
	    sResolvedFormula = sResolvedFormula.replace("/", " / ");
	}

	return sResolvedFormula.trim();
    }

    private String evalFormula(String sFormula, Map<String, String> mValues) {
	String sResult = "0";
	try {
	    while (sFormula.contains("'")) {
		int idx1 = sFormula.indexOf("'") + 1;
		int idx2 = sFormula.indexOf("'", idx1);
		String param = sFormula.substring(idx1, idx2).trim();
		if (mValues.containsKey(param)) {
		    sFormula = sFormula.replace(("'" + param + "'"), mValues.get(param));
		} else {
		    sFormula = sFormula.replace(("'" + param + "'"), param);
		}
	    }

	    Object result = engine.eval(sFormula);
	    sResult = df.format(Double.parseDouble(result.toString()));
	} catch (Exception e) {
	    sResult = "0";
	}

	return (NumberUtils.isNumber(sResult) ? sResult : "0");
    }

    public static String convertFormulaExpr(String sReport, String sFormula) throws Exception {
	DataQuery query = new DataQuery();
	Map<String, String> mColumns = query.getReportColumnHeaders(sReport, true);

	while (sFormula.contains("'")) {
	    int idx1 = sFormula.indexOf("'") + 1;
	    int idx2 = sFormula.indexOf("'", idx1);
	    String param = sFormula.substring(idx1, idx2).trim();

	    String sPrefix = "";
	    if (param.startsWith("CURR.")) {
		sPrefix = "CURR";
		param = param.substring(5, param.length());
	    } else if (param.startsWith("PREV.")) {
		sPrefix = "PREV";
		param = param.substring(5, param.length());
	    }

	    if (mColumns.containsKey(param)) {
		sFormula = sFormula.replace(("'" + sPrefix + "." + param + "'"),
			sPrefix + "[" + mColumns.get(param) + "]");
	    } else {
		sFormula = sFormula.replace(("'" + sPrefix + "." + param + "'"), sPrefix + "[" + param + "]");
	    }
	}

	return sFormula;
    }
}
