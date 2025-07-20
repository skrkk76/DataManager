package com.client.notify;

import java.net.URI;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;

import com.client.db.DataQuery;
import com.client.rules.RuleEngine;
import com.client.util.LabelResourceBundle;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;
import com.client.util.StringList;
import com.twilio.Twilio;
import com.twilio.exception.ApiException;
import com.twilio.http.TwilioRestClient;
import com.twilio.rest.api.v2010.account.Call;
import com.twilio.rest.api.v2010.account.CallCreator;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.rest.api.v2010.account.MessageCreator;
import com.twilio.type.PhoneNumber;

public class NotifyAlarms extends RDMServicesConstants {
    private static SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.getDefault());
    private static Map<String, MapList> NOTIFY_ALARMS = null;

    public NotifyAlarms() {

    }

    public StringList listAlarms(String sController) throws Exception {
	StringList slAlarms = new StringList();

	DataQuery query = new DataQuery();
	ArrayList<String[]> alAlarms = query.getNotificationAlarms();

	RuleEngine engine = new RuleEngine();
	MapList mlRules = engine.getUserRules();

	Map<String, String> mRule = null;
	for (int i = 0; i < mlRules.size(); i++) {
	    mRule = mlRules.get(i);
	    alAlarms.add(new String[] { mRule.get(RULE_DESCRIPTION), mRule.get(CNTRL_TYPE) });
	}

	String[] saAlarm = null;
	Map<String, Map<String, String>> mAlarms = getNotificationAlarms();

	for (int i = 0, iSz = alAlarms.size(); i < iSz; i++) {
	    saAlarm = alAlarms.get(i);
	    if (sController.equals(saAlarm[1]) && !mAlarms.containsKey(saAlarm[1] + "." + saAlarm[0])) {
		slAlarms.add(saAlarm[0]);
	    }
	}

	return slAlarms;
    }

    public Map<String, MapList> listNotificationAlarms() throws Exception {
	if (NOTIFY_ALARMS == null) {
	    DataQuery query = new DataQuery();
	    NOTIFY_ALARMS = query.listNotificationAlarms();
	}
	return NOTIFY_ALARMS;
    }

    public Map<String, Map<String, String>> listNotificationAlarms(String sController) throws Exception {
	listNotificationAlarms();

	Map<String, String> mAlarm = null;
	Map<String, Map<String, String>> mAlarms = new HashMap<String, Map<String, String>>();

	MapList mlAlarms = NOTIFY_ALARMS.get(sController);
	if (mlAlarms != null) {
	    for (int i = 0, iSz = mlAlarms.size(); i < iSz; i++) {
		mAlarm = mlAlarms.get(i);
		mAlarms.put(mAlarm.get(ALARM), mAlarm);
	    }
	}
	return mAlarms;
    }

    private Map<String, Map<String, String>> getNotificationAlarms() throws Exception {
	listNotificationAlarms();

	String sController = null;
	MapList mlAlarms = null;
	Map<String, String> mAlarm = null;
	Map<String, Map<String, String>> mAlarms = new HashMap<String, Map<String, String>>();

	Iterator<String> itr = NOTIFY_ALARMS.keySet().iterator();
	while (itr.hasNext()) {
	    sController = itr.next();
	    mlAlarms = NOTIFY_ALARMS.get(sController);
	    for (int i = 0, iSz = mlAlarms.size(); i < iSz; i++) {
		mAlarm = mlAlarms.get(i);
		mAlarms.put((sController + "." + mAlarm.get(ALARM)), mAlarm);
	    }
	}
	return mAlarms;
    }

    public void addNotificationAlarm(String sAlarm, String sCntrlType, String sNotifyBy, String sGroup,
	    int notifyDuration) throws Exception {
	DataQuery query = new DataQuery();
	query.addNotificationAlarm(sAlarm, sCntrlType, sNotifyBy, sGroup, notifyDuration);
	NOTIFY_ALARMS = query.listNotificationAlarms();
    }

    public void updateNotificationAlarm(String sAlarm, String sCntrlType, String sNotifyBy, String sGroup,
	    int notifyDuration) throws Exception {
	DataQuery query = new DataQuery();
	query.updateNotificationAlarm(sAlarm, sCntrlType, sNotifyBy, sGroup, notifyDuration);
	NOTIFY_ALARMS = query.listNotificationAlarms();
    }

    public void deleteNotificationAlarm(String sAlarm, String sCntrlType) throws Exception {
	DataQuery query = new DataQuery();
	query.deleteNotificationAlarm(sAlarm, sCntrlType);
	NOTIFY_ALARMS = query.listNotificationAlarms();
    }

    public void notifyUsers(Date timeStamp) throws Exception {
	HashSet<String> hsCallUsers = new HashSet<String>();
	Map<String, MapList> mSMSUsers = new HashMap<String, MapList>();
	MapList mlAlarms = null;

	Map<String, Map<String, String>> mNotificationAlarms = getNotificationAlarms();

	DataQuery query = new DataQuery();
	MapList mlNotifyAlarms = query.getNotifyAlarms();

	int level1;
	int level2;
	int level3;
	int firstNotify;
	int secondNotify;
	int thirdNotify;
	int notifyDuration;
	long timeDiff;
	String sAlarm = null;
	String sCntrlAlarm = null;
	String sNotifyBy = null;
	String sNotifyUser = null;
	String sLastNotified = null;
	Map<String, String> mAlarm = null;
	Map<String, String> mNotify = null;
	MapList mlUpdateAlarms = new MapList();

	for (int i = 0; i < mlNotifyAlarms.size(); i++) {
	    mAlarm = mlNotifyAlarms.get(i);
	    sAlarm = mAlarm.get(ALARM_TEXT);
	    level1 = Integer.parseInt(mAlarm.get(LEVEL1_ATTEMPTS));
	    level2 = Integer.parseInt(mAlarm.get(LEVEL2_ATTEMPTS));
	    level3 = Integer.parseInt(mAlarm.get(LEVEL3_ATTEMPTS));

	    timeDiff = 0;
	    sLastNotified = mAlarm.get(LAST_NOTIFIED);

	    if (sLastNotified != null && !"".equals(sLastNotified)) {
		timeDiff = (timeStamp.getTime() - format.parse(sLastNotified).getTime()) / (60 * 1000);
	    } else {
		timeDiff = 120;
	    }

	    String sCntrlType = RDMServicesUtils.getControllerType(mAlarm.get(ROOM_ID));
	    if (sCntrlType.startsWith("General")) {
		sCntrlType = sCntrlType.substring(8);
	    }

	    sCntrlAlarm = String.valueOf(sCntrlType) + "." + sAlarm;
	    if (mNotificationAlarms.containsKey(sCntrlAlarm)) {
		mNotify = mNotificationAlarms.get(sCntrlAlarm);
		sNotifyBy = mNotify.get(NOTIFY_BY);
		firstNotify = Integer.parseInt(mNotify.get(LEVEL1_ATTEMPTS));
		secondNotify = Integer.parseInt(mNotify.get(LEVEL2_ATTEMPTS));
		thirdNotify = Integer.parseInt(mNotify.get(LEVEL3_ATTEMPTS));
		notifyDuration = Integer.parseInt(mNotify.get(NOTIFY_DURATION));

		if (timeDiff < notifyDuration) {
		    continue;
		} else if (level1 < firstNotify) {
		    sNotifyUser = mNotify.get(NOTIFY_LEVEL1);

		    level1++;
		    mAlarm.put(LEVEL1_ATTEMPTS, Integer.toString(level1));
		    mAlarm.put(LEVEL2_ATTEMPTS, Integer.toString(0));
		    mAlarm.put(LEVEL3_ATTEMPTS, Integer.toString(0));
		} else if (level2 < secondNotify) {
		    sNotifyUser = mNotify.get(NOTIFY_LEVEL2);

		    level2++;
		    mAlarm.put(LEVEL1_ATTEMPTS, Integer.toString(level1));
		    mAlarm.put(LEVEL2_ATTEMPTS, Integer.toString(level2));
		    mAlarm.put(LEVEL3_ATTEMPTS, Integer.toString(0));
		} else if (level3 < thirdNotify) {
		    sNotifyUser = mNotify.get(NOTIFY_LEVEL3);

		    level3++;
		    mAlarm.put(LEVEL1_ATTEMPTS, Integer.toString(level1));
		    mAlarm.put(LEVEL2_ATTEMPTS, Integer.toString(level2));
		    mAlarm.put(LEVEL3_ATTEMPTS, Integer.toString(level3));
		} else {
		    continue;
		}

		mlUpdateAlarms.add(mAlarm);

		if (NOTIFY_CALL.equalsIgnoreCase(sNotifyBy)) {
		    hsCallUsers.add(sNotifyUser);
		}

		if ((level1 == 1) || (level2 == 1) || (level3 == 1)) {
		    mlAlarms = ((mSMSUsers.containsKey(sNotifyUser)) ? mSMSUsers.get(sNotifyUser) : new MapList());
		    mlAlarms.add(mAlarm);
		    mSMSUsers.put(sNotifyUser, mlAlarms);
		}
	    }
	}

	java.sql.Timestamp sqlTime = new java.sql.Timestamp(timeStamp.getTime());
	query.updateNotifyAlarms(mlUpdateAlarms, sqlTime);

	Map<String, String> mUser = null;
	Map<String, String> mUsers = new HashMap<String, String>();
	MapList mlUsers = RDMServicesUtils.getUserList();
	for (int i = 0; i < mlUsers.size(); i++) {
	    mUser = mlUsers.get(i);
	    mUsers.put(mUser.get(USER_ID), mUser.get(CONTACT_NO));
	}

	sendNotifications(hsCallUsers, mSMSUsers, mlAlarms, mUsers);
    }

    private void sendNotifications(HashSet<String> hsCallUsers, Map<String, MapList> mSMSUsers, MapList mlAlarms,
	    Map<String, String> mUsers) throws Exception {
	Locale locale = Locale.getDefault();
	LabelResourceBundle resourceBundle = new LabelResourceBundle(locale);
	String language = locale.getLanguage() + "-" + locale.getCountry();

	Map<String, String> mAcctCredentials = RDMServicesUtils.getAccountCredentials();
	String ACCOUNT_SID = mAcctCredentials.get(ACCT_SID);
	String AUTH_TOKEN = mAcctCredentials.get(AUTH_CODE);
	String REG_NUM = "+" + mAcctCredentials.get(REG_NUMBER);

	Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
	TwilioRestClient client = Twilio.getRestClient();

	String sCallMessage = "<Response><Say language=\"" + language + "\">"
		+ resourceBundle.getProperty("DataManager.DisplayText.Call_Message") + "</Say></Response>";
	sCallMessage = URLEncoder.encode(sCallMessage, "UTF-8").replace("+", "%20");
	String sUrl = "http://twimlets.com/echo?Twiml=" + sCallMessage;

	Iterator<String> itrUsers = hsCallUsers.iterator();
	while (itrUsers.hasNext()) {
	    String sNotifyUser = itrUsers.next();
	    try {
		String sContact = mUsers.get(sNotifyUser);
		if (RDMServicesUtils.isNotNullAndNotEmpty(sContact)) {
		    System.out.println("calling " + sNotifyUser + " - " + sContact);
		    CallCreator creator = Call.creator(new PhoneNumber("+" + sContact), new PhoneNumber(REG_NUM),
			    new URI(sUrl));
		    Call call = creator.create(client);
		    System.out.println("Call Status : " + call.getSid() + " - " + call.getStatus());
		}
	    } catch (final ApiException e) {
		System.out.println("Err while making call to user " + sNotifyUser + " : " + e.getMessage());
	    }
	}

	itrUsers = mSMSUsers.keySet().iterator();
	while (itrUsers.hasNext()) {
	    String sMessage = "";
	    String sNotifyUser = itrUsers.next();
	    try {
		String sContact = mUsers.get(sNotifyUser);
		if (RDMServicesUtils.isNotNullAndNotEmpty(sContact)) {
		    mlAlarms = mSMSUsers.get(sNotifyUser);
		    for (int i = 0; i < mlAlarms.size(); i++) {
			Map<String, String> mAlarm = mlAlarms.get(i);
			if (i > 0) {
			    sMessage += "\n";
			}

			sMessage += resourceBundle
				.getProperty("DataManager.DisplayText."
					+ RDMServicesUtils.getControllerType(mAlarm.get(RDMServicesConstants.ROOM_ID)))
				+ " - " + mAlarm.get(RDMServicesConstants.ROOM_ID) + " - "
				+ mAlarm.get(RDMServicesConstants.OCCURED_ON) + " - "
				+ mAlarm.get(RDMServicesConstants.ALARM_TEXT);
		    }

		    if (RDMServicesUtils.isNotNullAndNotEmpty(sMessage)) {
			System.out.println("sending SMS to " + sNotifyUser + " - " + sContact);
			MessageCreator creator = Message.creator(new PhoneNumber("+" + sContact),
				new PhoneNumber(REG_NUM), sMessage);
			Message message = creator.create(client);
			System.out.println("SMS Status : " + message.getSid() + " - " + message.getStatus());
		    }
		}
	    } catch (Exception e) {
		System.out.println("Err while sending SMS to user " + sNotifyUser + " : " + e.getMessage());
	    }
	}
    }
}
