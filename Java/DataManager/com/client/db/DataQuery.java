package com.client.db;

import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.postgresql.copy.CopyManager;
import org.postgresql.core.BaseConnection;

import com.client.PLCServices_newHW;
import com.client.PLCServices_oldHW;
import com.client.ServicesSession;
import com.client.license.EncryptDecrypt;
import com.client.license.VerifyLicense;
import com.client.notify.NotifyAlarms;
import com.client.util.MapList;
import com.client.util.ParamSettings;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;
import com.client.util.StringList;
import com.client.util.User;

public class DataQuery extends RDMServicesConstants {
	private DBConnectionPool connectionPool;
	private static String SCHEMA_NAME = null;
	private static DecimalFormat df = new DecimalFormat("#.####");
	private static SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	public DataQuery() throws Exception {
		SCHEMA_NAME = RDMServicesUtils.getProperty("rdmservices.db.schema");
		connectionPool = new DBConnectionPool();
	}

	public ArrayList<String> getDisplayOrder(String cntrlType) throws Exception {
		ArrayList<String> alOrderParams = new ArrayList<String>();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		ArrayList<String> alParams1 = null;
		ArrayList<String> alParams2 = null;
		Map<String, ArrayList<String>> mParams1 = new HashMap<String, ArrayList<String>>();
		Map<String, ArrayList<String>> mParams2 = new HashMap<String, ArrayList<String>>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sParam = null;
			String sStage = null;
			String sGroup = null;
			String sStageNum = null;

			StringList slStages = new StringList();
			slStages.add("");
			slStages.add("NA");
			slStages.add("Current.Phase");

			ArrayList<String[]> alStages = RDMServicesUtils.getControllerStages(cntrlType);
			for (int i = 0; i < alStages.size(); i++) {
				slStages.add(alStages.get(i)[0]);
			}

			String selectString = "select PARAM_NAME,STAGE_NAME,PARAM_GROUP from " + SCHEMA_NAME
					+ ".CONTROLLER_PARAMS_ADMIN " + "where DISPLAY_ORDER != '0' and CNTRL_TYPE = '" + cntrlType
					+ "' ORDER BY DISPLAY_ORDER,PARAM_NAME ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sParam = rs.getString(PARAM_NAME);
				sStage = rs.getString(STAGE_NAME);
				sGroup = rs.getString(PARAM_GROUP);
				sGroup = (sGroup == null ? "" : sGroup);

				if (!slStages.contains(sStage)) {
					continue;
				}

				if ("".equals(sStage) || "NA".equals(sStage) || "Current.Phase".equals(sStage)) {
					sStage = "UNDEFINED";
				} else {
					if (!"".equals(sGroup) && mParams1.containsKey("UNDEFINED")) {
						alParams1 = mParams1.get("UNDEFINED");
						if (!alParams1.contains(sGroup)) {
							alParams1.add(sGroup);
							mParams1.put("UNDEFINED", alParams1);
						}
					}
				}

				if (mParams1.containsKey(sStage)) {
					alParams1 = mParams1.get(sStage);
				} else {
					alParams1 = new ArrayList<String>();
				}

				alParams1.add(sParam);
				mParams1.put(sStage, alParams1);
			}

			close(rs);

			alParams1 = (mParams1.containsKey("UNDEFINED") ? mParams1.get("UNDEFINED") : new ArrayList<String>());

			selectString = "select PARAM_NAME,STAGE_NAME,PARAM_GROUP from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN "
					+ "where DISPLAY_ORDER = '0' and CNTRL_TYPE = '" + cntrlType + "' ORDER BY PARAM_NAME ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sParam = rs.getString(PARAM_NAME);
				sStage = rs.getString(STAGE_NAME);
				sGroup = rs.getString(PARAM_GROUP);
				sGroup = (sGroup == null ? "" : sGroup);

				if (!slStages.contains(sStage)) {
					continue;
				}

				if ("".equals(sStage) || "NA".equals(sStage) || "Current.Phase".equals(sStage)) {
					sStage = "UNDEFINED";
				} else {
					if (!"".equals(sGroup) && !alParams1.contains(sGroup) && mParams2.containsKey("UNDEFINED")) {
						alParams2 = mParams2.get("UNDEFINED");
						if (!alParams2.contains(sGroup) && !alParams1.contains(sGroup)) {
							alParams2.add(sGroup);
							mParams2.put("UNDEFINED", alParams2);
						}
					}
				}

				if (mParams2.containsKey(sStage)) {
					alParams2 = mParams2.get(sStage);
				} else {
					alParams2 = new ArrayList<String>();
				}

				alParams2.add(sParam);
				mParams2.put(sStage, alParams2);
			}

			String sName = null;
			if (mParams1.containsKey("UNDEFINED") || mParams2.containsKey("UNDEFINED")) {
				alOrderParams.add(">>>UNDEFINED");

				if (mParams1.containsKey("UNDEFINED")) {
					alParams1 = mParams1.get("UNDEFINED");
					for (int i = 0; i < alParams1.size(); i++) {
						sName = alParams1.get(i);
						if (!alOrderParams.contains(sName)) {
							alOrderParams.add(sName);
						}
					}
				}

				if (mParams2.containsKey("UNDEFINED")) {
					alParams2 = mParams2.get("UNDEFINED");
					for (int i = 0; i < alParams2.size(); i++) {
						sName = alParams2.get(i);
						if (!alOrderParams.contains(sName)) {
							alOrderParams.add(sName);
						}
					}
				}
			}

			for (int i = 0; i < alStages.size(); i++) {
				sStageNum = alStages.get(i)[0];

				alOrderParams.add(">>>" + alStages.get(i)[1].toUpperCase());
				if (mParams1.containsKey(sStageNum)) {
					alParams1 = mParams1.get(sStageNum);
					for (int x = 0; x < alParams1.size(); x++) {
						sName = alParams1.get(x);
						if (!alOrderParams.contains(sName)) {
							alOrderParams.add(sName);
						}
					}
				}

				if (mParams2.containsKey(sStageNum)) {
					alParams2 = mParams2.get(sStageNum);
					for (int x = 0; x < alParams2.size(); x++) {
						sName = alParams2.get(x);
						if (!alOrderParams.contains(sName)) {
							alOrderParams.add(sName);
						}
					}
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			alParams1 = null;
			alParams2 = null;
			mParams1 = null;
			mParams2 = null;
		}

		return alOrderParams;
	}

	public Map<String, ParamSettings> getViewParameters(String key, String cntrlType)
			throws SQLException, InterruptedException {
		Map<String, ParamSettings> mParams = new HashMap<String, ParamSettings>();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			boolean bIsNotGeneral = !cntrlType.startsWith("General");
			String sParamsAdminTab = (bIsNotGeneral ? "CONTROLLER_PARAMS_ADMIN" : "GENERAL_PARAMS_ADMIN");

			ParamSettings mParam = null;
			String sName = "";
			String selectString = "select * from " + SCHEMA_NAME + "." + sParamsAdminTab + " where " + key + " = 'Y'"
					+ " and CNTRL_TYPE = '" + cntrlType + "'";

			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sName = rs.getString(PARAM_NAME);

				mParam = new ParamSettings(sName);
				if (bIsNotGeneral) {
					mParam.setStage(rs.getString(STAGE_NAME));
					mParam.setParamGroup(rs.getString(PARAM_GROUP));
				}
				mParam.setDisplayOrder(rs.getInt(DISPLAY_ORDER));
				mParam.setScaleOnGraph(rs.getInt(SCALE_ON_GRAPH));
				mParam.setParamUnit(rs.getString(PARAM_UNIT));

				mParam.setHelperAccess(getRoleAccess(rs.getString(HELPER_READ), rs.getString(HELPER_WRITE)));
				mParam.setSupervisorAccess(
						getRoleAccess(rs.getString(SUPERVISOR_READ), rs.getString(SUPERVISOR_WRITE)));
				mParam.setManagerAccess(getRoleAccess(rs.getString(MANAGER_READ), rs.getString(MANAGER_WRITE)));
				mParam.setAdminAccess(getRoleAccess(rs.getString(ADMIN_READ), rs.getString(ADMIN_WRITE)));

				mParams.put(sName, mParam);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mParams;
	}

	public Map<String, ParamSettings> getSingleRoomViewParameters(String cntrlType) throws Exception {
		Map<String, ParamSettings> mParams = new HashMap<String, ParamSettings>();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			int iDispOrder = 0;
			String sName = null;
			String sGroup = null;
			String sStage = null;
			String sUnit = null;

			String selectString = "select * from " + SCHEMA_NAME
					+ ".CONTROLLER_PARAMS_ADMIN where SINGLEROOM_VIEW = 'Y'" + " and CNTRL_TYPE = '" + cntrlType
					+ "' and (PARAM_GROUP IS NOT NULL and PARAM_GROUP != '')"
					+ " ORDER BY DISPLAY_ORDER,PARAM_NAME ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sName = rs.getString(PARAM_NAME);
				sGroup = rs.getString(PARAM_GROUP);
				sStage = rs.getString(STAGE_NAME);
				sUnit = rs.getString(PARAM_UNIT);
				iDispOrder = rs.getInt(DISPLAY_ORDER);

				ParamSettings mGroupParam = mParams.get(sGroup);
				if (mGroupParam == null) {
					mGroupParam = new ParamSettings(sGroup);
				}

				ParamSettings mParam = new ParamSettings(sName);
				mParam.setStage(sStage);
				mParam.setDisplayOrder(iDispOrder);
				mParam.setParamGroup(sGroup);
				mParam.setParamUnit(sUnit);

				mParam.setHelperAccess(getRoleAccess(rs.getString(HELPER_READ), rs.getString(HELPER_WRITE)));
				mParam.setSupervisorAccess(
						getRoleAccess(rs.getString(SUPERVISOR_READ), rs.getString(SUPERVISOR_WRITE)));
				mParam.setManagerAccess(getRoleAccess(rs.getString(MANAGER_READ), rs.getString(MANAGER_WRITE)));
				mParam.setAdminAccess(getRoleAccess(rs.getString(ADMIN_READ), rs.getString(ADMIN_WRITE)));

				mGroupParam.setGroupParams(sStage, mParam);
				mGroupParam.setParamUnit(sUnit);
				mGroupParam.setDisplayOrder(iDispOrder);

				mParams.put(sGroup, mGroupParam);
			}

			close(rs);

			selectString = "select * from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN where SINGLEROOM_VIEW = 'Y'"
					+ " and CNTRL_TYPE = '" + cntrlType + "' and (PARAM_GROUP IS NULL or PARAM_GROUP = '')"
					+ " ORDER BY DISPLAY_ORDER,PARAM_NAME ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sName = rs.getString(PARAM_NAME);
				sStage = rs.getString(STAGE_NAME);

				ParamSettings mParam = mParams.get(sName);
				if (mParam == null) {
					mParam = new ParamSettings(sName);
				} else {
					sStage = "NA";
				}

				mParam.setStage(sStage);
				mParam.setDisplayOrder(rs.getInt(DISPLAY_ORDER));
				mParam.setParamGroup(rs.getString(PARAM_GROUP));
				mParam.setParamUnit(rs.getString(PARAM_UNIT));

				mParam.setHelperAccess(getRoleAccess(rs.getString(HELPER_READ), rs.getString(HELPER_WRITE)));
				mParam.setSupervisorAccess(
						getRoleAccess(rs.getString(SUPERVISOR_READ), rs.getString(SUPERVISOR_WRITE)));
				mParam.setManagerAccess(getRoleAccess(rs.getString(MANAGER_READ), rs.getString(MANAGER_WRITE)));
				mParam.setAdminAccess(getRoleAccess(rs.getString(ADMIN_READ), rs.getString(ADMIN_WRITE)));

				mParams.put(sName, mParam);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mParams;
	}

	public Map<String, Integer> getGraphScale(String sCntrlType) throws SQLException, InterruptedException {
		Map<String, Integer> mGraphScale = new HashMap<String, Integer>();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			String sParamsAdminTab = (sCntrlType.startsWith("General") ? "GENERAL_PARAMS_ADMIN"
					: "CONTROLLER_PARAMS_ADMIN");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select PARAM_NAME,SCALE_ON_GRAPH from " + SCHEMA_NAME + "." + sParamsAdminTab
					+ " where SCALE_ON_GRAPH > 1";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				mGraphScale.put(rs.getString(PARAM_NAME), Integer.valueOf(rs.getInt(SCALE_ON_GRAPH)));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mGraphScale;
	}

	public Map<String, String> getParamInfo(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> map = new HashMap<String, String>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			boolean bGeneral = cntrlType.startsWith("General.");

			String sTable = null;
			String selectString = "select param_name, param_info ";
			if (bGeneral) {
				sTable = "GENERAL_PARAMS_ADMIN";
			} else {
				sTable = "CONTROLLER_PARAMS_ADMIN";
				selectString += ", param_group ";
			}
			selectString += "from " + SCHEMA_NAME + "." + sTable + " where CNTRL_TYPE = '" + cntrlType + "'";

			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				String sParamInfo = rs.getString(PARAM_INFO);
				if (RDMServicesUtils.isNullOrEmpty(sParamInfo)) {
					continue;
				}

				String sParamGroup = bGeneral ? null : rs.getString(PARAM_GROUP);
				if (RDMServicesUtils.isNotNullAndNotEmpty(sParamGroup)) {
					map.put(sParamGroup, sParamInfo);
				} else {
					String sParamName = rs.getString(PARAM_NAME);
					map.put(sParamName, sParamInfo);
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return map;
	}

	public Map<String, ParamSettings> getAdminSettings(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, ParamSettings> map = new HashMap<String, ParamSettings>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sName = null;
			String selectString = "select * from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN where CNTRL_TYPE = '"
					+ cntrlType + "'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sName = rs.getString(PARAM_NAME);

				ParamSettings mParam = new ParamSettings(sName);
				mParam.setDisplayOrder(rs.getInt(DISPLAY_ORDER));
				mParam.setOnOffValue(rs.getString(ON_OFF_VALUE));
				mParam.setResetValue(rs.getString(RESET_VALUE));
				mParam.setStage(rs.getString(STAGE_NAME));
				mParam.setRoomsOverview(rs.getString(ROOMS_OVERVIEW));
				mParam.setMultiRoomView(rs.getString(MULTIROOMS_VIEW));
				mParam.setSingleRoomView(rs.getString(SINGLEROOM_VIEW));
				mParam.setGraphView(rs.getString(GRAPH_VIEW));
				mParam.setHelperRead(rs.getString(HELPER_READ));
				mParam.setHelperWrite(rs.getString(HELPER_WRITE));
				mParam.setSupervisorRead(rs.getString(SUPERVISOR_READ));
				mParam.setSupervisorWrite(rs.getString(SUPERVISOR_WRITE));
				mParam.setManagerRead(rs.getString(MANAGER_READ));
				mParam.setManagerWrite(rs.getString(MANAGER_WRITE));
				mParam.setAdminRead(rs.getString(ADMIN_READ));
				mParam.setAdminWrite(rs.getString(ADMIN_WRITE));
				mParam.setScaleOnGraph(rs.getInt(SCALE_ON_GRAPH));
				mParam.setParamUnit(rs.getString(PARAM_UNIT));
				mParam.setParamInfo(rs.getString(PARAM_INFO));

				map.put(sName, mParam);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return map;
	}

	public ArrayList<String[]> getControllerStages() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String[] saStage = null;
		ArrayList<String[]> alStages = new ArrayList<String[]>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String seqNum = "";
			String stageName = "";

			String selectString = "select * from " + SCHEMA_NAME + ".STAGE_INFO ORDER BY " + SCHEMA_NAME
					+ ".sort_alphanumeric(STAGE_NUMBER)";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				seqNum = rs.getString(STAGE_NUMBER);

				stageName = rs.getString(STAGE_NAME);
				stageName = ((stageName == null || "".equals(stageName)) ? seqNum : stageName);

				saStage = new String[3];
				saStage[0] = seqNum;
				saStage[1] = stageName;
				saStage[2] = rs.getString(CNTRL_TYPE);

				alStages.add(saStage);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return alStages;
	}

	public boolean updateAdminSettings(MapList mlParamSettings) throws Throwable {
		Connection conn = null;
		PreparedStatement pstmt = null;
		Map<String, String> map = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			sbUpdate.append("update " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN set ");
			sbUpdate.append("DISPLAY_ORDER = ?, ");
			sbUpdate.append("STAGE_NAME = ?, ");
			sbUpdate.append("ROOMS_OVERVIEW = ?, ");
			sbUpdate.append("MULTIROOMS_VIEW = ?, ");
			sbUpdate.append("SINGLEROOM_VIEW = ?, ");
			sbUpdate.append("GRAPH_VIEW = ?, ");
			sbUpdate.append("HELPER_READ = ?, ");
			sbUpdate.append("HELPER_WRITE = ?, ");
			sbUpdate.append("SUPERVISOR_READ = ?, ");
			sbUpdate.append("SUPERVISOR_WRITE = ?, ");
			sbUpdate.append("MANAGER_READ = ?, ");
			sbUpdate.append("MANAGER_WRITE = ?, ");
			sbUpdate.append("ADMIN_READ = ?, ");
			sbUpdate.append("ADMIN_WRITE = ?, ");
			sbUpdate.append("SCALE_ON_GRAPH = ?, ");
			sbUpdate.append("PARAM_GROUP = ?, ");
			sbUpdate.append("PARAM_UNIT = ?, ");
			sbUpdate.append("ON_OFF_VALUE = ?, ");
			sbUpdate.append("RESET_VALUE = ?, ");
			sbUpdate.append("PARAM_INFO = ?");
			sbUpdate.append(" where ");
			sbUpdate.append("PARAM_NAME = ?");
			sbUpdate.append(" and ");
			sbUpdate.append("CNTRL_TYPE = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			String sDisplayOrder;
			String sGraphScale;
			String sParamUnit;
			String sParamInfo;
			int iDisplayOrder;
			int iGraphScale;
			for (int i = 0, iSz = mlParamSettings.size(); i < iSz; i++) {
				map = mlParamSettings.get(i);

				sDisplayOrder = map.get(DISPLAY_ORDER);
				sDisplayOrder = ((sDisplayOrder == null || "".equals(sDisplayOrder)) ? "0" : sDisplayOrder);
				iDisplayOrder = Integer.parseInt(sDisplayOrder);
				iDisplayOrder = ((iDisplayOrder < 0) ? 0 : iDisplayOrder);

				sGraphScale = map.get(SCALE_ON_GRAPH);
				sGraphScale = ((sGraphScale == null || "".equals(sGraphScale)) ? "1" : sGraphScale);
				iGraphScale = Integer.parseInt(sGraphScale);
				iGraphScale = ((iGraphScale < 1) ? 1 : iGraphScale);

				sParamUnit = map.get(PARAM_UNIT);
				sParamUnit = ((sParamUnit == null || "null".equals(sParamUnit)) ? "" : sParamUnit);

				sParamInfo = map.get(PARAM_INFO);
				sParamInfo = ((sParamInfo == null || "N".equals(sParamInfo)) ? "" : sParamInfo);

				pstmt.setInt(1, iDisplayOrder);
				pstmt.setString(2, map.get(STAGE_NAME));
				pstmt.setString(3, map.get(ROOMS_OVERVIEW));
				pstmt.setString(4, map.get(MULTIROOMS_VIEW));
				pstmt.setString(5, map.get(SINGLEROOM_VIEW));
				pstmt.setString(6, map.get(GRAPH_VIEW));
				pstmt.setString(7, map.get(HELPER_READ));
				pstmt.setString(8, map.get(HELPER_WRITE));
				pstmt.setString(9, map.get(SUPERVISOR_READ));
				pstmt.setString(10, map.get(SUPERVISOR_WRITE));
				pstmt.setString(11, map.get(MANAGER_READ));
				pstmt.setString(12, map.get(MANAGER_WRITE));
				pstmt.setString(13, map.get(ADMIN_READ));
				pstmt.setString(14, map.get(ADMIN_WRITE));
				pstmt.setInt(15, iGraphScale);
				pstmt.setString(16, map.get(PARAM_GROUP));
				pstmt.setString(17, sParamUnit);
				pstmt.setString(18, map.get(ON_OFF_VALUE));
				pstmt.setString(19, map.get(RESET_VALUE));
				pstmt.setString(20, sParamInfo);
				pstmt.setString(21, map.get(PARAM_NAME));
				pstmt.setString(22, map.get(CNTRL_TYPE));
				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
			RDMServicesUtils.setViewParamaters(map.get(CNTRL_TYPE));
		}
		return true;
	}

	public boolean insertAdminSettings(MapList mlParamSettings) throws Throwable {
		Connection conn = null;
		PreparedStatement pstmt = null;
		Map<String, String> map = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			sbInsert.append("insert into " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN (");
			sbInsert.append(
					"PARAM_NAME, DISPLAY_ORDER, STAGE_NAME, ROOMS_OVERVIEW, MULTIROOMS_VIEW, SINGLEROOM_VIEW, GRAPH_VIEW, "
							+ "HELPER_READ, HELPER_WRITE, SUPERVISOR_READ, SUPERVISOR_WRITE, MANAGER_READ, MANAGER_WRITE, ADMIN_READ, ADMIN_WRITE, "
							+ "SCALE_ON_GRAPH, PARAM_GROUP, PARAM_UNIT, ON_OFF_VALUE, RESET_VALUE, CNTRL_TYPE, PARAM_INFO) "
							+ "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbInsert.toString());

			String sDisplayOrder;
			String sGraphScale;
			String sParamUnit;
			String sParamInfo;
			int iDisplayOrder;
			int iGraphScale;
			for (int i = 0, iSz = mlParamSettings.size(); i < iSz; i++) {
				map = mlParamSettings.get(i);

				sDisplayOrder = map.get(DISPLAY_ORDER);
				sDisplayOrder = ((sDisplayOrder == null || "".equals(sDisplayOrder)) ? "0" : sDisplayOrder);
				iDisplayOrder = Integer.parseInt(sDisplayOrder);
				iDisplayOrder = ((iDisplayOrder < 0) ? 0 : iDisplayOrder);

				sGraphScale = map.get(SCALE_ON_GRAPH);
				sGraphScale = ((sGraphScale == null || "".equals(sGraphScale)) ? "1" : sGraphScale);
				iGraphScale = Integer.parseInt(sGraphScale);
				iGraphScale = ((iGraphScale < 1) ? 1 : iGraphScale);

				sParamUnit = map.get(PARAM_UNIT);
				sParamUnit = ((sParamUnit == null || "null".equals(sParamUnit)) ? "" : sParamUnit);

				sParamInfo = map.get(PARAM_INFO);
				sParamInfo = ((sParamInfo == null || "N".equals(sParamInfo)) ? "" : sParamInfo);

				pstmt.setString(1, map.get(PARAM_NAME));
				pstmt.setInt(2, iDisplayOrder);
				pstmt.setString(3, map.get(STAGE_NAME));
				pstmt.setString(4, map.get(ROOMS_OVERVIEW));
				pstmt.setString(5, map.get(MULTIROOMS_VIEW));
				pstmt.setString(6, map.get(SINGLEROOM_VIEW));
				pstmt.setString(7, map.get(GRAPH_VIEW));
				pstmt.setString(8, map.get(HELPER_READ));
				pstmt.setString(9, map.get(HELPER_WRITE));
				pstmt.setString(10, map.get(SUPERVISOR_READ));
				pstmt.setString(11, map.get(SUPERVISOR_WRITE));
				pstmt.setString(12, map.get(MANAGER_READ));
				pstmt.setString(13, map.get(MANAGER_WRITE));
				pstmt.setString(14, map.get(ADMIN_READ));
				pstmt.setString(15, map.get(ADMIN_WRITE));
				pstmt.setInt(16, iGraphScale);
				pstmt.setString(17, map.get(PARAM_GROUP));
				pstmt.setString(18, sParamUnit);
				pstmt.setString(19, map.get(ON_OFF_VALUE));
				pstmt.setString(20, map.get(RESET_VALUE));
				pstmt.setString(21, map.get(CNTRL_TYPE));
				pstmt.setString(22, sParamInfo);
				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbInsert = null;
			RDMServicesUtils.setViewParamaters(map.get(CNTRL_TYPE));
		}

		return true;
	}

	public boolean deleteAdminSettings(String sParams, String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			if (sParams == null || "".equals(sParams)) {
				return true;
			}

			String sQuery = "delete from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN " + "where CNTRL_TYPE = '"
					+ cntrlType + "' and PARAM_NAME IN ( " + sParams + " )";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
		return true;
	}

	public StringList getManualParams(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringList slParams = new StringList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sParam = null;
			String selectString = "select PARAM_NAME,PARAM_GROUP from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN"
					+ " where CNTRL_TYPE = '" + cntrlType + "' and PARAM_NAME LIKE '%manual%' and PARAM_UNIT = ''";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sParam = rs.getString(PARAM_GROUP);
				if (sParam == null || "".equals(sParam)) {
					sParam = rs.getString(PARAM_NAME);
				}
				slParams.add(sParam);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return slParams;
	}

	public StringList getCoolingSteamParams(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringList slParams = new StringList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sParam = null;
			String selectString = "select PARAM_NAME,PARAM_GROUP from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN"
					+ " where CNTRL_TYPE = '" + cntrlType
					+ "' and (PARAM_NAME LIKE 'cooling%' or PARAM_NAME LIKE 'steam%') and PARAM_UNIT = ''";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sParam = rs.getString(PARAM_GROUP);
				if (sParam == null || "".equals(sParam)) {
					sParam = rs.getString(PARAM_NAME);
				}

				if (!sParam.contains("manual")) {
					slParams.add(sParam);
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return slParams;
	}

	public StringList getCompErrorParams(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringList slParams = new StringList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sName = null;
			String selectString = "select PARAM_NAME from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN"
					+ " where CNTRL_TYPE = '" + cntrlType + "' and PARAM_NAME LIKE 'comp%error'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sName = rs.getString(PARAM_NAME);
				slParams.add(sName);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return slParams;
	}

	public void saveParameters(String sController, java.sql.Date date, java.sql.Time time,
			Map<String, String[]> mParams) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String value;

		try {
			boolean isGeneral = isGeneralController(sController);
			boolean fg1 = false;
			boolean fg2 = false;
			String sParam = "";
			String sColParam = "";

			StringBuilder sbCols = new StringBuilder();
			StringBuilder sbVals = new StringBuilder();
			StringBuilder sbNewCols = new StringBuilder();
			StringList slParams = new StringList();
			StringList slCols = new StringList();

			String roomTable = sController.replace(" ", "") + "_param_data";
			StringList slColParams = getColumnParameters(roomTable);

			Iterator<String> itr = mParams.keySet().iterator();
			while (itr.hasNext()) {
				sParam = itr.next();

				sColParam = new String(sParam);
				sColParam = sColParam.replace(" ", "_").trim();

				if (!"".equals(sColParam) && !slColParams.contains(sColParam.toUpperCase())) {
					if (fg1) {
						sbNewCols.append(", ");
					}

					sbNewCols.append("ADD COLUMN ");
					sbNewCols.append(sColParam);
					sbNewCols.append(" ");
					sbNewCols.append("character varying");

					slColParams.add(sColParam.toUpperCase());
					fg1 = true;
				}

				if (!slCols.contains(sParam.toUpperCase())) {
					if (fg2) {
						sbCols.append(", ");
						sbVals.append(", ");
					}

					sbCols.append(sColParam);
					sbVals.append("?");

					slParams.add(sParam);
					slCols.add(sParam.toUpperCase());
					fg2 = true;
				}
			}

			if (sbNewCols.length() > 0) {
				String sQuery = "ALTER TABLE " + SCHEMA_NAME + "." + roomTable + " " + sbNewCols.toString();
				addColumnParameters(sController, sQuery);
			}

			String sInsertStmt = "";
			if (isGeneral) {
				sInsertStmt = "insert into " + SCHEMA_NAME + "." + roomTable + " (LOG_DATE, LOG_TIME, "
						+ sbCols.toString() + ") values (?, ?, " + sbVals.toString() + ")";
			} else {
				sInsertStmt = "insert into " + SCHEMA_NAME + "." + roomTable + " (LOG_DATE, LOG_TIME, BATCH_NO, "
						+ sbCols.toString() + ") values (?, ?, ?, " + sbVals.toString() + ")";
			}

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sInsertStmt);

			int i = 3;
			pstmt.setDate(1, date);
			pstmt.setTime(2, time);

			if (!isGeneral) {
				pstmt.setString(3, getBatchNo(sController));
				i++;
			}

			for (int x = 0; x < slParams.size(); x++) {
				value = mParams.get(slParams.get(x))[0];
				pstmt.setString(i, value);

				i++;
			}

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public StringList getColumnParameters(String sTable) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringList slParams = new StringList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "select column_name from information_schema.columns where UPPER(table_name)='"
					+ sTable.toUpperCase() + "'";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				String columnName = rs.getString("column_name");
				slParams.add(columnName.toUpperCase());
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return slParams;
	}

	public boolean addColumnParameters(String sController, String sQuery) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			stmt.executeUpdate(sQuery);
		} catch (SQLException | InterruptedException e) {
			System.out.println("Exp in addColumnParameters [" + sController + "] : " + e.getMessage());
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public String getControllerParameters(String sController, String[] saParams, String startDate, String endDate,
			boolean bYield, boolean bExport) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		String sGraphData = "";
		StringBuilder sbParams = new StringBuilder();
		StringBuilder sbParamValues = new StringBuilder();

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");

			String sCntrlType = RDMServicesUtils.getControllerType(sController);
			boolean bIsNotGeneral = !sCntrlType.startsWith("General");

			sbParams.append("LOG_DATE");
			sbParams.append(",");
			sbParams.append("LOG_TIME");

			sbParamValues.append("Date");

			Map<String, String> mYield = new HashMap<String, String>();
			if (bIsNotGeneral) {
				if (bExport) {
					sbParams.append(",");
					sbParams.append("BATCH_NO");

					sbParamValues.append(",");
					sbParamValues.append("Batch No");
				}

				if (bYield) {
					sbParamValues.append(",");
					sbParamValues.append("Yield");

					Map<String, String> mTemp = null;
					MapList mlYields = getYields(sController, startDate, endDate, "", "", "", true, true);
					for (int i = 0; i < mlYields.size(); i++) {
						mTemp = mlYields.get(i);
						mYield.put(mTemp.get(ON_DATE), mTemp.get(DAILY_YIELD));
					}
				}
			}

			int iSz = saParams.length;
			String sParam = "";
			String sValue = "";
			String BNo = "";
			String sLogDate = "";
			for (int i = 0; i < iSz; i++) {
				sParam = saParams[i];
				sbParamValues.append(",");
				sbParamValues.append(sParam);
				sbParams.append(",");
				sbParams.append(sParam.replace(" ", "_"));
			}
			sbParamValues.append("\n");

			int iGraphScale = 1;
			int iYieldScale = RDMServicesUtils.getGraphYieldScale();
			Map<String, Integer> mGraphScale = RDMServicesUtils.getGraphScale(sCntrlType);
			StringList slOnOffValues = getOnOffParams(sCntrlType);
			StringList slManualParams = getManualParams(sCntrlType);

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String roomTable = sController.replace(" ", "") + "_param_data";
			String selectString = "select " + sbParams.toString() + " from " + SCHEMA_NAME + "." + roomTable
					+ " where LOG_DATE BETWEEN '" + startDate + "' AND '" + endDate
					+ "' order by LOG_DATE asc, LOG_TIME asc";

			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sLogDate = bExport ? sdf.format(rs.getDate(LOG_DATE))
						: RDMServicesUtils.dateToShortString(rs.getDate("LOG_DATE"));
				sbParamValues.append(sLogDate);
				sbParamValues.append(" ");
				sbParamValues.append(RDMServicesUtils.timeToShortString(rs.getTime("LOG_TIME")));

				if (bIsNotGeneral) {
					if (bExport) {
						BNo = rs.getString(BATCH_NO);
						BNo = ((BNo == null) ? "" : BNo);
						sbParamValues.append(",");
						sbParamValues.append(BNo);
					}

					if (bYield) {
						if (mYield.containsKey(sLogDate)) {
							sbParamValues.append(",");
							if (bExport) {
								sbParamValues.append(mYield.get(sLogDate));
							} else {
								sbParamValues.append(
										Double.toString(Double.parseDouble(mYield.get(sLogDate)) / iYieldScale));
							}
						} else {
							sbParamValues.append(",");
							sbParamValues.append("0");
						}
					}
				}

				for (int i = 0; i < iSz; i++) {
					sParam = saParams[i];
					sValue = rs.getString(sParam.replace(" ", "_"));

					if (bExport) {
						if (slOnOffValues.contains(sParam) || slManualParams.contains(sParam)) {
							if (sParam.contains("door.open")) {
								if ("1".equals(sValue) || "On".equals(sValue)) {
									sValue = "Open";
								} else if ("0".equals(sValue) || "Off".equals(sValue)) {
									sValue = "Close";
								}
							} else if ("1".equals(sValue)) {
								sValue = "On";
							} else if ("0".equals(sValue)) {
								sValue = "Off";
							}
						}
					} else {
						try {
							if ("On".equals(sValue)) {
								sValue = "1";
							} else if ("Off".equals(sValue)) {
								sValue = "0";
							}

							iGraphScale = (mGraphScale.containsKey(sParam) ? mGraphScale.get(sParam).intValue() : 1);
							iGraphScale = ((iGraphScale < 1) ? 1 : iGraphScale);
							sValue = Double.toString(Double.parseDouble(sValue) / iGraphScale);
						} catch (Exception ex) {
							// do nothing
						}
					}

					sbParamValues.append(",");
					sbParamValues.append(sValue);
				}
				sbParamValues.append("\n");
			}

			sGraphData = sbParamValues.toString();
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbParams = null;
			sbParamValues = null;
		}

		return sGraphData;
	}

	public Map<String, String> isUserExists(String name, String password) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> mUserInfo = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			Date date = null;
			String sDateofJoin = null;
			String sDateofBirth = null;
			String sHomePage = null;

			String selectString = "select * from " + SCHEMA_NAME + ".USER_INFO where USER_ID = '" + name + "'";
			if (!("PUSH_CONTEXT".equals(password) || "RESET_CONTEXT".equals(password))) {
				selectString += " and PASSWORD = '" + password + "'";
			}

			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				mUserInfo = new HashMap<String, String>();

				date = rs.getDate(DATE_OF_JOIN);
				sDateofJoin = (date == null ? "" : date.toString());

				date = rs.getDate(DATE_OF_BIRTH);
				sDateofBirth = (date == null ? "" : date.toString());

				sHomePage = rs.getString(HOME_PAGE);
				sHomePage = (sHomePage == null ? "" : sHomePage);

				mUserInfo.put(FIRST_NAME, rs.getString(FIRST_NAME));
				mUserInfo.put(LAST_NAME, rs.getString(LAST_NAME));
				mUserInfo.put(ROLE_NAME, rs.getString(ROLE_NAME));
				mUserInfo.put(EMAIL, rs.getString(EMAIL));
				mUserInfo.put(DEPARTMENT_NAME, rs.getString(DEPARTMENT_NAME));
				mUserInfo.put(GROUP_NAME, rs.getString(GROUP_NAME));
				mUserInfo.put(GENDER, rs.getString(GENDER));
				mUserInfo.put(ADDRESS, rs.getString(ADDRESS));
				mUserInfo.put(CONTACT_NO, rs.getString(CONTACT_NO));
				mUserInfo.put(DATE_OF_BIRTH, sDateofBirth);
				mUserInfo.put(DATE_OF_JOIN, sDateofJoin);
				mUserInfo.put(BLOCKED, rs.getString(BLOCKED));
				mUserInfo.put(HOME_PAGE, sHomePage);
				mUserInfo.put(MANAGE_USERS, rs.getString(MANAGE_USERS));
				mUserInfo.put(MANAGE_ALARMS, rs.getString(MANAGE_ALARMS));
				mUserInfo.put(LOCALE, rs.getString(LOCALE));
				mUserInfo.put(QUALIFICATION, rs.getString(QUALIFICATION));
				mUserInfo.put(DESIGNATION, rs.getString(DESIGNATION));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mUserInfo;
	}

	public Map<String, String> getUserSavedGraphs(String name) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> mGraphs = new HashMap<String, String>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select * from " + SCHEMA_NAME + ".SAVED_GRAPHS where USER_ID = '" + name
					+ "' or GLOBAL_ACCESS = TRUE";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				mGraphs.put(rs.getString("GRAPH_NAME"), rs.getString("RM_ID") + "|" + rs.getString("PARAMETERS"));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mGraphs;
	}

	public boolean saveGraphParams(String user, String name, String room, String sParams, boolean isPublic)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sb = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			int cnt = 0;
			String selectString = "select COUNT(*) from " + SCHEMA_NAME + ".SAVED_GRAPHS where GRAPH_NAME = '" + name
					+ "' and (USER_ID = '" + user + "' or GLOBAL_ACCESS = TRUE)";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				cnt = rs.getInt(1);
			}

			if (cnt > 0) {
				sb.append("update " + SCHEMA_NAME + ".SAVED_GRAPHS set");
				sb.append(" RM_ID = '" + room + "',");
				sb.append(" PARAMETERS = '" + sParams + "',");
				sb.append(" USER_ID = '" + user + "',");
				sb.append(" GLOBAL_ACCESS = " + (isPublic ? "TRUE" : "FALSE"));
				sb.append(" where (USER_ID = '" + user + "' or GLOBAL_ACCESS = TRUE)");
				sb.append(" and GRAPH_NAME = '" + name + "'");
			} else {
				sb.append("insert into " + SCHEMA_NAME + ".SAVED_GRAPHS (");
				sb.append("USER_ID, GRAPH_NAME, RM_ID, PARAMETERS, GLOBAL_ACCESS");
				sb.append(") values ('" + user + "', '" + name + "', '" + room + "', '" + sParams + "', "
						+ (isPublic ? "TRUE" : "FALSE") + ")");
			}

			stmt.executeUpdate(sb.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sb = null;
		}

		return true;
	}

	public boolean deleteSavedGraph(String user, String name) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "delete from " + SCHEMA_NAME + ".SAVED_GRAPHS where USER_ID = '" + user
					+ "' and GRAPH_NAME = '" + name + "'";
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	private String getRoleAccess(String sRead, String sWrite) {
		if ("Y".equals(sWrite)) {
			return ACCESS_WRITE;
		} else if ("Y".equals(sRead)) {
			return ACCESS_READ;
		}

		return ACCESS_NONE;
	}

	public MapList getUserList() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlUsers = new MapList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			Date date = null;
			String sDateofJoin = null;
			String sDateofBirth = null;
			String sDept = null;
			String sGroup = null;
			String sHomePage = null;
			String sQualification = null;
			String sDesignation = null;

			String selectString = "select * from " + SCHEMA_NAME
					+ ".USER_INFO where USER_ID != 'SYSTEM' ORDER BY USER_ID ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				Map<String, String> mUser = new HashMap<String, String>();
				sDept = rs.getString(DEPARTMENT_NAME);
				sDept = (sDept == null) ? "" : sDept;

				sGroup = rs.getString(GROUP_NAME);
				sGroup = (sGroup == null) ? "" : sGroup;

				date = rs.getDate(DATE_OF_JOIN);
				sDateofJoin = (date == null ? "" : date.toString());

				date = rs.getDate(DATE_OF_BIRTH);
				sDateofBirth = (date == null ? "" : date.toString());

				sHomePage = rs.getString(HOME_PAGE);
				sHomePage = (sHomePage == null ? "" : sHomePage);

				sQualification = rs.getString(QUALIFICATION);
				sQualification = (sQualification == null ? "" : sQualification);

				sDesignation = rs.getString(DESIGNATION);
				sDesignation = (sDesignation == null ? "" : sDesignation);

				mUser.put(USER_ID, rs.getString(USER_ID));
				mUser.put(FIRST_NAME, rs.getString(FIRST_NAME));
				mUser.put(LAST_NAME, rs.getString(LAST_NAME));
				mUser.put(EMAIL, rs.getString(EMAIL));
				mUser.put(ROLE_NAME, rs.getString(ROLE_NAME));
				mUser.put(DEPARTMENT_NAME, sDept);
				mUser.put(GROUP_NAME, sGroup);
				mUser.put(GENDER, rs.getString(GENDER));
				mUser.put(ADDRESS, rs.getString(ADDRESS));
				mUser.put(CONTACT_NO, rs.getString(CONTACT_NO));
				mUser.put(DATE_OF_BIRTH, sDateofBirth);
				mUser.put(DATE_OF_JOIN, sDateofJoin);
				mUser.put(BLOCKED, rs.getString(BLOCKED));
				mUser.put(HOME_PAGE, sHomePage);
				mUser.put(MANAGE_USERS, rs.getString(MANAGE_USERS));
				mUser.put(MANAGE_ALARMS, rs.getString(MANAGE_ALARMS));
				mUser.put(LOCALE, rs.getString(LOCALE));
				mUser.put(QUALIFICATION, sQualification);
				mUser.put(DESIGNATION, sDesignation);

				mlUsers.add(mUser);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlUsers;
	}

	public boolean updateUser(String userId, Map<String, String> mInfo)
			throws SQLException, InterruptedException, ParseException {
		Connection conn = null;
		Statement stmt = null;
		StringBuilder sbUpdate = new StringBuilder();
		SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
		SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			boolean bFlag = false;
			sbUpdate.append("update " + SCHEMA_NAME + ".USER_INFO set ");

			String sPassword = mInfo.get(PASSWORD);
			sPassword = (sPassword == null ? "" : sPassword);
			if (!"".equals(sPassword)) {
				sbUpdate.append(PASSWORD + " = '" + mInfo.get(PASSWORD) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(USER_ID)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(USER_ID + " = '" + mInfo.get(USER_ID) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(FIRST_NAME)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(FIRST_NAME + " = '" + mInfo.get(FIRST_NAME) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(LAST_NAME)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(LAST_NAME + " = '" + mInfo.get(LAST_NAME) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(EMAIL)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(EMAIL + " = '" + mInfo.get(EMAIL) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(ROLE_NAME)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(ROLE_NAME + " = '" + mInfo.get(ROLE_NAME) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(DEPARTMENT_NAME)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(DEPARTMENT_NAME + " = '" + mInfo.get(DEPARTMENT_NAME) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(GROUP_NAME)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(GROUP_NAME + " = '" + mInfo.get(GROUP_NAME) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(GENDER)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(GENDER + " = '" + mInfo.get(GENDER) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(ADDRESS)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(ADDRESS + " = '" + mInfo.get(ADDRESS) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(CONTACT_NO)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(CONTACT_NO + " = '" + mInfo.get(CONTACT_NO) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(DATE_OF_BIRTH)) {
				String sDOB = mInfo.get(DATE_OF_BIRTH);
				if (!"".equals(sDOB)) {
					if (bFlag) {
						sbUpdate.append(",");
					}

					sbUpdate.append(DATE_OF_BIRTH + " = '" + output.format(input.parse(sDOB)) + "'");
					bFlag = true;
				}
			}
			if (mInfo.containsKey(DATE_OF_JOIN)) {
				String sDOJ = mInfo.get(DATE_OF_JOIN);
				if (!"".equals(sDOJ)) {
					if (bFlag) {
						sbUpdate.append(",");
					}

					sbUpdate.append(DATE_OF_JOIN + " = '" + output.format(input.parse(sDOJ)) + "'");
					bFlag = true;
				}
			}
			if (mInfo.containsKey(HOME_PAGE)) {
				if (bFlag) {
					sbUpdate.append(",");
				}

				sbUpdate.append(HOME_PAGE + " = '" + mInfo.get(HOME_PAGE) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(LOCALE)) {
				if (bFlag) {
					sbUpdate.append(",");
				}

				sbUpdate.append(LOCALE + " = '" + mInfo.get(LOCALE) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(MANAGE_USERS)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(MANAGE_USERS + " = '" + mInfo.get(MANAGE_USERS) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(MANAGE_ALARMS)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(MANAGE_ALARMS + " = '" + mInfo.get(MANAGE_ALARMS) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(QUALIFICATION)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(QUALIFICATION + " = '" + mInfo.get(QUALIFICATION) + "'");
				bFlag = true;
			}
			if (mInfo.containsKey(DESIGNATION)) {
				if (bFlag) {
					sbUpdate.append(",");
				}
				sbUpdate.append(DESIGNATION + " = '" + mInfo.get(DESIGNATION) + "'");
				bFlag = true;
			}

			sbUpdate.append(" where USER_ID = '" + userId + "'");

			stmt.executeUpdate(sbUpdate.toString());
		} finally {
			close(stmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	public boolean addUser(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();
		SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
		SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sUserId = mInfo.get(USER_ID);

			String sQuery = "SELECT USER_ID FROM " + SCHEMA_NAME + ".USER_INFO WHERE UPPER(USER_ID) = UPPER('" + sUserId
					+ "')";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				throw new SQLException("User " + sUserId + " already exists in the system.");
			}

			String sDOB = mInfo.get(DATE_OF_BIRTH);
			if (!"".equals(sDOB)) {
				sDOB = output.format(input.parse(sDOB));
			}

			String sDOJ = mInfo.get(DATE_OF_JOIN);
			if (!"".equals(sDOJ)) {
				sDOJ = output.format(input.parse(sDOJ));
			}

			sbInsert.append("insert into " + SCHEMA_NAME + ".USER_INFO (");
			sbInsert.append("USER_ID,PASSWORD,FIRST_NAME,LAST_NAME,EMAIL,ROLE_NAME,");
			sbInsert.append("DEPARTMENT_NAME,GROUP_NAME,GENDER,ADDRESS,CONTACT_NO,BLOCKED,");
			sbInsert.append("LOCALE,MANAGE_USERS,MANAGE_ALARMS,QUALIFICATION,DESIGNATION");
			if (!"".equals(sDOJ)) {
				sbInsert.append(",DATE_OF_JOIN");
			}
			if (!"".equals(sDOB)) {
				sbInsert.append(",DATE_OF_BIRTH");
			}

			sbInsert.append(") values ('");
			sbInsert.append(sUserId);
			sbInsert.append("','");
			sbInsert.append(mInfo.get(PASSWORD));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(FIRST_NAME));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(LAST_NAME));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(EMAIL));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(ROLE_NAME));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(DEPARTMENT_NAME));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(GROUP_NAME));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(GENDER));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(ADDRESS));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(CONTACT_NO));
			sbInsert.append("','N','");
			sbInsert.append(mInfo.get(LOCALE));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(MANAGE_USERS));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(MANAGE_ALARMS));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(QUALIFICATION));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(DESIGNATION));

			if (!"".equals(sDOJ)) {
				sbInsert.append("','");
				sbInsert.append(sDOJ);
			}
			if (!"".equals(sDOB)) {
				sbInsert.append("','");
				sbInsert.append(sDOB);
			}
			sbInsert.append("')");

			stmt.executeUpdate(sbInsert.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	public boolean deleteUser(String userId) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".USER_INFO where USER_ID = '" + userId + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
		return true;
	}

	public boolean updateUserStatus(String userId, String status) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "update " + SCHEMA_NAME + ".USER_INFO set BLOCKED = '" + status + "' where USER_ID = '"
					+ userId + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
		return true;
	}

	public void saveAlarmLogs(String sController, MapList mControllerAlarms) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			boolean bNotify = false;
			boolean bNotGeneral = !isGeneralController(sController);
			double dStage = 0;
			String sInsertStmt = "";
			String sBatchNo = "";
			String sAlarm = "";

			if (bNotGeneral) {
				sInsertStmt = "insert into " + SCHEMA_NAME + ".ALARM_HISTORY ("
						+ "RM_ID, SERIAL_ID, TEXT, OCCURED_ON, ACCEPTED, ACCEPTED_BY, MUTED_ON, MUTED_BY, CLEARED_ON, "
						+ "NOTIFY_ALARM, LEVEL1_ATTEMPTS, LEVEL2_ATTEMPTS, LEVEL3_ATTEMPTS, STAGE_NUMBER, BATCH_NO"
						+ ") values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

				String sStage = getCurrentStage(sController);
				if (sStage != null && !"".equals(sStage)) {
					dStage = Double.parseDouble(sStage.replace(" ", "."));
				}

				sBatchNo = getBatchNo(sController);
			} else {
				sInsertStmt = "insert into " + SCHEMA_NAME + ".ALARM_HISTORY ("
						+ "RM_ID, SERIAL_ID, TEXT, OCCURED_ON, ACCEPTED, ACCEPTED_BY, MUTED_ON, MUTED_BY, "
						+ "CLEARED_ON, NOTIFY_ALARM, LEVEL1_ATTEMPTS, LEVEL2_ATTEMPTS, LEVEL3_ATTEMPTS"
						+ ") values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			}

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sInsertStmt);

			String sCntrlType = RDMServicesUtils.getControllerType(sController);
			if (sCntrlType.startsWith("General")) {
				sCntrlType = sCntrlType.substring(8);
			}

			NotifyAlarms notifyAlarms = new NotifyAlarms();
			Map<String, Map<String, String>> mNotifyAlarms = notifyAlarms.listNotificationAlarms(sCntrlType);

			Map<String, String> mAlarm = null;
			for (int i = 0, iSz = mControllerAlarms.size(); i < iSz; i++) {
				mAlarm = mControllerAlarms.get(i);
				sAlarm = mAlarm.get(ALARM_TEXT).replace(".", " ");

				pstmt.setString(1, sController);
				pstmt.setString(2, mAlarm.get(SERIAL_ID));
				pstmt.setString(3, sAlarm);
				pstmt.setTimestamp(4, new java.sql.Timestamp(Date.parse(mAlarm.get(OCCURED_ON))));

				if ("".equals(mAlarm.get(ACCEPTED_BY))) {
					pstmt.setNull(5, java.sql.Types.TIMESTAMP);
					if ("".equals(mAlarm.get(CLEARED_ON))) {
						pstmt.setNull(6, java.sql.Types.VARCHAR);
					} else {
						pstmt.setString(6, "SYSTEM");
					}
				} else {
					pstmt.setTimestamp(5, new java.sql.Timestamp(Date.parse(mAlarm.get(ACCEPTED_ON))));
					pstmt.setString(6, mAlarm.get(ACCEPTED_BY));
				}

				if (!mAlarm.containsKey(MUTED_BY) || "".equals(mAlarm.get(MUTED_BY))) {
					pstmt.setNull(7, java.sql.Types.TIMESTAMP);
					pstmt.setNull(8, java.sql.Types.VARCHAR);
				} else {
					pstmt.setTimestamp(7, new java.sql.Timestamp(Date.parse(mAlarm.get(MUTED_ON))));
					pstmt.setString(8, mAlarm.get(MUTED_BY));
				}

				if ("".equals(mAlarm.get(CLEARED_ON))) {
					pstmt.setNull(9, java.sql.Types.TIMESTAMP);
				} else {
					pstmt.setTimestamp(9, new java.sql.Timestamp(Date.parse(mAlarm.get(CLEARED_ON))));
				}

				bNotify = mNotifyAlarms.containsKey(sAlarm);
				pstmt.setBoolean(10, bNotify);
				if (bNotify) {
					pstmt.setInt(11, 0);
					pstmt.setInt(12, 0);
					pstmt.setInt(13, 0);
				} else {
					pstmt.setNull(11, java.sql.Types.INTEGER);
					pstmt.setNull(12, java.sql.Types.INTEGER);
					pstmt.setNull(13, java.sql.Types.INTEGER);
				}

				if (bNotGeneral) {
					pstmt.setDouble(14, dStage);
					pstmt.setString(15, sBatchNo);
				}

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public void saveLogHistory(String sUser, String sController, Map<String, String[]> mParams) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			boolean bNotGeneral = !isGeneralController(sController);
			double dStage = 0;
			String sInsertStmt = "";
			String sBatchNo = "";

			if (bNotGeneral) {
				sInsertStmt = "insert into " + SCHEMA_NAME + ".LOG_HISTORY ("
						+ "RM_ID, LOGGED_BY, LOGGED_ON, PARAM_NAME, LOG_TEXT, STAGE_NUMBER, BATCH_NO"
						+ ") values (?, ?, ?, ?, ?, ?, ?)";

				String sStage = getCurrentStage(sController);
				if (sStage != null && !"".equals(sStage)) {
					dStage = Double.parseDouble(sStage.replace(" ", "."));
				}

				sBatchNo = getBatchNo(sController);
			} else {
				sInsertStmt = "insert into " + SCHEMA_NAME + ".LOG_HISTORY ("
						+ "RM_ID, LOGGED_BY, LOGGED_ON, PARAM_NAME, LOG_TEXT" + ") values (?, ?, ?, ?, ?)";
			}

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sInsertStmt);

			String sParam;
			String[] saValue;
			Calendar cal = Calendar.getInstance();

			Iterator<String> itr = mParams.keySet().iterator();
			while (itr.hasNext()) {
				sParam = itr.next();
				saValue = mParams.get(sParam);

				pstmt.setString(1, sController);
				pstmt.setString(2, sUser);
				pstmt.setTimestamp(3, new java.sql.Timestamp(cal.getTimeInMillis()));
				pstmt.setString(4, sParam);
				pstmt.setString(5, "Changed from old value: " + saValue[0] + " to new value: " + saValue[1]);

				if (bNotGeneral) {
					pstmt.setDouble(6, dStage);
					pstmt.setString(7, sBatchNo);
				}

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public void saveSysLogs(String sUserId, String sController, ArrayList<String[]> alSysLog) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			boolean bNotGeneral = !isGeneralController(sController);
			double dStage = 0;
			String sInsertStmt = "";
			String sBatchNo = "";

			if (bNotGeneral) {
				sInsertStmt = "insert into " + SCHEMA_NAME + ".LOG_HISTORY ("
						+ "RM_ID, LOGGED_BY, LOGGED_ON, LOG_TEXT, STAGE_NUMBER, BATCH_NO"
						+ ") values (?, ?, ?, ?, ?, ?)";

				String sStage = getCurrentStage(sController);
				if (sStage != null && !"".equals(sStage)) {
					dStage = Double.parseDouble(sStage.replace(" ", "."));
				}

				sBatchNo = getBatchNo(sController);
			} else {
				sInsertStmt = "insert into " + SCHEMA_NAME + ".LOG_HISTORY (" + "RM_ID, LOGGED_BY, LOGGED_ON, LOG_TEXT"
						+ ") values (?, ?, ?, ?)";
			}

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sInsertStmt);

			String[] saLog = null;
			for (int i = 0, iSz = alSysLog.size(); i < iSz; i++) {
				saLog = alSysLog.get(i);

				pstmt.setString(1, sController);
				pstmt.setString(2, sUserId);
				pstmt.setTimestamp(3, new java.sql.Timestamp(Date.parse(saLog[0])));
				pstmt.setString(4, saLog[1]);
				if (bNotGeneral) {
					pstmt.setDouble(5, dStage);
					pstmt.setString(6, sBatchNo);
				}

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public MapList getLogHistory(User ctxUser, String sRoom, String sStage, String BNo, String sFromDate,
			String sToDate, String sParams, String showSysLogs, int limit) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		MapList mlLogs = new MapList();
		Map<String, String> mLog = null;
		String sController = null;
		String sParam = null;
		StringBuilder sbQuery = new StringBuilder();
		StringList slControllers = null;
		StringList userControllers = null;

		try {
			userControllers = ctxUser.getControllers();

			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm");

			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			if (!"".equals(sFromDate)) {
				sFromDate = output.format(input.parse(sFromDate));
			}
			if (!"".equals(sToDate)) {
				sToDate = output.format(input.parse(sToDate));
			}

			sbQuery.append("select * from " + SCHEMA_NAME + ".LOG_HISTORY where ");

			boolean bFlag = false;
			if (!"".equals(sRoom)) {
				sbQuery.append(ROOM_ID + " = '" + sRoom + "'");
				bFlag = true;
			}

			if (!"".equals(sStage)) {
				if (bFlag) {
					sbQuery.append(" and ");
				}

				String[] saCntrlStage = sStage.split("\\|");
				sStage = saCntrlStage[0];
				slControllers = RDMServicesUtils.getTypeControllers(saCntrlStage[1]);

				sStage = sStage.replace(' ', '.');
				sStage += (sStage.contains(".") ? "" : ".0");
				if ("0.0".equals(sStage)) {
					sbQuery.append("(");
					sbQuery.append(STAGE_NUMBER + " = '" + sStage + "'");
					sbQuery.append(" or ");
					sbQuery.append(STAGE_NUMBER + " is NULL");
					sbQuery.append(")");
				} else {
					sbQuery.append(STAGE_NUMBER + " = '" + sStage + "'");
				}
				bFlag = true;
			}

			if ("Yes".equalsIgnoreCase(showSysLogs)) {
				if (bFlag) {
					sbQuery.append(" and ");
				}
				sbQuery.append("LOG_TEXT not like 'Web services %'");
				sbQuery.append(" and ");
				sbQuery.append(LOGGED_BY + " = 'SYSTEM'");
				bFlag = true;
			} else {
				if (bFlag) {
					sbQuery.append(" and ");
				}
				sbQuery.append(LOGGED_BY + " != 'SYSTEM'");
				bFlag = true;
			}

			if (!"".equals(sFromDate)) {
				if (bFlag) {
					sbQuery.append(" and ");
				}
				sbQuery.append(LOGGED_ON + " >= '" + sFromDate + " 12:00:00 AM'");
				bFlag = true;
			}

			if (!"".equals(sToDate)) {
				if (bFlag) {
					sbQuery.append(" and ");
				}
				sbQuery.append(LOGGED_ON + " <= '" + sToDate + " 11:59:59 PM'");
				bFlag = true;
			}

			if (!"".equals(sParams)) {
				if (bFlag) {
					sbQuery.append(" and ");
				}
				sParams = sParams.replace(",", "%','%");
				sbQuery.append(PARAM_NAME + " ~~* any(array['%" + sParams + "%'])");
				bFlag = true;
			}

			if (!"".equals(BNo)) {
				if (bFlag) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				BNo = BNo.replace(",", "%','%");
				sbQuery.append(BATCH_NO + " ~~* any(array['%" + BNo + "%'])");
			}

			sbQuery.append(" ORDER BY LOGGED_ON DESC ");

			if (limit > 0) {
				sbQuery.append(" LIMIT " + limit);
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				sController = rs.getString(ROOM_ID);
				if (userControllers.contains(sController)
						&& (slControllers == null || slControllers.contains(sController))) {
					mLog = new HashMap<String, String>();
					sParam = rs.getString(PARAM_NAME);
					BNo = rs.getString(BATCH_NO);
					sStage = rs.getString(STAGE_NUMBER);

					mLog.put(ROOM_ID, sController);
					mLog.put(LOGGED_BY, rs.getString(LOGGED_BY));
					mLog.put(LOGGED_ON, sdf.format(rs.getTimestamp(LOGGED_ON)));
					mLog.put(PARAM_NAME, ((sParam == null || "null".equals(sParam)) ? "" : sParam.trim()));
					mLog.put(LOG_TEXT, rs.getString(LOG_TEXT));
					mLog.put(STAGE_NUMBER, ((sStage == null) ? "" : sStage));
					mLog.put(BATCH_NO, ((BNo == null) ? "" : BNo));

					mlLogs.add(mLog);
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbQuery = null;
		}

		return mlLogs;
	}

	public MapList getAlarmLogHistory(User ctxUser, String sRoom, String sStage, String BNo, String sParams,
			String sFromDate, String sToDate, String showOpenAlarms, int limit) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		MapList mlAlarms = new MapList();
		Map<String, String> mAlarm = null;
		String sAcceptedBy = null;
		String sMutedBy = null;
		String sController = null;
		StringList slControllers = null;
		StringList userControllers = null;
		Timestamp tsAcceptedOn = null;
		Timestamp tsMutedOn = null;
		Timestamp tsClearedOn = null;
		Timestamp tsLastNotified = null;

		try {
			userControllers = ctxUser.getControllers();

			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm");

			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			if (!"".equals(sFromDate)) {
				sFromDate = output.format(input.parse(sFromDate));
			}
			if (!"".equals(sToDate)) {
				sToDate = output.format(input.parse(sToDate));
			}

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".ALARM_HISTORY");
			boolean bFlag = false;

			if (!"".equals(sRoom)) {
				sbQuery.append(" where ");
				sbQuery.append(ROOM_ID + " = '" + sRoom + "'");
				bFlag = true;
			}

			if (!"".equals(sStage)) {
				if (bFlag) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				String[] saCntrlStage = sStage.split("\\|");
				sStage = saCntrlStage[0];
				slControllers = RDMServicesUtils.getTypeControllers(saCntrlStage[1]);

				sStage = sStage.replace(' ', '.');
				sStage += (sStage.contains(".") ? "" : ".0");
				if ("0.0".equals(sStage)) {
					sbQuery.append("(");
					sbQuery.append(STAGE_NUMBER + " = '" + sStage + "'");
					sbQuery.append(" or ");
					sbQuery.append(STAGE_NUMBER + " is NULL");
					sbQuery.append(")");
				} else {
					sbQuery.append(STAGE_NUMBER + " = '" + sStage + "'");
				}
				bFlag = true;
			}

			if ("Yes".equalsIgnoreCase(showOpenAlarms)) {
				if (bFlag) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				sbQuery.append(CLEARED_ON + " IS NULL");
				bFlag = true;
			}

			if (!"".equals(sFromDate)) {
				if (bFlag) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				sbQuery.append(OCCURED_ON + " >= '" + sFromDate + " 12:00:00 AM'");
				bFlag = true;
			}

			if (!"".equals(sToDate)) {
				if (bFlag) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				sbQuery.append(OCCURED_ON + " <= '" + sToDate + " 11:59:59 PM'");
				bFlag = true;
			}

			if (!"".equals(sParams)) {
				if (bFlag) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				sParams = sParams.replace(",", "%','%");
				sbQuery.append(ALARM_TEXT + " ~~* any(array['%" + sParams + "%'])");
				bFlag = true;
			}

			if (!"".equals(BNo)) {
				if (bFlag) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				BNo = BNo.replace(",", "%','%");
				sbQuery.append(BATCH_NO + " ~~* any(array['%" + BNo + "%'])");
			}

			sbQuery.append(" ORDER BY OCCURED_ON DESC ");

			if (limit > 0) {
				sbQuery.append(" LIMIT " + limit);
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				sController = rs.getString(ROOM_ID);
				if (userControllers.contains(sController)
						&& (slControllers == null || slControllers.contains(sController))) {
					mAlarm = new HashMap<String, String>();

					sAcceptedBy = rs.getString(ACCEPTED_BY);
					tsAcceptedOn = rs.getTimestamp(ACCEPTED_ON);
					sMutedBy = rs.getString(MUTED_BY);
					tsMutedOn = rs.getTimestamp(MUTED_ON);
					tsClearedOn = rs.getTimestamp(CLEARED_ON);
					tsLastNotified = rs.getTimestamp(LAST_NOTIFIED);
					BNo = rs.getString(BATCH_NO);
					sStage = rs.getString(STAGE_NUMBER);

					mAlarm.put(ROOM_ID, sController);
					mAlarm.put(SERIAL_ID, rs.getString(SERIAL_ID));
					mAlarm.put(ALARM_TEXT, rs.getString(ALARM_TEXT));
					mAlarm.put(OCCURED_ON, sdf.format(rs.getTimestamp(OCCURED_ON)));
					mAlarm.put(ACCEPTED_BY, ((sAcceptedBy == null) ? "" : sAcceptedBy));
					mAlarm.put(ACCEPTED_ON, ((tsAcceptedOn == null) ? "" : sdf.format(tsAcceptedOn)));
					mAlarm.put(MUTED_BY, ((sMutedBy == null) ? "" : sMutedBy));
					mAlarm.put(MUTED_ON, ((tsMutedOn == null) ? "" : sdf.format(tsMutedOn)));
					mAlarm.put(CLEARED_ON, ((tsClearedOn == null) ? "" : sdf.format(tsClearedOn)));
					mAlarm.put(STAGE_NUMBER, ((sStage == null) ? "" : sStage));
					mAlarm.put(BATCH_NO, ((BNo == null) ? "" : BNo));
					mAlarm.put(LEVEL1_ATTEMPTS, Integer.toString(rs.getInt(LEVEL1_ATTEMPTS)));
					mAlarm.put(LEVEL2_ATTEMPTS, Integer.toString(rs.getInt(LEVEL2_ATTEMPTS)));
					mAlarm.put(LEVEL3_ATTEMPTS, Integer.toString(rs.getInt(LEVEL3_ATTEMPTS)));
					mAlarm.put(LAST_NOTIFIED, ((tsLastNotified == null) ? "" : sdf.format(tsLastNotified)));
					mAlarm.put(NOTIFY_ALARM, (rs.getBoolean(NOTIFY_ALARM) ? "TRUE" : "FALSE"));

					mlAlarms.add(mAlarm);
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlAlarms;
	}

	public StringList getAlarmFilters() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		StringList slText = new StringList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "select DISTINCT " + ALARM_TEXT + " from " + SCHEMA_NAME + ".ALARM_HISTORY ORDER BY "
					+ ALARM_TEXT + " ASC";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				slText.add(rs.getString(ALARM_TEXT));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return slText;
	}

	public ArrayList<String[]> getNotificationAlarms() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		ArrayList<String[]> alAlarms = new ArrayList<String[]>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "select DISTINCT a.text, b.cntrl_type from " + SCHEMA_NAME + ".ALARM_HISTORY a, "
					+ SCHEMA_NAME + ".ROOM_INFO b where a.rm_id = b.rm_id order by a.text";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				alAlarms.add(new String[] { rs.getString(ALARM_TEXT), rs.getString(CNTRL_TYPE) });
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return alAlarms;
	}

	public void deleteDuplicateSysLogs() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQry = "DELETE FROM " + SCHEMA_NAME + ".LOG_HISTORY WHERE oid IN "
					+ "(SELECT oid FROM (SELECT oid, row_number() over "
					+ "(partition BY RM_ID, LOGGED_ON, LOG_TEXT ORDER BY oid) AS rnum FROM " + SCHEMA_NAME
					+ ".LOG_HISTORY) t WHERE t.rnum > 1)";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			stmt.execute(sQry);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public MapList getStageList() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlStages = new MapList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select * from " + SCHEMA_NAME + ".STAGE_INFO ORDER BY CNTRL_TYPE ASC, " + SCHEMA_NAME
					+ ".sort_alphanumeric(STAGE_NUMBER)";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				Map<String, String> mStage = new HashMap<String, String>();
				mStage.put(STAGE_NAME, rs.getString(STAGE_NAME));
				mStage.put(STAGE_NUMBER, rs.getString(STAGE_NUMBER));
				mStage.put(CNTRL_TYPE, rs.getString(CNTRL_TYPE));
				mStage.put(STAGE_DESC, rs.getString(STAGE_DESC));

				mlStages.add(mStage);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlStages;
	}

	public boolean addStage(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sName = mInfo.get(STAGE_NAME);
			String sCntrlType = mInfo.get(CNTRL_TYPE);
			String sDesc = mInfo.get(STAGE_DESC);
			String sStageId = mInfo.get(STAGE_NUMBER);

			String sQuery = "SELECT STAGE_NUMBER FROM " + SCHEMA_NAME + ".STAGE_INFO WHERE STAGE_NUMBER = '" + sStageId
					+ "' and CNTRL_TYPE = '" + sCntrlType + "'";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				throw new SQLException("Stage " + sStageId + " for " + sCntrlType + " already exists in the system.");
			}

			sbInsert.append("insert into " + SCHEMA_NAME + ".STAGE_INFO (");
			sbInsert.append("STAGE_NAME,STAGE_NUMBER,CNTRL_TYPE,STAGE_DESC");
			sbInsert.append(") values ('");
			sbInsert.append(sName);
			sbInsert.append("','");
			sbInsert.append(sStageId);
			sbInsert.append("','");
			sbInsert.append(sCntrlType);
			sbInsert.append("','");
			sbInsert.append(sDesc);
			sbInsert.append("')");

			stmt.executeUpdate(sbInsert.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	public boolean updateStage(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sStageId = mInfo.get(STAGE_NUMBER);

			String sName = mInfo.get(STAGE_NAME);
			String sCntrlType = mInfo.get(CNTRL_TYPE);
			String sDesc = mInfo.get(STAGE_DESC);

			sbUpdate.append("update " + SCHEMA_NAME + ".STAGE_INFO set ");
			sbUpdate.append("STAGE_NAME = '" + sName + "',");
			sbUpdate.append("STAGE_DESC = '" + sDesc + "' ");
			sbUpdate.append(" where ");
			sbUpdate.append("STAGE_NUMBER = '" + sStageId + "'");
			sbUpdate.append(" and ");
			sbUpdate.append("CNTRL_TYPE = '" + sCntrlType + "'");

			stmt.executeUpdate(sbUpdate.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	public boolean deleteStage(String sStageId, String cntrlType) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".STAGE_INFO " + "where STAGE_NUMBER = '" + sStageId
					+ "' and CNTRL_TYPE = '" + cntrlType + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public MapList getRoomsList() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlRooms = new MapList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select * from " + SCHEMA_NAME + ".ROOM_INFO ORDER BY CNTRL_TYPE, " + SCHEMA_NAME
					+ ".sort_alphanumeric(RM_ID)";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				Map<String, String> mRoom = new HashMap<String, String>();

				mRoom.put(ROOM_ID, rs.getString(ROOM_ID));
				mRoom.put(ROOM_IP, rs.getString(ROOM_IP));
				mRoom.put(CNTRL_TYPE, rs.getString(CNTRL_TYPE));
				mRoom.put(ROOM_STATUS, rs.getString(ROOM_STATUS));
				mRoom.put(GROUP_NAME, rs.getString(GROUP_NAME));
				mRoom.put(CNTRL_VERSION, rs.getString(CNTRL_VERSION));

				mlRooms.add(mRoom);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlRooms;
	}

	public boolean updateRoom(ServicesSession RDMSession, String sRoomId, Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sRoomIP = mInfo.get(ROOM_IP);
			String sCntrlType = mInfo.get(CNTRL_TYPE);
			String sStatus = mInfo.get(ROOM_STATUS);
			String sGroup = mInfo.get(GROUP_NAME);
			String sCntrlVersion = mInfo.get(CNTRL_VERSION);

			sbUpdate.append("update " + SCHEMA_NAME + ".ROOM_INFO set ");
			sbUpdate.append("RM_IP = '" + sRoomIP + "',");
			sbUpdate.append("CNTRL_TYPE = '" + sCntrlType + "', ");
			sbUpdate.append("CNTRL_VERSION = '" + sCntrlVersion + "', ");
			sbUpdate.append("GROUP_NAME = '" + sGroup + "', ");
			sbUpdate.append("RM_STATUS = '" + sStatus + "' ");
			sbUpdate.append("where RM_ID = '" + sRoomId + "'");

			stmt.executeUpdate(sbUpdate.toString());

			int cnt = 0;
			String roomTable = sRoomId.replace(" ", "") + "_param_data";
			String sQuery = "SELECT COUNT(*) FROM pg_tables where schemaname='" + SCHEMA_NAME
					+ "' and UPPER(tablename)='" + roomTable.toUpperCase() + "'";

			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				cnt = rs.getInt(1);
			}

			if (cnt == 0) {
				createControllerDataTable(RDMSession, sRoomId, sCntrlType);
				createUniqueIndex(sRoomId);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	public boolean addRoom(ServicesSession RDMSession, Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "SELECT COUNT(*) FROM " + SCHEMA_NAME + ".ROOM_INFO WHERE " + CNTRL_TYPE
					+ " NOT LIKE 'General.%' and " + ROOM_STATUS + " = '" + ACTIVE + "'";
			rs = stmt.executeQuery(sQuery);

			int iCnt = 0;
			while (rs.next()) {
				iCnt = rs.getInt(1);
			}

			int iLimit = VerifyLicense.getLicenseRoomCount();
			if ((iLimit > 0) && (iCnt >= iLimit)) {
				throw new SQLException("Max number of Licensed Rooms (" + iLimit
						+ ") has exceeded. Please contact the admin at L-Pit for licenses to create more Rooms.");
			}

			close(rs);

			String sRoomId = mInfo.get(ROOM_ID);
			sQuery = "SELECT RM_ID FROM " + SCHEMA_NAME + ".ROOM_INFO WHERE UPPER(RM_ID) = UPPER('" + sRoomId + "')";

			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				throw new SQLException("Room " + sRoomId + " already exists in the system.");
			}

			String sRoomIP = mInfo.get(ROOM_IP);
			String sCntrlType = mInfo.get(CNTRL_TYPE);
			String sStatus = mInfo.get(ROOM_STATUS);
			String sGroup = mInfo.get(GROUP_NAME);
			String sCntrlVersion = mInfo.get(CNTRL_VERSION);

			sbInsert.append("insert into " + SCHEMA_NAME + ".ROOM_INFO (");
			sbInsert.append("RM_ID,RM_IP,CNTRL_TYPE,GROUP_NAME,RM_STATUS,CNTRL_VERSION");
			sbInsert.append(") values ('");
			sbInsert.append(sRoomId);
			sbInsert.append("','");
			sbInsert.append(sRoomIP);
			sbInsert.append("','");
			sbInsert.append(sCntrlType);
			sbInsert.append("','");
			sbInsert.append(sGroup);
			sbInsert.append("','");
			sbInsert.append(sStatus);
			sbInsert.append("','");
			sbInsert.append(sCntrlVersion);
			sbInsert.append("')");

			stmt.executeUpdate(sbInsert.toString());

			createControllerDataTable(RDMSession, sRoomId, sCntrlType);
			createUniqueIndex(sRoomId);
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	private void createControllerDataTable(ServicesSession RDMSession, String sRoomId, String sCntrlType)
			throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			boolean bIsGeneral = isGeneralController(sRoomId);

			StringBuilder sbCols = new StringBuilder();
			sbCols.append("LOG_DATE date NOT NULL");
			sbCols.append(", ");
			sbCols.append("LOG_TIME time without time zone NOT NULL");
			if (!bIsGeneral) {
				sbCols.append(", ");
				sbCols.append("BATCH_NO character varying");
			}

			try {
				String sParam = null;
				StringList slParams = new StringList();
				Map<String, String> mCntrlParams = null;

				String sCntrlVersion = RDMSession.getControllerVersion(sRoomId);
				if (RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion)) {
					PLCServices_oldHW client = new PLCServices_oldHW(RDMSession, sRoomId);
					mCntrlParams = client.getControllerParameters();
				} else if (RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion)) {
					PLCServices_newHW client = new PLCServices_newHW(RDMSession, sRoomId);
					mCntrlParams = client.getControllerParameters();
				}

				Iterator<String> itr = mCntrlParams.keySet().iterator();
				while (itr.hasNext()) {
					sParam = itr.next();
					sParam = sParam.replace(" ", "_");

					if (!slParams.contains(sParam)) {
						sbCols.append(", ");
						sbCols.append(sParam);
						sbCols.append(" ");
						sbCols.append("character varying");

						slParams.add(sParam);
					}
				}
			} catch (Exception e) {
				// do nothing
			}

			String roomTable = sRoomId.replace(" ", "") + "_param_data";
			String sQuery = "CREATE TABLE " + SCHEMA_NAME + "." + roomTable + " ( " + sbCols.toString() + " )";
			stmt.executeUpdate(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	private void createUniqueIndex(String sRoomId) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String roomTable = sRoomId.replace(" ", "") + "_param_data";
			String sQuery = "CREATE UNIQUE INDEX " + roomTable + "_UNQ_IDX ON " + SCHEMA_NAME + "." + roomTable
					+ " (log_date ASC NULLS LAST, log_time ASC NULLS LAST)";

			stmt.executeUpdate(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public MapList getUserComments(User ctxUser, String sRoom, String sStage, String BNo, String sFromDate,
			String sToDate, String sLoggedBy, String sCategory, String sDept, boolean bGlobal, boolean bClosed,
			int limit) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		boolean fg = false;
		String sDesc = null;
		String sClosed = null;
		String reviewComments = null;
		String attachments = null;
		StringList slControllers = null;
		StringList userControllers = null;
		Timestamp tsClosedOn = null;
		MapList mlLogs = new MapList();
		Map<String, String> mLog = null;

		try {
			userControllers = ctxUser.getControllers();

			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm");

			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			if (!"".equals(sFromDate)) {
				sFromDate = output.format(input.parse(sFromDate));
			}
			if (!"".equals(sToDate)) {
				sToDate = output.format(input.parse(sToDate));
			}

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".USER_COMMENTS");

			if (!"".equals(sRoom)) {
				sbQuery.append(" where ");
				sbQuery.append("(");
				sbQuery.append(ROOM_ID + " is NULL");
				sbQuery.append(" or ");
				sbQuery.append(ROOM_ID + " = '" + sRoom + "'");
				sbQuery.append(")");
				fg = true;
			}

			if (!"".equals(sStage)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				String[] saCntrlStage = sStage.split("\\|");
				sStage = saCntrlStage[0];
				slControllers = RDMServicesUtils.getTypeControllers(saCntrlStage[1]);

				sStage = sStage.replace(' ', '.');
				sStage += (sStage.contains(".") ? "" : ".0");
				if ("0.0".equals(sStage)) {
					sbQuery.append("(");
					sbQuery.append(STAGE_NUMBER + " = '" + sStage + "'");
					sbQuery.append(" or ");
					sbQuery.append(STAGE_NUMBER + " is NULL");
					sbQuery.append(")");
				} else {
					sbQuery.append(STAGE_NUMBER + " = '" + sStage + "'");
				}
				fg = true;
			}

			if (!"".equals(sFromDate)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				sbQuery.append(bClosed ? CLOSED_ON : LOGGED_ON);
				sbQuery.append(" >= '" + sFromDate + " 12:00:00 AM'");
				fg = true;
			}

			if (!"".equals(sToDate)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				sbQuery.append(bClosed ? CLOSED_ON : LOGGED_ON);
				sbQuery.append(" <= '" + sToDate + " 11:59:59 PM'");
				fg = true;
			}

			if (!"".equals(sLoggedBy)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				sbQuery.append(LOGGED_BY + " = '" + sLoggedBy + "'");
				fg = true;
			}

			if (fg) {
				sbQuery.append(" and ");
			} else {
				sbQuery.append(" where ");
			}
			sbQuery.append(GLOBAL_ALERT + " = '" + ((bGlobal || bClosed) ? "Y" : "N") + "'");
			fg = true;

			if (fg) {
				sbQuery.append(" and ");
			} else {
				sbQuery.append(" where ");
			}
			sbQuery.append(CLOSED_COMMENT + (bClosed ? " = 'Y'" : " is NULL"));
			fg = true;

			if (!"".equals(BNo)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				BNo = BNo.replace(",", "%','%");
				sbQuery.append(BATCH_NO + " ~~* any(array['%" + BNo + "%'])");
				fg = true;
			}

			if (!"".equals(sCategory)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				sbQuery.append("(" + CATEGORY + " LIKE '%" + sCategory + "%')");
			}

			if (!"".equals(sDept)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				sbQuery.append("(regexp_split_to_array(" + DEPARTMENT_NAME + ", '\\|') && regexp_split_to_array('"
						+ sDept + "', '\\|')");
				sbQuery.append(" or ");
				sbQuery.append(DEPARTMENT_NAME + " = '')");
			}

			sbQuery.append(" ORDER BY LOGGED_ON DESC");

			if (limit > 0) {
				sbQuery.append(" LIMIT " + limit);
			}

			Map<String, String> mTasks = RDMServicesUtils.listAdminTasks();

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			
			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				sRoom = rs.getString(ROOM_ID);
				if (userControllers.contains(sRoom) && (slControllers == null || slControllers.contains(sRoom))) {
					mLog = new HashMap<String, String>();

					mLog.put(COMMENT_ID, rs.getString(COMMENT_ID));
					mLog.put(ROOM_ID, sRoom);
					mLog.put(LOGGED_BY, rs.getString(LOGGED_BY));
					mLog.put(LOGGED_ON, sdf.format(rs.getTimestamp(LOGGED_ON)));
					mLog.put(GLOBAL_ALERT, rs.getString(GLOBAL_ALERT));
					mLog.put(DEPARTMENT_NAME, rs.getString(DEPARTMENT_NAME));
					mLog.put(RUNNING_DAY, rs.getString(RUNNING_DAY));

					sClosed = rs.getString(CLOSED_COMMENT);
					mLog.put(CLOSED_COMMENT, ((sClosed == null) ? "" : sClosed));

					tsClosedOn = rs.getTimestamp(CLOSED_ON);
					mLog.put(CLOSED_ON, ((tsClosedOn == null) ? "" : sdf.format(tsClosedOn)));

					reviewComments = rs.getString(REVIEW_COMMENTS);
					mLog.put(REVIEW_COMMENTS, (reviewComments == null ? "" : reviewComments));

					sStage = rs.getString(STAGE_NUMBER);
					mLog.put(STAGE_NUMBER, ((sStage == null) ? "" : sStage));

					sCategory = rs.getString(CATEGORY);
					mLog.put(CATEGORY, (sCategory == null ? "" : sCategory));

					sDesc = mTasks.get(sCategory);
					mLog.put(LOG_TEXT, (sDesc == null ? "" : sDesc));

					BNo = rs.getString(BATCH_NO);
					mLog.put(BATCH_NO, ((BNo == null) ? "" : BNo));

					attachments = rs.getString(ATTACHMENTS);
					mLog.put(ATTACHMENTS, ((attachments == null) ? "" : attachments));

					mlLogs.add(mLog);
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlLogs;
	}

	public boolean addUserComments(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			String sController = mInfo.get(ROOM_ID);
			boolean bNotGeneral = !isGeneralController(sController);
			double dStage = 0;
			int iNoDays = 0;
			String sInsertStmt = "";
			String sBatchNo = "";

			if (bNotGeneral) {
				sInsertStmt = "insert into " + SCHEMA_NAME + ".USER_COMMENTS ("
						+ "CMT_ID, RM_ID, LOGGED_BY, LOGGED_ON, REVIEW_COMMENTS, GLOBAL, CATEGORY, DEPARTMENT_NAME, ATTACHMENTS, STAGE_NUMBER, BATCH_NO, RUNNING_DAY"
						+ ") values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

				String sStage = getCurrentStage(sController);
				if (sStage != null && !"".equals(sStage)) {
					dStage = Double.parseDouble(sStage.replace(" ", "."));
				}

				sBatchNo = getBatchNo(sController);
				iNoDays = getPhaseRunningDay(sController);
			} else {
				sInsertStmt = "insert into " + SCHEMA_NAME + ".USER_COMMENTS ("
						+ "CMT_ID, RM_ID, LOGGED_BY, LOGGED_ON, REVIEW_COMMENTS, GLOBAL, CATEGORY, DEPARTMENT_NAME, ATTACHMENTS"
						+ ") values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			}

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sInsertStmt);

			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
			StringBuilder sbComments = new StringBuilder();

			String sComments = mInfo.get(REVIEW_COMMENTS).trim();
			if (!sComments.isEmpty()) {
				Map<String, String> mUsers = RDMServicesUtils.getUserNames(false);
				String sLoggedBy = mInfo.get(LOGGED_BY);
				if (mUsers.containsKey(sLoggedBy)) {
					sLoggedBy = mUsers.get(sLoggedBy);
				}

				sbComments.append("- " + sLoggedBy);
				sbComments.append(" on " + sdf.format(cal.getTime()));
				sbComments.append("<br>");
				sbComments.append(sComments.replace("\n", "<br>"));
			}

			pstmt.setString(1, mInfo.get(COMMENT_ID));
			pstmt.setString(2, sController);
			pstmt.setString(3, mInfo.get(LOGGED_BY));
			pstmt.setTimestamp(4, new java.sql.Timestamp(cal.getTimeInMillis()));
			pstmt.setString(5, sbComments.toString());
			pstmt.setString(6, mInfo.get(GLOBAL_ALERT));
			pstmt.setString(7, mInfo.get(CATEGORY));
			pstmt.setString(8, mInfo.get(DEPARTMENT_NAME));
			pstmt.setString(9, mInfo.get(ATTACHMENTS));
			if (bNotGeneral) {
				pstmt.setDouble(10, dStage);
				pstmt.setString(11, sBatchNo);
				pstmt.setInt(12, iNoDays);
			}

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public String getCurrentStage(String sController) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sStage = null;
		try {
			String roomTable = sController.replace(" ", "") + "_param_data";

			String sQry = "select LOG_DATE,LOG_TIME,CURRENT_PHASE from " + SCHEMA_NAME + "." + roomTable
					+ " where LOG_DATE = (select max(LOG_DATE) from " + SCHEMA_NAME + "." + roomTable + ")"
					+ " and LOG_TIME = (select max(LOG_TIME) from " + SCHEMA_NAME + "." + roomTable
					+ " where LOG_DATE = (select max(LOG_DATE) from " + SCHEMA_NAME + "." + roomTable + "))";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sQry.toString());
			while (rs.next()) {
				sStage = rs.getString("CURRENT_PHASE");
			}
		} catch (Exception e) {
			return "";
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return sStage;
	}

	public boolean updateAlert(Map<String, String> mInfo, boolean bClose) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sComments = null;
			String user = mInfo.get(LOGGED_BY);
			String sCmtId = mInfo.get(COMMENT_ID);
			String text = mInfo.get(REVIEW_COMMENTS);
			String sAttachment = mInfo.get(ATTACHMENTS);
			String sReplace = mInfo.get("REPLACE");

			String sQuery = "select REVIEW_COMMENTS from " + SCHEMA_NAME + ".USER_COMMENTS where " + COMMENT_ID + " = '"
					+ sCmtId + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sQuery);

			while (rs.next()) {
				sComments = rs.getString(REVIEW_COMMENTS);
			}

			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
			Calendar cal = Calendar.getInstance();

			Map<String, String> mUsers = RDMServicesUtils.getUserNames(false);
			if (mUsers.containsKey(user)) {
				user = mUsers.get(user);
			}

			StringBuilder sbComments = new StringBuilder();
			sbComments.append("- " + user);
			sbComments.append(" on " + sdf.format(cal.getTime()));
			sbComments.append("<br>");
			sbComments.append(text.replace("\n", "<br>"));
			if (sComments != null && !"".equals(sComments)) {
				sbComments.append("<br>");
				sbComments.append(sComments);
			}
			sComments = sbComments.toString();

			sbComments = new StringBuilder();
			sbComments.append("update " + SCHEMA_NAME + ".USER_COMMENTS set ");
			sbComments.append(REVIEW_COMMENTS + " = ?");
			if (bClose) {
				sbComments.append(", ");
				sbComments.append(CLOSED_COMMENT);
				sbComments.append(" = 'Y'");
				sbComments.append(", ");
				sbComments.append(CLOSED_ON);
				sbComments.append(" = '" + new java.sql.Timestamp(cal.getTimeInMillis()) + "'");
			} else {
				if (sAttachment != null && !"".equals(sAttachment)) {
					sbComments.append(", ");
					if ("yes".equalsIgnoreCase(sReplace)) {
						sbComments.append(ATTACHMENTS + " = '" + sAttachment + "'");
					} else {
						sbComments.append(ATTACHMENTS + " = (" + ATTACHMENTS + " || '," + sAttachment + "')");
					}
				}
			}

			sbComments.append(" where ");
			sbComments.append(COMMENT_ID + " = ?");

			pstmt = conn.prepareStatement(sbComments.toString());
			pstmt.setString(1, sComments);
			pstmt.setString(2, sCmtId);
			pstmt.executeUpdate();
		} finally {
			close(stmt, rs);
			close(pstmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public Map<String, String[]> getParamColNames(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String[]> mParam = new HashMap<String, String[]>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sParamName = null;
			String sParamUnit = null;
			String sColName = null;

			String sTable = (cntrlType.startsWith("General.") ? "GENERAL_PARAMS_ADMIN" : "CONTROLLER_PARAMS_ADMIN");
			String selectString = "select PARAM_NAME,PARAM_UNIT from " + SCHEMA_NAME + "." + sTable
					+ " where CNTRL_TYPE = '" + cntrlType + "'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sParamName = rs.getString(PARAM_NAME);
				sParamUnit = rs.getString(PARAM_UNIT);
				sParamUnit = (sParamUnit == null ? "" : sParamUnit);
				sColName = sParamName.replace(" ", "_");

				mParam.put(sParamName, new String[] { sColName, sParamUnit });
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return mParam;
	}

	public String getControllerPhase(String controller) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		String currentPhase = "";
		try {
			String roomTable = controller.replace(" ", "") + "_param_data";
			String sQry = "select current_phase from " + SCHEMA_NAME + "." + roomTable
					+ " where LOG_DATE = (select max(LOG_DATE) from " + SCHEMA_NAME + "." + roomTable + ")"
					+ " and LOG_TIME = (select max(LOG_TIME) from " + SCHEMA_NAME + "." + roomTable
					+ " where LOG_DATE = (select max(LOG_DATE) from " + SCHEMA_NAME + "." + roomTable + "))";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sQry);
			while (rs.next()) {
				currentPhase = rs.getString(CURRENT_PHASE);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return currentPhase;
	}

	public Map<String, String[]> getControllerParameters(String sController) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		Map<String, String[]> mParams = new HashMap<String, String[]>();
		try {
			String sName = null;
			String lastRefresh = null;
			String[] saVal = null;
			String cntrlType = RDMServicesUtils.getControllerType(sController);
			boolean isGeneral = isGeneralController(sController);

			String sProductType = getProductType(sController);

			Map<String, String[]> mColParam = RDMServicesUtils.getParamColNames(cntrlType);
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy");

			String roomTable = sController.replace(" ", "") + "_param_data";

			String sQry = "select * from " + SCHEMA_NAME + "." + roomTable
					+ " where LOG_DATE = (select max(LOG_DATE) from " + SCHEMA_NAME + "." + roomTable + ")"
					+ " and LOG_TIME = (select max(LOG_TIME) from " + SCHEMA_NAME + "." + roomTable
					+ " where LOG_DATE = (select max(LOG_DATE) from " + SCHEMA_NAME + "." + roomTable + "))";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sQry);
			while (rs.next()) {
				lastRefresh = sdf.format(rs.getDate("LOG_DATE")) + " "
						+ RDMServicesUtils.timeToShortString(rs.getTime("LOG_TIME"));
				mParams.put("Last Refresh", new String[] { lastRefresh, "" });
				if (!isGeneral) {
					mParams.put("BatchNo", new String[] { rs.getString(BATCH_NO), "" });
					mParams.put("Product", new String[] { sProductType, "" });
				}

				Iterator<String> itr = mColParam.keySet().iterator();
				while (itr.hasNext()) {
					try {
						sName = itr.next();
						saVal = mColParam.get(sName);
						mParams.put(sName, new String[] { rs.getString(saVal[0]), saVal[1] });
					} catch (SQLException sql) {
						// do nothing, continue
					}
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mParams;
	}

	public boolean hasOpenAlarms(String sRoom) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			int cnt = 0;
			String selectString = "select COUNT(*) from " + SCHEMA_NAME + ".ALARM_HISTORY where RM_ID = '" + sRoom
					+ "' and CLEARED_ON IS NULL";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				cnt = rs.getInt(1);
			}

			if (cnt > 0) {
				return true;
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return false;
	}

	public MapList getOpenAlarms(String sRoom) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		StringBuilder sbQuery = new StringBuilder();
		MapList alOpenAlarms = new MapList();
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm");

			sbQuery.append("select * from " + SCHEMA_NAME + ".ALARM_HISTORY");
			sbQuery.append(" where ");
			sbQuery.append(ROOM_ID + " = '" + sRoom + "'");
			sbQuery.append(" and ");
			sbQuery.append(CLEARED_ON + " IS NULL");
			sbQuery.append(" ORDER BY OCCURED_ON DESC");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sAcceptedBy = null;
			String sMutedBy = null;
			Timestamp tsAcceptedOn = null;
			Timestamp tsMutedOn = null;
			Timestamp tsLastNotified = null;
			Map<String, String> mAlarm = null;

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				sAcceptedBy = rs.getString(ACCEPTED_BY);
				tsAcceptedOn = rs.getTimestamp(ACCEPTED_ON);
				sMutedBy = rs.getString(MUTED_BY);
				tsMutedOn = rs.getTimestamp(MUTED_ON);
				tsLastNotified = rs.getTimestamp(LAST_NOTIFIED);

				mAlarm = new HashMap<String, String>();
				mAlarm.put(SERIAL_ID, rs.getString(SERIAL_ID));
				mAlarm.put(ALARM_TEXT, rs.getString(ALARM_TEXT));
				mAlarm.put(OCCURED_ON, sdf.format(rs.getTimestamp(OCCURED_ON)));
				mAlarm.put(ACCEPTED_BY, ((sAcceptedBy == null) ? "" : sAcceptedBy));
				mAlarm.put(ACCEPTED_ON, ((tsAcceptedOn == null) ? "" : sdf.format(tsAcceptedOn)));
				mAlarm.put(MUTED_BY, ((sMutedBy == null) ? "" : sMutedBy));
				mAlarm.put(MUTED_ON, ((tsMutedOn == null) ? "" : sdf.format(tsMutedOn)));
				mAlarm.put(LEVEL1_ATTEMPTS, Integer.toString(rs.getInt(LEVEL1_ATTEMPTS)));
				mAlarm.put(LEVEL2_ATTEMPTS, Integer.toString(rs.getInt(LEVEL2_ATTEMPTS)));
				mAlarm.put(LEVEL3_ATTEMPTS, Integer.toString(rs.getInt(LEVEL3_ATTEMPTS)));
				mAlarm.put(LAST_NOTIFIED, ((tsLastNotified == null) ? "" : sdf.format(tsLastNotified)));
				mAlarm.put(NOTIFY_ALARM, (rs.getBoolean(NOTIFY_ALARM) ? "TRUE" : "FALSE"));

				alOpenAlarms.add(mAlarm);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbQuery = null;
		}

		return alOpenAlarms;
	}

	public void closeOpenAlarms(String sUser, Map<String, Map<String, String>> mCloseAlarms)
			throws SQLException, InterruptedException {
		String sRoomId = null;
		Map<String, String> mOpenAlarms = null;

		Iterator<String> itr = mCloseAlarms.keySet().iterator();
		while (itr.hasNext()) {
			sRoomId = itr.next();
			mOpenAlarms = mCloseAlarms.get(sRoomId);

			closeOpenAlarms(sUser, sRoomId, mOpenAlarms);
		}
	}

	public void closeOpenAlarms(String sUser, String sRoom, Map<String, String> mCloseAlarms)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sbQuery = new StringBuilder();

		try {
			sbQuery.append("update " + SCHEMA_NAME + ".ALARM_HISTORY set ");
			sbQuery.append(MUTED_ON + " = ?, ");
			sbQuery.append(MUTED_BY + " = ?, ");
			sbQuery.append(CLEARED_ON + " = ?, ");
			sbQuery.append(ACCEPTED_BY + " = ? ");
			sbQuery.append(" where ");
			sbQuery.append(ROOM_ID + " = ?");
			sbQuery.append(" and ");
			sbQuery.append(SERIAL_ID + " = ?");
			sbQuery.append(" and ");
			sbQuery.append(CLEARED_ON + " IS NULL");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbQuery.toString());

			String serialID = null;
			String clearedOn = null;
			Iterator<String> itr = mCloseAlarms.keySet().iterator();
			while (itr.hasNext()) {
				serialID = itr.next();
				clearedOn = mCloseAlarms.get(serialID);

				pstmt.setNull(1, java.sql.Types.TIMESTAMP);
				pstmt.setNull(2, java.sql.Types.VARCHAR);
				pstmt.setTimestamp(3, new java.sql.Timestamp(Date.parse(clearedOn)));
				pstmt.setString(4, sUser);
				pstmt.setString(5, sRoom);
				pstmt.setString(6, serialID);
				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbQuery = null;
		}
	}

	public void muteOpenAlarm(String sUser, String sRoom, String sSerialId, String sMutedOn)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sbQuery = new StringBuilder();

		try {
			sbQuery.append("update " + SCHEMA_NAME + ".ALARM_HISTORY set ");
			sbQuery.append(MUTED_ON + " = ?, ");
			sbQuery.append(MUTED_BY + " = ?");
			sbQuery.append(" where ");
			sbQuery.append(ROOM_ID + " = ?");
			sbQuery.append(" and ");
			sbQuery.append(SERIAL_ID + " = ?");
			sbQuery.append(" and ");
			sbQuery.append(CLEARED_ON + " IS NULL");
			sbQuery.append(" and ");
			sbQuery.append(ACCEPTED_ON + " IS NULL");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbQuery.toString());

			pstmt.setTimestamp(1, new java.sql.Timestamp(Date.parse(sMutedOn)));
			pstmt.setString(2, sUser);
			pstmt.setString(3, sRoom);
			pstmt.setString(4, sSerialId);
			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbQuery = null;
		}
	}

	public void deleteDuplicateAlarmLogs() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQry = "DELETE FROM " + SCHEMA_NAME + ".ALARM_HISTORY WHERE SERIAL_ID NOT LIKE 'RL100%' AND "
					+ "oid IN (SELECT oid FROM (SELECT oid, row_number() over "
					+ "(partition BY RM_ID, SERIAL_ID, TEXT, OCCURED_ON ORDER BY oid) AS rnum FROM " + SCHEMA_NAME
					+ ".ALARM_HISTORY) t WHERE t.rnum > 1)";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			stmt.execute(sQry);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public MapList getHeaders() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlHeaders = new MapList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".PARAM_HEADERS");
			sbQuery.append(" ORDER BY CNTRL_TYPE,HEADER_LOC ASC");

			Map<String, String> mHeader = null;
			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				mHeader = new HashMap<String, String>();
				mHeader.put(HEADER_LOC, String.valueOf(rs.getInt(HEADER_LOC)));
				mHeader.put(HEADER_NAME, rs.getString(HEADER_NAME));
				mHeader.put(CNTRL_TYPE, rs.getString(CNTRL_TYPE));

				mlHeaders.add(mHeader);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlHeaders;
	}

	public Map<Integer, String> getHeaders(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<Integer, String> mHeader = new HashMap<Integer, String>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".PARAM_HEADERS");
			sbQuery.append(" where CNTRL_TYPE = '" + cntrlType + "'");
			sbQuery.append(" ORDER BY CNTRL_TYPE,HEADER_LOC ASC");

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				mHeader.put(Integer.valueOf(rs.getInt(HEADER_LOC)), rs.getString(HEADER_NAME));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mHeader;
	}

	public Map<String, String> displayHeaders(String cntrlType) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> mDisplayHeaders = new HashMap<String, String>();

		try {
			Map<Integer, String> mHeaders = getHeaders(cntrlType);
			if (!mHeaders.isEmpty()) {
				boolean fg = false;
				int iLoc = 0;
				String sGroup = null;
				StringBuilder sbLocs = new StringBuilder();

				Iterator<Integer> itr = mHeaders.keySet().iterator();
				while (itr.hasNext()) {
					if (fg) {
						sbLocs.append(",");
					}
					sbLocs.append(itr.next().toString());
					fg = true;
				}

				conn = connectionPool.getConnection();
				stmt = conn.createStatement();

				String selectString = "select DISTINCT PARAM_GROUP,DISPLAY_ORDER,PARAM_NAME from " + SCHEMA_NAME
						+ ".CONTROLLER_PARAMS_ADMIN " + "where CNTRL_TYPE = '" + cntrlType + "' and DISPLAY_ORDER IN ("
						+ sbLocs.toString() + ")";
				rs = stmt.executeQuery(selectString);
				while (rs.next()) {
					iLoc = rs.getInt(DISPLAY_ORDER);

					sGroup = rs.getString(PARAM_GROUP);
					sGroup = ((sGroup == null || "".equals(sGroup)) ? rs.getString(PARAM_NAME) : sGroup);

					mDisplayHeaders.put(sGroup, mHeaders.get(Integer.valueOf(iLoc)));
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mDisplayHeaders;
	}

	public boolean addHeader(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sHeaderName = mInfo.get(HEADER_NAME);
			String sCntrlType = mInfo.get(CNTRL_TYPE);
			String sHeaderLoc = mInfo.get(HEADER_LOC);
			int iHeaderLoc = Integer.parseInt(sHeaderLoc);

			sbInsert.append("insert into " + SCHEMA_NAME + ".PARAM_HEADERS (");
			sbInsert.append("HEADER_NAME,HEADER_LOC,CNTRL_TYPE");
			sbInsert.append(") values ('");
			sbInsert.append(sHeaderName);
			sbInsert.append("',");
			sbInsert.append(iHeaderLoc);
			sbInsert.append(",'");
			sbInsert.append(sCntrlType);
			sbInsert.append("')");

			stmt.executeUpdate(sbInsert.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	public boolean updateHeader(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sHeaderName = mInfo.get(HEADER_NAME);
			String sCntrlType = mInfo.get(CNTRL_TYPE);
			String sHeaderLoc = mInfo.get(HEADER_LOC);
			int iHeaderLoc = Integer.parseInt(sHeaderLoc);
			String sOldHeaderLoc = mInfo.get("OLD_HEADER_LOC");
			int iOldHeaderLoc = Integer.parseInt(sOldHeaderLoc);

			sbUpdate.append("update " + SCHEMA_NAME + ".PARAM_HEADERS set ");
			sbUpdate.append(HEADER_NAME + " = '" + sHeaderName + "'");
			if (iOldHeaderLoc != iHeaderLoc) {
				sbUpdate.append(", ");
				sbUpdate.append(HEADER_LOC + " = " + sHeaderLoc);
			}
			sbUpdate.append(" where ");
			sbUpdate.append(HEADER_LOC + " = " + iOldHeaderLoc);
			sbUpdate.append(" and ");
			sbUpdate.append(CNTRL_TYPE + " = '" + sCntrlType + "'");

			stmt.executeUpdate(sbUpdate.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	public boolean deleteHeader(int iHeaderLoc, String sCntrlType) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".PARAM_HEADERS " + "where HEADER_LOC = " + iHeaderLoc
					+ " and CNTRL_TYPE = '" + sCntrlType + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public Map<String, String> getCntrlGroups() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> mGroups = new HashMap<String, String>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".CNTRL_GROUPS");
			sbQuery.append(" ORDER BY GROUP_NAME ASC");

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				mGroups.put(rs.getString(GROUP_NAME), rs.getString(GROUP_DESC));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mGroups;
	}

	public boolean addCntrlGroup(String group, String desc) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbInsert.append("insert into " + SCHEMA_NAME + ".CNTRL_GROUPS (");
			sbInsert.append("GROUP_NAME,GROUP_DESC");
			sbInsert.append(") values ('");
			sbInsert.append(group);
			sbInsert.append("','");
			sbInsert.append(desc);
			sbInsert.append("')");

			stmt.executeUpdate(sbInsert.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	public boolean updateCntrlGroup(String group, String newName, String desc) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbUpdate.append("update " + SCHEMA_NAME + ".CNTRL_GROUPS set ");
			sbUpdate.append(GROUP_NAME + " = '" + newName + "'");
			sbUpdate.append(", ");
			sbUpdate.append(GROUP_DESC + " = '" + desc + "'");
			sbUpdate.append(" where ");
			sbUpdate.append(GROUP_NAME + " = '" + group + "'");

			stmt.executeUpdate(sbUpdate.toString());

			updateUsersGroup(group, newName);
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	public boolean deleteCntrlGroup(String group) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".CNTRL_GROUPS " + "where GROUP_NAME = '" + group + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);

			updateUsersGroup(group, "");
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	private void updateUsersGroup(String oldName, String newName) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			String sUserId = "";
			String userGroup = "";
			Map<String, String> mUser = new HashMap<String, String>();

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select USER_ID,GROUP_NAME from " + SCHEMA_NAME + ".USER_INFO where " + GROUP_NAME
					+ " LIKE '%" + oldName + "%'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				userGroup = rs.getString(GROUP_NAME);
				userGroup = userGroup.replace(oldName, newName).replace("||", "|");

				if (userGroup.startsWith("|")) {
					userGroup = userGroup.substring(1);
				}
				if (userGroup.endsWith("|")) {
					userGroup = userGroup.substring(0, (userGroup.length() - 1));
				}

				mUser.put(rs.getString(USER_ID), userGroup);
			}

			sbUpdate.append("update " + SCHEMA_NAME + ".USER_INFO set ");
			sbUpdate.append(GROUP_NAME + " = ?");
			sbUpdate.append(" where ");
			sbUpdate.append(USER_ID + " = ?");

			pstmt = conn.prepareStatement(sbUpdate.toString());

			Iterator<String> itr = mUser.keySet().iterator();
			while (itr.hasNext()) {
				sUserId = itr.next();

				pstmt.setString(1, mUser.get(sUserId));
				pstmt.setString(2, sUserId);

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(stmt, rs);
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	public MapList getAdminTasks() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlTasks = new MapList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sTaskAttrs = null;
			String sTaskDepts = null;
			Map<String, String> mTask = null;

			String selectString = "select * from " + SCHEMA_NAME + ".LIST_OF_TASKS ORDER BY TASK_ID ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				mTask = new HashMap<String, String>();
				mTask.put(TASK_ID, rs.getString(TASK_ID));
				mTask.put(TASK_NAME, rs.getString(TASK_NAME));
				mTask.put(DURATION_ALERT, "" + rs.getInt(DURATION_ALERT));
				mTask.put(PRODUCTIVITY_TASK, Boolean.toString(rs.getBoolean(PRODUCTIVITY_TASK)));

				sTaskAttrs = rs.getString(TASK_ATTRIBUTES);
				if (sTaskAttrs == null) {
					sTaskAttrs = "";
				}
				mTask.put(TASK_ATTRIBUTES, sTaskAttrs);

				sTaskDepts = rs.getString(DEPARTMENT_NAME);
				if (sTaskDepts == null) {
					sTaskDepts = "";
				}
				mTask.put(DEPARTMENT_NAME, sTaskDepts);

				mlTasks.add(mTask);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlTasks;
	}

	public boolean addAdminTask(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbInsert.append("insert into " + SCHEMA_NAME + ".LIST_OF_TASKS (");
			sbInsert.append("TASK_ID, TASK_NAME, TASK_ATTRIBUTES, DEPARTMENT_NAME, DURATION_ALERT, PRODUCTIVITY_TASK");
			sbInsert.append(") values ('");
			sbInsert.append(mInfo.get(TASK_ID));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(TASK_NAME));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(TASK_ATTRIBUTES));
			sbInsert.append("','");
			sbInsert.append(mInfo.get(DEPARTMENT_NAME));
			sbInsert.append("',");
			sbInsert.append(mInfo.get(DURATION_ALERT));
			sbInsert.append(",'");
			sbInsert.append(mInfo.get(PRODUCTIVITY_TASK));
			sbInsert.append("')");

			stmt.executeUpdate(sbInsert.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	public boolean updateAdminTask(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbUpdate.append("update " + SCHEMA_NAME + ".LIST_OF_TASKS set ");
			sbUpdate.append(TASK_NAME + " = '" + mInfo.get(TASK_NAME) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(TASK_ATTRIBUTES + " = '" + mInfo.get(TASK_ATTRIBUTES) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(DEPARTMENT_NAME + " = '" + mInfo.get(DEPARTMENT_NAME) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(DURATION_ALERT + " = " + mInfo.get(DURATION_ALERT));
			sbUpdate.append(", ");
			sbUpdate.append(PRODUCTIVITY_TASK + " = '" + mInfo.get(PRODUCTIVITY_TASK) + "'");
			sbUpdate.append(" where ");
			sbUpdate.append(TASK_ID + " = '" + mInfo.get(TASK_ID) + "'");

			stmt.executeUpdate(sbUpdate.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	public boolean deleteAdminTask(String sTaskId) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".LIST_OF_TASKS where TASK_ID = '" + sTaskId + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public MapList getAdminAttributes() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlTaskAttrs = new MapList();

		try {
			double dMaxWeight;
			double dTareWeight;
			String sMaxWeight;
			String sTareWeight;

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			Map<String, String> mTaskAttrs = null;

			String selectString = "select * from " + SCHEMA_NAME + ".TASK_ATTRIBUTES_INFO ORDER BY ATTRIBUTE_NAME ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				mTaskAttrs = new HashMap<String, String>();
				mTaskAttrs.put(ATTRIBUTE_NAME, rs.getString(ATTRIBUTE_NAME));
				mTaskAttrs.put(ATTRIBUTE_UNIT, rs.getString(ATTRIBUTE_UNIT));
				mTaskAttrs.put(CALCULATE, rs.getString(CALCULATE));

				dMaxWeight = rs.getDouble(MAX_WEIGHT);
				sMaxWeight = "";
				if (dMaxWeight > 0) {
					sMaxWeight = df.format(dMaxWeight);
				}
				mTaskAttrs.put(MAX_WEIGHT, sMaxWeight);

				dTareWeight = rs.getDouble(TARE_WEIGHT);
				sTareWeight = "";
				if (dTareWeight > 0) {
					sTareWeight = df.format(dTareWeight);
				}
				mTaskAttrs.put(TARE_WEIGHT, sTareWeight);

				mlTaskAttrs.add(mTaskAttrs);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlTaskAttrs;
	}

	public boolean addAdminAttribute(Map<String, String> mAttribute) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbInsert.append("insert into " + SCHEMA_NAME + ".TASK_ATTRIBUTES_INFO (");
			sbInsert.append("ATTRIBUTE_NAME, ATTRIBUTE_UNIT, MAX_WEIGHT, TARE_WEIGHT, CALCULATE");
			sbInsert.append(") values ('");
			sbInsert.append(mAttribute.get(ATTRIBUTE_NAME));
			sbInsert.append("','");
			sbInsert.append(mAttribute.get(ATTRIBUTE_UNIT));
			sbInsert.append("',");
			sbInsert.append(mAttribute.get(MAX_WEIGHT));
			sbInsert.append(",");
			sbInsert.append(mAttribute.get(TARE_WEIGHT));
			sbInsert.append(",'");
			sbInsert.append(mAttribute.get(CALCULATE));
			sbInsert.append("')");

			stmt.executeUpdate(sbInsert.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	public boolean updateAdminAttribute(Map<String, String> mAttribute) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			String sAttrName = mAttribute.get(ATTRIBUTE_NAME);
			String sOldAttrName = mAttribute.get("OLD_ATTRIBUTE_NAME");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbUpdate.append("update " + SCHEMA_NAME + ".TASK_ATTRIBUTES_INFO set ");
			sbUpdate.append(ATTRIBUTE_NAME + " = '" + sAttrName + "'");
			sbUpdate.append(", ");
			sbUpdate.append(ATTRIBUTE_UNIT + " = '" + mAttribute.get(ATTRIBUTE_UNIT) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(MAX_WEIGHT + " = " + mAttribute.get(MAX_WEIGHT));
			sbUpdate.append(", ");
			sbUpdate.append(TARE_WEIGHT + " = " + mAttribute.get(TARE_WEIGHT));
			sbUpdate.append(", ");
			sbUpdate.append(CALCULATE + " = '" + mAttribute.get(CALCULATE) + "'");
			sbUpdate.append(" where ");
			sbUpdate.append(ATTRIBUTE_NAME + " = '" + sOldAttrName + "'");

			stmt.executeUpdate(sbUpdate.toString());

			if (!sAttrName.equals(sOldAttrName)) {
				updateTaskAttribute(mAttribute);
				updateDeliverableAttribute(mAttribute);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	public boolean deleteAdminAttribute(String sAttrName) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			int cnt = 0;
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select COUNT(*) from " + SCHEMA_NAME + ".LIST_OF_TASKS where " + TASK_ATTRIBUTES
					+ " LIKE '%" + sAttrName + "%'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				cnt = rs.getInt(1);
			}

			if (cnt == 0) {
				String sQuery = "delete from " + SCHEMA_NAME + ".TASK_ATTRIBUTES_INFO where ATTRIBUTE_NAME = '"
						+ sAttrName + "'";
				stmt.execute(sQuery);

				Map<String, String> mAttribute = new HashMap<String, String>();
				mAttribute.put(ATTRIBUTE_NAME, "");
				mAttribute.put("OLD_ATTRIBUTE_NAME", sAttrName);

				updateTaskAttribute(mAttribute);
			} else {
				throw new Exception("Cannot delete the attribute, attribute already added in some Tasks");
			}
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	private void updateDeliverableAttribute(Map<String, String> mAttribute) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			sbUpdate.append("update " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO set ");
			sbUpdate.append(ATTRIBUTE_NAME + " = '" + mAttribute.get(ATTRIBUTE_NAME) + "'");
			sbUpdate.append(" where ");
			sbUpdate.append(ATTRIBUTE_NAME + " = '" + mAttribute.get("OLD_ATTRIBUTE_NAME") + "'");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			stmt.executeUpdate(sbUpdate.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	private void updateTaskAttribute(Map<String, String> mAttribute) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			String sAttrName = mAttribute.get(ATTRIBUTE_NAME);
			String sOldAttrName = mAttribute.get("OLD_ATTRIBUTE_NAME");

			String sTaskId = "";
			String sTaskAttrs = "";
			Map<String, String> mTask = new HashMap<String, String>();

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select TASK_ID,TASK_ATTRIBUTES from " + SCHEMA_NAME + ".LIST_OF_TASKS where "
					+ TASK_ATTRIBUTES + " LIKE '%" + sOldAttrName + "%'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sTaskAttrs = rs.getString(TASK_ATTRIBUTES);
				sTaskAttrs = sTaskAttrs.replace(sOldAttrName, sAttrName).replace("||", "|");

				if (sTaskAttrs.startsWith("|")) {
					sTaskAttrs = sTaskAttrs.substring(1);
				}
				if (sTaskAttrs.endsWith("|")) {
					sTaskAttrs = sTaskAttrs.substring(0, (sTaskAttrs.length() - 1));
				}

				mTask.put(rs.getString(TASK_ID), sTaskAttrs);
			}

			sbUpdate.append("update " + SCHEMA_NAME + ".LIST_OF_TASKS set ");
			sbUpdate.append(TASK_ATTRIBUTES + " = ?");
			sbUpdate.append(" where ");
			sbUpdate.append(TASK_ID + " = ?");

			pstmt = conn.prepareStatement(sbUpdate.toString());

			Iterator<String> itr = mTask.keySet().iterator();
			while (itr.hasNext()) {
				sTaskId = itr.next();

				pstmt.setString(1, mTask.get(sTaskId));
				pstmt.setString(2, sTaskId);

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(stmt, rs);
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	public void saveParameters(String sController, String[] saLogData) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		boolean fg = false;
		String sParam = null;
		StringBuilder sbCols = new StringBuilder();
		StringBuilder sbVals = new StringBuilder();
		StringList slNames = new StringList();
		StringList slDuplicateIdx = new StringList();

		try {
			boolean isGeneral = isGeneralController(sController);
			String roomTable = sController.replace(" ", "") + "_param_data";

			if (saLogData.length == 0) {
				return;
			}

			String sKeys = "";
			for (int x = 0; x < saLogData.length; x++) {
				if (saLogData[x].contains(":")) {
					break;
				}
				sKeys += saLogData[x].replace("\n", " ");
			}

			String[] saKeys = sKeys.split(",");
			int iSz = saKeys.length;
			for (int i = 1; i < iSz; i++) {
				sParam = saKeys[i].trim();
				sParam = sParam.replace(" ", "_");

				if (slNames.contains(sParam) || "".equals(sParam)) {
					slDuplicateIdx.add(Integer.toString(i));
					continue;
				}
				slNames.add(sParam);

				if (fg) {
					sbCols.append(", ");
					sbVals.append(", ");
				}

				sbCols.append(sParam);
				sbVals.append("?");

				fg = true;
			}

			String sBatchNo = "";
			String sInsertStmt = null;
			if (isGeneral) {
				sInsertStmt = "insert into " + SCHEMA_NAME + "." + roomTable + " (LOG_DATE, LOG_TIME, "
						+ sbCols.toString() + ") values (?, ?, " + sbVals.toString() + ")";
			} else {
				sInsertStmt = "insert into " + SCHEMA_NAME + "." + roomTable + " (LOG_DATE, LOG_TIME, BATCH_NO, "
						+ sbCols.toString() + ") values (?, ?, ?, " + sbVals.toString() + ")";

				sBatchNo = getBatchNo(sController);
			}

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sInsertStmt);

			int idx = 0;
			iSz = slNames.size();
			String[] saVals = null;
			String sDate = null;
			String sTime = null;

			for (int j = 1; j < saLogData.length; j++) {
				try {
					int i = 2;
					saVals = saLogData[j].split(",");

					if (saVals.length < iSz) {
						continue;
					}

					idx = saVals[0].indexOf('T');
					sDate = saVals[0].substring(0, idx);
					sTime = saVals[0].substring((idx + 1));
					sTime = sTime.substring(0, 8);

					pstmt.setDate(1, java.sql.Date.valueOf(sDate));
					pstmt.setTime(2, java.sql.Time.valueOf(sTime));
					if (!isGeneral) {
						pstmt.setString(3, sBatchNo);
						i = 3;
					}

					int pos = 1;
					for (int k = 1; k < saVals.length; k++) {
						if (!slDuplicateIdx.contains(Integer.toString(k))) {
							pstmt.setString(pos + i, saVals[k]);
							pos++;
						}
					}

					pstmt.executeUpdate();
					pstmt.clearParameters();
				} catch (Exception e) {
					System.out.println(sController + "-[" + sDate + " : " + sTime + "] : " + e.getMessage());
				}
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbCols = null;
			sbVals = null;
			slNames = null;
			slDuplicateIdx = null;
		}
	}

	public Map<String, ParamSettings> getGeneralParamAdminSettings(String sCntrlType)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, ParamSettings> map = new HashMap<String, ParamSettings>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sName = null;
			String selectString = "select * from " + SCHEMA_NAME + ".GENERAL_PARAMS_ADMIN where CNTRL_TYPE = '"
					+ sCntrlType + "'";

			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sName = rs.getString(PARAM_NAME);

				ParamSettings mParam = new ParamSettings(sName);
				mParam.setParamUnit(rs.getString(PARAM_UNIT));
				mParam.setDisplayOrder(rs.getInt(DISPLAY_ORDER));
				mParam.setHelperRead(rs.getString(HELPER_READ));
				mParam.setHelperWrite(rs.getString(HELPER_WRITE));
				mParam.setSupervisorRead(rs.getString(SUPERVISOR_READ));
				mParam.setSupervisorWrite(rs.getString(SUPERVISOR_WRITE));
				mParam.setManagerRead(rs.getString(MANAGER_READ));
				mParam.setManagerWrite(rs.getString(MANAGER_WRITE));
				mParam.setAdminRead(rs.getString(ADMIN_READ));
				mParam.setAdminWrite(rs.getString(ADMIN_WRITE));
				mParam.setScaleOnGraph(rs.getInt(SCALE_ON_GRAPH));
				mParam.setGraphView(rs.getString(GRAPH_VIEW));
				mParam.setOnOffValue(rs.getString(ON_OFF_VALUE));
				mParam.setParamInfo(rs.getString(PARAM_INFO));

				mParam.setHelperAccess(getRoleAccess(rs.getString(HELPER_READ), rs.getString(HELPER_WRITE)));
				mParam.setSupervisorAccess(
						getRoleAccess(rs.getString(SUPERVISOR_READ), rs.getString(SUPERVISOR_WRITE)));
				mParam.setManagerAccess(getRoleAccess(rs.getString(MANAGER_READ), rs.getString(MANAGER_WRITE)));
				mParam.setAdminAccess(getRoleAccess(rs.getString(ADMIN_READ), rs.getString(ADMIN_WRITE)));

				map.put(sName, mParam);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return map;
	}

	public ArrayList<String> getGeneralParamDisplayOrder(String sCntrlType) throws SQLException, InterruptedException {
		ArrayList<String> alOrderParams = new ArrayList<String>();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sParam = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select PARAM_NAME from " + SCHEMA_NAME + ".GENERAL_PARAMS_ADMIN "
					+ "where DISPLAY_ORDER != '0' and CNTRL_TYPE = '" + sCntrlType
					+ "' ORDER BY DISPLAY_ORDER,PARAM_NAME ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sParam = rs.getString(PARAM_NAME);
				alOrderParams.add(sParam);
			}

			close(rs);

			selectString = "select PARAM_NAME from " + SCHEMA_NAME + ".GENERAL_PARAMS_ADMIN "
					+ "where DISPLAY_ORDER = '0' and CNTRL_TYPE = '" + sCntrlType + "' ORDER BY PARAM_NAME ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sParam = rs.getString(PARAM_NAME);
				alOrderParams.add(sParam);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return alOrderParams;
	}

	public boolean updateGeneralParamSettings(MapList mlParamSettings) throws Throwable {
		Connection conn = null;
		PreparedStatement pstmt = null;
		Map<String, String> map = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			sbUpdate.append("update " + SCHEMA_NAME + ".GENERAL_PARAMS_ADMIN set ");
			sbUpdate.append("PARAM_UNIT = ?, ");
			sbUpdate.append("DISPLAY_ORDER = ?, ");
			sbUpdate.append("HELPER_READ = ?, ");
			sbUpdate.append("HELPER_WRITE = ?, ");
			sbUpdate.append("SUPERVISOR_READ = ?, ");
			sbUpdate.append("SUPERVISOR_WRITE = ?, ");
			sbUpdate.append("MANAGER_READ = ?, ");
			sbUpdate.append("MANAGER_WRITE = ?, ");
			sbUpdate.append("ADMIN_READ = ?, ");
			sbUpdate.append("ADMIN_WRITE = ?, ");
			sbUpdate.append("SCALE_ON_GRAPH = ?, ");
			sbUpdate.append("GRAPH_VIEW = ?, ");
			sbUpdate.append("ON_OFF_VALUE = ?, ");
			sbUpdate.append("PARAM_INFO = ? ");
			sbUpdate.append("where PARAM_NAME = ?");
			sbUpdate.append(" and ");
			sbUpdate.append("CNTRL_TYPE = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			String sDisplayOrder;
			String sGraphScale;
			String sParamUnit;
			String sParamInfo;
			int iDisplayOrder;
			int iGraphScale;
			for (int i = 0, iSz = mlParamSettings.size(); i < iSz; i++) {
				map = mlParamSettings.get(i);

				sDisplayOrder = map.get(DISPLAY_ORDER);
				sDisplayOrder = ((sDisplayOrder == null || "".equals(sDisplayOrder)) ? "0" : sDisplayOrder);
				iDisplayOrder = Integer.parseInt(sDisplayOrder);
				iDisplayOrder = ((iDisplayOrder < 0) ? 0 : iDisplayOrder);

				sGraphScale = map.get(SCALE_ON_GRAPH);
				sGraphScale = ((sGraphScale == null || "".equals(sGraphScale)) ? "1" : sGraphScale);
				iGraphScale = Integer.parseInt(sGraphScale);
				iGraphScale = ((iGraphScale < 1) ? 1 : iGraphScale);

				sParamUnit = map.get(PARAM_UNIT);
				sParamUnit = ((sParamUnit == null || "null".equals(sParamUnit)) ? "" : sParamUnit);

				sParamInfo = map.get(PARAM_INFO);
				sParamInfo = ((sParamInfo == null || "N".equals(sParamInfo)) ? "" : sParamInfo);

				pstmt.setString(1, sParamUnit);
				pstmt.setInt(2, iDisplayOrder);
				pstmt.setString(3, map.get(HELPER_READ));
				pstmt.setString(4, map.get(HELPER_WRITE));
				pstmt.setString(5, map.get(SUPERVISOR_READ));
				pstmt.setString(6, map.get(SUPERVISOR_WRITE));
				pstmt.setString(7, map.get(MANAGER_READ));
				pstmt.setString(8, map.get(MANAGER_WRITE));
				pstmt.setString(9, map.get(ADMIN_READ));
				pstmt.setString(10, map.get(ADMIN_WRITE));
				pstmt.setInt(11, iGraphScale);
				pstmt.setString(12, map.get(GRAPH_VIEW));
				pstmt.setString(13, map.get(ON_OFF_VALUE));
				pstmt.setString(14, sParamInfo);
				pstmt.setString(15, map.get(PARAM_NAME));
				pstmt.setString(16, map.get(CNTRL_TYPE));

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
			RDMServicesUtils.setViewParamaters(map.get(CNTRL_TYPE));
		}
		return true;
	}

	public boolean insertGeneralParamSettings(MapList mlParamSettings) throws Throwable {
		Connection conn = null;
		PreparedStatement pstmt = null;
		Map<String, String> map = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			sbInsert.append("insert into " + SCHEMA_NAME
					+ ".GENERAL_PARAMS_ADMIN (PARAM_NAME, PARAM_UNIT, DISPLAY_ORDER, "
					+ "HELPER_READ, HELPER_WRITE, SUPERVISOR_READ, SUPERVISOR_WRITE, MANAGER_READ, MANAGER_WRITE, ADMIN_READ, ADMIN_WRITE, "
					+ "CNTRL_TYPE, SCALE_ON_GRAPH, GRAPH_VIEW, ON_OFF_VALUE, PARAM_INFO) "
					+ "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbInsert.toString());

			String sDisplayOrder;
			String sGraphScale;
			String sParamUnit;
			String sParamInfo;
			int iDisplayOrder;
			int iGraphScale;
			for (int i = 0, iSz = mlParamSettings.size(); i < iSz; i++) {
				map = mlParamSettings.get(i);

				sDisplayOrder = map.get(DISPLAY_ORDER);
				sDisplayOrder = ((sDisplayOrder == null || "".equals(sDisplayOrder)) ? "0" : sDisplayOrder);
				iDisplayOrder = Integer.parseInt(sDisplayOrder);
				iDisplayOrder = ((iDisplayOrder < 0) ? 0 : iDisplayOrder);

				sGraphScale = map.get(SCALE_ON_GRAPH);
				sGraphScale = ((sGraphScale == null || "".equals(sGraphScale)) ? "1" : sGraphScale);
				iGraphScale = Integer.parseInt(sGraphScale);
				iGraphScale = ((iGraphScale < 1) ? 1 : iGraphScale);

				sParamUnit = map.get(PARAM_UNIT);
				sParamUnit = ((sParamUnit == null || "null".equals(sParamUnit)) ? "" : sParamUnit);

				sParamInfo = map.get(PARAM_INFO);
				sParamInfo = ((sParamInfo == null || "N".equals(sParamInfo)) ? "" : sParamInfo);

				pstmt.setString(1, map.get(PARAM_NAME));
				pstmt.setString(2, sParamUnit);
				pstmt.setInt(3, iDisplayOrder);
				pstmt.setString(4, map.get(HELPER_READ));
				pstmt.setString(5, map.get(HELPER_WRITE));
				pstmt.setString(6, map.get(SUPERVISOR_READ));
				pstmt.setString(7, map.get(SUPERVISOR_WRITE));
				pstmt.setString(8, map.get(MANAGER_READ));
				pstmt.setString(9, map.get(MANAGER_WRITE));
				pstmt.setString(10, map.get(ADMIN_READ));
				pstmt.setString(11, map.get(ADMIN_WRITE));
				pstmt.setString(12, map.get(CNTRL_TYPE));
				pstmt.setInt(13, iGraphScale);
				pstmt.setString(14, map.get(GRAPH_VIEW));
				pstmt.setString(15, map.get(ON_OFF_VALUE));
				pstmt.setString(16, sParamInfo);

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbInsert = null;
			RDMServicesUtils.setViewParamaters(map.get(CNTRL_TYPE));
		}

		return true;
	}

	public boolean deleteGeneralParamSettings(String sParams, String cntrlType)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			if (sParams == null || "".equals(sParams)) {
				return true;
			}

			String sQuery = "delete from " + SCHEMA_NAME + ".GENERAL_PARAMS_ADMIN " + "where CNTRL_TYPE = '" + cntrlType
					+ "' and PARAM_NAME IN ( " + sParams + " )";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
		return true;
	}

	public String getProductType(String sController) throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sProduct = "";

		try {
			String sQry = "select DEF_VAL_TYPE from " + SCHEMA_NAME + ".BATCH_INFO" + " where RM_ID = ?"
					+ " and (START_DT IS NOT NULL and END_DT IS NULL)";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQry);
			pstmt.setString(1, sController);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				sProduct = rs.getString(DEF_VAL_TYPE);
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}
		return sProduct;
	}

	public String getBatchNo(String sController) throws SQLException, InterruptedException {
		return getBatchNo(sController, true);
	}

	public String getBatchNo(String sController, boolean bIgnoreAutoName) throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sBatchNo = "";

		try {
			String sQry = "select BATCH_NO from " + SCHEMA_NAME + ".BATCH_INFO" + " where RM_ID = ?"
					+ " and (START_DT IS NOT NULL and END_DT IS NULL)";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQry);
			pstmt.setString(1, sController);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				sBatchNo = rs.getString(BATCH_NO);
			}

			if (bIgnoreAutoName && (sBatchNo.startsWith("-") && sBatchNo.endsWith("-"))) {
				sBatchNo = "";
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}
		return sBatchNo;
	}

	public String getBatchDefType(String sController, String sBatchNo) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sDefValType = "";

		try {
			String sQry = "select DEF_VAL_TYPE from " + SCHEMA_NAME + ".BATCH_INFO";
			if (sBatchNo == null || "".equals(sBatchNo)) {
				sQry += " where RM_ID = '" + sController + "' and (START_DT IS NOT NULL and END_DT IS NULL)";
			} else {
				sQry += " where RM_ID = '" + sController + "' and BATCH_NO = '" + sBatchNo + "'";
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sQry);

			while (rs.next()) {
				sDefValType = rs.getString(DEF_VAL_TYPE);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return sDefValType;
	}

	public MapList getBatchNos(String sCntrlType, String sProductType) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlBatchNos = new MapList();

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy hh:mm a");
			Map<String, String> mBatchNo = null;
			boolean bIsEmpty = RDMServicesUtils.isNullOrEmpty(sCntrlType);

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".BATCH_INFO");
			sbQuery.append(" where ");
			sbQuery.append("(START_DT IS NOT NULL and END_DT IS NULL)");
			if (!bIsEmpty) {
				sbQuery.append(" AND ");
				sbQuery.append("CNTRL_TYPE = '" + sCntrlType + "'");
			}
			if (!"".equals(sProductType)) {
				sbQuery.append(" AND ");
				sbQuery.append("DEF_VAL_TYPE = '" + sProductType + "'");
			}
			sbQuery.append(" ORDER BY CNTRL_TYPE, " + SCHEMA_NAME + ".sort_alphanumeric(RM_ID)");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbQuery.toString());

			String sRoomId = null;
			String sRoomType = null;
			String sBatchNo = null;
			StringList slRooms = new StringList();

			while (rs.next()) {
				sBatchNo = rs.getString(BATCH_NO);
				if (sBatchNo.startsWith("-") && sBatchNo.endsWith("-")) {
					continue;
				}

				mBatchNo = new HashMap<String, String>();
				sRoomId = rs.getString(ROOM_ID);
				mBatchNo.put(ROOM_ID, sRoomId);
				mBatchNo.put(BATCH_NO, sBatchNo);
				mBatchNo.put(START_DT, sdf.format(rs.getTimestamp(START_DT)));
				mBatchNo.put(END_DT, "");
				mBatchNo.put(DEF_VAL_TYPE, rs.getString(DEF_VAL_TYPE));
				mBatchNo.put(CNTRL_TYPE, rs.getString(CNTRL_TYPE));
				mlBatchNos.add(mBatchNo);

				slRooms.add(sRoomId);
			}

			MapList mlRooms = RDMServicesUtils.getRoomsList();
			for (int i = 0; i < mlRooms.size(); i++) {
				sRoomId = mlRooms.get(i).get(ROOM_ID);
				sRoomType = mlRooms.get(i).get(CNTRL_TYPE);

				if (!slRooms.contains(sRoomId) && (bIsEmpty || sRoomType.equals(sCntrlType))) {
					mBatchNo = new HashMap<String, String>();
					mBatchNo.put(ROOM_ID, sRoomId);
					mBatchNo.put(BATCH_NO, "");
					mBatchNo.put(START_DT, "");
					mBatchNo.put(END_DT, "");
					mBatchNo.put(DEF_VAL_TYPE, "");
					mBatchNo.put(CNTRL_TYPE, sRoomType);
					mlBatchNos.add(mBatchNo);
				}
			}

			mlBatchNos.sort(CNTRL_TYPE, ROOM_ID);
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return mlBatchNos;
	}

	public MapList getBatchLoad(String sStartDt, String sEndDt, String sCntrlType, String sProductType, boolean bYield,
			boolean bInactiveCntrls) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlBatchNos = new MapList();
		Map<String, Map<String, String>> mBatchLoads = new HashMap<String, Map<String, String>>();

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
			Map<String, String> mBatchNo = null;
			String sBatchNo = null;
			StringList slBatchNos = new StringList();

			String sRoomId = null;
			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".BATCH_INFO");
			sbQuery.append(" where ");
			sbQuery.append("END_DT BETWEEN ? AND ?");
			if (!"".equals(sCntrlType)) {
				sbQuery.append(" AND ");
				sbQuery.append("CNTRL_TYPE = ?");
			}
			if (!"".equals(sProductType)) {
				sbQuery.append(" AND ");
				sbQuery.append("DEF_VAL_TYPE = ?");
			}
			sbQuery.append(" ORDER BY CNTRL_TYPE, " + SCHEMA_NAME + ".sort_alphanumeric(RM_ID), START_DT DESC");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbQuery.toString());

			pstmt.setTimestamp(1, java.sql.Timestamp.valueOf(sStartDt + " 00:00:00.000"));
			pstmt.setTimestamp(2, java.sql.Timestamp.valueOf(sEndDt + " 23:55:00.000"));
			if (!"".equals(sCntrlType) && !"".equals(sProductType)) {
				pstmt.setString(3, sCntrlType);
				pstmt.setString(4, sProductType);
			} else if (!"".equals(sCntrlType)) {
				pstmt.setString(3, sCntrlType);
			}
			rs = pstmt.executeQuery();

			ServicesSession session = new ServicesSession();
			StringList slControllers = session.getAllControllers();

			while (rs.next()) {
				sRoomId = rs.getString(ROOM_ID);
				if (slControllers.contains(sRoomId) || bInactiveCntrls) {
					sBatchNo = rs.getString(BATCH_NO);
					if (sBatchNo.startsWith("-") && sBatchNo.endsWith("-")) {
						continue;
					}

					mBatchNo = new HashMap<String, String>();
					mBatchNo.put(ROOM_ID, sRoomId);
					mBatchNo.put(BATCH_NO, sBatchNo);
					mBatchNo.put(START_DT, sdf.format(rs.getTimestamp(START_DT)));
					mBatchNo.put(END_DT, sdf.format(rs.getTimestamp(END_DT)));
					mBatchNo.put(DEF_VAL_TYPE, rs.getString(DEF_VAL_TYPE));
					mBatchNo.put(CNTRL_TYPE, rs.getString(CNTRL_TYPE));

					if (bYield) {
						mBatchLoads.put(sBatchNo, mBatchNo);
						slBatchNos.add("'" + sBatchNo + "'");
					} else {
						mlBatchNos.add(mBatchNo);
					}
				}
			}

			rs.close();

			if (bYield && !slBatchNos.isEmpty()) {
				DecimalFormat df1 = new DecimalFormat("#.##");

				String sQry = "select BATCH_NO, SUM(DAILY_YIELD) as total from " + SCHEMA_NAME + ".DAILY_YIELD"
						+ " where BATCH_NO IN (" + slBatchNos.join(',') + ") group by BATCH_NO,RM_ID" + " ORDER BY "
						+ SCHEMA_NAME + ".sort_alphanumeric(RM_ID)";

				stmt = conn.createStatement();
				rs = stmt.executeQuery(sQry);

				while (rs.next()) {
					mBatchNo = mBatchLoads.get(rs.getString(BATCH_NO));
					mBatchNo.put(DAILY_YIELD, df1.format(rs.getDouble("total")));
					mlBatchNos.add(mBatchNo);
				}
			}
		} finally {
			close(stmt, rs);
			close(pstmt, null);
			connectionPool.free(conn);

			mBatchLoads = null;
		}
		return mlBatchNos;
	}

	public void addBatchNo(String sController, String BNo, String sDefType) throws Exception {
		if (isBatchExists(sController, BNo)) {
			throw new Exception("Batch " + BNo + " already created for Room " + sController);
		}

		insertBatchNo(sController, BNo, sDefType);
		closeBatchNo(sController, BNo);
	}

	public void updateBatchNo(String sController, String BNo, String sDefType) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			if (isBatchExists(sController, BNo)) {
				throw new Exception("Batch " + BNo + " already created for Room " + sController);
			}

			sbUpdate.append("update " + SCHEMA_NAME + ".BATCH_INFO set ");
			if (!"".equals(sDefType)) {
				sbUpdate.append("DEF_VAL_TYPE = ?, ");
			}
			sbUpdate.append("BATCH_NO = ? ");
			sbUpdate.append("where RM_ID = ? and (START_DT IS NOT NULL and END_DT IS NULL)");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			if ("".equals(sDefType)) {
				pstmt.setString(1, BNo);
				pstmt.setString(2, sController);
			} else {
				pstmt.setString(1, sDefType);
				pstmt.setString(2, BNo);
				pstmt.setString(3, sController);
			}

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	public void updateDefaultProduct(String sController, String BNo, String sDefType) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			sbUpdate.append("update " + SCHEMA_NAME + ".BATCH_INFO set ");
			sbUpdate.append("DEF_VAL_TYPE = ? ");
			sbUpdate.append("where BATCH_NO = ? and RM_ID = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			pstmt.setString(1, sDefType);
			pstmt.setString(2, BNo);
			pstmt.setString(3, sController);

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	private boolean isBatchExists(String sController, String BNo) throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sQuery = "SELECT BATCH_NO FROM " + SCHEMA_NAME + ".BATCH_INFO WHERE RM_ID = ? and BATCH_NO = ?";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);
			pstmt.setString(1, sController);
			pstmt.setString(2, BNo);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				return true;
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return false;
	}

	private void insertBatchNo(String sController, String BNo, String sDefType) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			String sCntrlType = RDMServicesUtils.getControllerType(sController);

			Calendar cal = Calendar.getInstance();

			sbInsert.append("insert into " + SCHEMA_NAME + ".BATCH_INFO (");
			sbInsert.append("RM_ID, BATCH_NO, START_DT, CNTRL_TYPE, DEF_VAL_TYPE");
			sbInsert.append(") values (");
			sbInsert.append("?, ?, ?, ?, ?)");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbInsert.toString());

			pstmt.setString(1, sController);
			pstmt.setString(2, BNo);
			pstmt.setTimestamp(3, new java.sql.Timestamp(cal.getTimeInMillis()));
			pstmt.setString(4, sCntrlType);
			pstmt.setString(5, sDefType);

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbInsert = null;
		}
	}

	public void closeBatchNo(String sController, String sBNo) throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			Calendar cal = Calendar.getInstance();

			sbUpdate.append("update " + SCHEMA_NAME + ".BATCH_INFO set");
			sbUpdate.append(" END_DT = ?");
			sbUpdate.append(" where RM_ID = ? and (START_DT IS NOT NULL and END_DT IS NULL)");
			if (sBNo != null && !"".equals(sBNo)) {
				sbUpdate.append(" and BATCH_NO != ?");
			}

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			pstmt.setTimestamp(1, new java.sql.Timestamp(cal.getTimeInMillis()));
			pstmt.setString(2, sController);
			if (sBNo != null && !"".equals(sBNo)) {
				pstmt.setString(3, sBNo);
			}

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	public Map<String, String> getUserDetails(String name) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> mUserInfo = new HashMap<String, String>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select * from " + SCHEMA_NAME + ".USER_INFO where USER_ID = '" + name + "'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				mUserInfo = new HashMap<String, String>();
				mUserInfo.put(USER_ID, rs.getString(USER_ID));
				mUserInfo.put(PASSWORD, rs.getString(PASSWORD));
				mUserInfo.put(FIRST_NAME, rs.getString(FIRST_NAME));
				mUserInfo.put(LAST_NAME, rs.getString(LAST_NAME));
				mUserInfo.put(EMAIL, rs.getString(EMAIL));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mUserInfo;
	}

	public MapList getYields(String sRoom, String sFromDate, String sToDate, String sCond, String sYield, String sBNo,
			boolean bGrpByDate) throws SQLException, InterruptedException, ParseException {
		return getYields(sRoom, sFromDate, sToDate, sCond, sYield, sBNo, bGrpByDate, false);
	}

	public MapList getYields(String sRoom, String sFromDate, String sToDate, String sCond, String sYield, String sBNo,
			boolean bGrpByDate, boolean showInGraph) throws SQLException, InterruptedException, ParseException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		boolean fg = false;
		MapList mlYields = new MapList();
		Map<String, String> mYield = null;

		try {
			SimpleDateFormat sdf = null;
			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			if (!showInGraph) {
				if (!"".equals(sFromDate)) {
					sFromDate = output.format(input.parse(sFromDate));
				}
				if (!"".equals(sToDate)) {
					sToDate = output.format(input.parse(sToDate));
				}
			}

			if (showInGraph) {
				sdf = new SimpleDateFormat("yyyy/MM/dd");
			} else {
				sdf = new SimpleDateFormat("MM/dd/yyyy");
			}

			StringBuilder sbQuery = new StringBuilder();
			if (!"".equals(sRoom)) {
				sbQuery.append(" where ");
				sbQuery.append(ROOM_ID + " IN ('" + sRoom.replace(",", "','") + "')");
				fg = true;
			}

			if (!"".equals(sFromDate)) {

				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				sbQuery.append(ON_DATE + " >= '" + sFromDate + "'");
				fg = true;
			}

			if (!"".equals(sToDate)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				sbQuery.append(ON_DATE + " <= '" + sToDate + "'");
				fg = true;
			}

			if (!"".equals(sYield)) {
				if (bGrpByDate) {
					if (fg) {
						sbQuery.append(" and ");
					} else {
						sbQuery.append(" where ");
					}

					sbQuery.append(DAILY_YIELD);
					if ("morethan".equals(sCond)) {
						sbQuery.append(" > ");
					} else if ("lessthan".equals(sCond)) {
						sbQuery.append(" < ");
					} else {
						sbQuery.append(" = ");
					}
					sbQuery.append(sYield);
					fg = true;
				} else {
					StringList slBatchNos = getYieldBatchNos(sbQuery.toString(), sYield, sBNo, sCond);
					sBNo = slBatchNos.join(',');
				}
			}

			if (!"".equals(sBNo)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				sBNo = sBNo.replace(",", "%','%");
				sbQuery.append(BATCH_NO + " ~~* any(array['%" + sBNo + "%'])");
			}

			String sQuery = "select * from " + SCHEMA_NAME + ".DAILY_YIELD " + sbQuery.toString();
			sQuery += (bGrpByDate) ? " ORDER BY ON_DATE DESC, " : " ORDER BY BATCH_NO DESC, ON_DATE DESC, ";
			sQuery += SCHEMA_NAME + ".sort_alphanumeric(RM_ID)";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sBatchNo = null;
			String sLoggedBy = null;
			String sComments = null;
			String sStage = null;
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				mYield = new HashMap<String, String>();
				sBatchNo = rs.getString(BATCH_NO);
				sLoggedBy = rs.getString(LOGGED_BY);
				sComments = rs.getString(COMMENTS);
				sStage = rs.getString(STAGE_NUMBER);

				mYield.put(ROOM_ID, rs.getString(ROOM_ID));
				mYield.put(ON_DATE, sdf.format(rs.getDate(ON_DATE)));
				mYield.put(BATCH_NO, ((sBatchNo == null) ? "" : sBatchNo));
				mYield.put(DAILY_YIELD, ("" + rs.getDouble(DAILY_YIELD)));
				mYield.put(EST_YIELD, ("" + rs.getDouble(EST_YIELD)));
				mYield.put(LOGGED_BY, ((sLoggedBy == null) ? "" : sLoggedBy));
				mYield.put(COMMENTS, ((sComments == null) ? "" : sComments));
				mYield.put(STAGE_NUMBER, ((sStage == null) ? "" : sStage));
				mYield.put(RUNNING_DAY, rs.getString(RUNNING_DAY));

				mlYields.add(mYield);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlYields;
	}

	private StringList getYieldBatchNos(String sWhereExpr, String sYield, String sBNo, String sCond)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		StringList slBatchNos = new StringList();
		try {
			boolean bMoreThan = "morethan".equals(sCond);
			boolean bLessThan = "lessthan".equals(sCond);
			double dYieldValue;
			double dYield = Double.valueOf(sYield);
			String sBatchNo = null;
			StringList slBNo = null;
			if (!"".equals(sBNo)) {
				slBNo = StringList.split(sBNo, ",");
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "select SUM(DAILY_YIELD) as total, BATCH_NO from " + SCHEMA_NAME + ".DAILY_YIELD "
					+ sWhereExpr + " GROUP BY BATCH_NO";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				dYieldValue = rs.getDouble("total");
				sBatchNo = rs.getString(BATCH_NO);

				if ((bMoreThan && (dYieldValue > dYield)) || (bLessThan && (dYieldValue < dYield))) {
					if ((slBNo == null) || (slBNo != null && slBNo.contains(sBatchNo))) {
						slBatchNos.add(sBatchNo);
					}
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return slBatchNos;
	}

	public boolean updateYield(String sController, String sEstYield, String sYield, String sDate, String sLoggedBy,
			String sComments) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");
			sDate = output.format(input.parse(sDate));

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			boolean bChanged = false;
			double dEstYield = -1;
			String selectString = "select EST_YIELD from " + SCHEMA_NAME + ".DAILY_YIELD where RM_ID = '" + sController
					+ "' and ON_DATE = '" + sDate + "'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				bChanged = true;
				dEstYield = rs.getDouble(EST_YIELD);
			}

			if (!"".equals(sComments)) {
				SimpleDateFormat sdfIn = new SimpleDateFormat("MM/dd/yyyy HH:mm");
				String sLogDate = sdfIn.format(new java.util.Date());
				sComments = "<b>" + User.getDisplayName(sLoggedBy) + " on " + sLogDate + "</b>\n - " + sComments;

				if (bChanged && (dEstYield != Double.parseDouble(sEstYield))) {
					sComments += " (Estimate changed was: " + dEstYield + ")";
				}
			}

			double dStage = 0.0;
			String sStage = getCurrentStage(sController);
			if (sStage != null && !"".equals(sStage)) {
				dStage = Double.parseDouble(sStage.replace(" ", "."));
			}

			int iNoDays = 0;
			if ("SYSTEM".equals(sLoggedBy)) {
				if (dStage >= 13) {
					dStage = 12.3;
					iNoDays = 1;
				} else {
					iNoDays = getPhaseRunningDay(sController);
				}
			}

			StringBuilder sbQuery = new StringBuilder();
			if (bChanged) {
				sbQuery.append("update " + SCHEMA_NAME + ".DAILY_YIELD set");
				if ("SYSTEM".equals(sLoggedBy)) {
					sbQuery.append(" RUNNING_DAY = '" + iNoDays + "',");
				} else {
					sbQuery.append(" EST_YIELD = '" + sEstYield + "',");
					sbQuery.append(" LOGGED_BY = '" + sLoggedBy + "',");
					sbQuery.append(" COMMENTS = (" + COMMENTS + " || '\n" + sComments + "'),");
				}

				sbQuery.append(" STAGE_NUMBER = '" + dStage + "',");
				sbQuery.append(" DAILY_YIELD = '" + sYield + "'");
				sbQuery.append(" where RM_ID = '" + sController + "'");
				sbQuery.append(" and ON_DATE = '" + sDate + "'");
			} else {
				sbQuery.append("insert into " + SCHEMA_NAME + ".DAILY_YIELD (");
				sbQuery.append("RM_ID, BATCH_NO, ON_DATE, DAILY_YIELD, LOGGED_BY, EST_YIELD, COMMENTS, STAGE_NUMBER");
				if ("SYSTEM".equals(sLoggedBy)) {
					sbQuery.append(", RUNNING_DAY");
				}
				sbQuery.append(") values (");
				sbQuery.append("'" + sController + "', ");
				sbQuery.append("'" + getBatchNo(sController) + "', ");
				sbQuery.append("'" + sDate + "', ");
				sbQuery.append("'" + sYield + "', ");
				sbQuery.append("'" + sLoggedBy + "', ");
				sbQuery.append("'" + sEstYield + "', ");
				sbQuery.append("'" + sComments + "', ");
				sbQuery.append("'" + dStage + "'");
				if ("SYSTEM".equals(sLoggedBy)) {
					sbQuery.append(", '" + iNoDays + "'");
				}
				sbQuery.append(")");
			}

			stmt.executeUpdate(sbQuery.toString());
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public boolean deleteYield(String sUserId, String sController, String sDate) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".DAILY_YIELD where RM_ID = '" + sController
					+ "' and ON_DATE = '" + sDate + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);

			String[] saLog = new String[2];
			saLog[0] = new java.util.Date().toLocaleString();
			saLog[1] = "Yields added on " + sDate
					+ " are deleted by user. Check Room, Logged By & Logged On for details.";

			ArrayList<String[]> alSysLog = new ArrayList<String[]>();
			alSysLog.add(saLog);

			saveSysLogs(sUserId, sController, alSysLog);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
		return true;
	}

	public MapList getControllerData(String sController, StringList slParams, Set<String> keys, int iCnt)
			throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		MapList mlData = new MapList();
		Map<String, String> mData = null;
		String sParam = null;
		String sCurrPhase = null;
		String sStageName = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sCntrlType = RDMServicesUtils.getControllerType(sController);

			String roomTable = sController.replace(" ", "") + "_param_data";
			String sQuery = "SELECT * FROM " + SCHEMA_NAME + "." + roomTable
					+ " ORDER BY log_date DESC, log_time DESC LIMIT " + iCnt;

			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				mData = new HashMap<String, String>();
				mData.put("timestamp", rs.getString("log_date") + " " + rs.getString("log_time"));

				if (sCurrPhase == null) {
					sCurrPhase = rs.getString("current_phase");

					String[] saStage = RDMServicesUtils.getControllerStage(sCntrlType, sCurrPhase);
					sCurrPhase = saStage[0];
					sStageName = saStage[1];
				}

				for (int i = 0; i < slParams.size(); i++) {
					sParam = slParams.get(i);

					if (!keys.contains(sParam)) {
						if ("0".equalsIgnoreCase(sCurrPhase)) {
							sParam = sParam + " " + sStageName;
						} else if (!sCurrPhase.equals(sStageName)) {
							sParam = sParam + " " + sStageName + " " + sCurrPhase;
						}

						if (!keys.contains(sParam)) {
							if ("0".equalsIgnoreCase(sCurrPhase)) {
								sParam = sParam + " " + "phase" + " " + sStageName;
							} else {
								sParam = sParam + " " + "phase" + " " + sCurrPhase;
							}
						}
					}

					if (keys.contains(sParam)) {
						sParam = sParam.replace(" ", "_");
						mData.put(slParams.get(i), rs.getString(sParam));
					}
				}

				mlData.add(mData);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlData;
	}

	public MapList getUserRules(String sCntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		MapList mlRules = new MapList();
		Map<String, String> mRule = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "select * from " + SCHEMA_NAME + ".USER_RULES where CNTRL_TYPE = '" + sCntrlType + "'";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				mRule = new HashMap<String, String>();

				mRule.put(RULE_OID, rs.getString(RULE_OID));
				mRule.put(RULE_EXPRESSION, rs.getString(RULE_EXPRESSION));
				mRule.put(RULE_EXECUTE, ("" + rs.getInt(RULE_EXECUTE)));
				mRule.put(RULE_DESCRIPTION, rs.getString(RULE_DESCRIPTION));
				mRule.put(CNTRL_TYPE, rs.getString(CNTRL_TYPE));

				mlRules.add(mRule);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlRules;
	}

	public boolean addUserRule(String sRule, String sExec, String sRuleDesc, String sCntrlType)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			int iSeq = 0;
			String sQuery = "SELECT nextval('" + SCHEMA_NAME + ".USER_RULES_SEQ')";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				iSeq = rs.getInt("nextval");
			}

			StringBuilder sbInsert = new StringBuilder();
			sbInsert.append("insert into " + SCHEMA_NAME + ".USER_RULES (");
			sbInsert.append("RULE_OID, RULE_EXPRESSION, RULE_EXECUTE, RULE_DESC, CNTRL_TYPE");
			sbInsert.append(") values (");
			sbInsert.append("?, ?, ?, ?, ?");
			sbInsert.append(")");

			pstmt = conn.prepareStatement(sbInsert.toString());

			pstmt.setString(1, ("RL" + iSeq));
			pstmt.setString(2, sRule);
			pstmt.setInt(3, Integer.parseInt(sExec));
			pstmt.setString(4, sRuleDesc);
			pstmt.setString(5, sCntrlType);

			pstmt.executeUpdate();
		} finally {
			close(pstmt, rs);
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public boolean updateRule(String oid, String sRule, String sExec, String sRuleDesc)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + ".USER_RULES set");
			sbUpdate.append(" RULE_EXPRESSION = ?,");
			sbUpdate.append(" RULE_DESC = ?,");
			sbUpdate.append(" RULE_EXECUTE = ?");
			sbUpdate.append(" where RULE_OID = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			pstmt.setString(1, sRule);
			pstmt.setString(2, sRuleDesc);
			pstmt.setInt(3, Integer.parseInt(sExec));
			pstmt.setString(4, oid);

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
		return true;
	}

	public boolean deleteRule(String oid) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".USER_RULES where RULE_OID = '" + oid + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
		return true;
	}

	public StringList getParamGroup(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		StringList slParamGroup = new StringList();
		String sGroup = null;
		String sParam = null;
		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "select DISTINCT PARAM_GROUP, PARAM_NAME from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN "
					+ "where CNTRL_TYPE = '" + cntrlType + "'";

			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				sGroup = rs.getString(PARAM_GROUP);
				sParam = rs.getString(PARAM_NAME);

				if (sGroup == null || "".equals(sGroup)) {
					slParamGroup.add(sParam);
				} else {
					slParamGroup.add(sGroup);
				}
			}

			slParamGroup.sort();
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return slParamGroup;
	}

	public StringList getControllerParameters() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		StringList slParams = new StringList();
		String sParam = null;
		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "select DISTINCT PARAM_NAME from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				sParam = rs.getString(PARAM_NAME);
				slParams.add(sParam);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return slParams;
	}

	public StringList createUserTask(Map<String, String> mTask, String[] saAssignees) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringList slReturn = new StringList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sAutoName = "";
			String sQuery = "SELECT nextval('" + SCHEMA_NAME + ".WBS_TASK_SEQ')";

			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			SimpleDateFormat output = new SimpleDateFormat("dd-MMM-yy hh:mm:ss a");

			String sEstStart = output.format(input.parse(mTask.get(ESTIMATED_START)));
			String sEstEnd = output.format(input.parse(mTask.get(ESTIMATED_END)));

			String sStatus = TASK_STATUS_NOT_STARTED;

			StringBuilder sbInsert = new StringBuilder();
			sbInsert.append("insert into " + SCHEMA_NAME + ".WBS_TASK_INFO (");
			sbInsert.append("TASK_AUTONAME, TASK_ID, RM_ID, OWNER, ASSIGNEE, ");
			sbInsert.append("ESTIMATED_START, ESTIMATED_END, PARENT_TASK, STATUS, CO_OWNERS, SYSTEM_LOG");

			String sRoomId = mTask.get(ROOM_ID);
			boolean bGeneral = isGeneralController(sRoomId);

			if (!"".equals(sRoomId) && !bGeneral) {
				sbInsert.append(", BATCH_NO, STAGE_NUMBER");
				sbInsert.append(") values (");
				sbInsert.append("?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			} else {
				sbInsert.append(") values (");
				sbInsert.append("?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
			}

			pstmt = conn.prepareStatement(sbInsert.toString());

			String sStage = mTask.get(STAGE_NUMBER);
			sStage = ((sStage == null || "".equals(sStage)) ? "0.0" : sStage);

			String sOwner = mTask.get(OWNER);
			String sCreatedBy = mTask.get(CREATED_BY);

			String sSysLog = "";
			if (!sOwner.equals(sCreatedBy)) {
				SimpleDateFormat sdfIn = new SimpleDateFormat("MM/dd/yyyy HH:mm");
				String sLogDate = sdfIn.format(new java.util.Date());
				sSysLog = User.getDisplayName(sCreatedBy) + "[" + sLogDate + "]: Created for "
						+ User.getDisplayName(sOwner);
			}

			for (int i = 0; i < saAssignees.length; i++) {
				rs = stmt.executeQuery(sQuery);
				while (rs.next()) {
					sAutoName = "" + rs.getInt("nextval");

					int iLen = sAutoName.length();
					for (int j = 0, iSz = (6 - iLen); j < iSz; j++) {
						sAutoName = "0" + sAutoName;
					}

					sAutoName = "T-" + sAutoName;
					slReturn.add(sAutoName);
				}

				pstmt.setString(1, sAutoName);
				pstmt.setString(2, mTask.get(TASK_ID));
				pstmt.setString(3, sRoomId);
				pstmt.setString(4, sOwner);
				pstmt.setString(5, saAssignees[i]);
				pstmt.setTimestamp(6, new java.sql.Timestamp(Date.parse(sEstStart)));
				pstmt.setTimestamp(7, new java.sql.Timestamp(Date.parse(sEstEnd)));
				pstmt.setString(8, mTask.get(PARENT_TASK));
				pstmt.setString(9, sStatus);
				pstmt.setString(10, mTask.get(CO_OWNERS));
				pstmt.setString(11, sSysLog);
				if (!"".equals(sRoomId) && !bGeneral) {
					pstmt.setString(12, mTask.get(BATCH_NO));
					pstmt.setDouble(13, Double.valueOf(sStage));
				}

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return slReturn;
	}

	public boolean updateUserTask(String sUserId, Map<String, String> mTask) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sStatus = mTask.get(STATUS);
			if (TASK_STATUS_COMPLETED.equals(sStatus) || TASK_STATUS_CANCELLED.equals(sStatus)) {
				StringBuilder sbQuery = new StringBuilder();
				sbQuery.append("select count(");
				sbQuery.append(TASK_AUTONAME);
				sbQuery.append(") from ");
				sbQuery.append(SCHEMA_NAME + ".WBS_TASK_INFO");
				sbQuery.append(" where ");
				if (TASK_STATUS_COMPLETED.equals(sStatus)) {
					sbQuery.append(STATUS + " != '" + TASK_STATUS_CANCELLED + "'");
					sbQuery.append(" and ");
				}
				sbQuery.append(STATUS + " != '" + sStatus + "'");
				sbQuery.append(" and ");
				sbQuery.append(PARENT_TASK);
				sbQuery.append(" = '");
				sbQuery.append(mTask.get(TASK_AUTONAME));
				sbQuery.append("'");

				int iCnt = 0;
				rs = stmt.executeQuery(sbQuery.toString());
				while (rs.next()) {
					iCnt = rs.getInt(1);
				}

				if (iCnt > 0) {
					return false;
				}
			}

			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			SimpleDateFormat output = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss a");
			Calendar cal = Calendar.getInstance();

			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + ".WBS_TASK_INFO set ");

			String sEstStart = mTask.get(ESTIMATED_START);
			String sEstEnd = mTask.get(ESTIMATED_END);
			if ((sEstStart != null && !"".equals(sEstStart)) && (sEstEnd != null && !"".equals(sEstEnd))) {
				sEstStart = output.format(input.parse(sEstStart));
				sEstEnd = output.format(input.parse(sEstEnd));

				sbUpdate.append("ESTIMATED_START = '" + sEstStart + "', ");
				sbUpdate.append("ESTIMATED_END = '" + sEstEnd + "', ");
			}

			String sActual = output.format(cal.getTime());
			if (TASK_STATUS_NOT_STARTED.equals(mTask.get("CURRENT_STATUS"))
					&& !TASK_STATUS_NOT_STARTED.equals(sStatus)) {
				sbUpdate.append("ACTUAL_START = '" + sActual + "', ");
			}

			if (TASK_STATUS_COMPLETED.equals(sStatus) || TASK_STATUS_CANCELLED.equals(sStatus)) {
				sbUpdate.append("ACTUAL_END = '" + sActual + "', ");
			}

			String sRoomId = mTask.get(ROOM_ID);
			sbUpdate.append("RM_ID = '" + sRoomId + "', ");
			String sAssignee = mTask.get(ASSIGNEE);
			sbUpdate.append("ASSIGNEE = '" + sAssignee + "', ");
			sbUpdate.append("STATUS = '" + sStatus + "', ");
			sbUpdate.append("NOTES = '" + mTask.get(NOTES).trim() + "', ");
			sbUpdate.append("CO_OWNERS = '" + mTask.get(CO_OWNERS) + "'");

			if (TASK_STATUS_NOT_STARTED.equals(mTask.get("CURRENT_STATUS"))) {
				boolean bGeneral = isGeneralController(sRoomId);
				if (!"".equals(sRoomId) && !bGeneral) {
					String sStage = getCurrentStage(sRoomId);
					sStage = (sStage == null ? "" : sStage);
					if (!"".equals(sStage)) {
						sbUpdate.append(", ");
						sbUpdate.append("STAGE_NUMBER = '" + sStage + "'");
					}

					String sBatchNo = getBatchNo(sRoomId);
					sBatchNo = (sBatchNo == null ? "" : sBatchNo);
					sbUpdate.append(", ");
					sbUpdate.append("BATCH_NO = '" + sBatchNo + "'");
				}
			}

			String sReplace = mTask.get("REPLACE");
			String sAttachment = mTask.get(ATTACHMENTS);
			if (sAttachment != null && !"".equals(sAttachment)) {
				sbUpdate.append(", ");
				if ("yes".equalsIgnoreCase(sReplace)) {
					sbUpdate.append(ATTACHMENTS + " = '" + sAttachment + "'");
				} else {
					sbUpdate.append(ATTACHMENTS + " = (" + ATTACHMENTS + " || '," + sAttachment + "')");
				}
			}

			SimpleDateFormat sdfIn = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			String sLogDate = sdfIn.format(new java.util.Date());
			String sSysLog = "\n" + User.getDisplayName(sUserId) + "[" + sLogDate + "]:";

			boolean bChanged = false;
			if (!sStatus.equals(mTask.get("CURRENT_STATUS"))) {
				bChanged = true;
				sSysLog += " Status changed to " + sStatus;
			}

			if (!sRoomId.equals(mTask.get("CURRENT_ROOM"))) {
				bChanged = true;
				sSysLog += " Room changed to " + sRoomId + " was " + mTask.get("CURRENT_ROOM");
			}

			if (!sAssignee.equals(mTask.get("CURRENT_ASSIGNEE"))) {
				bChanged = true;
				sSysLog += " Assignee changed to " + sAssignee + " was " + mTask.get("CURRENT_ASSIGNEE");
			}

			if (bChanged) {
				bChanged = true;
				sbUpdate.append(", ");
				sbUpdate.append(SYSTEM_LOG + " = (" + SYSTEM_LOG + " || '" + sSysLog + "')");
			}

			sbUpdate.append(" where TASK_AUTONAME = '" + mTask.get(TASK_AUTONAME) + "'");

			stmt.executeUpdate(sbUpdate.toString());

			if (TASK_STATUS_NOT_STARTED.equals(mTask.get("CURRENT_STATUS"))
					&& (TASK_STATUS_STARTED.equals(sStatus) || TASK_STATUS_WIP_25.equals(sStatus)
							|| TASK_STATUS_WIP_50.equals(sStatus) || TASK_STATUS_WIP_75.equals(sStatus))) {
				updateDeptLogtime(sAssignee, "", sActual.substring(0, sActual.indexOf(' ')), sActual, "", true);
			} else if (TASK_STATUS_COMPLETED.equals(sStatus)) {
				updateDeptLogtime(sAssignee, "", sActual.substring(0, sActual.indexOf(' ')), "", sActual, true);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return true;
	}

	public boolean startUserTasks(String sUserId, StringList slTasks) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			StringBuilder sbTasks = new StringBuilder();
			for (int i = 0; i < slTasks.size(); i++) {
				if (i > 0) {
					sbTasks.append(", ");
				}
				sbTasks.append("'");
				sbTasks.append(slTasks.get(i));
				sbTasks.append("'");
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			SimpleDateFormat output = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss a");
			Calendar cal = Calendar.getInstance();

			String sActStart = output.format(cal.getTime());
			String sDate = sActStart.substring(0, sActStart.indexOf(' '));

			SimpleDateFormat sdfIn = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			String sLogDate = sdfIn.format(new java.util.Date());
			String sSysLog = "\n" + User.getDisplayName(sUserId) + "[" + sLogDate + "]: Status changed to Started";

			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + ".WBS_TASK_INFO set ");
			sbUpdate.append("ACTUAL_START = '" + sActStart + "', ");
			sbUpdate.append("STATUS = '" + TASK_STATUS_STARTED + "', ");
			sbUpdate.append(SYSTEM_LOG + " = (" + SYSTEM_LOG + " || '" + sSysLog + "') ");
			sbUpdate.append("where ");
			sbUpdate.append(TASK_AUTONAME + " IN (" + sbTasks.toString() + ")");

			stmt.executeUpdate(sbUpdate.toString());

			String sQuery = "select ASSIGNEE from " + SCHEMA_NAME + ".WBS_TASK_INFO where TASK_AUTONAME IN ("
					+ sbTasks.toString() + ")";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				sUserId = rs.getString(ASSIGNEE);
				updateDeptLogtime(sUserId, "", sDate, sActStart, "", true);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return true;
	}

	public String completeUserTasks(String sUserId, StringList slTasks) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;

		String sRet = "";
		try {
			StringBuilder sbTasks = new StringBuilder();
			for (int i = 0, iSz = slTasks.size(); i < iSz; i++) {
				if (i > 0) {
					sbTasks.append(", ");
				}
				sbTasks.append("'");
				sbTasks.append(slTasks.get(i));
				sbTasks.append("'");
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select ");
			sbQuery.append(PARENT_TASK);
			sbQuery.append(" from ");
			sbQuery.append(SCHEMA_NAME + ".WBS_TASK_INFO");
			sbQuery.append(" where ");
			sbQuery.append(STATUS + " != '" + TASK_STATUS_COMPLETED + "'");
			sbQuery.append(" and ");
			sbQuery.append(STATUS + " != '" + TASK_STATUS_CANCELLED + "'");
			sbQuery.append(" and ");
			sbQuery.append(PARENT_TASK);
			sbQuery.append(" IN (");
			sbQuery.append(sbTasks.toString());
			sbQuery.append(") GROUP BY ");
			sbQuery.append(PARENT_TASK);

			String sTaskId = "";
			rs1 = stmt.executeQuery(sbQuery.toString());
			while (rs1.next()) {
				sTaskId = rs1.getString(PARENT_TASK);
				slTasks.remove(sTaskId);

				sRet += "<br>" + sTaskId;
			}

			int iCnt = slTasks.size();
			if (iCnt > 0) {
				if (!"".equals(sRet)) {
					sbTasks = new StringBuilder();
					for (int i = 0; i < iCnt; i++) {
						if (i > 0) {
							sbTasks.append(", ");
						}
						sbTasks.append("'");
						sbTasks.append(slTasks.get(i));
						sbTasks.append("'");
					}
				}

				SimpleDateFormat output = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss a");
				Calendar cal = Calendar.getInstance();

				String sActEnd = output.format(cal.getTime());
				String sDate = sActEnd.substring(0, sActEnd.indexOf(' '));

				SimpleDateFormat sdfIn = new SimpleDateFormat("MM/dd/yyyy HH:mm");
				String sLogDate = sdfIn.format(new java.util.Date());
				String sSysLog = "\n" + User.getDisplayName(sUserId) + "[" + sLogDate
						+ "]: Status changed to Completed";

				sbQuery = new StringBuilder();
				sbQuery.append("update " + SCHEMA_NAME + ".WBS_TASK_INFO set ");
				sbQuery.append(ACTUAL_END + " = '" + sActEnd + "', ");
				sbQuery.append(STATUS + " = '" + TASK_STATUS_COMPLETED + "', ");
				sbQuery.append(SYSTEM_LOG + " = (" + SYSTEM_LOG + " || '" + sSysLog + "') ");
				sbQuery.append("where ");
				sbQuery.append(TASK_AUTONAME + " IN (" + sbTasks.toString() + ")");

				stmt.executeUpdate(sbQuery.toString());

				String sQuery = "select ASSIGNEE from " + SCHEMA_NAME + ".WBS_TASK_INFO where TASK_AUTONAME IN ("
						+ sbTasks.toString() + ")";
				rs2 = stmt.executeQuery(sQuery);
				while (rs2.next()) {
					sUserId = rs2.getString(ASSIGNEE);
					updateDeptLogtime(sUserId, "", sDate, "", sActEnd, true);
				}
			}
		} finally {
			close(rs2);
			close(stmt, rs1);
			connectionPool.free(conn);
		}

		return sRet;
	}

	public boolean deleteUserTasks(StringList slTasks) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".WBS_TASK_INFO where " + TASK_AUTONAME + " = ?";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery.toString());

			String sTaskId = null;
			for (int i = 0; i < slTasks.size(); i++) {
				sTaskId = slTasks.get(i);

				deleteDeliverables(sTaskId);

				pstmt.setString(1, sTaskId);
				pstmt.execute();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public MapList searchUserTasks(String sRoom, String sTaskName, String sTaskId, String sDept, String sOwner,
			String sAssignee, String sFromDate, String sToDate, String sStatus, String sBatchNo, String sStage,
			boolean childTasks, boolean parentTasks, boolean coOwners, boolean deliverables, boolean WBS, int limit,
			String sSearchType) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		boolean fg = false;
		String sRoomId = null;
		StringList slControllers = null;
		MapList mlTasks = new MapList();
		Map<String, String> mTask = null;

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			StringBuilder sbQuery = new StringBuilder();

			if (!"".equals(sFromDate)) {
				sFromDate = output.format(input.parse(sFromDate));
			}
			if (!"".equals(sToDate)) {
				sToDate = output.format(input.parse(sToDate));
			}

			if (NO_ROOM.equals(sRoom)) {
				sbQuery.append(" where ");
				sbQuery.append("(");
				sbQuery.append(ROOM_ID + " = ''");
				sbQuery.append(")");
				fg = true;
			} else if (!"".equals(sRoom)) {
				sbQuery.append(" where ");
				sbQuery.append("(");
				sbQuery.append(ROOM_ID + " = '" + sRoom + "'");
				sbQuery.append(")");
				fg = true;
			}

			if (!"".equals(sTaskName)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				if (sTaskName.contains("','")) {
					sbQuery.append(TASK_AUTONAME + " IN ('" + sTaskName + "')");
				} else {
					sbQuery.append(TASK_AUTONAME + " = '" + sTaskName + "'");
				}
				fg = true;
			}

			if (!"".equals(sDept) && "".equals(sTaskId)) {
				Map<String, String> mDeptTask = null;
				MapList mlDeptTasks = RDMServicesUtils.getAdminTasks(sDept);

				for (int i = 0; i < mlDeptTasks.size(); i++) {
					mDeptTask = mlDeptTasks.get(i);
					if (i == 0) {
						sTaskId = mDeptTask.get(TASK_ID);
					} else {
						sTaskId += "','" + mDeptTask.get(TASK_ID);
					}
				}

				if ("".equals(sTaskId)) {
					return mlTasks;
				}
			}

			if (!"".equals(sTaskId)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				if (sTaskId.contains("','")) {
					sbQuery.append(TASK_ID + " IN ('" + sTaskId + "')");
				} else {
					sbQuery.append(TASK_ID + " = '" + sTaskId + "'");
				}
				fg = true;
			}

			if (!"".equals(sFromDate)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				if ("".equals(sStatus)) {
					sbQuery.append("((" + ESTIMATED_START + " >= '" + sFromDate + " 12:00:00 AM'");
					sbQuery.append(" and ");
					sbQuery.append(STATUS + " = '" + TASK_STATUS_NOT_STARTED + "')");
					sbQuery.append(" or ");
					sbQuery.append(ACTUAL_START + " >= '" + sFromDate + " 12:00:00 AM')");
				} else if (TASK_STATUS_NOT_STARTED.equals(sStatus)) {
					sbQuery.append(ESTIMATED_START + " >= '" + sFromDate + " 12:00:00 AM'");
				} else {
					sbQuery.append(ACTUAL_START + " >= '" + sFromDate + " 12:00:00 AM'");
				}
				fg = true;
			}

			if (!"".equals(sToDate)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				if ("".equals(sStatus)) {
					sbQuery.append("((" + ESTIMATED_END + " <= '" + sToDate + " 11:59:59 PM'");
					sbQuery.append(" and ");
					sbQuery.append(STATUS + " = '" + TASK_STATUS_NOT_STARTED + "')");
					sbQuery.append(" or ");
					sbQuery.append(ACTUAL_END + " <= '" + sToDate + " 11:59:59 PM')");
				} else if (TASK_STATUS_NOT_STARTED.equals(sStatus)) {
					sbQuery.append(ESTIMATED_END + " <= '" + sToDate + " 11:59:59 PM'");
				} else {
					sbQuery.append(ACTUAL_END + " <= '" + sToDate + " 11:59:59 PM'");
				}
				fg = true;
			}

			if (!"".equals(sOwner)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				if (coOwners) {
					sbQuery.append("(");
					sbQuery.append(OWNER + " = '" + sOwner + "'");
					sbQuery.append(" or ");
					sbQuery.append(CO_OWNERS + " like '%" + sOwner + "%'");
					sbQuery.append(")");
				} else {
					sbQuery.append(OWNER + " = '" + sOwner + "'");
				}
				fg = true;
			}

			if (!"".equals(sAssignee)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				if (sAssignee.contains("','")) {
					sbQuery.append(ASSIGNEE + " IN ('" + sAssignee + "')");
				} else {
					sbQuery.append(ASSIGNEE + " = '" + sAssignee + "'");
				}
				fg = true;
			}

			if (!"".equals(sStatus)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				if (TASK_STATUS_WIP.equals(sStatus)) {
					sbQuery.append(STATUS);
					sbQuery.append(" IN ('Started','WIP (25%)','WIP (50%)','WIP (75%)')");
				} else if (TASK_STATUS_OPEN.equals(sStatus)) {
					sbQuery.append(STATUS);
					sbQuery.append(" != '");
					sbQuery.append(TASK_STATUS_COMPLETED);
					sbQuery.append("' and ");
					sbQuery.append(STATUS);
					sbQuery.append(" != '");
					sbQuery.append(TASK_STATUS_CANCELLED);
					sbQuery.append("'");
				} else if (TASK_PRODUCTIVITY.equals(sStatus)) {
					sbQuery.append(STATUS);
					sbQuery.append(" != '");
					sbQuery.append(TASK_STATUS_NOT_STARTED);
					sbQuery.append("' and ");
					sbQuery.append(STATUS);
					sbQuery.append(" != '");
					sbQuery.append(TASK_STATUS_CANCELLED);
					sbQuery.append("'");
				} else {
					sbQuery.append(STATUS);
					sbQuery.append(" = '");
					sbQuery.append(sStatus);
					sbQuery.append("'");
				}
				fg = true;
			}

			if (!childTasks) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				sbQuery.append(PARENT_TASK + " = ''");
				fg = true;
			}

			if (!"".equals(sBatchNo)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}
				sbQuery.append(BATCH_NO + " ILIKE '%" + sBatchNo + "%'");
				fg = true;
			}

			if (!"".equals(sStage)) {
				if (fg) {
					sbQuery.append(" and ");
				} else {
					sbQuery.append(" where ");
				}

				String[] saCntrlStage = sStage.split("\\|");
				sStage = saCntrlStage[0];
				slControllers = RDMServicesUtils.getTypeControllers(saCntrlStage[1]);

				sStage = sStage.replace(' ', '.');
				sStage += (sStage.contains(".") ? "" : ".0");
				if ("0.0".equals(sStage)) {
					sbQuery.append("(");
					sbQuery.append(STAGE_NUMBER + " = '" + sStage + "'");
					sbQuery.append(" or ");
					sbQuery.append(STAGE_NUMBER + " is NULL");
					sbQuery.append(")");
				} else {
					sbQuery.append(STAGE_NUMBER + " = '" + sStage + "'");
				}
				fg = true;
			}

			sbQuery.append(" ORDER BY ");
			if (USER_BASED.equals(sSearchType)) {
				sbQuery.append(ASSIGNEE + " ASC, ");
				sbQuery.append(ACTUAL_START + " DESC, ");
				sbQuery.append(ESTIMATED_START + " DESC ");
			} else if (ROOM_BASED.equals(sSearchType)) {
				sbQuery.append(SCHEMA_NAME + ".sort_alphanumeric(RM_ID), ");
				sbQuery.append(ACTUAL_START + " DESC, ");
				sbQuery.append(ESTIMATED_START + " DESC ");
			} else {
				sbQuery.append(ACTUAL_START + " ASC, ");
				sbQuery.append(ESTIMATED_START + " ASC ");
			}

			if (limit > 0) {
				sbQuery.append(" LIMIT " + limit);
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			Map<String, String> mDeliverables = new HashMap<String, String>();
			if (deliverables) {
				String sSelect = "select TASK_ID, COUNT(DISTINCT(DELIVERABLE_ID)) as DEL_CNT" + " from " + SCHEMA_NAME
						+ ".TASK_DELIVERABLE_INFO where " + TASK_ID + " IN (select TASK_AUTONAME from " + SCHEMA_NAME
						+ ".WBS_TASK_INFO" + sbQuery.toString() + ") group by TASK_ID";

				rs = stmt.executeQuery(sSelect);
				while (rs.next()) {
					sTaskId = rs.getString(TASK_ID);
					mDeliverables.put(sTaskId, Integer.toString(rs.getInt("DEL_CNT")));
				}
				close(rs);
			}

			Map<String, Integer[]> mChildTasks = new HashMap<String, Integer[]>();
			if (WBS) {
				String sSelect = "select PARENT_TASK, STATUS from " + SCHEMA_NAME + ".WBS_TASK_INFO where "
						+ PARENT_TASK + " IN (select TASK_AUTONAME from " + SCHEMA_NAME + ".WBS_TASK_INFO"
						+ sbQuery.toString() + ")";

				Integer[] iaCnt = null;
				rs = stmt.executeQuery(sSelect);
				while (rs.next()) {
					sTaskId = rs.getString(PARENT_TASK);
					sStatus = rs.getString(STATUS);

					if (mChildTasks.containsKey(sTaskId)) {
						iaCnt = mChildTasks.get(sTaskId);
					} else {
						iaCnt = new Integer[] { 0, 0 };
					}

					iaCnt[0] = iaCnt[0] + 1;
					if (TASK_STATUS_COMPLETED.equals(sStatus) || TASK_STATUS_CANCELLED.equals(sStatus)) {
						iaCnt[1] = iaCnt[1] + 1;
					}

					mChildTasks.put(sTaskId, iaCnt);
				}
				close(rs);
			}

			StringList slParentTasks = getParentTasks();

			String sCoOwners = null;
			String sParentTask = null;
			String sTaskAdmName = null;
			String sAttachments = null;
			Map<String, String> mTasks = RDMServicesUtils.listAdminTasks();

			rs = stmt.executeQuery("select * from " + SCHEMA_NAME + ".WBS_TASK_INFO" + sbQuery.toString());
			while (rs.next()) {
				sRoomId = rs.getString(ROOM_ID);
				sRoomId = (sRoomId == null ? "" : sRoomId);

				if (slControllers == null || slControllers.contains(sRoomId)) {
					sTaskName = rs.getString(TASK_AUTONAME);

					if ((!parentTasks && slParentTasks.contains(sTaskName))
							|| (!childTasks && !slParentTasks.contains(sTaskName))) {
						continue;
					}

					sCoOwners = rs.getString(CO_OWNERS);
					sCoOwners = (sCoOwners == null ? "" : sCoOwners);
					sParentTask = rs.getString(PARENT_TASK);
					sParentTask = (sParentTask == null ? "" : sParentTask);
					sTaskId = rs.getString(TASK_ID);
					sTaskAdmName = mTasks.get(sTaskId);
					sTaskAdmName = (sTaskAdmName == null ? "" : sTaskAdmName);
					sAttachments = rs.getString(ATTACHMENTS);
					sAttachments = (sAttachments == null ? "" : sAttachments);

					mTask = new HashMap<String, String>();

					mTask.put(TASK_AUTONAME, sTaskName);
					mTask.put(ROOM_ID, sRoomId);
					mTask.put(TASK_ID, sTaskId);
					mTask.put(TASK_NAME, sTaskAdmName);
					mTask.put(OWNER, rs.getString(OWNER));
					mTask.put(CO_OWNERS, sCoOwners);
					mTask.put(ASSIGNEE, rs.getString(ASSIGNEE));
					mTask.put(STATUS, rs.getString(STATUS));
					mTask.put(SYSTEM_LOG, rs.getString(SYSTEM_LOG));
					mTask.put(NOTES, rs.getString(NOTES));
					mTask.put(PARENT_TASK, sParentTask);
					mTask.put(ATTACHMENTS, sAttachments);

					mTask.put(ESTIMATED_START, sdf.format(rs.getTimestamp(ESTIMATED_START)));
					mTask.put(ESTIMATED_END, sdf.format(rs.getTimestamp(ESTIMATED_END)));

					if (rs.getTimestamp(ACTUAL_START) != null) {
						mTask.put(ACTUAL_START, sdf.format(rs.getTimestamp(ACTUAL_START)));
					} else {
						mTask.put(ACTUAL_START, "");
					}

					if (rs.getTimestamp(ACTUAL_END) != null) {
						mTask.put(ACTUAL_END, sdf.format(rs.getTimestamp(ACTUAL_END)));
					} else {
						mTask.put(ACTUAL_END, "");
					}

					mTask.put(BATCH_NO, rs.getString(BATCH_NO));
					mTask.put(STAGE_NUMBER, rs.getString(STAGE_NUMBER));

					if (deliverables) {
						if (mDeliverables.containsKey(sTaskName)) {
							mTask.put(DELIVERABLE_CNT, mDeliverables.get(sTaskName));
						} else {
							mTask.put(DELIVERABLE_CNT, "0");
						}
					}

					if (WBS) {
						if (mChildTasks.containsKey(sTaskName)) {
							mTask.put(NO_CHILD_TASKS, mChildTasks.get(sTaskName)[0].toString());
							mTask.put(NO_CHILD_TASKS_CLOSED, mChildTasks.get(sTaskName)[1].toString());
						} else {
							mTask.put(NO_CHILD_TASKS, "0");
							mTask.put(NO_CHILD_TASKS_CLOSED, "0");
						}
					}
					mlTasks.add(mTask);
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlTasks;
	}

	public MapList getChildTasks(String sParentTask, boolean deliverables) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs1 = null;
		ResultSet rs2 = null;

		String sRoomId = null;
		String sTaskId = null;
		String sTaskName = null;
		String sTaskAdmName = null;
		MapList mlTasks = new MapList();
		Map<String, String> mTask = null;
		Map<String, String> mAdminTasks = RDMServicesUtils.listAdminTasks();

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm");

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME
					+ ".WBS_TASK_INFO where PARENT_TASK = ? ORDER BY ACTUAL_START DESC, ESTIMATED_START DESC ");

			conn = connectionPool.getConnection();
			pstmt1 = conn.prepareStatement(sbQuery.toString());

			pstmt1.setString(1, sParentTask);
			rs1 = pstmt1.executeQuery();

			int cnt = 0;
			if (deliverables) {
				String sSelect = "select COUNT(DISTINCT DELIVERABLE_ID) from " + SCHEMA_NAME
						+ ".TASK_DELIVERABLE_INFO where " + TASK_ID + " = ?";
				pstmt2 = conn.prepareStatement(sSelect);
			}

			while (rs1.next()) {
				sTaskName = rs1.getString(TASK_AUTONAME);
				sRoomId = rs1.getString(ROOM_ID);
				sRoomId = (sRoomId == null ? "" : sRoomId);
				sTaskId = rs1.getString(TASK_ID);
				sTaskAdmName = mAdminTasks.get(sTaskId);
				sTaskAdmName = (sTaskAdmName == null ? "" : sTaskAdmName);

				mTask = new HashMap<String, String>();

				mTask.put(TASK_AUTONAME, sTaskName);
				mTask.put(ROOM_ID, sRoomId);
				mTask.put(TASK_ID, sTaskId);
				mTask.put(TASK_NAME, sTaskAdmName);
				mTask.put(OWNER, rs1.getString(OWNER));
				mTask.put(ASSIGNEE, rs1.getString(ASSIGNEE));
				mTask.put(STATUS, rs1.getString(STATUS));
				mTask.put(SYSTEM_LOG, rs1.getString(SYSTEM_LOG));
				mTask.put(NOTES, rs1.getString(NOTES));
				mTask.put(PARENT_TASK, rs1.getString(PARENT_TASK));

				mTask.put(ESTIMATED_START, sdf.format(rs1.getTimestamp(ESTIMATED_START)));
				mTask.put(ESTIMATED_END, sdf.format(rs1.getTimestamp(ESTIMATED_END)));

				if (rs1.getTimestamp(ACTUAL_START) != null) {
					mTask.put(ACTUAL_START, sdf.format(rs1.getTimestamp(ACTUAL_START)));
				} else {
					mTask.put(ACTUAL_START, "");
				}

				if (rs1.getTimestamp(ACTUAL_END) != null) {
					mTask.put(ACTUAL_END, sdf.format(rs1.getTimestamp(ACTUAL_END)));
				} else {
					mTask.put(ACTUAL_END, "");
				}

				mTask.put(BATCH_NO, rs1.getString(BATCH_NO));
				mTask.put(STAGE_NUMBER, rs1.getString(STAGE_NUMBER));

				if (deliverables) {
					cnt = 0;
					pstmt2.setString(1, sTaskName);
					rs2 = pstmt2.executeQuery();
					while (rs2.next()) {
						cnt = rs2.getInt(1);
					}
					mTask.put(DELIVERABLE_CNT, ("" + cnt));
				}

				mlTasks.add(mTask);
			}
		} finally {
			close(pstmt1, rs1);
			close(pstmt2, rs2);
			connectionPool.free(conn);
		}

		return mlTasks;
	}

	public MapList getTaskDeliverables(String sTaskId) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		MapList mlDeliverables = new MapList();
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm");

			String sQuery = "SELECT *, (cast (a.ATTRIBUTE_VALUE as real) - " + "(select b.MAX_WEIGHT from "
					+ SCHEMA_NAME + ".TASK_ATTRIBUTES_INFO b "
					+ "where b.ATTRIBUTE_NAME = a.ATTRIBUTE_NAME and b.MAX_WEIGHT != 0)) OVERAGE " + "FROM "
					+ SCHEMA_NAME + ".TASK_DELIVERABLE_INFO a where a.TASK_ID = ? ORDER BY a.CREATED_ON ASC";

			int idx = 0;
			String sAttrName = null;
			String sDeliverbleId = null;
			String sfxOverage = "_" + OVERAGE;
			String sModifiedTW = "_" + MODIFIED_TW;
			StringList slDeliverableIds = new StringList();
			Map<String, String> mDeliverable = null;
			java.sql.Timestamp createdOn = null;

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);

			pstmt.setString(1, sTaskId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				sDeliverbleId = rs.getString(DELIVERABLE_ID);
				sAttrName = rs.getString(ATTRIBUTE_NAME);

				if (slDeliverableIds.contains(sDeliverbleId)) {
					idx = slDeliverableIds.indexOf(sDeliverbleId);
					mDeliverable = mlDeliverables.get(idx);
					mDeliverable.put(sAttrName, rs.getString(ATTRIBUTE_VALUE));
					mDeliverable.put((sAttrName + sModifiedTW), rs.getString(MODIFIED_TW));
					mDeliverable.put((sAttrName + sfxOverage), Double.toString(rs.getDouble(OVERAGE)));

					mlDeliverables.set(idx, mDeliverable);
				} else {
					createdOn = rs.getTimestamp(CREATED_ON);

					mDeliverable = new HashMap<String, String>();
					mDeliverable.put(DELIVERABLE_ID, sDeliverbleId);
					mDeliverable.put(CREATED_ON, (createdOn == null ? "" : sdf.format(createdOn)));
					mDeliverable.put(sAttrName, rs.getString(ATTRIBUTE_VALUE));
					mDeliverable.put((sAttrName + sModifiedTW), rs.getString(MODIFIED_TW));
					mDeliverable.put((sAttrName + sfxOverage), df.format(rs.getDouble(OVERAGE)));

					mlDeliverables.add(mDeliverable);
					slDeliverableIds.add(sDeliverbleId);
				}
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return mlDeliverables;
	}

	public Map<String, String> getDeliverableDetails(String sDeliverableId) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Map<String, String> mDeliverable = new HashMap<String, String>();
		try {
			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO");
			sbQuery.append(" where ");
			sbQuery.append(DELIVERABLE_ID + " = ?");
			sbQuery.append(" ORDER BY ATTRIBUTE_NAME ASC");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbQuery.toString());

			pstmt.setString(1, sDeliverableId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				mDeliverable.put(rs.getString(ATTRIBUTE_NAME), rs.getString(ATTRIBUTE_VALUE).replace(".0", ""));
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return mDeliverable;
	}

	public boolean addDeliverable(String sTaskId, Map<String, String[]> mDeliverable)
			throws SQLException, InterruptedException, ParseException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sDeliverableId = "";
			String sQuery = "SELECT nextval('" + SCHEMA_NAME + ".TASK_DELIVERABLE_SEQ')";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				sDeliverableId = "" + rs.getInt("nextval");

				int iLen = sDeliverableId.length();
				for (int i = 0, iSz = (6 - iLen); i < iSz; i++) {
					sDeliverableId = "0" + sDeliverableId;
				}

				sDeliverableId = "D-" + sDeliverableId;
			}

			addDeliverable(sTaskId, sDeliverableId, mDeliverable);
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return true;
	}

	public boolean addDeliverable(String sTaskId, String sDeliverableId, Map<String, String[]> mDeliverable)
			throws SQLException, InterruptedException, ParseException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			StringBuilder sbInsert = new StringBuilder();
			sbInsert.append("insert into " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO (");
			sbInsert.append("TASK_ID, DELIVERABLE_ID, ATTRIBUTE_NAME, ATTRIBUTE_VALUE, MODIFIED_TW, CREATED_ON ");
			sbInsert.append(") values (?, ?, ?, ?, ?, ?)");

			Calendar cal = Calendar.getInstance();
			long l = cal.getTimeInMillis();

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbInsert.toString());

			String sAttrName = null;
			String sAttrValue = null;
			String sModifiedTW = null;
			String[] sValues = null;
			Iterator<String> itrDeliverable = mDeliverable.keySet().iterator();
			while (itrDeliverable.hasNext()) {
				sAttrName = itrDeliverable.next();
				sValues = mDeliverable.get(sAttrName);
				sAttrValue = sValues[0];
				sModifiedTW = sValues[1];

				sAttrValue = sValues[0];
				pstmt.setString(1, sTaskId);
				pstmt.setString(2, sDeliverableId);
				pstmt.setString(3, sAttrName);
				pstmt.setString(4, sAttrValue);
				pstmt.setString(5, sModifiedTW);
				pstmt.setTimestamp(6, new java.sql.Timestamp(l));

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public boolean updateDeliverable(String sDeliverableId, Map<String, String[]> mDeliverable)
			throws SQLException, InterruptedException, ParseException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO set");
			sbUpdate.append(" ATTRIBUTE_VALUE = ?");
			sbUpdate.append(",");
			sbUpdate.append(" MODIFIED_TW = ?");
			sbUpdate.append(" where");
			sbUpdate.append(" DELIVERABLE_ID = ?");
			sbUpdate.append(" AND");
			sbUpdate.append(" ATTRIBUTE_NAME = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			String sAttrName = null;
			String sAttrValue = null;
			String sModifiedTW = null;
			String[] sValues = null;
			Iterator<String> itrDeliverable = mDeliverable.keySet().iterator();
			while (itrDeliverable.hasNext()) {
				sAttrName = itrDeliverable.next();
				sValues = mDeliverable.get(sAttrName);
				sAttrValue = sValues[0];
				sModifiedTW = sValues[1];

				pstmt.setString(1, sAttrValue);
				pstmt.setString(2, sModifiedTW);
				pstmt.setString(3, sDeliverableId);
				pstmt.setString(4, sAttrName);

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public boolean deleteDeliverable(String sUserId, String sTaskId, String sDeliverableId) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO where DELIVERABLE_ID = '"
					+ sDeliverableId + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);

			SimpleDateFormat sdfIn = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			String sLogDate = sdfIn.format(new java.util.Date());
			String sSysLog = "\n" + User.getDisplayName(sUserId) + "[" + sLogDate + "]: Deliverable " + sDeliverableId
					+ " is deleted";

			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + ".WBS_TASK_INFO set ");
			sbUpdate.append(SYSTEM_LOG + " = (" + SYSTEM_LOG + " || '" + sSysLog + "')");
			sbUpdate.append(" where ");
			sbUpdate.append(TASK_AUTONAME + " = '" + sTaskId + "'");
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public boolean deleteDeliverables(String sTaskId) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		try {
			boolean fg = false;
			StringBuilder sbDeliverableIds = new StringBuilder();

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select DISTINCT DELIVERABLE_ID from " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO");
			sbQuery.append(" where ");
			sbQuery.append(TASK_ID + " = '" + sTaskId + "'");

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				if (fg) {
					sbDeliverableIds.append(", ");
				}

				sbDeliverableIds.append("'");
				sbDeliverableIds.append(rs.getString(DELIVERABLE_ID));
				sbDeliverableIds.append("'");
				fg = true;
			}

			if (fg) {
				StringBuilder sbDelete = new StringBuilder();
				sbDelete.append("delete from " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO ");
				sbDelete.append("where ");
				sbDelete.append(DELIVERABLE_ID + " IN (" + sbDeliverableIds.toString() + ")");

				stmt.execute(sbDelete.toString());
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return true;
	}

	public MapList getDepartments() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlDepts = new MapList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			Map<String, String> mDepartment = null;
			String selectString = "select * from " + SCHEMA_NAME + ".DEPARTMENT_INFO ORDER BY DEPARTMENT_NAME ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				mDepartment = new HashMap<String, String>();
				mDepartment.put(DEPARTMENT_NAME, rs.getString(DEPARTMENT_NAME));
				mDepartment.put(DESCRIPTION, rs.getString(DESCRIPTION));
				mDepartment.put(DEPT_ISACTIVE, rs.getString(DEPT_ISACTIVE));
				mDepartment.put(EDIT_PARAMS, rs.getString(EDIT_PARAMS));

				mlDepts.add(mDepartment);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlDepts;
	}

	public boolean addDepartment(Map<String, String> mDepartment) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbInsert.append("insert into " + SCHEMA_NAME + ".DEPARTMENT_INFO (");
			sbInsert.append(DEPARTMENT_NAME + ", " + DESCRIPTION + ", " + EDIT_PARAMS + ", " + DEPT_ISACTIVE);
			sbInsert.append(") values ('");
			sbInsert.append(mDepartment.get(DEPARTMENT_NAME));
			sbInsert.append("','");
			sbInsert.append(mDepartment.get(DESCRIPTION));
			sbInsert.append("','");
			sbInsert.append(mDepartment.get(EDIT_PARAMS));
			sbInsert.append("','Y')");

			stmt.executeUpdate(sbInsert.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	public boolean updateDepartment(Map<String, String> mDepartment) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			String sDeptName = mDepartment.get(DEPARTMENT_NAME);
			String sOldDeptName = mDepartment.get("OLD_DEPT_NAME");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbUpdate.append("update " + SCHEMA_NAME + ".DEPARTMENT_INFO set ");
			sbUpdate.append(DEPARTMENT_NAME + " = '" + sDeptName + "'");
			sbUpdate.append(", ");
			sbUpdate.append(DESCRIPTION + " = '" + mDepartment.get(DESCRIPTION) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(DEPT_ISACTIVE + " = '" + mDepartment.get(DEPT_ISACTIVE) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(EDIT_PARAMS + " = '" + mDepartment.get(EDIT_PARAMS) + "'");
			sbUpdate.append(" where ");
			sbUpdate.append(DEPARTMENT_NAME + " = '" + sOldDeptName + "'");

			stmt.executeUpdate(sbUpdate.toString());

			if (!sDeptName.equals(sOldDeptName)) {
				updateUsersDepartment(mDepartment);
				updateTasksDepartment(mDepartment);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	private void updateUsersDepartment(Map<String, String> mDepartment) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			String sDeptName = mDepartment.get(DEPARTMENT_NAME);
			String sOldDeptName = mDepartment.get("OLD_DEPT_NAME");

			String sUserId = "";
			String UserDept = "";
			Map<String, String> mUser = new HashMap<String, String>();

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select USER_ID,DEPARTMENT_NAME from " + SCHEMA_NAME + ".USER_INFO where "
					+ DEPARTMENT_NAME + " LIKE '%" + sOldDeptName + "%'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				UserDept = rs.getString(DEPARTMENT_NAME);
				UserDept = UserDept.replace(sOldDeptName, sDeptName).replace("||", "|");

				if (UserDept.startsWith("|")) {
					UserDept = UserDept.substring(1);
				}
				if (UserDept.endsWith("|")) {
					UserDept = UserDept.substring(0, (UserDept.length() - 1));
				}

				mUser.put(rs.getString(USER_ID), UserDept);
			}

			sbUpdate.append("update " + SCHEMA_NAME + ".USER_INFO set ");
			sbUpdate.append(DEPARTMENT_NAME + " = ?");
			sbUpdate.append(" where ");
			sbUpdate.append(USER_ID + " = ?");

			pstmt = conn.prepareStatement(sbUpdate.toString());

			Iterator<String> itr = mUser.keySet().iterator();
			while (itr.hasNext()) {
				sUserId = itr.next();

				pstmt.setString(1, mUser.get(sUserId));
				pstmt.setString(2, sUserId);

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(stmt, rs);
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	private void updateTasksDepartment(Map<String, String> mDepartment) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			String sDeptName = mDepartment.get(ATTRIBUTE_NAME);
			String sOldDeptName = mDepartment.get("OLD_ATTRIBUTE_NAME");

			String sTaskId = "";
			String sTaskDept = "";
			Map<String, String> mTask = new HashMap<String, String>();

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select TASK_ID,DEPARTMENT_NAME from " + SCHEMA_NAME + ".LIST_OF_TASKS where "
					+ DEPARTMENT_NAME + " LIKE '%" + sOldDeptName + "%'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sTaskDept = rs.getString(DEPARTMENT_NAME);
				sTaskDept = sTaskDept.replace(sOldDeptName, sDeptName).replace("||", "|");

				if (sTaskDept.startsWith("|")) {
					sTaskDept = sTaskDept.substring(1);
				}
				if (sTaskDept.endsWith("|")) {
					sTaskDept = sTaskDept.substring(0, (sTaskDept.length() - 1));
				}

				mTask.put(rs.getString(TASK_ID), sTaskDept);
			}

			sbUpdate.append("update " + SCHEMA_NAME + ".LIST_OF_TASKS set ");
			sbUpdate.append(DEPARTMENT_NAME + " = ?");
			sbUpdate.append(" where ");
			sbUpdate.append(TASK_ID + " = ?");

			pstmt = conn.prepareStatement(sbUpdate.toString());

			Iterator<String> itr = mTask.keySet().iterator();
			while (itr.hasNext()) {
				sTaskId = itr.next();

				pstmt.setString(1, mTask.get(sTaskId));
				pstmt.setString(2, sTaskId);

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(stmt, rs);
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	public Map<String, Map<String, Object>> getUserViews() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, Map<String, Object>> mUserViews = new HashMap<String, Map<String, Object>>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sRole = null;
			String sDept = null;
			Map<String, Object> mView = null;

			String selectString = "select * from " + SCHEMA_NAME + ".USER_ACCESS_VIEWS";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sRole = rs.getString(ROLE_NAME);
				sRole = (sRole == null ? "" : sRole.trim());
				sDept = rs.getString(DEPT_NAME);
				sDept = (sDept == null ? "" : sDept.trim());

				mView = new HashMap<String, Object>();
				mView.put(HIDE_VIEW, Boolean.toString(rs.getBoolean(HIDE_VIEW)));
				mView.put(ROLE_NAME, StringList.split(sRole, ","));
				mView.put(DEPT_NAME, StringList.split(sDept, ","));

				mUserViews.put(rs.getString(VIEW_NAME), mView);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mUserViews;
	}

	public void updateUserView(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		StringBuilder sb = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			int cnt = 0;
			String sSelect = "select COUNT(*) from " + SCHEMA_NAME + ".USER_ACCESS_VIEWS where " + VIEW_NAME + " = '"
					+ mInfo.get(VIEW_NAME) + "'";
			rs = stmt.executeQuery(sSelect);
			while (rs.next()) {
				cnt = rs.getInt(1);
			}

			if (cnt > 0) {
				sb.append("update " + SCHEMA_NAME + ".USER_ACCESS_VIEWS set ");
				sb.append("ROLE_NAME = '" + mInfo.get(ROLE_NAME) + "', ");
				sb.append("DEPT_NAME = '" + mInfo.get(DEPT_NAME) + "', ");
				sb.append("HIDE_VIEW = '" + mInfo.get(HIDE_VIEW) + "' ");
				sb.append("where VIEW_NAME = '" + mInfo.get(VIEW_NAME) + "'");
			} else {
				sb.append("insert into " + SCHEMA_NAME + ".USER_ACCESS_VIEWS (");
				sb.append("VIEW_NAME, ROLE_NAME, DEPT_NAME, HIDE_VIEW");
				sb.append(") values ('");
				sb.append(mInfo.get(VIEW_NAME) + "', '" + mInfo.get(ROLE_NAME) + "', '" + mInfo.get(DEPT_NAME) + "', '"
						+ mInfo.get(HIDE_VIEW) + "')");
			}

			stmt.executeUpdate(sb.toString());
		} finally {
			close(stmt, null);
			connectionPool.free(conn);

			sb = null;
		}
	}

	public StringList getOnOffParams(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringList slParams = new StringList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sTable = (cntrlType.startsWith("General.") ? "GENERAL_PARAMS_ADMIN" : "CONTROLLER_PARAMS_ADMIN");

			String selectString = "select PARAM_NAME from " + SCHEMA_NAME + "." + sTable
					+ " where ON_OFF_VALUE = 'Y' and CNTRL_TYPE = '" + cntrlType + "'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				slParams.add(rs.getString(PARAM_NAME));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return slParams;
	}

	public StringList getResetParams(String cntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringList slParams = new StringList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String selectString = "select PARAM_NAME from " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN "
					+ "where RESET_VALUE = 'Y' and CNTRL_TYPE = '" + cntrlType + "'";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				slParams.add(rs.getString(PARAM_NAME));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return slParams;
	}

	public boolean moveTaskDeliverables(String sUserId, String sTaskId, String sSrcTaskId, StringList slDeliverableIds)
			throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sDeliverableIds = "";
			for (int i = 0; i < slDeliverableIds.size(); i++) {
				if (i > 0) {
					sDeliverableIds += "','";
				}
				sDeliverableIds += slDeliverableIds.get(i);
			}

			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO set ");
			sbUpdate.append(TASK_ID + " = '" + sTaskId + "'");
			sbUpdate.append(" where ");
			if (sDeliverableIds.contains("','")) {
				sbUpdate.append(DELIVERABLE_ID + " IN ('" + sDeliverableIds + "')");
			} else {
				sbUpdate.append(DELIVERABLE_ID + " = '" + sDeliverableIds + "'");
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sbUpdate.toString());

			SimpleDateFormat sdfIn = new SimpleDateFormat("MM/dd/yyyy HH:mm");
			String sLogDate = sdfIn.format(new java.util.Date());
			String sSysLog = "\n" + User.getDisplayName(sUserId) + "[" + sLogDate + "]: Deliverable(s) moved from Task "
					+ sSrcTaskId;

			sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + ".WBS_TASK_INFO set ");
			sbUpdate.append(SYSTEM_LOG + " = (" + SYSTEM_LOG + " || '" + sSysLog + "')");
			sbUpdate.append(" where ");
			sbUpdate.append(TASK_AUTONAME + " = '" + sTaskId + "'");

			stmt.executeUpdate(sbUpdate.toString());
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public boolean updateTimesheet(String sUserId, String sOID, String sLogDate, String sLogIn, String sLogOut,
			String shiftCode) throws Exception {
		boolean bLogIn = "".equals(sLogIn);
		boolean bLogOut = "".equals(sLogOut);
		if (bLogIn && bLogOut) {
			return true;
		}

		Connection conn = null;
		Statement stmt = null;
		StringBuilder sbQuery = new StringBuilder();

		try {
			boolean bInsert = "".equals(sOID);
			if (bInsert) {
				sbQuery.append("insert into " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT (");
				sbQuery.append("USER_ID");
				if (!"".equals(sLogDate)) {
					sbQuery.append(", ");
					sbQuery.append(LOG_DATE);
				}
				if (!bLogIn) {
					sbQuery.append(", ");
					sbQuery.append(LOG_IN);
				}
				if (!bLogOut) {
					sbQuery.append(", ");
					sbQuery.append(LOG_OUT);
				}
				if (!"".equals(shiftCode)) {
					sbQuery.append(", ");
					sbQuery.append(SHIFT_CODE);
				}

				sbQuery.append(") values ('");
				sbQuery.append(sUserId);
				if (!"".equals(sLogDate)) {
					sbQuery.append("','");
					sbQuery.append(sLogDate);
				}
				if (!bLogIn) {
					sbQuery.append("','");
					sbQuery.append(sLogIn);
				}
				if (!bLogOut) {
					sbQuery.append("','");
					sbQuery.append(sLogOut);
				}
				if (!"".equals(shiftCode)) {
					sbQuery.append("','");
					sbQuery.append(shiftCode);
				}
				sbQuery.append("')");
			} else {
				boolean fg = false;
				sbQuery.append("update " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT set ");
				if (!bLogIn) {
					sbQuery.append(LOG_IN);
					sbQuery.append(" = '");
					sbQuery.append(sLogIn);
					sbQuery.append("'");
					fg = true;
				}
				if (!bLogOut) {
					if (fg) {
						sbQuery.append(", ");
					}
					sbQuery.append(LOG_OUT);
					sbQuery.append(" = '");
					sbQuery.append(sLogOut);
					sbQuery.append("'");
					fg = true;
				}
				if (!"".equals(shiftCode)) {
					if (fg) {
						sbQuery.append(", ");
					}

					sbQuery.append(SHIFT_CODE);
					sbQuery.append(" = '");
					sbQuery.append(shiftCode);
					sbQuery.append("'");
				}

				sbQuery.append(" where ");
				sbQuery.append(OID);
				sbQuery.append(" = '");
				sbQuery.append(sOID);
				sbQuery.append("'");
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sbQuery.toString());

			if (!bLogOut) {
				if ("".equals(sLogDate)) {
					sLogDate = sLogOut.substring(0, sLogOut.indexOf(' ')).trim();
				}

				String sDeptOut = getDeptLogout(sUserId, sLogDate);
				if (!"".equals(sDeptOut.trim())) {
					updateDeptLogtime(sUserId, sOID, sLogDate, "", sDeptOut, false);
				}
			}
		} finally {
			close(stmt, null);
			connectionPool.free(conn);

			sbQuery = null;
		}

		return true;
	}

	public Map<String, String> getLogTime(String sOID) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbSelect = new StringBuilder();

		Map<String, String> mLog = new HashMap<String, String>();
		try {
			java.sql.Date sqlDate = null;
			java.sql.Timestamp sqlTime = null;
			String inTime = "";
			String outTime = "";
			String deptInTime = "";
			String deptOutTime = "";
			String sDate = "";
			String shiftCode = "";

			sbSelect.append("select oid,* from " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT");
			sbSelect.append(" where ");
			sbSelect.append(OID);
			sbSelect.append(" = '");
			sbSelect.append(sOID);
			sbSelect.append("'");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sbSelect.toString());
			while (rs.next()) {
				sqlDate = rs.getDate(LOG_DATE);
				if (sqlDate != null && !"null".equals(sqlDate)) {
					sDate = sqlDate.toString();
				}

				sqlTime = rs.getTimestamp(LOG_IN);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					inTime = sqlTime.toString();
					inTime = inTime.substring(0, inTime.lastIndexOf(':'));

					if ("".equals(sDate)) {
						sDate = inTime.substring(0, inTime.indexOf(' '));
					}
				}

				sqlTime = rs.getTimestamp(LOG_OUT);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					outTime = sqlTime.toString();
					outTime = outTime.substring(0, outTime.lastIndexOf(':'));

					if ("".equals(sDate)) {
						sDate = outTime.substring(0, outTime.indexOf(' '));
					}
				}

				sqlTime = rs.getTimestamp(DEPT_IN);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					deptInTime = sqlTime.toString();
					deptInTime = deptInTime.substring(0, deptInTime.lastIndexOf(':'));
				}

				sqlTime = rs.getTimestamp(DEPT_OUT);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					deptOutTime = sqlTime.toString();
					deptOutTime = deptOutTime.substring(0, deptOutTime.lastIndexOf(':'));
				}

				shiftCode = rs.getString(SHIFT_CODE);
				shiftCode = ((shiftCode == null || "null".equalsIgnoreCase(shiftCode)) ? "" : shiftCode);

				mLog.put(LOG_DATE, sDate);
				mLog.put(LOG_IN, inTime);
				mLog.put(LOG_OUT, outTime);
				mLog.put(DEPT_IN, deptInTime);
				mLog.put(DEPT_OUT, deptOutTime);
				mLog.put(SHIFT_CODE, shiftCode);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbSelect = null;
		}

		return mLog;
	}

	public Map<String, Map<String, MapList>> getTimesheets(Map<String, String> mInfo) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbQuery = new StringBuilder();

		Map<String, Map<String, MapList>> mLogs = new HashMap<String, Map<String, MapList>>();
		try {
			SimpleDateFormat sdfIn = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat sdfOut = new SimpleDateFormat("dd-MMM-yyyy");

			boolean fg = false;
			double dDelQty;
			double dProdHrs;
			String sUserId = mInfo.get(USER_ID);
			String sFName = mInfo.get(FIRST_NAME);
			String sLName = mInfo.get(LAST_NAME);
			String sDept = mInfo.get(DEPT_NAME);
			String startDate = mInfo.get("fromDate");
			String endDate = mInfo.get("endDate");
			String loggedIn = mInfo.get("loggedIn");
			String loggedOut = mInfo.get("loggedOut");
			String inTime = "";
			String outTime = "";
			String deptInTime = "";
			String deptOutTime = "";
			String sDate = "";
			String sOID = "";
			String shiftCode = "";
			String productivity = "";
			Map<String, MapList> mUserInfo = null;
			Map<String, String> mLog = null;
			MapList mlLogs = null;
			java.sql.Date sqlDate = null;
			java.sql.Timestamp sqlTime = null;

			sbQuery.append("select oid,* from " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT");

			if (!"".equals(sFName) || !"".equals(sLName) || !"".equals(sDept)) {
				StringBuilder sbUserIds = new StringBuilder();
				MapList mlUsers = RDMServicesUtils.getUsers(sUserId, sFName, sLName, sDept, true);
				for (int i = 0; i < mlUsers.size(); i++) {
					if (i > 0) {
						sbUserIds.append("','");
					}
					sbUserIds.append(mlUsers.get(i).get(USER_ID));
				}

				sbQuery.append(" where ");
				sbQuery.append(USER_ID + " IN ('" + sbUserIds.toString() + "')");
				fg = true;
			} else if (!"".equals(sUserId)) {
				sbQuery.append(" where ");
				sbQuery.append(USER_ID + " LIKE '%" + sUserId + "%'");
				fg = true;
			}

			sbQuery.append((fg ? " and " : " where "));
			if (!"".equals(startDate)) {
				startDate = RDMServicesUtils.convertToSQLDate(startDate);
				endDate = RDMServicesUtils.convertToSQLDate(endDate);
				sbQuery.append("(" + LOG_DATE + " >= '" + startDate + "' and " + LOG_DATE + " <= '" + endDate + "')");
			} else {
				endDate = RDMServicesUtils.convertToSQLDate(endDate);
				sbQuery.append(LOG_DATE + " = '" + endDate + "'");
			}

			sbQuery.append(" and ");
			sbQuery.append("oid IN (");
			sbQuery.append("select oid from " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT");

			sbQuery.append(" where ");
			if (!"".equals(startDate)) {
				sbQuery.append("(" + LOG_DATE + " >= '" + startDate + "' and " + LOG_DATE + " <= '" + endDate + "')");
			} else {
				sbQuery.append(LOG_DATE + " = '" + endDate + "'");
			}

			sbQuery.append(" and ");
			if ("Y".equals(loggedIn) && "Y".equals(loggedOut)) {
				sbQuery.append(LOG_IN + " IS NOT NULL");
			} else if (!"Y".equals(loggedIn) && !"Y".equals(loggedOut)) {
				sbQuery.append("(" + LOG_IN + " IS NULL or " + LOG_OUT + " IS NULL)");
			} else if ("Y".equals(loggedIn)) {
				sbQuery.append("(" + LOG_IN + " IS NOT NULL and " + LOG_OUT + " IS NULL)");
			} else if ("Y".equals(loggedOut)) {
				sbQuery.append("(" + LOG_IN + " IS NULL and " + LOG_OUT + " IS NOT NULL)");
			}
			sbQuery.append(")");

			sbQuery.append(" ORDER BY USER_ID,LOG_IN ASC");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				sUserId = rs.getString(USER_ID);
				sOID = rs.getString(OID);
				sDate = "";
				inTime = "";
				outTime = "";
				deptInTime = "";
				deptOutTime = "";

				sqlDate = rs.getDate(LOG_DATE);
				if (sqlDate != null && !"null".equals(sqlDate)) {
					sDate = sqlDate.toString();
					sDate = sdfOut.format(sdfIn.parse(sDate));
				}

				sqlTime = rs.getTimestamp(LOG_IN);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					inTime = sqlTime.toString();
					inTime = inTime.substring(0, inTime.lastIndexOf(':'));

					if ("".equals(sDate)) {
						sDate = inTime.substring(0, inTime.indexOf(' '));
						sDate = sdfOut.format(sdfIn.parse(sDate));
					}
				}

				sqlTime = rs.getTimestamp(LOG_OUT);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					outTime = sqlTime.toString();
					outTime = outTime.substring(0, outTime.lastIndexOf(':'));

					if ("".equals(sDate)) {
						sDate = outTime.substring(0, outTime.indexOf(' '));
						sDate = sdfOut.format(sdfIn.parse(sDate));
					}
				}

				sqlTime = rs.getTimestamp(DEPT_IN);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					deptInTime = sqlTime.toString();
					deptInTime = deptInTime.substring(0, deptInTime.lastIndexOf(':'));
				}

				sqlTime = rs.getTimestamp(DEPT_OUT);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					deptOutTime = sqlTime.toString();
					deptOutTime = deptOutTime.substring(0, deptOutTime.lastIndexOf(':'));
				}

				dDelQty = rs.getDouble(T_DEL_QTY);
				dProdHrs = rs.getDouble(PRODUCTIVE_HRS);
				productivity = (dProdHrs != 0 ? df.format(dDelQty / dProdHrs) : "0");

				if (mLogs.containsKey(sUserId)) {
					mUserInfo = mLogs.get(sUserId);
				} else {
					mUserInfo = new HashMap<String, MapList>();
				}

				shiftCode = rs.getString(SHIFT_CODE);
				shiftCode = ((shiftCode == null || "null".equalsIgnoreCase(shiftCode)) ? "" : shiftCode);

				mlLogs = mUserInfo.get(sDate);
				if (mlLogs == null) {
					mlLogs = new MapList();
				}

				mLog = new HashMap<String, String>();
				mLog.put(OID, sOID);
				mLog.put(LOG_IN, inTime);
				mLog.put(LOG_OUT, outTime);
				mLog.put(SHIFT_CODE, shiftCode);
				mLog.put(DEPT_IN, deptInTime);
				mLog.put(DEPT_OUT, deptOutTime);
				mLog.put(PRODUCTIVITY, productivity);
				mlLogs.add(mLog);

				mUserInfo.put(sDate, mlLogs);
				mLogs.put(sUserId, mUserInfo);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbQuery = null;
		}

		return mLogs;
	}

	public Map<java.util.Date, Map<String, String[]>> getUserLogs() throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbQuery = new StringBuilder();

		Map<java.util.Date, Map<String, String[]>> mLogs = new HashMap<java.util.Date, Map<String, String[]>>();
		try {
			SimpleDateFormat sdfIn = new SimpleDateFormat("yyyy-MM-dd");
			String sLogDate = sdfIn.format(new java.util.Date());

			sbQuery.append("select oid,* from " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT");
			sbQuery.append(" where ");
			sbQuery.append(LOG_DATE + " = '" + sLogDate + "'");
			sbQuery.append(" or ");
			sbQuery.append(LOG_IN + " IS NULL");
			sbQuery.append(" or ");
			sbQuery.append(LOG_OUT + " IS NULL");
			sbQuery.append(" ORDER BY LOG_IN,USER_ID ASC");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sUserId = null;
			String inTime = "";
			String outTime = "";
			String deptInTime = "";
			String deptOutTime = "";
			String sOID = "";
			String shiftCode = "";
			Map<String, String[]> mUserInfo = null;
			java.util.Date date = null;
			java.sql.Date sqlDate = null;
			java.sql.Timestamp sqlTime = null;

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				sUserId = rs.getString(USER_ID);
				sOID = rs.getString(OID);
				date = null;
				inTime = "";
				outTime = "";
				deptInTime = "";
				deptOutTime = "";

				sqlDate = rs.getDate(LOG_DATE);
				if (sqlDate != null && !"null".equals(sqlDate)) {
					date = sdfIn.parse(sqlDate.toString());
				}

				sqlTime = rs.getTimestamp(LOG_IN);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					inTime = sqlTime.toString();
					inTime = inTime.substring(0, inTime.lastIndexOf(':'));

					if (date == null) {
						date = sdfIn.parse(inTime.substring(0, inTime.lastIndexOf(' ')));
					}
				}

				sqlTime = rs.getTimestamp(LOG_OUT);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					outTime = sqlTime.toString();
					outTime = outTime.substring(0, outTime.lastIndexOf(':'));

					if (date == null) {
						date = sdfIn.parse(outTime.substring(0, outTime.lastIndexOf(' ')));
					}
				}

				sqlTime = rs.getTimestamp(DEPT_IN);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					deptInTime = sqlTime.toString();
					deptInTime = deptInTime.substring(0, deptInTime.lastIndexOf(':'));
				}

				sqlTime = rs.getTimestamp(DEPT_OUT);
				if (sqlTime != null && !"null".equals(sqlTime)) {
					deptOutTime = sqlTime.toString();
					deptOutTime = deptOutTime.substring(0, deptOutTime.lastIndexOf(':'));
				}

				if (mLogs.containsKey(date)) {
					mUserInfo = mLogs.get(date);
				} else {
					mUserInfo = new HashMap<String, String[]>();
				}

				shiftCode = rs.getString(SHIFT_CODE);
				shiftCode = ((shiftCode == null || "null".equalsIgnoreCase(shiftCode)) ? "" : shiftCode);

				mUserInfo.put(sUserId, new String[] { sOID, inTime, outTime, shiftCode, deptInTime, deptOutTime });
				mLogs.put(date, mUserInfo);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbQuery = null;
		}

		return mLogs;
	}

	public boolean updateDeptLogtime(String sUserId, String sOID, String sLogDate, String sDeptIn, String sDeptOut,
			boolean completeTask) throws Exception {
		boolean bLogIn = !"".equals(sDeptIn);
		boolean bLogOut = !"".equals(sDeptOut);
		if (!bLogIn && !bLogOut) {
			return true;
		}

		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbQuery = new StringBuilder();
		StringBuilder sbWhere = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbWhere.append(" where ");
			sbWhere.append(OID);
			sbWhere.append(" = ");

			if ("".equals(sOID)) {
				sbWhere.append("(select max(oid) from " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT");
				sbWhere.append(" where ");
				sbWhere.append(USER_ID);
				sbWhere.append(" = '");
				sbWhere.append(sUserId);
				sbWhere.append("' and ");
				sbWhere.append(LOG_DATE);
				sbWhere.append(" = '");
				sbWhere.append(sLogDate);
				sbWhere.append("')");
			} else {
				sbWhere.append("'" + sOID + "'");
			}

			sbQuery.append("update " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT set ");
			if (bLogIn) {
				sbQuery.append(DEPT_IN);
				sbQuery.append(" = '");
				sbQuery.append(sDeptIn);
				sbQuery.append("'");
			} else if (bLogOut) {
				String sQuery = "select DEPT_IN from " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT" + sbWhere.toString();

				rs = stmt.executeQuery(sQuery);
				while (rs.next()) {
					sDeptIn = RDMServicesUtils.dateToLongString(rs.getTimestamp("DEPT_IN"));
				}

				double dQuantity = getDeliverableQuantity(sUserId, sDeptIn, sDeptOut);
				double dProdHrs = geProductiveHrs(sUserId, sDeptIn, sDeptOut);

				sbQuery.append(DEPT_OUT);
				sbQuery.append(" = '");
				sbQuery.append(sDeptOut);
				sbQuery.append("', ");
				sbQuery.append(T_DEL_QTY);
				sbQuery.append(" = '");
				sbQuery.append(dQuantity);
				sbQuery.append("', ");
				sbQuery.append(PRODUCTIVE_HRS);
				sbQuery.append(" = '");
				sbQuery.append(df.format(dProdHrs));
				sbQuery.append("'");
			}

			sbQuery.append(sbWhere.toString());

			if (bLogIn) {
				sbQuery.append(" and ");
				sbQuery.append(DEPT_IN);
				sbQuery.append(" IS NULL");
			}

			if (bLogOut && completeTask) {
				sbQuery.append(" and ");
				sbQuery.append(LOG_OUT);
				sbQuery.append(" IS NOT NULL");
			}

			stmt.executeUpdate(sbQuery.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbQuery = null;
			sbWhere = null;
		}

		return true;
	}

	public String getDeptLogout(String sUserId, String sLogDate) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			String sQuery = "select max(" + ACTUAL_END + ") from " + SCHEMA_NAME + ".WBS_TASK_INFO where " + ASSIGNEE
					+ " = '" + sUserId + "' and " + ACTUAL_END + " > '" + sLogDate + "' group by " + ASSIGNEE;

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				if (rs.getTimestamp("max") != null) {
					return format.format(rs.getTimestamp("max"));
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return "";
	}

	public boolean deleteTimesheet(String sUserId, String sOID) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT where " + OID + " = '" + sOID + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public Map<String, String> getUserTaskCnt() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Map<String, String> mCnt = new HashMap<String, String>();
		try {
			String sQuery = "select " + ASSIGNEE + ", COUNT(" + ASSIGNEE + ") from " + SCHEMA_NAME
					+ ".WBS_TASK_INFO a where a.task_autoname NOT IN " + "(SELECT " + PARENT_TASK + " FROM "
					+ SCHEMA_NAME + ".WBS_TASK_INFO b where b.parent_task != '') and " + "a.STATUS != '"
					+ TASK_STATUS_COMPLETED + "' and a.STATUS != '" + TASK_STATUS_CANCELLED + "' GROUP BY " + ASSIGNEE;

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				mCnt.put(rs.getString(1), Integer.toString(rs.getInt(2)));
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return mCnt;
	}

	public int getUserTaskCnt(String sUserId) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		int iCnt = 0;
		try {
			String sQuery = "select COUNT(" + ASSIGNEE + ") from " + SCHEMA_NAME
					+ ".WBS_TASK_INFO a where a.task_autoname NOT IN " + "(SELECT " + PARENT_TASK + " FROM "
					+ SCHEMA_NAME + ".WBS_TASK_INFO b where b.parent_task != '') and "
					+ "a.ASSIGNEE = ? and a.STATUS NOT IN ('" + TASK_STATUS_NOT_STARTED + "','" + TASK_STATUS_COMPLETED
					+ "','" + TASK_STATUS_CANCELLED + "') " + "GROUP BY " + ASSIGNEE;

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);

			pstmt.setString(1, sUserId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				iCnt = rs.getInt(1);
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return iCnt;
	}

	public StringList getParentTasks() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		StringList slParentTasks = new StringList();
		try {
			String sQuery = "SELECT distinct(PARENT_TASK) FROM " + SCHEMA_NAME
					+ ".WBS_TASK_INFO a where a.PARENT_TASK != ''";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				slParentTasks.add(rs.getString(1));
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return slParentTasks;
	}

	private double getDeliverableQuantity(String sUserId, String sStart, String sEnd) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		double dQuantity = 0.0;
		String sValue = null;
		try {
			String sQuery = "SELECT ATTRIBUTE_VALUE FROM " + SCHEMA_NAME + ".TASK_DELIVERABLE_INFO a "
					+ "where (a.created_on BETWEEN ? AND ?) and " + "a.TASK_ID in (select TASK_AUTONAME from "
					+ SCHEMA_NAME + ".WBS_TASK_INFO b where b.ASSIGNEE = ?)";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);

			if (RDMServicesUtils.isNullOrEmpty(sStart) || RDMServicesUtils.isNullOrEmpty(sEnd)) {
				return dQuantity;
			}

			sStart = RDMServicesUtils.convert24to12Hr(sStart);
			sEnd = RDMServicesUtils.convert24to12Hr(sEnd);

			pstmt.setTimestamp(1, java.sql.Timestamp.valueOf(sStart));
			pstmt.setTimestamp(2, java.sql.Timestamp.valueOf(sEnd));
			pstmt.setString(3, sUserId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				sValue = rs.getString(ATTRIBUTE_VALUE);
				if (sValue != null && !"".equals(sValue)) {
					dQuantity = dQuantity + Double.parseDouble(sValue);
				}
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return dQuantity;
	}

	private double geProductiveHrs(String sUserId, String sStart, String sEnd) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		double dProdHrs = 0.0;
		try {
			String sProdTasks = RDMServicesUtils.getProductivityTasks().join(',');
			sProdTasks = "'" + sProdTasks.replace(",", "','") + "'";

			String sQuery = "SELECT (sum(DATE_PART('day', actual_end - actual_start) * 24 + DATE_PART('hour', actual_end - actual_start) * 60 + DATE_PART('minute', actual_end - actual_start)) / 60) as DURATION "
					+ "from rdm_admin.wbs_task_info where assignee = ? and (actual_start BETWEEN ? and ?) and (actual_end BETWEEN ? and ?) and task_id IN ("
					+ sProdTasks + ")";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);

			if (RDMServicesUtils.isNullOrEmpty(sStart) || RDMServicesUtils.isNullOrEmpty(sEnd)) {
				return dProdHrs;
			}

			sStart = RDMServicesUtils.convert24to12Hr(sStart);
			sEnd = RDMServicesUtils.convert24to12Hr(sEnd);

			pstmt.setString(1, sUserId);
			pstmt.setTimestamp(2, java.sql.Timestamp.valueOf(sStart));
			pstmt.setTimestamp(3, java.sql.Timestamp.valueOf(sEnd));
			pstmt.setTimestamp(4, java.sql.Timestamp.valueOf(sStart));
			pstmt.setTimestamp(5, java.sql.Timestamp.valueOf(sEnd));

			rs = pstmt.executeQuery();
			while (rs.next()) {
				dProdHrs = rs.getDouble(DURATION);
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return dProdHrs;
	}

	public MapList getProductivity(String sUserId, String sFName, String sLName, String sDept, String sStartDt,
			String sEndDt) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbQuery = new StringBuilder();
		MapList mlData = new MapList();
		Map<String, String> mData = null;

		try {
			int iUserCnt;
			double dTotalDelQty;
			double dPrdtHrs;
			String sProductivity;

			sbQuery.append("SELECT A.USER_ID, ");
			sbQuery.append("DEPARTMENT_NAME, ");
			sbQuery.append("COUNT(A.USER_ID) as CNT, ");
			sbQuery.append("SUM(T_DEL_QTY) as QTY, ");
			sbQuery.append("SUM(PRODUCTIVE_HRS) as PROD ");
			sbQuery.append("FROM " + SCHEMA_NAME + ".EMPLOYEE_IN_OUT A ");
			sbQuery.append("INNER JOIN " + SCHEMA_NAME + ".USER_INFO ON USER_INFO.USER_ID = A.USER_ID ");
			sbQuery.append("WHERE ");
			if (sStartDt.equals(sEndDt)) {
				sbQuery.append(LOG_DATE + " = '" + sStartDt + "'");
			} else {
				sbQuery.append(LOG_DATE + " BETWEEN '" + sStartDt + "' AND '" + sEndDt + "'");
			}

			if (!"".equals(sUserId) || !"".equals(sFName) || !"".equals(sLName) || !"".equals(sDept)) {
				sbQuery.append(" and A.USER_ID in (select USER_ID from " + SCHEMA_NAME + ".USER_INFO where ");

				boolean fg = false;
				if (!"".equals(sUserId)) {
					sbQuery.append(USER_ID + " like '%" + sUserId + "%'");
					fg = true;
				}

				if (!"".equals(sFName)) {
					sbQuery.append(fg ? " and " : "");
					sbQuery.append(FIRST_NAME + " like '%" + sFName + "%'");
					fg = true;

				}

				if (!"".equals(sLName)) {
					sbQuery.append(fg ? " and " : "");
					sbQuery.append(LAST_NAME + " like '%" + sLName + "%'");
					fg = true;
				}

				if (!"".equals(sDept)) {
					sbQuery.append(fg ? " and " : "");
					sbQuery.append("(regexp_split_to_array(" + DEPARTMENT_NAME + ", '\\|') && regexp_split_to_array('"
							+ sDept + "', '\\|'))");
				}

				sbQuery.append(")");
			}

			sbQuery.append(" GROUP BY A.USER_ID, DEPARTMENT_NAME ");
			sbQuery.append(" ORDER BY " + SCHEMA_NAME + ".sort_alphanumeric(A.USER_ID)");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				iUserCnt = rs.getInt("CNT");
				dTotalDelQty = rs.getDouble("QTY");
				dPrdtHrs = rs.getDouble("PROD");
				sProductivity = (dPrdtHrs != 0 ? df.format(dTotalDelQty / dPrdtHrs) : "0");

				mData = new HashMap<String, String>();
				mData.put(USER_ID, rs.getString(USER_ID));
				mData.put(DEPARTMENT_NAME, rs.getString(DEPARTMENT_NAME));
				mData.put(T_DAYS, Integer.toString(iUserCnt));
				mData.put(T_DEL_QTY, df.format(dTotalDelQty));
				mData.put(PRODUCTIVE_HRS, df.format(dPrdtHrs));
				mData.put(PRODUCTIVITY, sProductivity);

				mlData.add(mData);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbQuery = null;
			mData = null;
		}

		return mlData;
	}

	public void updateDailyYield() throws SQLException, InterruptedException, ParseException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			java.util.Date dt = new java.util.Date();
			DateFormat df1 = new SimpleDateFormat("yyyy-MM-dd");
			DateFormat df2 = new SimpleDateFormat("dd-MM-yyyy");

			double dYield;
			String sRoom;
			String sDate = df2.format(dt);
			String sYieldAttrs = RDMServicesUtils.getYieldAttributes().join(',');
			sYieldAttrs = "'" + sYieldAttrs.replace(",", "','") + "'";

			String sQuery = "SELECT SUM(cast(a.attribute_value as real)) as yield, b.rm_id FROM " + SCHEMA_NAME
					+ ".TASK_DELIVERABLE_INFO a, " + SCHEMA_NAME + ".WBS_TASK_INFO b"
					+ " where (cast(a.created_on as date) = '" + df1.format(dt) + "') and a.attribute_name IN ("
					+ sYieldAttrs + ") and (a.task_id = b.task_autoname) and (b.status != 'Cancelled')"
					+ " group by b.rm_id";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				try {
					dYield = rs.getDouble("yield");
					sRoom = rs.getString(ROOM_ID);

					if (sRoom != null && !"".equals(sRoom)) {
						updateYield(sRoom, "0.0", Double.toString(dYield), sDate, "SYSTEM", "");
					}
				} catch (Exception e) {
					// do nothing
				}
			}
		} catch (Exception se) {
			// do nothing
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
	}

	public double[] getPackedOverages(String sDate) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		double[] dRet = new double[2];

		try {
			String sOverageAttrs = RDMServicesUtils.getOverageAttributes().join(',');
			sOverageAttrs = "'" + sOverageAttrs.replace(",", "','") + "'";

			String sQuery = "SELECT SUM(cast (a.ATTRIBUTE_VALUE as real)) as total, SUM(cast (a.ATTRIBUTE_VALUE as real) - (select b.MAX_WEIGHT from rdm_admin.TASK_ATTRIBUTES_INFO b"
					+ " where b.ATTRIBUTE_NAME = a.ATTRIBUTE_NAME and b.MAX_WEIGHT != 0)) as overage FROM rdm_admin.TASK_DELIVERABLE_INFO a"
					+ " where cast(a.CREATED_ON as date) = '" + sDate + "' and a.ATTRIBUTE_NAME IN (" + sOverageAttrs
					+ ")";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				dRet[0] = rs.getDouble("total");
				dRet[1] = rs.getDouble("overage");
			}
		} catch (Exception e) {
			// do nothing
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return dRet;
	}

	public boolean checkAllowedRooms() throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "SELECT COUNT(*) FROM " + SCHEMA_NAME + ".ROOM_INFO WHERE " + CNTRL_TYPE
					+ " NOT LIKE 'General.%' and " + ROOM_STATUS + " = '" + ACTIVE + "'";
			rs = stmt.executeQuery(sQuery);

			int iCnt = 0;
			while (rs.next()) {
				iCnt = rs.getInt(1);
			}

			int iLimit = VerifyLicense.getLicenseRoomCount();
			if ((iLimit > 0) && (iCnt > iLimit)) {
				return false;
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return true;
	}

	public void writeAdminSettingsToCSV(String sCntrlType, String sFilePath)
			throws IOException, InterruptedException, SQLException {
		Connection conn = null;
		Statement stmt = null;

		try (FileOutputStream fileOutputStream = new FileOutputStream(sFilePath)) {
			conn = connectionPool.getConnection();
			CopyManager copyManager = new CopyManager((BaseConnection) conn);

			if (sCntrlType.startsWith("General.")) {
				copyManager
						.copyOut(
								"COPY (SELECT * FROM " + SCHEMA_NAME + ".GENERAL_PARAMS_ADMIN WHERE CNTRL_TYPE = '"
										+ sCntrlType + "' ORDER BY DISPLAY_ORDER) TO STDOUT WITH (FORMAT CSV, HEADER)",
								fileOutputStream);
			} else {
				copyManager.copyOut(
						"COPY (SELECT * FROM " + SCHEMA_NAME + ".CONTROLLER_PARAMS_ADMIN WHERE CNTRL_TYPE = '"
								+ sCntrlType + "' ORDER BY DISPLAY_ORDER, " + SCHEMA_NAME
								+ ".sort_alphanumeric(STAGE_NAME)) TO STDOUT WITH (FORMAT CSV, HEADER)",
						fileOutputStream);
			}

		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public void importAdminSettingsFromCSV(String sCntrlType, String sFilePath) throws Throwable {
		Connection conn = null;
		Statement stmt = null;
		try {
			String sTable = (sCntrlType.startsWith("General.") ? "GENERAL_PARAMS_ADMIN" : "CONTROLLER_PARAMS_ADMIN");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute("delete from " + SCHEMA_NAME + "." + sTable + " where CNTRL_TYPE = '" + sCntrlType + "'");
			stmt.execute("COPY " + SCHEMA_NAME + "." + sTable + " FROM '" + sFilePath + "' with csv HEADER");

			RDMServicesUtils.setViewParamaters(sCntrlType);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public Map<String, MapList> listNotificationAlarms() throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		MapList mlAlarms = null;
		Map<String, String> mAlarm = null;
		Map<String, MapList> mAlarms = new HashMap<String, MapList>();

		Map<String, String> mDept = null;
		Map<String, Map<String, String>> mDepts = new HashMap<String, Map<String, String>>();
		MapList mlDepts = RDMServicesUtils.getNotificationGroups();
		for (int i = 0; i < mlDepts.size(); i++) {
			mDept = mlDepts.get(i);
			mDepts.put(mDept.get(ALARM_GROUP), mDept);
		}

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sAlramGroup = null;
			String sCntrlType = null;
			String sQuery = "select * from " + SCHEMA_NAME + ".NOTIFY_ALARMS ORDER BY CNTRL_TYPE, " + SCHEMA_NAME
					+ ".sort_alphanumeric(ALARM)";
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				sAlramGroup = rs.getString(ALARM_GROUP);

				mAlarm = new HashMap<String, String>();
				mAlarm.put(ALARM, rs.getString(ALARM));
				mAlarm.put(NOTIFY_BY, rs.getString(NOTIFY_BY));
				mAlarm.put(ALARM_GROUP, sAlramGroup);
				mAlarm.put(NOTIFY_DURATION, Integer.toString(rs.getInt(NOTIFY_DURATION)));

				mDept = mDepts.get(sAlramGroup);
				if (mDept != null) {
					mAlarm.put(NOTIFY_LEVEL1, mDept.get(NOTIFY_LEVEL1));
					mAlarm.put(NOTIFY_LEVEL2, mDept.get(NOTIFY_LEVEL2));
					mAlarm.put(NOTIFY_LEVEL3, mDept.get(NOTIFY_LEVEL3));
					mAlarm.put(LEVEL1_ATTEMPTS, mDept.get(LEVEL1_ATTEMPTS));
					mAlarm.put(LEVEL2_ATTEMPTS, mDept.get(LEVEL2_ATTEMPTS));
					mAlarm.put(LEVEL3_ATTEMPTS, mDept.get(LEVEL3_ATTEMPTS));
				} else {
					mAlarm.put(NOTIFY_LEVEL1, "");
					mAlarm.put(NOTIFY_LEVEL2, "");
					mAlarm.put(NOTIFY_LEVEL3, "");
					mAlarm.put(LEVEL1_ATTEMPTS, "");
					mAlarm.put(LEVEL2_ATTEMPTS, "");
					mAlarm.put(LEVEL3_ATTEMPTS, "");
				}

				sCntrlType = rs.getString(CNTRL_TYPE);
				mlAlarms = (mAlarms.containsKey(sCntrlType) ? mAlarms.get(sCntrlType) : new MapList());
				mlAlarms.add(mAlarm);
				mAlarms.put(sCntrlType, mlAlarms);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mAlarms;
	}

	public void addNotificationAlarm(String sAlarm, String sCntrlType, String sNotifyBy, String sGroup,
			int notifyDuration) throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			StringBuilder sbInsert = new StringBuilder();
			sbInsert.append("insert into " + SCHEMA_NAME + ".NOTIFY_ALARMS (");
			sbInsert.append("ALARM, CNTRL_TYPE, ALARM_GROUP, NOTIFY_BY, NOTIFY_DURATION");
			sbInsert.append(") values (");
			sbInsert.append("?, ?, ?, ?, ?");
			sbInsert.append(")");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbInsert.toString());

			pstmt.setString(1, sAlarm);
			pstmt.setString(2, sCntrlType);
			pstmt.setString(3, sGroup);
			pstmt.setString(4, sNotifyBy);
			pstmt.setInt(5, notifyDuration);

			pstmt.executeUpdate();
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}
	}

	public void updateNotificationAlarm(String sAlarm, String sCntrlType, String sNotifyBy, String sGroup,
			int notifyDuration) throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + ".NOTIFY_ALARMS set");
			sbUpdate.append(" NOTIFY_BY = ?,");
			sbUpdate.append(" ALARM_GROUP = ?,");
			sbUpdate.append(" NOTIFY_DURATION = ?");
			sbUpdate.append(" where ");
			sbUpdate.append("ALARM = ?");
			sbUpdate.append(" and ");
			sbUpdate.append("CNTRL_TYPE = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			pstmt.setString(1, sNotifyBy);
			pstmt.setString(2, sGroup);
			pstmt.setInt(3, notifyDuration);
			pstmt.setString(4, sAlarm);
			pstmt.setString(5, sCntrlType);

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public void deleteNotificationAlarm(String sAlarm, String sCntrlType) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".NOTIFY_ALARMS where ALARM = '" + sAlarm
					+ "' and CNTRL_TYPE = '" + sCntrlType + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public MapList getNotifyAlarms() throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		Map<String, String> mAlarm = null;
		MapList mlAlarms = new MapList();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");

		try {
			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select oid, * from " + SCHEMA_NAME + ".ALARM_HISTORY");
			sbQuery.append(" where ");
			sbQuery.append(NOTIFY_ALARM + " = TRUE");
			sbQuery.append(" and ");
			sbQuery.append(CLEARED_ON + " IS NULL");
			sbQuery.append(" and ");
			sbQuery.append(MUTED_ON + " IS NULL");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbQuery.toString());

			rs = pstmt.executeQuery();
			while (rs.next()) {
				mAlarm = new HashMap<String, String>();
				mAlarm.put(OID, rs.getString(OID));
				mAlarm.put(ROOM_ID, rs.getString(ROOM_ID));
				mAlarm.put(SERIAL_ID, rs.getString(SERIAL_ID));
				mAlarm.put(ALARM_TEXT, rs.getString(ALARM_TEXT));
				mAlarm.put(OCCURED_ON, sdf.format(rs.getTimestamp(OCCURED_ON)));
				mAlarm.put(LEVEL1_ATTEMPTS, Integer.toString(rs.getInt(LEVEL1_ATTEMPTS)));
				mAlarm.put(LEVEL2_ATTEMPTS, Integer.toString(rs.getInt(LEVEL2_ATTEMPTS)));
				mAlarm.put(LEVEL3_ATTEMPTS, Integer.toString(rs.getInt(LEVEL3_ATTEMPTS)));
				java.sql.Timestamp lastNotified = rs.getTimestamp(LAST_NOTIFIED);
				mAlarm.put(LAST_NOTIFIED, (lastNotified == null ? "" : sdf.format(lastNotified)));

				mlAlarms.add(mAlarm);
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return mlAlarms;
	}

	public void updateNotifyAlarms(MapList mlUpdateAlarms, java.sql.Timestamp sqlTime)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("update " + SCHEMA_NAME + ".ALARM_HISTORY set ");
			sbQuery.append(LEVEL1_ATTEMPTS + " = ?, ");
			sbQuery.append(LEVEL2_ATTEMPTS + " = ?, ");
			sbQuery.append(LEVEL3_ATTEMPTS + " = ?, ");
			sbQuery.append(LAST_NOTIFIED + " = ?");
			sbQuery.append(" where ");
			sbQuery.append("cast(oid as varchar) = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbQuery.toString());

			Map<String, String> mAlarm = null;
			for (int i = 0; i < mlUpdateAlarms.size(); i++) {
				mAlarm = mlUpdateAlarms.get(i);

				pstmt.setInt(1, Integer.parseInt(mAlarm.get(LEVEL1_ATTEMPTS)));
				pstmt.setInt(2, Integer.parseInt(mAlarm.get(LEVEL2_ATTEMPTS)));
				pstmt.setInt(3, Integer.parseInt(mAlarm.get(LEVEL3_ATTEMPTS)));
				pstmt.setTimestamp(4, sqlTime);
				pstmt.setString(5, mAlarm.get(OID));

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public Map<String, String> getBatchPhaseDurations(String sRoomId, String sBatchNo, String sStartDate,
			String sEndDate) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<String, String> mPhaseDurations = new HashMap<String, String>();

		try {
			String roomTable = sRoomId.replace(" ", "") + "_param_data";
			DecimalFormat dformat = new DecimalFormat("#.#");

			String sQry = "SELECT current_phase, " + SCHEMA_NAME
					+ ".to_hours(max(log_date + log_time) - min(log_date + log_time)) as PD" + " FROM " + SCHEMA_NAME
					+ "." + roomTable + " where log_date BETWEEN ? and ?" + " and batch_no = ? group by current_phase"
					+ " order by " + SCHEMA_NAME + ".sort_alphanumeric(current_phase)";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQry.toString());

			SimpleDateFormat input = new SimpleDateFormat("MM/dd/yyyy hh:mm a");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			sStartDate = output.format(input.parse(sStartDate));
			sEndDate = output.format(input.parse(sEndDate));

			pstmt.setDate(1, java.sql.Date.valueOf(sStartDate));
			pstmt.setDate(2, java.sql.Date.valueOf(sEndDate));
			pstmt.setString(3, sBatchNo);
			rs = pstmt.executeQuery();

			String sPhase = null;
			String sDuration = null;
			while (rs.next()) {
				sPhase = rs.getString("current_phase");
				if (sPhase != null) {
					if (sPhase.endsWith(".0")) {
						sPhase = sPhase.substring(0, sPhase.indexOf("."));
					}
					sPhase = sPhase.replace(".", " ");

					sDuration = dformat.format(rs.getDouble("PD"));
					mPhaseDurations.put(sPhase, sDuration);
				}
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return mPhaseDurations;
	}

	public void manageReport(String sReport, String sTemplate, String sDesc, String[] saKeyColumn, StringList slColumns,
			Map<String, String> mColumnHeaders, StringList slSearchCols, Map<String, String> mFormulae,
			Map<String, String> mRanges, StringList slReadOnlyCols, String sBasedOn, int iHeader, int iFormula,
			int iRanges, int iEditCols, StringList slReadAccess, StringList slReadDept, StringList slWriteAccess,
			StringList slWriteDept, StringList slModifyAccess, StringList slModifyDept, boolean bAllowUpdates,
			boolean bAdd) throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			String sColumn = null;
			String sColumnKey = null;
			String sReportTab = sReport.replace(" ", "_");

			StringBuilder sbHeaders = new StringBuilder();
			StringBuilder sbFormula = new StringBuilder();
			StringBuilder sbRanges = new StringBuilder();
			StringBuilder sbReadOnlyCols = new StringBuilder();
			StringBuilder sbSearchCols = new StringBuilder();
			StringList slNewColumns = new StringList();
			StringList slReportCols = getColumnParameters(sReportTab);
			slReportCols.remove(IS_UPDATED);

			for (int i = 0, iSz = slColumns.size(); i < iSz; i++) {
				sColumn = slColumns.get(i);
				sColumnKey = mColumnHeaders.get(sColumn);

				if (bAdd) {
					slNewColumns.add(sColumnKey);
				} else {
					if (slReportCols.contains(sColumnKey.toUpperCase())) {
						slReportCols.remove(sColumnKey.toUpperCase());
					} else {
						slNewColumns.add(sColumnKey);
					}
				}

				if (sbHeaders.length() > 1) {
					sbHeaders.append("|");
				}
				sbHeaders.append(sColumnKey);
				sbHeaders.append("=");
				sbHeaders.append(sColumn);

				if (mFormulae.containsKey(sColumn)) {
					if (sbFormula.length() > 1) {
						sbFormula.append("|");
					}

					sbFormula.append(sColumnKey);
					sbFormula.append("=");
					sbFormula.append(mFormulae.get(sColumn));
				}

				if (mRanges.containsKey(sColumn)) {
					if (sbRanges.length() > 1) {
						sbRanges.append("|");
					}

					sbRanges.append(sColumnKey);
					sbRanges.append("=");
					sbRanges.append(mRanges.get(sColumn));
				}

				if (slReadOnlyCols.contains(sColumn)) {
					if (sbReadOnlyCols.length() > 1) {
						sbReadOnlyCols.append("|");
					}
					sbReadOnlyCols.append(sColumnKey);
				}

				if (slSearchCols.contains(sColumn)) {
					if (sbSearchCols.length() > 1) {
						sbSearchCols.append("|");
					}
					sbSearchCols.append(sColumnKey);
				}
			}

			StringBuilder sbQuery = new StringBuilder();
			if (bAdd) {
				sbQuery.append("insert into " + SCHEMA_NAME + ".MAINTENANCE_REPORTS (");
				sbQuery.append("TEMPLATE,DESCRIPTION,COLUMN_HEADER,COLUMN_FORMULA,COLUMN_RANGES,READ_ONLY_COLUMN");
				sbQuery.append(",SEARCH_COLUMNS,HEADER_ROW,FORMULA_ROW,RANGES_ROW,EDITABLE_ROW,CALC_BASED_ON");
				sbQuery.append(",READ_ACCESS,READ_DEPT,WRITE_ACCESS,WRITE_DEPT,MODIFY_ACCESS,MODIFY_DEPT");
				sbQuery.append(",KEY_COLUMN,ALLOW_MULTIPLE_UPDATES,REPORT");
				sbQuery.append(") values (");
				sbQuery.append("?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?");
				sbQuery.append(")");
			} else {
				sbQuery.append("update " + SCHEMA_NAME + ".MAINTENANCE_REPORTS set ");
				sbQuery.append("TEMPLATE = ?, ");
				sbQuery.append("DESCRIPTION = ?, ");
				sbQuery.append("COLUMN_HEADER = ?, ");
				sbQuery.append("COLUMN_FORMULA = ?, ");
				sbQuery.append("COLUMN_RANGES = ?, ");
				sbQuery.append("READ_ONLY_COLUMN = ?, ");
				sbQuery.append("SEARCH_COLUMNS = ?, ");
				sbQuery.append("HEADER_ROW = ?, ");
				sbQuery.append("FORMULA_ROW = ?, ");
				sbQuery.append("RANGES_ROW = ?, ");
				sbQuery.append("EDITABLE_ROW = ?, ");
				sbQuery.append("CALC_BASED_ON = ?, ");
				sbQuery.append("READ_ACCESS = ?, ");
				sbQuery.append("READ_DEPT = ?, ");
				sbQuery.append("WRITE_ACCESS = ?, ");
				sbQuery.append("WRITE_DEPT = ?, ");
				sbQuery.append("MODIFY_ACCESS = ?, ");
				sbQuery.append("MODIFY_DEPT = ?, ");
				sbQuery.append("KEY_COLUMN = ?, ");
				sbQuery.append("ALLOW_MULTIPLE_UPDATES = ?");
				sbQuery.append(" where ");
				sbQuery.append("REPORT = ?");
			}

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbQuery.toString());

			pstmt.setString(1, sTemplate);
			pstmt.setString(2, sDesc);
			pstmt.setString(3, sbHeaders.toString());
			pstmt.setString(4, sbFormula.toString());
			pstmt.setString(5, sbRanges.toString());
			pstmt.setString(6, sbReadOnlyCols.toString());
			pstmt.setString(7, sbSearchCols.toString());
			pstmt.setInt(8, iHeader);
			pstmt.setInt(9, iFormula);
			pstmt.setInt(10, iRanges);
			pstmt.setInt(11, iEditCols);
			pstmt.setString(12, sBasedOn);
			pstmt.setString(13, slReadAccess.join('|'));
			pstmt.setString(14, slReadDept.join('|'));
			pstmt.setString(15, slWriteAccess.join('|'));
			pstmt.setString(16, slWriteDept.join('|'));
			pstmt.setString(17, slModifyAccess.join('|'));
			pstmt.setString(18, slModifyDept.join('|'));
			pstmt.setString(19, saKeyColumn[0]);
			pstmt.setBoolean(20, bAllowUpdates);
			pstmt.setString(21, sReport);

			pstmt.executeUpdate();

			if (bAdd) {
				createReportTable(sReportTab, saKeyColumn[1], slNewColumns);
			} else if (!(slNewColumns.isEmpty() && slReportCols.isEmpty())) {
				updateReportTable(sReportTab, saKeyColumn[1], slNewColumns, slReportCols);
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}
	}

	public void updateReport(String sReport, String sDesc, String sKeyColumn, int iHeader, int iFormula, int iRanges,
			int iEditCols, StringList slReadAccess, StringList slReadDept, StringList slWriteAccess,
			StringList slWriteDept, StringList slModifyAccess, StringList slModifyDept, boolean bAllowUpdates)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("update " + SCHEMA_NAME + ".MAINTENANCE_REPORTS set ");
			sbQuery.append("DESCRIPTION = ?, ");
			sbQuery.append("HEADER_ROW = ?, ");
			sbQuery.append("FORMULA_ROW = ?, ");
			sbQuery.append("RANGES_ROW = ?, ");
			sbQuery.append("EDITABLE_ROW = ?, ");
			sbQuery.append("READ_ACCESS = ?, ");
			sbQuery.append("READ_DEPT = ?, ");
			sbQuery.append("WRITE_ACCESS = ?, ");
			sbQuery.append("WRITE_DEPT = ?, ");
			sbQuery.append("MODIFY_ACCESS = ?, ");
			sbQuery.append("MODIFY_DEPT = ?, ");
			sbQuery.append("KEY_COLUMN = ?, ");
			sbQuery.append("ALLOW_MULTIPLE_UPDATES = ?");
			sbQuery.append(" where ");
			sbQuery.append("REPORT = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbQuery.toString());

			pstmt.setString(1, sDesc);
			pstmt.setInt(2, iHeader);
			pstmt.setInt(3, iFormula);
			pstmt.setInt(4, iRanges);
			pstmt.setInt(5, iEditCols);
			pstmt.setString(6, slReadAccess.join('|'));
			pstmt.setString(7, slReadDept.join('|'));
			pstmt.setString(8, slWriteAccess.join('|'));
			pstmt.setString(9, slWriteDept.join('|'));
			pstmt.setString(10, slModifyAccess.join('|'));
			pstmt.setString(11, slModifyDept.join('|'));
			pstmt.setString(12, sKeyColumn);
			pstmt.setBoolean(13, bAllowUpdates);
			pstmt.setString(14, sReport);

			pstmt.executeUpdate();
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}
	}

	public void deleteReport(String sReport) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sQuery = "delete from " + SCHEMA_NAME + ".MAINTENANCE_REPORTS where REPORT = '" + sReport + "'";
			stmt.execute(sQuery);

			sQuery = "drop TABLE " + SCHEMA_NAME + "." + sReport.replace(" ", "_");
			stmt.execute(sQuery);
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
	}

	public StringList getReportColumns(String sReport) throws SQLException, InterruptedException {
		StringList slColumns = new StringList();
		MapList mlReportCols = getReportColumns(sReport, COLUMN_HEADER);

		String sColumnKey = null;
		Map<String, String> map = null;
		for (int i = 0; i < mlReportCols.size(); i++) {
			map = mlReportCols.get(i);
			sColumnKey = map.get(COLUMN_KEY);

			slColumns.add(sColumnKey);
		}

		return slColumns;
	}

	public String[] getReportKeyColumn(String sReport) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sKeyColumn = "";
		String sColumnName = "";

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select KEY_COLUMN,COLUMN_HEADER from " + SCHEMA_NAME + ".MAINTENANCE_REPORTS");
			sbQuery.append(" where REPORT = '" + sReport + "'");

			rs = stmt.executeQuery(sbQuery.toString());
			if (rs.next()) {
				sKeyColumn = rs.getString(KEY_COLUMN);
				String columnName = rs.getString(COLUMN_HEADER);

				if (columnName != null) {
					String[] saColumns = columnName.split("\\|");
					for (int i = 0; i < saColumns.length; i++) {
						if (saColumns[i].contains("=")) {
							String[] column = saColumns[i].split("=");
							if (column[1].equals(sKeyColumn)) {
								sColumnName = column[0];
								break;
							}
						}
					}
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return new String[] { sKeyColumn, sColumnName };
	}

	public Map<String, String> getReportColumnHeaders(String sReport, boolean bColumnKey)
			throws SQLException, InterruptedException {
		Map<String, String> mReportCols = new HashMap<String, String>();
		MapList mlReportCols = getReportColumns(sReport, COLUMN_HEADER);

		String sColumnKey = null;
		String sColumnHeader = null;
		Map<String, String> map = null;
		for (int i = 0; i < mlReportCols.size(); i++) {
			map = mlReportCols.get(i);
			sColumnKey = map.get(COLUMN_KEY);
			sColumnHeader = map.get(COLUMN_HEADER);

			if (bColumnKey) {
				mReportCols.put(sColumnKey, sColumnHeader);
			} else {
				mReportCols.put(sColumnHeader, sColumnKey);
			}
		}

		return mReportCols;
	}

	public Map<String, String> getReportColumnFormulae(String sReport) throws SQLException, InterruptedException {
		Map<String, String> mReportFormulae = new HashMap<String, String>();
		MapList mlReportCols = getReportColumns(sReport, COLUMN_FORMULA);

		String sColumnKey = null;
		String sFormula = null;
		Map<String, String> map = null;
		for (int i = 0; i < mlReportCols.size(); i++) {
			map = mlReportCols.get(i);
			sColumnKey = map.get(COLUMN_KEY);
			sFormula = map.get(COLUMN_FORMULA);

			if (!"".equals(sFormula)) {
				mReportFormulae.put(sColumnKey, sFormula);
			}
		}

		return mReportFormulae;
	}

	public Map<String, String[]> getReportColumnRanges(String sReport) throws SQLException, InterruptedException {
		Map<String, String[]> mReportRanges = new HashMap<String, String[]>();
		MapList mlReportCols = getReportColumns(sReport, COLUMN_RANGES);

		String sColumnKey = null;
		String sRanges = null;
		Map<String, String> map = null;
		for (int i = 0; i < mlReportCols.size(); i++) {
			map = mlReportCols.get(i);
			sColumnKey = map.get(COLUMN_KEY);
			sRanges = map.get(COLUMN_RANGES);

			if (!"".equals(sRanges)) {
				mReportRanges.put(sColumnKey, sRanges.split("\\/"));
			}
		}

		return mReportRanges;
	}

	public StringList getReportSearchColumns(String sReport) throws SQLException, InterruptedException {
		StringList slSearchColumns = new StringList();
		MapList mlReportCols = getReportColumns(sReport, SEARCH_COLUMNS);

		String sColumn = "";
		for (int i = 0; i < mlReportCols.size(); i++) {
			sColumn = mlReportCols.get(i).get(SEARCH_COLUMNS);
			if (sColumn != null && !"".equals(sColumn)) {
				slSearchColumns.add(mlReportCols.get(i).get(SEARCH_COLUMNS));
			}
		}

		return slSearchColumns;
	}

	public StringList getReadOnlyColumns(String sReport) throws SQLException, InterruptedException {
		StringList slReadOnlyColumns = new StringList();
		MapList mlReportCols = getReportColumns(sReport, READ_ONLY_COLUMN);

		for (int i = 0; i < mlReportCols.size(); i++) {
			slReadOnlyColumns.add(mlReportCols.get(i).get(READ_ONLY_COLUMN));
		}

		return slReadOnlyColumns;
	}

	private MapList getReportColumns(String sReport, String sSelect) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlReportCols = new MapList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select " + sSelect + " from " + SCHEMA_NAME + ".MAINTENANCE_REPORTS");
			sbQuery.append(" where ");
			sbQuery.append("REPORT = '" + sReport + "'");

			rs = stmt.executeQuery(sbQuery.toString());
			if (rs.next()) {
				String[] saColumn = null;
				Map<String, String> mReportCols = null;

				String sValue = rs.getString(sSelect);
				if (sValue != null) {
					String[] saColumns = sValue.split("\\|");
					for (int i = 0; i < saColumns.length; i++) {
						mReportCols = new HashMap<String, String>();
						if (saColumns[i].contains("=")) {
							saColumn = saColumns[i].split("=");
							mReportCols.put(COLUMN_KEY, saColumn[0].trim());
							mReportCols.put(sSelect, saColumn[1].trim());
						} else {
							mReportCols.put(sSelect, saColumns[i].trim());
						}

						mlReportCols.add(mReportCols);
					}
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlReportCols;
	}

	public MapList getReports(String sUser) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlReports = new MapList();

		try {
			Map<String, String> mReport = null;
			Map<String, String> mUser = RDMServicesUtils.getUser(sUser);
			String sRole = mUser.get(ROLE_NAME);
			String sDept = mUser.get(DEPARTMENT_NAME);

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + ".MAINTENANCE_REPORTS");
			if (!ROLE_ADMIN.equals(sRole)) {
				sbQuery.append(" where ");

				sbQuery.append("(" + READ_ACCESS + " LIKE '%" + sRole + "%'");
				if (!"".equals(sDept)) {
					sbQuery.append(" and ");
					if (sDept.contains("|")) {
						sbQuery.append("(regexp_split_to_array(" + READ_DEPT + ", '\\|') && regexp_split_to_array('"
								+ sDept + "', '\\|')");
					} else {
						sbQuery.append("(" + READ_DEPT + " LIKE '%" + sDept + "%'");
					}

					sbQuery.append(" or ");
					sbQuery.append(READ_DEPT + " = '')");
				}
				sbQuery.append(") or ");

				sbQuery.append("(" + WRITE_ACCESS + " LIKE '%" + sRole + "%'");
				if (!"".equals(sDept)) {
					sbQuery.append(" and ");
					if (sDept.contains("|")) {
						sbQuery.append("(regexp_split_to_array(" + WRITE_DEPT + ", '\\|') && regexp_split_to_array('"
								+ sDept + "', '\\|')");
					} else {
						sbQuery.append("(" + WRITE_DEPT + " LIKE '%" + sDept + "%'");
					}

					sbQuery.append(" or ");
					sbQuery.append(WRITE_DEPT + " = '')");
				}
				sbQuery.append(") or ");

				sbQuery.append("(" + MODIFY_ACCESS + " LIKE '%" + sRole + "%')");
				if (!"".equals(sDept)) {
					sbQuery.append(" and ");
					if (sDept.contains("|")) {
						sbQuery.append("(regexp_split_to_array(" + MODIFY_DEPT + ", '\\|') && regexp_split_to_array('"
								+ sDept + "', '\\|')");
					} else {
						sbQuery.append("(" + MODIFY_DEPT + " LIKE '%" + sDept + "%'");
					}

					sbQuery.append(" or ");
					sbQuery.append(MODIFY_DEPT + " = '')");
				}
			}
			sbQuery.append(" ORDER BY  " + SCHEMA_NAME + ".sort_alphanumeric(REPORT)");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				mReport = new HashMap<String, String>();
				mReport.put(REPORT, rs.getString(REPORT));
				mReport.put(TEMPLATE, rs.getString(TEMPLATE));
				mReport.put(DESCRIPTION, rs.getString(DESCRIPTION));
				mReport.put(KEY_COLUMN, rs.getString(KEY_COLUMN));
				mReport.put(COLUMN_HEADER, rs.getString(COLUMN_HEADER));
				mReport.put(COLUMN_FORMULA, rs.getString(COLUMN_FORMULA));
				mReport.put(COLUMN_RANGES, rs.getString(COLUMN_RANGES));
				mReport.put(READ_ONLY_COLUMN, rs.getString(READ_ONLY_COLUMN));
				mReport.put(HEADER_ROW, ("" + rs.getInt(HEADER_ROW)));
				mReport.put(FORMULA_ROW, ("" + rs.getInt(FORMULA_ROW)));
				mReport.put(RANGES_ROW, ("" + rs.getInt(RANGES_ROW)));
				mReport.put(EDITABLE_ROW, ("" + rs.getInt(EDITABLE_ROW)));
				mReport.put(CALC_BASED_ON, rs.getString(CALC_BASED_ON));
				mReport.put(READ_ACCESS, rs.getString(READ_ACCESS));
				mReport.put(WRITE_ACCESS, rs.getString(WRITE_ACCESS));
				mReport.put(MODIFY_ACCESS, rs.getString(MODIFY_ACCESS));
				mReport.put(READ_DEPT, rs.getString(READ_DEPT));
				mReport.put(WRITE_DEPT, rs.getString(WRITE_DEPT));
				mReport.put(MODIFY_DEPT, rs.getString(MODIFY_DEPT));
				mReport.put(ALLOW_MULTIPLE_UPDATES, (rs.getBoolean(ALLOW_MULTIPLE_UPDATES) ? "TRUE" : "FALSE"));

				mlReports.add(mReport);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlReports;
	}

	public Map<String, String> getReport(String sReport) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> mReport = new HashMap<String, String>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(
					"select * from " + SCHEMA_NAME + ".MAINTENANCE_REPORTS where report = '" + sReport + "'");
			while (rs.next()) {
				mReport.put(REPORT, rs.getString(REPORT));
				mReport.put(TEMPLATE, rs.getString(TEMPLATE));
				mReport.put(DESCRIPTION, rs.getString(DESCRIPTION));
				mReport.put(KEY_COLUMN, rs.getString(KEY_COLUMN));
				mReport.put(COLUMN_HEADER, rs.getString(COLUMN_HEADER));
				mReport.put(COLUMN_FORMULA, rs.getString(COLUMN_FORMULA));
				mReport.put(COLUMN_RANGES, rs.getString(COLUMN_RANGES));
				mReport.put(READ_ONLY_COLUMN, rs.getString(READ_ONLY_COLUMN));
				mReport.put(HEADER_ROW, ("" + rs.getInt(HEADER_ROW)));
				mReport.put(FORMULA_ROW, ("" + rs.getInt(FORMULA_ROW)));
				mReport.put(RANGES_ROW, ("" + rs.getInt(RANGES_ROW)));
				mReport.put(EDITABLE_ROW, ("" + rs.getInt(EDITABLE_ROW)));
				mReport.put(CALC_BASED_ON, rs.getString(CALC_BASED_ON));
				mReport.put(READ_ACCESS, rs.getString(READ_ACCESS));
				mReport.put(WRITE_ACCESS, rs.getString(WRITE_ACCESS));
				mReport.put(MODIFY_ACCESS, rs.getString(MODIFY_ACCESS));
				mReport.put(READ_DEPT, rs.getString(READ_DEPT));
				mReport.put(WRITE_DEPT, rs.getString(WRITE_DEPT));
				mReport.put(MODIFY_DEPT, rs.getString(MODIFY_DEPT));
				mReport.put(ALLOW_MULTIPLE_UPDATES, (rs.getBoolean(ALLOW_MULTIPLE_UPDATES) ? "TRUE" : "FALSE"));
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mReport;
	}

	private void createReportTable(String sReportTab, String sKeyColumn, StringList slColumns)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			slColumns.sort();
			StringBuilder sbCols = new StringBuilder();

			for (int i = 0; i < slColumns.size(); i++) {
				sbCols.append("Column" + (i + 1));
				if (i == 0) {
					sbCols.append(" timestamp without time zone NOT NULL");
				} else {
					sbCols.append(" character varying");
				}
				sbCols.append(", ");
			}

			sbCols.append("is_updated boolean, ");
			sbCols.append("CONSTRAINT " + sReportTab + "_uk UNIQUE (" + sKeyColumn + ")");

			String sQuery = "CREATE TABLE " + SCHEMA_NAME + "." + sReportTab + " ( " + sbCols.toString() + " ) ";
			stmt.executeUpdate(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	private void updateReportTable(String sReportTab, String sKeyColumn, StringList slNewColumns,
			StringList slDelColumns) throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			boolean bFlag = false;
			slNewColumns.sort();
			StringBuilder sbCols = new StringBuilder();

			for (int i = 0, iSz = slNewColumns.size(); i < iSz; i++) {
				if (bFlag) {
					sbCols.append(", ");
				}

				sbCols.append("ADD COLUMN ");
				sbCols.append(slNewColumns.get(i));
				sbCols.append(" character varying");
				bFlag = true;
			}

			for (int i = 0, iSz = slDelColumns.size(); i < iSz; i++) {
				if (bFlag) {
					sbCols.append(", ");
				}

				sbCols.append("DROP COLUMN ");
				sbCols.append(slDelColumns.get(i));
				bFlag = true;
			}

			String sQuery = "ALTER TABLE " + SCHEMA_NAME + "." + sReportTab + " " + sbCols.toString();
			stmt.executeUpdate(sQuery);

			sQuery = "ALTER TABLE " + SCHEMA_NAME + "." + sReportTab + " DROP CONSTRAINT " + sReportTab
					+ "_uk, ADD CONSTRAINT " + sReportTab + "_uk UNIQUE (" + sKeyColumn + ")";
			stmt.executeUpdate(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public void insertReportRecord(String sReport, String sKeyColumn, MapList mlRecords)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			Map<String, String> mRecord = mlRecords.get(0);

			String sReportTab = sReport.replace(" ", "_");
			StringList slColumns = RDMServicesUtils.getSortedKeySet(mRecord.keySet());

			StringBuilder sbInsert = new StringBuilder();
			sbInsert.append("insert into " + SCHEMA_NAME + "." + sReportTab + " (IS_UPDATED");
			for (int i = 0; i < slColumns.size(); i++) {
				sbInsert.append(",");
				sbInsert.append(slColumns.get(i));
			}
			sbInsert.append(") values (FALSE");
			for (int i = 0; i < slColumns.size(); i++) {
				sbInsert.append(",");
				sbInsert.append("?");
			}
			sbInsert.append(")");

			int idx = slColumns.indexOf(sKeyColumn);

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbInsert.toString());

			for (int i = 0; i < mlRecords.size(); i++) {
				mRecord = mlRecords.get(i);
				for (int j = 0, iSz = slColumns.size(); j < iSz; j++) {
					if (j == idx) {
						pstmt.setTimestamp(j + 1,
								new java.sql.Timestamp(Date.parse(mRecord.get(slColumns.get(j)).trim())));
					} else {
						pstmt.setString(j + 1, mRecord.get(slColumns.get(j)).replace("'", "''").trim());
					}
				}

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public void updateReportRecord(String sReport, String sKeyColumn, Map<String, String> mRecord)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sReportTab = sReport.replace(" ", "_");
			StringList slColumns = RDMServicesUtils.getSortedKeySet(mRecord.keySet());

			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("update " + SCHEMA_NAME + "." + sReportTab + " set IS_UPDATED = TRUE");
			for (int i = 0; i < slColumns.size(); i++) {
				sbUpdate.append(", ");
				sbUpdate.append(slColumns.get(i));
				sbUpdate.append(" = '");
				sbUpdate.append(mRecord.get(slColumns.get(i)).replace("'", "''").trim());
				sbUpdate.append("'");
			}
			sbUpdate.append(" where ");
			sbUpdate.append(sKeyColumn + " = '");
			sbUpdate.append(mRecord.get(sKeyColumn).trim());
			sbUpdate.append("'");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate(sbUpdate.toString());
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public void deleteReportRecord(String sReport, String sKeyColumn, String sDateTime)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("delete from " + SCHEMA_NAME + "." + sReport.replace(" ", "_"));
			sbQuery.append(" where ");
			sbQuery.append(sKeyColumn + " = '");
			sbQuery.append(sDateTime);
			sbQuery.append("'");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sbQuery.toString());
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public MapList getRecords(String sReport, String sFromDate, String sToDate)
			throws SQLException, InterruptedException, ParseException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlReportRecords = new MapList();

		try {
			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			sFromDate = output.format(input.parse(sFromDate));
			sToDate = output.format(input.parse(sToDate));

			StringList slColumns = getReportColumns(sReport);
			int iSz = slColumns.size();
			Map<String, String> mRecord = null;
			String sColumn = null;

			String[] saColumn = getReportKeyColumn(sReport);
			String sKeyColumn = saColumn[0];
			String sColumnName = saColumn[1];
			if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
				throw new SQLException("Missing Column name for Record Entry Time");
			}

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + "." + sReport.replace(" ", "_"));
			sbQuery.append(" where ");
			sbQuery.append(sColumnName + " BETWEEN '" + sFromDate + " 12:00:00 AM' AND '" + sToDate + " 11:59:59 PM'");
			sbQuery.append(" ORDER BY " + sColumnName + " ASC");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				mRecord = new HashMap<String, String>();
				for (int i = 0; i < iSz; i++) {
					sColumn = slColumns.get(i);
					mRecord.put(sColumn, rs.getString(sColumn));
				}
				mRecord.put(IS_UPDATED, (rs.getBoolean(IS_UPDATED) ? "TRUE" : "FALSE"));
				mlReportRecords.add(mRecord);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlReportRecords;
	}

	public MapList getRecords(String sReport, Map<String, String> mSearchCriteria)
			throws SQLException, InterruptedException, ParseException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlRecords = new MapList();

		try {
			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			boolean bFlag = false;
			String sColumn = null;
			String sValue = null;
			String sFromDate = null;
			String sToDate = null;
			String[] saValue = null;
			StringList slColumns = getReportColumns(sReport);
			Map<String, String> mRecord = null;
			int iSz = slColumns.size();

			String[] saColumn = getReportKeyColumn(sReport);
			String sKeyColumn = saColumn[0];
			String sColumnName = saColumn[1];
			if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
				throw new SQLException("Missing Column name for Record Entry Time");
			}

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + "." + sReport.replace(" ", "_"));
			sbQuery.append(" where ");

			Iterator<String> itr = mSearchCriteria.keySet().iterator();
			while (itr.hasNext()) {
				sColumn = itr.next();
				sValue = mSearchCriteria.get(sColumn).trim();

				if (!"".equals(sValue)) {
					if (bFlag) {
						sbQuery.append(" and ");
					}

					if (sValue.contains("|")) {
						saValue = sValue.split("\\|");

						sFromDate = saValue[0].trim();
						if (!"NA".equals(sFromDate)) {
							sFromDate = output.format(input.parse(sFromDate));
						}

						sToDate = saValue[1].trim();
						if (!"NA".equals(sToDate)) {
							sToDate = output.format(input.parse(sToDate));
						}

						if (!"NA".equals(sFromDate) && !"NA".equals(sToDate)) {
							sbQuery.append(sColumn + " BETWEEN '" + sFromDate + " 12:00:00 AM' AND '" + sToDate
									+ " 11:59:59 PM'");
						} else if (!"NA".equals(sFromDate)) {
							sbQuery.append(sColumn + " >= '" + sFromDate + " 12:00:00 AM'");
						} else if (!"NA".equals(sToDate)) {
							sbQuery.append(sColumn + " <= '" + sToDate + " 11:59:59 PM'");
						}
					} else {
						if (sValue.startsWith(">")) {
							sbQuery.append("cast(regexp_replace(" + sColumn + ",'[^0-9.-]+','0','g') as numeric) >= "
									+ sValue.substring(1).trim());
						} else if (sValue.startsWith("<")) {
							sbQuery.append("cast(regexp_replace(" + sColumn + ",'[^0-9.-]+','0','g') as numeric) <= "
									+ sValue.substring(1).trim());
						} else if (sValue.startsWith("=")) {
							sValue = sValue.substring(1).trim();
							if (NumberUtils.isNumber(sValue)) {
								sbQuery.append("cast(regexp_replace(" + sColumn + ",'[^0-9.-]+','0','g') as numeric) = "
										+ sValue);
							} else {
								sbQuery.append(sColumn + " = '" + sValue + "'");
							}
						} else if (sValue.startsWith("!")) {
							sValue = sValue.substring(1).trim();
							if (NumberUtils.isNumber(sValue)) {
								sbQuery.append("cast(regexp_replace(" + sColumn
										+ ",'[^0-9.-]+','0','g') as numeric) != " + sValue);
							} else {
								sbQuery.append(sColumn + " != '" + sValue + "'");
							}
						} else if (sValue.contains("~")) {
							String[] saRanges = StringUtils.split(sValue, '~');
							sbQuery.append("(");
							sbQuery.append("cast(regexp_replace(" + sColumn + ",'[^0-9.-]+','0','g') as numeric) >= "
									+ saRanges[0].trim());
							sbQuery.append(" and ");
							sbQuery.append("cast(regexp_replace(" + sColumn + ",'[^0-9.-]+','0','g') as numeric) <= "
									+ saRanges[1].trim());
							sbQuery.append(")");
						} else {
							sbQuery.append(sColumn + " LIKE '%" + sValue + "%'");
						}
					}

					bFlag = true;
				}
			}

			sbQuery.append(" ORDER BY " + sColumnName + " ASC");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				mRecord = new HashMap<String, String>();
				for (int i = 0; i < iSz; i++) {
					sColumn = slColumns.get(i);
					mRecord.put(sColumn, rs.getString(sColumn));
				}

				mlRecords.add(mRecord);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlRecords;
	}

	public StringList getRecordTimestamps(String sReport, Map<String, String> mSearchCriteria)
			throws SQLException, InterruptedException, ParseException {
		StringList slTimeStamps = new StringList();

		SimpleDateFormat sdfOut = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat sdfIn = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		String[] saColumn = getReportKeyColumn(sReport);
		String sKeyColumn = saColumn[0];
		String sColumnName = saColumn[1];
		if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
			throw new SQLException("Missing Column name for Record Entry Time");
		}

		Map<String, String> mRecord = new HashMap<String, String>();
		MapList mlRecords = getRecords(sReport, mSearchCriteria);
		for (int i = 0, iSz = mlRecords.size(); i < iSz; i++) {
			mRecord = mlRecords.get(i);
			slTimeStamps.add(sdfOut.format(sdfIn.parse(mRecord.get(sColumnName))));
		}

		return slTimeStamps;
	}

	public Map<String, String> getRecord(String sReport, String sDateTime)
			throws ParseException, SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Map<String, String> mRecord = new HashMap<String, String>();

		try {
			String[] saColumn = getReportKeyColumn(sReport);
			String sKeyColumn = saColumn[0];
			String sColumnName = saColumn[1];
			if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
				throw new SQLException("Missing Column name for Record Entry Time");
			}

			String sColumn = null;
			String sQuery = "select * from " + SCHEMA_NAME + "." + sReport.replace(" ", "_") + " where " + sColumnName
					+ " = ?";
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

			StringList slColumns = getReportColumns(sReport);
			int iSz = slColumns.size();

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);
			pstmt.setTimestamp(1, new java.sql.Timestamp(sdf.parse(sDateTime).getTime()));
			rs = pstmt.executeQuery();

			while (rs.next()) {
				mRecord = new HashMap<String, String>();
				for (int i = 0; i < iSz; i++) {
					sColumn = slColumns.get(i);
					mRecord.put(sColumn, rs.getString(sColumn));
				}
				mRecord.put(IS_UPDATED, (rs.getBoolean(IS_UPDATED) ? "TRUE" : "FALSE"));
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return mRecord;
	}

	public StringList getRecordTimestamps(String sReport, String sDate)
			throws ParseException, SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringList slTimeStamps = new StringList();

		try {
			String[] saColumn = getReportKeyColumn(sReport);
			String sKeyColumn = saColumn[0];
			String sColumnName = saColumn[1];
			if ("".equals(sKeyColumn) || "".equals(sColumnName)) {
				throw new SQLException("Missing Column name for Record Entry Time");
			}

			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
			String sQuery = "select \"time\"(" + sColumnName + ") as logTime from " + SCHEMA_NAME + "."
					+ sReport.replace(" ", "_") + " where date(" + sColumnName + ") = ? ORDER BY " + sColumnName
					+ " DESC";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sQuery);
			pstmt.setDate(1, new java.sql.Date(sdf.parse(sDate).getTime()));
			rs = pstmt.executeQuery();

			while (rs.next()) {
				slTimeStamps.add(rs.getString("logTime"));
			}
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);
		}

		return slTimeStamps;
	}

	public Map<String, String> getReportLastRecord(String sReport, String sKeyColumn, String sDate, String sBasedOnCol,
			String sBasedOnVal) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> mRecord = new HashMap<String, String>();

		try {
			StringList slColumns = getReportColumns(sReport);
			int iSz = slColumns.size();
			String sColumn = null;

			StringBuilder sbQuery = new StringBuilder();
			sbQuery.append("select * from " + SCHEMA_NAME + "." + sReport.replace(" ", "_"));
			sbQuery.append(" where " + sKeyColumn + " < '" + sDate + "'");
			if (!"".equals(sBasedOnCol) && !"".equals(sBasedOnVal)) {
				sbQuery.append(" and " + sBasedOnCol + " = '" + sBasedOnVal + "'");
			}
			sbQuery.append(" ORDER BY " + sKeyColumn + " DESC LIMIT 1");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				mRecord = new HashMap<String, String>();
				for (int i = 0; i < iSz; i++) {
					sColumn = slColumns.get(i);
					mRecord.put("PREV." + sColumn, rs.getString(sColumn));
				}
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mRecord;
	}

	public MapList getDefaultTypes() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlDefTypes = new MapList();

		try {
			Map<String, String> mDefTypes = null;
			String sQuery = "select * from " + SCHEMA_NAME
					+ ".CONTROLLER_DEF_TYPES ORDER BY CNTRL_TYPE, CNTRL_DEF_TYPE ASC";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sQuery);
			while (rs.next()) {
				mDefTypes = new HashMap<String, String>();
				mDefTypes.put(CNTRL_TYPE, rs.getString(CNTRL_TYPE));
				mDefTypes.put(CNTRL_DEF_TYPE, rs.getString(CNTRL_DEF_TYPE));
				mDefTypes.put(DESCRIPTION, rs.getString(DESCRIPTION));
				mlDefTypes.add(mDefTypes);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlDefTypes;
	}

	public void addDefaultType(String sCntrlType, String sDefType, String sDesc)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			sbInsert.append("insert into " + SCHEMA_NAME + ".CONTROLLER_DEF_TYPES (");
			sbInsert.append("CNTRL_TYPE, CNTRL_DEF_TYPE, DESCRIPTION");
			sbInsert.append(") values (");
			sbInsert.append("?, ?, ?");
			sbInsert.append(")");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbInsert.toString());

			pstmt.setString(1, sCntrlType);
			pstmt.setString(2, sDefType);
			pstmt.setString(3, sDesc);

			pstmt.executeUpdate();

			updateDefaultParamCols(sCntrlType, sDefType, "", "ADD");
		} finally {
			close(pstmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}
	}

	public void updateDefaultType(String sCntrlType, String sDefType, String sOldDefType, String sDesc)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {

			sbUpdate.append("update " + SCHEMA_NAME + ".CONTROLLER_DEF_TYPES set ");
			sbUpdate.append("CNTRL_DEF_TYPE = ?, ");
			sbUpdate.append("DESCRIPTION = ? ");
			sbUpdate.append(" where ");
			sbUpdate.append("CNTRL_DEF_TYPE = ?");
			sbUpdate.append(" and ");
			sbUpdate.append("CNTRL_TYPE = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			pstmt.setString(1, sDefType);
			pstmt.setString(2, sDesc);
			pstmt.setString(3, sOldDefType);
			pstmt.setString(4, sCntrlType);

			pstmt.executeUpdate();

			updateDefaultParamCols(sCntrlType, sDefType, sOldDefType, "MOD");
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}
	}

	public void deleteDefaultType(String sCntrlType, String sDefType) throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			StringBuilder sbUpdate = new StringBuilder();
			sbUpdate.append("delete from " + SCHEMA_NAME + ".CONTROLLER_DEF_TYPES ");
			sbUpdate.append(" where ");
			sbUpdate.append("CNTRL_DEF_TYPE = ?");
			sbUpdate.append(" and ");
			sbUpdate.append("CNTRL_TYPE = ?");

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sbUpdate.toString());

			pstmt.setString(1, sDefType);
			pstmt.setString(2, sCntrlType);

			pstmt.executeUpdate();

			updateDefaultParamCols(sCntrlType, sDefType, "", "DEL");
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	private void updateDefaultParamCols(String sCntrlType, String sDefType, String sOldDefType, String sAction)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "";
			String sTable = sCntrlType + "_DEF_PARAM_VAL";
			sDefType = sDefType.replace(" ", "_").trim();
			sOldDefType = sOldDefType.replace(" ", "_").trim();
			StringList slDefTypes = getColumnParameters(sTable);

			if ("ADD".equals(sAction) && !slDefTypes.contains(sDefType.toUpperCase())) {
				sQuery = "ALTER TABLE " + SCHEMA_NAME + "." + sTable + " ADD COLUMN " + sDefType + " character varying";
			} else if ("MOD".equals(sAction) && slDefTypes.contains(sOldDefType.toUpperCase())
					&& !sDefType.equalsIgnoreCase(sOldDefType)) {
				sQuery = "ALTER TABLE " + SCHEMA_NAME + "." + sTable + " RENAME " + sOldDefType + " TO " + sDefType;
			} else if ("DEL".equals(sAction) && slDefTypes.contains(sDefType.toUpperCase())) {
				sQuery = "ALTER TABLE " + SCHEMA_NAME + "." + sTable + " DROP COLUMN " + sDefType;
			}

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			stmt.executeUpdate(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public Map<String, String> getDefaultParamValues(String sCntrlType, String sDefType, String sParamGroup)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		Map<String, String> map = new HashMap<String, String>();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sName = "";
			String sDefVal = "";
			sDefType = sDefType.replace(" ", "_").trim();

			String selectString = "select PARAM_NAME," + sDefType + " from " + SCHEMA_NAME + "." + sCntrlType
					+ "_DEF_PARAM_VAL";
			if (sParamGroup != null && !"".equals(sParamGroup)) {
				selectString += " where PARAM_NAME LIKE '" + sParamGroup + "%'";
			}

			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				sName = rs.getString(PARAM_NAME);
				sDefVal = rs.getString(sDefType);
				sDefVal = (sDefVal == null ? "" : sDefVal);
				map.put(sName, sDefVal);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
		return map;
	}

	public void updateDefaultParamValues(String sCntrlType, String sDefType, Map<String, String> mDefValues)
			throws SQLException, InterruptedException {
		Connection conn = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;

		try {
			Map<String, String> mDefParams = getDefaultParamValues(sCntrlType, sDefType, null);

			String sParam = null;
			sDefType = sDefType.replace(" ", "_").trim();
			String sUpdate = "update " + SCHEMA_NAME + "." + sCntrlType + "_DEF_PARAM_VAL set " + sDefType
					+ " = ? where " + PARAM_NAME + " = ?";
			String sInsert = "insert into " + SCHEMA_NAME + "." + sCntrlType + "_DEF_PARAM_VAL (param_name, " + sDefType
					+ ") values (?, ?)";

			conn = connectionPool.getConnection();
			pstmt1 = conn.prepareStatement(sUpdate);

			Iterator<String> itrDefVals = mDefParams.keySet().iterator();
			while (itrDefVals.hasNext()) {
				sParam = itrDefVals.next();
				if (mDefValues.containsKey(sParam)) {
					pstmt1.setString(1, mDefValues.get(sParam));
					pstmt1.setString(2, sParam);

					pstmt1.executeUpdate();
					pstmt1.clearParameters();

					mDefValues.remove(sParam);
				}
			}

			if (mDefValues.size() > 0 && !mDefValues.isEmpty()) {
				pstmt2 = conn.prepareStatement(sInsert);

				itrDefVals = mDefValues.keySet().iterator();
				while (itrDefVals.hasNext()) {
					sParam = itrDefVals.next();

					pstmt2.setString(1, sParam);
					pstmt2.setString(2, mDefValues.get(sParam));

					pstmt2.executeUpdate();
					pstmt2.clearParameters();
				}
			}
		} finally {
			close(pstmt1, null);
			close(pstmt2, null);
			connectionPool.free(conn);
		}
	}

	public void copyDefaultValues(String sCntrlType, String sToDefType, String sFromDefType)
			throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		try {
			sToDefType = sToDefType.replace(" ", "_").trim();
			sFromDefType = sFromDefType.replace(" ", "_").trim();

			String sUpdate = "update " + SCHEMA_NAME + "." + sCntrlType + "_DEF_PARAM_VAL as D " + "set " + sToDefType
					+ " = S." + sFromDefType + " from " + SCHEMA_NAME + "." + sCntrlType + "_DEF_PARAM_VAL as S "
					+ "where D.PARAM_NAME = S.PARAM_NAME";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			stmt.executeUpdate(sUpdate);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}
	}

	public void setAccountCredentials(Map<String, String> mAcctCredentials) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			String sQuery = "update " + SCHEMA_NAME + ".ACCT_SETTINGS set ACCT_KEY_VAL = ? where ACCT_KEY_NAME = ?";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareCall(sQuery);

			String sKey = null;
			String sVal = null;
			EncryptDecrypt encrypt = new EncryptDecrypt();

			Iterator<String> itr = mAcctCredentials.keySet().iterator();
			while (itr.hasNext()) {
				sKey = itr.next();
				sVal = mAcctCredentials.get(sKey);
				if (CNTRL_PWD.equals(sKey) || MAILID_PWD.equals(sKey)) {
					sVal = encrypt.encrypt(sVal, ALGORITHM_DES);
				}

				pstmt.setString(1, sVal);
				pstmt.setString(2, sKey);

				pstmt.executeUpdate();
				pstmt.clearParameters();
			}
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public Map<String, String> getAccountCredentials() throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		Map<String, String> mAcctCredentials = new HashMap<String, String>();

		try {
			String sKey = null;
			String sVal = null;
			EncryptDecrypt encrypt = new EncryptDecrypt();

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery("select * from " + SCHEMA_NAME + ".ACCT_SETTINGS");
			while (rs.next()) {
				sKey = rs.getString(ACCT_KEY_NAME);
				sVal = rs.getString(ACCT_KEY_VAL);

				if (CNTRL_PWD.equals(sKey) || MAILID_PWD.equals(sKey)) {
					sVal = encrypt.decrypt(sVal, ALGORITHM_DES);
				}
				mAcctCredentials.put(sKey, sVal);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mAcctCredentials;
	}

	public void logUserActivity(String sUserId, String sUserIP, boolean bLogIn, String sText) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			String sInsertStmt = "insert into " + SCHEMA_NAME + ".USER_ACTIVITY (" + "USER_ID, USER_IP, "
					+ (bLogIn ? LOG_IN : LOG_OUT) + ", LOG_TEXT) values (?, ?, ?, ?)";

			conn = connectionPool.getConnection();
			pstmt = conn.prepareStatement(sInsertStmt);

			pstmt.setString(1, sUserId);
			pstmt.setString(2, sUserIP);
			pstmt.setTimestamp(3, new java.sql.Timestamp(Calendar.getInstance().getTimeInMillis()));
			pstmt.setString(4, sText);

			pstmt.executeUpdate();
		} finally {
			close(pstmt, null);
			connectionPool.free(conn);
		}
	}

	public MapList getUserActivityLog(String sFromDate, String sToDate) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		MapList mlLogs = new MapList();
		Map<String, String> mLog = null;
		StringBuilder sbQuery = new StringBuilder();
		Timestamp tsLog = null;

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm");

			SimpleDateFormat input = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat output = new SimpleDateFormat("yyyy-MM-dd");

			if (!"".equals(sFromDate)) {
				sFromDate = output.format(input.parse(sFromDate));
			}
			if (!"".equals(sToDate)) {
				sToDate = output.format(input.parse(sToDate));
			}

			sbQuery.append("select * from " + SCHEMA_NAME + ".USER_ACTIVITY where ");

			boolean bFlag = false;
			if (!"".equals(sFromDate)) {
				sbQuery.append("(");
				sbQuery.append(LOG_IN + " >= '" + sFromDate + " 12:00:00 AM'");
				sbQuery.append(" or ");
				sbQuery.append(LOG_OUT + " >= '" + sFromDate + " 12:00:00 AM'");
				sbQuery.append(")");
				bFlag = true;
			}

			if (!"".equals(sToDate)) {
				if (bFlag) {
					sbQuery.append(" and ");
				}
				sbQuery.append("(");
				sbQuery.append(LOG_IN + " <= '" + sToDate + " 11:59:59 PM'");
				sbQuery.append(" or ");
				sbQuery.append(LOG_OUT + " <= '" + sToDate + " 11:59:59 PM'");
				sbQuery.append(")");
			}

			sbQuery.append(" ORDER BY OID DESC ");

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sbQuery.toString());
			while (rs.next()) {
				mLog = new HashMap<String, String>();
				mLog.put(USER_ID, rs.getString(USER_ID));
				mLog.put(USER_IP, rs.getString(USER_IP));
				mLog.put(LOG_TEXT, rs.getString(LOG_TEXT));

				tsLog = rs.getTimestamp(LOG_IN);
				mLog.put(LOG_IN, ((tsLog != null) ? sdf.format(tsLog) : ""));

				tsLog = rs.getTimestamp(LOG_OUT);
				mLog.put(LOG_OUT, ((tsLog != null) ? sdf.format(tsLog) : ""));

				mlLogs.add(mLog);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbQuery = null;
		}

		return mlLogs;
	}

	public void killIdleQueries() throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			String sPID = null;
			StringList slIdlePID = new StringList();

			rs = stmt.executeQuery("SELECT pid FROM pg_stat_activity WHERE query != '<IDLE>' AND "
					+ "query NOT ILIKE '%pg_stat_activity%' AND ((now() - query_start) > '15 minutes'::interval);");
			while (rs.next()) {
				sPID = Integer.toString(rs.getInt("pid"));
				slIdlePID.add(sPID);
			}

			stmt.clearBatch();
			String sQuery = null;

			for (int i = 0, iSz = slIdlePID.size(); i < iSz; i++) {
				sQuery = "SELECT pg_terminate_backend(" + slIdlePID.get(i) + ")";
				stmt.addBatch(sQuery);
			}

			stmt.executeBatch();
			stmt.clearBatch();
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}
	}

	public MapList getNotificationGroups() throws SQLException, InterruptedException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		MapList mlGroups = new MapList();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			Map<String, String> mGroup = null;
			String selectString = "select * from " + SCHEMA_NAME + ".ALARM_GROUP ORDER BY ALARM_GROUP ASC";
			rs = stmt.executeQuery(selectString);
			while (rs.next()) {
				mGroup = new HashMap<String, String>();
				mGroup.put(ALARM_GROUP, rs.getString(ALARM_GROUP));
				mGroup.put(NOTIFY_LEVEL1, rs.getString(NOTIFY_LEVEL1));
				mGroup.put(NOTIFY_LEVEL2, rs.getString(NOTIFY_LEVEL2));
				mGroup.put(NOTIFY_LEVEL3, rs.getString(NOTIFY_LEVEL3));
				mGroup.put(LEVEL1_ATTEMPTS, Integer.toString(rs.getInt(LEVEL1_ATTEMPTS)));
				mGroup.put(LEVEL2_ATTEMPTS, Integer.toString(rs.getInt(LEVEL2_ATTEMPTS)));
				mGroup.put(LEVEL3_ATTEMPTS, Integer.toString(rs.getInt(LEVEL3_ATTEMPTS)));

				mlGroups.add(mGroup);
			}
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);
		}

		return mlGroups;
	}

	public boolean addNotificationGroup(Map<String, String> mGroup) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		StringBuilder sbInsert = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbInsert.append("insert into " + SCHEMA_NAME + ".ALARM_GROUP (");
			sbInsert.append(ALARM_GROUP + ", " + NOTIFY_LEVEL1 + ", " + NOTIFY_LEVEL2 + ", " + NOTIFY_LEVEL3 + ", ");
			sbInsert.append(LEVEL1_ATTEMPTS + ", " + LEVEL2_ATTEMPTS + ", " + LEVEL3_ATTEMPTS);
			sbInsert.append(") values ('");
			sbInsert.append(mGroup.get(ALARM_GROUP));
			sbInsert.append("','");
			sbInsert.append(mGroup.get(NOTIFY_LEVEL1));
			sbInsert.append("','");
			sbInsert.append(mGroup.get(NOTIFY_LEVEL2));
			sbInsert.append("','");
			sbInsert.append(mGroup.get(NOTIFY_LEVEL3));
			sbInsert.append("','");
			sbInsert.append(mGroup.get(LEVEL1_ATTEMPTS));
			sbInsert.append("','");
			sbInsert.append(mGroup.get(LEVEL2_ATTEMPTS));
			sbInsert.append("','");
			sbInsert.append(mGroup.get(LEVEL3_ATTEMPTS));
			sbInsert.append("')");

			stmt.executeUpdate(sbInsert.toString());
		} finally {
			close(stmt, rs);
			connectionPool.free(conn);

			sbInsert = null;
		}

		return true;
	}

	public boolean updateNotificationGroup(Map<String, String> mGroup) throws Exception {
		Connection conn = null;
		Statement stmt = null;
		StringBuilder sbUpdate = new StringBuilder();

		try {
			conn = connectionPool.getConnection();
			stmt = conn.createStatement();

			sbUpdate.append("update " + SCHEMA_NAME + ".ALARM_GROUP set ");
			sbUpdate.append(NOTIFY_LEVEL1 + " = '" + mGroup.get(NOTIFY_LEVEL1) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(NOTIFY_LEVEL2 + " = '" + mGroup.get(NOTIFY_LEVEL2) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(NOTIFY_LEVEL3 + " = '" + mGroup.get(NOTIFY_LEVEL3) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(LEVEL1_ATTEMPTS + " = '" + mGroup.get(LEVEL1_ATTEMPTS) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(LEVEL2_ATTEMPTS + " = '" + mGroup.get(LEVEL2_ATTEMPTS) + "'");
			sbUpdate.append(", ");
			sbUpdate.append(LEVEL3_ATTEMPTS + " = '" + mGroup.get(LEVEL3_ATTEMPTS) + "'");
			sbUpdate.append(" where ");
			sbUpdate.append(ALARM_GROUP + " = '" + mGroup.get(ALARM_GROUP) + "'");

			stmt.executeUpdate(sbUpdate.toString());
		} finally {
			close(stmt, null);
			connectionPool.free(conn);

			sbUpdate = null;
		}

		return true;
	}

	public boolean deleteNotificationGroup(String sGroup) throws Exception {
		Connection conn = null;
		Statement stmt = null;

		try {
			String sQuery = "delete from " + SCHEMA_NAME + ".ALARM_GROUP where " + ALARM_GROUP + " = '" + sGroup + "'";

			conn = connectionPool.getConnection();
			stmt = conn.createStatement();
			stmt.execute(sQuery);
		} finally {
			close(stmt, null);
			connectionPool.free(conn);
		}

		return true;
	}

	public int getPhaseRunningDay(String sController) throws Exception {
		int iNoDays = 0;

		Map<String, String[]> mCntrlData = getControllerParameters(sController);

		if (mCntrlData.containsKey("current phase")) {
			String sValue = "";

			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MMM-yyyy HH:mm");

			String cntrlType = RDMServicesUtils.getControllerType(sController);

			String sPhaseSeq = mCntrlData.get("current phase")[0];
			sPhaseSeq = ((sPhaseSeq.endsWith(".0")) ? sPhaseSeq.substring(0, sPhaseSeq.indexOf(".")) : sPhaseSeq);
			sPhaseSeq = sPhaseSeq.replace('.', ' ');

			String sPhase = RDMServicesUtils.getStageName(cntrlType, sPhaseSeq);

			if (mCntrlData.containsKey("Last Refresh")) {
				java.util.Date date = sdf.parse(mCntrlData.get("Last Refresh")[0]);
				cal.setTime(date);
			}

			int iMin = cal.get(Calendar.MINUTE);
			iMin = iMin - ((iMin / 6) * 6);
			cal.add(Calendar.SECOND, -(cal.get(Calendar.SECOND)));
			cal.add(Calendar.MINUTE, -(iMin));

			String sParam = "time " + sPhase + " " + sPhaseSeq;
			if (mCntrlData.containsKey(sParam)) {
				sValue = mCntrlData.get(sParam)[0];
			} else {
				sParam = "time phase " + sPhaseSeq;
				if (mCntrlData.containsKey(sParam)) {
					sValue = mCntrlData.get(sParam)[0];
				}
			}

			if (sValue == null || "".equals(sValue) || "0".equals(sValue) || "0.0".equals(sValue)) {
				sParam = "duration " + sPhase + " " + sPhaseSeq;
				if (mCntrlData.containsKey(sParam)) {
					sValue = mCntrlData.get(sParam)[0];
				} else {
					sParam = "duration phase " + sPhaseSeq;
					if (mCntrlData.containsKey(sParam)) {
						sValue = mCntrlData.get(sParam)[0];
					}
				}
			}

			if (sValue != null && !"".equals(sValue) && !("0".equals(sValue) || "0.0".equals(sValue))) {
				try {
					double dTime = Double.parseDouble(sValue);
					iNoDays = (int) Math.ceil(Math.abs(dTime) / 24);
				} catch (NumberFormatException e) {
					// do nothing
				}
			}
		}

		return iNoDays;
	}

	private void close(ResultSet rs) throws SQLException, InterruptedException {
		if (rs != null) {
			if (!rs.isClosed()) {
				rs.close();
			}
		}
	}

	private void close(Statement stmt, ResultSet rs) throws SQLException, InterruptedException {
		if (rs != null) {
			if (!rs.isClosed()) {
				rs.close();
			}
		}

		if (stmt != null) {
			if (!stmt.isClosed()) {
				stmt.close();
			}
		}
	}

	private void close(PreparedStatement pstmt, ResultSet rs) throws SQLException, InterruptedException {
		if (rs != null) {
			if (!rs.isClosed()) {
				rs.close();
			}
		}

		if (pstmt != null) {
			if (!pstmt.isClosed()) {
				pstmt.close();
			}
		}
	}

	private boolean isGeneralController(String sRoom) throws Exception {
		return RDMServicesUtils.isGeneralController(sRoom);
	}
}
