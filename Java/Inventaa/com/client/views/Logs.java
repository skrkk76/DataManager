package com.client.views;

import com.client.db.DataQuery;
import com.client.util.MapList;
import com.client.util.User;

public class Logs {
	public Logs() {

	}

	public MapList getLogHistory(User ctxUser, String sRoom, String sStage, String BNo, String sFromDate,
			String sToDate, String sParams, String showSysLogs, int limit) throws Exception {
		DataQuery query = new DataQuery();
		return query.getLogHistory(ctxUser, sRoom, sStage, BNo, sFromDate, sToDate, sParams, showSysLogs, limit);
	}
}
