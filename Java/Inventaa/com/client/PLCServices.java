package com.client;

import java.util.ArrayList;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;

import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.User;

public abstract class PLCServices extends RDMServicesConstants
{
	public abstract Map<String, String> getControllerParameters(String cntrlType) throws Exception;
	public abstract ArrayList<String[]> getControllerStages() throws Exception;
	public abstract Map<String, String[]> getControllerData(boolean isRealTime) throws Exception;
	public abstract Map<String, Map<String, String>> getRoomViewParams(User u, boolean isRealTime) throws Exception;
	public abstract TreeMap<String, Map<String, String>> getImageControllerData(Map<String, String[]> mParams, String sParamKey, String sSelPhase) throws Exception;
	public abstract String setParameters(User u, Map<String, String[]> mParams) throws Throwable;
	public abstract boolean hasOpenAlarms() throws Exception;
	public abstract MapList getAlarmList() throws Exception;
	public abstract MapList getAlarmList(int cnt, boolean bUpdate) throws Exception;
	public abstract boolean saveLogData(String sStartDate, String sEndDate) throws Exception;
	public abstract ArrayList<String[]> getSysLog(Date toTime) throws Throwable;
	public abstract Map<String, String> getPhaseStartTime(Map<String, String[]> mCntrlData) throws Exception;
	public abstract String getBatchNo() throws Exception;
	public abstract String getBatchDefType() throws Exception;
	public abstract String getControllerType();
	public abstract void addBatchNo(String sBNo, String sDefType) throws Exception;
	public abstract void updateBatchNo(String sBNo, String sDefType) throws Exception;
	public abstract void updateDefaultProduct(String sBNo, String sDefType) throws Exception;
}
