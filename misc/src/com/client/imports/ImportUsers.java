package com.client.imports;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;

import com.client.db.DataQuery;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;
import com.client.util.StringList;

public class ImportUsers extends RDMServicesConstants {
	private static final SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

	public void importUsers(String sFilePath) throws Exception {
		DataQuery query = new DataQuery();
		MapList mlExistUsers = query.getUserList();

		StringList slUsers = new StringList();
		for (int i = 0, iSz = mlExistUsers.size(); i < iSz; i++) {
			Map<String, String> mUser = mlExistUsers.get(i);
			slUsers.add(mUser.get(USER_ID));
		}

		MapList mlUserInput = readUserInput(sFilePath);
		for (int i = 0, iSz = mlUserInput.size(); i < iSz; i++) {
			Map<String, String> mUser = mlUserInput.get(i);
			String sUserId = mUser.get("User Id");

			Map<String, String> mUserData = new HashMap<>();
			mUserData.put(USER_ID, sUserId);
			mUserData.put(FIRST_NAME, mUser.get("First Name"));
			mUserData.put(LAST_NAME, mUser.get("Last Name"));
			mUserData.put(EMAIL, mUser.get("Email"));
			mUserData.put(DATE_OF_BIRTH, mUser.get("Date of Birth"));
			mUserData.put(GENDER, mUser.get("Gender"));
			mUserData.put(ADDRESS, mUser.get("Address"));
			mUserData.put(ROLE_NAME, mUser.get("User Role"));
			mUserData.put(DEPARTMENT_NAME, mUser.get("Department").replace(",", "|"));
			mUserData.put(GROUP_NAME, mUser.get("Group").replace(",", "|"));
			mUserData.put(DATE_OF_JOIN, mUser.get("Date of Join"));
			mUserData.put(CONTACT_NO, mUser.get("Phone Number"));
			mUserData.put(TRAINING, mUser.get("Needs Training"));
			mUserData.put(DESIGNATION, mUser.get("Designation"));
			mUserData.put(QUALIFICATION, mUser.get("Qualification"));
			mUserData.put(LOCALE, mUser.get("en"));

			if (slUsers.contains(sUserId)) {
				query.updateUser(sUserId, mUserData);
			} else {
				query.addUser(mUserData);
				slUsers.add(sUserId);
			}
		}
		RDMServicesUtils.setUserList();
	}

	private MapList readUserInput(String sFilePath) throws Exception {
		boolean bHeader = true;
		StringList slHeaders = new StringList();
		MapList mlUsers = new MapList();

		FileInputStream fis = new FileInputStream(new File(sFilePath));

		HSSFWorkbook workbook = new HSSFWorkbook(fis);
		HSSFSheet sheet = workbook.getSheetAt(0);
		for (Row row : sheet) {
			if (bHeader) {
				for (Cell cell : row) {
					String header = cell.getStringCellValue();
					slHeaders.add(header);
				}
				bHeader = false;
				continue;
			}

			int idx = 0;
			Map<String, String> mUser = new HashMap<>();
			for (Cell cell : row) {
				String header = slHeaders.get(idx++);
				String value = (header.startsWith("Date")) ? getDateValue(cell) : getStringValue(cell);
				mUser.put(header, value);
			}

			String sUserId = mUser.get("User Id");
			if (RDMServicesUtils.isNotNullAndNotEmpty(sUserId)) {
				mlUsers.add(mUser);
			}
		}

		return mlUsers;
	}

	private String getDateValue(Cell cell) {
		String value = "";
		try {
			Date date = cell.getDateCellValue();
			value = sdf.format(date);
		} catch (Exception e) {
			try {
				value = cell.getStringCellValue();
				if (RDMServicesUtils.isNotNullAndNotEmpty(value)) {
					value = sdf.format(sdf.parse(value));
				}
			} catch (Exception exp) {
				System.out.println("Err in getDateValue: " + e);
			}
		}
		return value;
	}

	private String getStringValue(Cell cell) {
		String value = "";
		try {
			value = cell.getStringCellValue();
		} catch (Exception e) {
			try {
				value = Double.toString(cell.getNumericCellValue());
			} catch (Exception exp) {
				System.out.println("Err in getStringValue: " + e);
			}
		}
		return value;
	}
}
