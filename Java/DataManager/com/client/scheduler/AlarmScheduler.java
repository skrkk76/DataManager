package com.client.scheduler;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.client.PLCServices;
import com.client.PLCServices_newHW;
import com.client.PLCServices_oldHW;
import com.client.ServicesSession;
import com.client.db.DataQuery;
import com.client.license.VerifyLicense;
import com.client.notify.NotifyAlarms;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.StringList;

public class AlarmScheduler {
	private int cnt = -1;
	private Calendar cal = null;
	private Date date = null;

	public static void main(String[] args) throws Throwable {
		try {
			boolean licensed = VerifyLicense.verifyLicense();
			if (!licensed) {
				throw new Exception("Unlicensed software, please contact the provider for license");
			}

			int i = 0;
			if (args.length == 1) {
				try {
					i = Integer.parseInt(args[0]);
					i = 0 - i;
				} catch (Exception e) {
					i = -5;
				}
			}

			new AlarmScheduler(i);
		} catch (Exception e) {
			throw new Exception(e.getLocalizedMessage());
		} finally {
			System.exit(0);
		}
	}

	public AlarmScheduler(int i) throws Throwable {
		cal = Calendar.getInstance();
		date = cal.getTime();

		if (i < 0) {
			cal.add(Calendar.MINUTE, i);
			cal.add(Calendar.SECOND, (0 - cal.get(Calendar.SECOND)));
			cnt = 50;
		}

		Map<String, MapList> mControllerAlarms = this.getControllerAlarms();
		this.saveAlarms(mControllerAlarms);
		this.deleteDuplicateLogs();
		this.notifyUsers();
	}

	private Map<String, MapList> getControllerAlarms() throws Exception {
		String sController = "";
		PLCServices client = null;
		MapList mlAlarms = null;
		Map<String, MapList> mControllerParams = new HashMap<String, MapList>();

		ServicesSession session = new ServicesSession();
		StringList slControllers = session.getAllControllers();

		DataQuery query = new DataQuery();
		if (!query.checkAllowedRooms()) {
			throw new Exception(
					"Max number of Licensed Rooms has exceeded. Please contact the admin at L-Pit for licenses to create more Rooms.");
		}

		for (int i = 0; i < slControllers.size(); i++) {
			try {
				sController = slControllers.get(i);
				String sCntrlVersion = session.getControllerVersion(sController);
				if (RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion)) {
					client = new PLCServices_oldHW(session, sController);
				} else if (RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion)) {
					client = new PLCServices_newHW(session, sController);
				}
				mlAlarms = client.getAlarmList(cnt, true);
				mControllerParams.put(sController, mlAlarms);
			} catch (Exception e) {
				System.out.println(sController + " [getControllerAlarms] : " + e.getLocalizedMessage());
				e.printStackTrace(System.out);
			}
		}

		return mControllerParams;
	}

	private void saveAlarms(Map<String, MapList> mControllerParams) throws Exception {
		String sController = "";
		MapList mlAlarms;
		DataQuery query = new DataQuery();

		Iterator<String> itr = mControllerParams.keySet().iterator();
		while (itr.hasNext()) {
			try {
				sController = itr.next();
				mlAlarms = mControllerParams.get(sController);

				query.saveAlarmLogs(sController, mlAlarms);
			} catch (Exception e) {
				System.out.println(sController + " [saveAlarms] : " + e.getLocalizedMessage());
				e.printStackTrace(System.out);
			}
		}
	}

	private void deleteDuplicateLogs() throws Exception {
		DataQuery query = new DataQuery();
		query.deleteDuplicateAlarmLogs();
	}

	private void notifyUsers() throws Exception {
		NotifyAlarms notifyAlarms = new NotifyAlarms();
		notifyAlarms.notifyUsers(date);
	}
}
