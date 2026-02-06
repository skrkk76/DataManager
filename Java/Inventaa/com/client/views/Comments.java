package com.client.views;

import java.util.HashMap;
import java.util.Map;

import com.client.db.DataQuery;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.StringList;
import com.client.util.User;

public class Comments extends RDMServicesConstants {
	public Comments() {

	}

	public MapList getGlobalAlerts(User ctxUser) throws Exception {
		StringList slDept = ctxUser.getDepartment();
		return getUserComments(ctxUser, "", "", "", "", "", "", "", slDept.join('|'), true, false, 0);
	}

	public MapList getUserComments(User ctxUser, String sRoom, String sStage, String BNo, String sFromDate,
			String sToDate, String sLoggedBy, String sCategory, String sDept, boolean bGlobal, boolean bClosed,
			int limit) throws Exception {
		DataQuery query = new DataQuery();
		return query.getUserComments(ctxUser, sRoom, sStage, BNo, sFromDate, sToDate, sLoggedBy, sCategory, sDept,
				bGlobal, bClosed, limit);
	}

	public boolean addUserComments(Map<String, String> mInfo) throws Exception {
		DataQuery query = new DataQuery();
		return query.addUserComments(mInfo);
	}

	public boolean updateAlert(Map<String, String> mInfo) throws Exception {
		DataQuery query = new DataQuery();
		return query.updateAlert(mInfo, false);
	}

	public boolean closeAlert(String user, String sCmtId) throws Exception {
		Map<String, String> mInfo = new HashMap<String, String>();
		mInfo.put(LOGGED_BY, user);
		mInfo.put(COMMENT_ID, sCmtId);
		mInfo.put(REVIEW_COMMENTS, "Notification Closed");

		DataQuery query = new DataQuery();
		return query.updateAlert(mInfo, true);
	}
}
