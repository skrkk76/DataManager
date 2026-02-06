package com.client.scheduler;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.client.PLCServices;
import com.client.PLCServices_newHW;
import com.client.PLCServices_oldHW;
import com.client.ServicesSession;
import com.client.db.DataQuery;
import com.client.license.VerifyLicense;
import com.client.rules.RuleEngine;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;
import com.client.util.StringList;

public class RDMScheduler {
	private java.sql.Date sqlDate = RDMServicesUtils.getDate();
	private java.sql.Time sqlTime = RDMServicesUtils.getTime();

	public static void main(String[] args) throws Throwable {
		try {
			if (args.length == 0) {
				throw new Exception("Missing args");
			}

			boolean licensed = VerifyLicense.verifyLicense();
			if (!licensed) {
				throw new Exception("Unlicensed software, please contact the provider for license");
			}

			new RDMScheduler(args);
		} catch (Exception e) {
			throw new Exception(e.getLocalizedMessage());
		} finally {
			System.exit(0);
		}
	}

	public RDMScheduler(String[] args) throws Throwable {
		Map<String, Map<String, String[]>> mControllerParams = this.getControllerData(args);
		this.saveControllersData(mControllerParams);
		this.evaluateUserRules(mControllerParams);
	}

	private Map<String, Map<String, String[]>> getControllerData(String[] args) throws Exception {
		String sController = "";
		StringList slControllers = new StringList();
		Map<String, String[]> mParams = null;
		Map<String, Map<String, String[]>> mControllerParams = new HashMap<String, Map<String, String[]>>();
		ServicesSession session = new ServicesSession();

		if (args.length == 1) {
			if (RDMServicesConstants.TYPE_GENERAL.equals(args[0])) {
				for (int i = 0; i < RDMServicesConstants.GENERAL_CNTRL_TYPES.size(); i++) {
					String cntrlType = RDMServicesConstants.GENERAL_CNTRL_TYPES.get(i);
					slControllers.addAll(session.getAllControllers(cntrlType));
				}
			} else {
				slControllers.addAll(session.getAllControllers(args[0]));
			}
		} else {
			String[] controllers = args[1].split(",");
			for (String controller : controllers) {
				slControllers.add(controller.trim());
			}
		}

		DataQuery query = new DataQuery();
		if (!query.checkAllowedRooms()) {
			throw new Exception(
					"Max number of Licensed Rooms has exceeded. Please contact the admin at L-Pit for licenses to create more Rooms.");
		}

		for (int i = 0, iSz = slControllers.size(); i < iSz; i++) {
			try {
				PLCServices client = null;
				sController = slControllers.get(i);
				String sCntrlVersion = session.getControllerVersion(sController);
				if (RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion)) {
					client = new PLCServices_oldHW(session, sController);
				} else if (RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion)) {
					client = new PLCServices_newHW(session, sController);
				}
				mParams = client.getControllerData(true);
				mParams.remove("Last Refresh");
				mParams.remove("manual.sl");
				mParams.remove("cooling.steam");
				mParams.remove("comp.error");
				mParams.remove("BatchNo");
				mParams.remove("Product");
				mControllerParams.put(sController, mParams);
			} catch (Exception e) {
				System.out.println(sController + "[getControllerData] : " + e.getLocalizedMessage());
				e.printStackTrace(System.out);
			}
		}

		return mControllerParams;
	}

	private void saveControllersData(Map<String, Map<String, String[]>> mControllerParams) throws Throwable {
		String sController = "";
		Map<String, String[]> mParams = null;
		DataQuery query = new DataQuery();

		Iterator<String> itr = mControllerParams.keySet().iterator();
		while (itr.hasNext()) {
			try {
				sController = itr.next();
				mParams = mControllerParams.get(sController);
				query.saveParameters(sController, sqlDate, sqlTime, mParams);
			} catch (Exception e) {
				System.out.println(sController + "[saveControllersData] : " + e.getLocalizedMessage());
				e.printStackTrace(System.out);
			}
		}
	}

	private void evaluateUserRules(Map<String, Map<String, String[]>> mControllerParams) throws Throwable {
		String sController = "";
		Map<String, String[]> mParams = null;
		RuleEngine ruleEngine = new RuleEngine();

		Iterator<String> itr = mControllerParams.keySet().iterator();
		while (itr.hasNext()) {
			try {
				sController = itr.next();
				if (!RDMServicesUtils.isGeneralController(sController)) {
					mParams = mControllerParams.get(sController);
					ruleEngine.evaluateUserRules(sController, mParams.keySet());
				}
			} catch (Exception e) {
				System.out.println(sController + "[evaluateUserRules] : " + e.getLocalizedMessage());
				e.printStackTrace(System.out);
			}
		}
	}
}
