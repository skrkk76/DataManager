package com.client.util;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;

import com.client.db.DataQuery;

public class User extends RDMServicesConstants implements Serializable {
    private static final long serialVersionUID = 1L;

    private boolean isLoggedIn = false;
    private String sUserId = "";
    private String sFirstName = "";
    private String sLastName = "";
    private String sRole = "";
    private String sEmail = "";
    private String cGender = "";
    private String sAddress = "";
    private String dDateOfBirth = "";
    private String dDateOfJoin = "";
    private String sContactNo = "";
    private String sBlocked = "";
    private String sHomePage = "";
    private String sLocale = "";
    private String sTraining = "";
    private String sQualification = "";
    private String sDesignation = "";
    private StringList slDept = new StringList();
    private StringList slGroups = new StringList();
    private StringList slControllers = new StringList();

    public User(String userId) {
	sUserId = userId;
    }

    public String getUser() {
	return sUserId;
    }

    public String getFirstName() {
	return sFirstName;
    }

    public String getLastName() {
	return sLastName;
    }

    public String getDisplayName() {
	return sLastName + ", " + sFirstName;
    }

    public static String getDisplayName(String sUser) throws Exception {
	Map<String, String> mInfo = RDMServicesUtils.getUser(sUser);
	return mInfo.get(FIRST_NAME) + ", " + mInfo.get(LAST_NAME);
    }

    public String getEmail() {
	return sEmail;
    }

    public String getRole() {
	return sRole;
    }

    public StringList getDepartment() {
	return slDept;
    }

    public StringList getGroup() {
	return slGroups;
    }

    public StringList getControllers() {
	return slControllers;
    }

    public String getGender() {
	return cGender;
    }

    public String getAddress() {
	return sAddress;
    }

    public String getContactNo() {
	return sContactNo;
    }

    public String getDateOfBirth() {
	return dDateOfBirth;
    }

    public String getDateOfJoin() {
	return dDateOfJoin;
    }

    public String getTraining() {
	return sTraining;
    }

    public boolean isLoggedIn() {
	return isLoggedIn;
    }

    public boolean isBlocked() {
	return ("Y".equals(sBlocked) ? true : false);
    }

    public String getHomePage() {
	return sHomePage;
    }

    public Locale getLocale() {
	if (sLocale == null || "".equals(sLocale)) {
	    sLocale = "en";
	}

	return new Locale(sLocale);
    }

    public String getQualification() {
	return sQualification;
    }

    public String getDesignation() {
	return sDesignation;
    }

    public int login(String sPwd) throws Exception {
	int iLoggedIn = 1;

	DataQuery query = new DataQuery();
	Map<String, String> mUserInfo = query.isUserExists(sUserId, sPwd);

	if (mUserInfo != null && !mUserInfo.isEmpty()) {
	    isLoggedIn = true;

	    sFirstName = mUserInfo.get(FIRST_NAME);
	    sLastName = mUserInfo.get(LAST_NAME);
	    sRole = mUserInfo.get(ROLE_NAME);
	    sEmail = mUserInfo.get(EMAIL);
	    cGender = mUserInfo.get(GENDER);
	    sAddress = mUserInfo.get(ADDRESS);
	    sContactNo = mUserInfo.get(CONTACT_NO);
	    dDateOfBirth = mUserInfo.get(DATE_OF_BIRTH);
	    dDateOfJoin = mUserInfo.get(DATE_OF_JOIN);
	    sBlocked = mUserInfo.get(BLOCKED);
	    sHomePage = mUserInfo.get(HOME_PAGE);
	    sLocale = mUserInfo.get(LOCALE);
	    sTraining = mUserInfo.get(TRAINING);
	    sQualification = mUserInfo.get(QUALIFICATION);
	    sDesignation = mUserInfo.get(DESIGNATION);

	    String sDept = mUserInfo.get(DEPARTMENT_NAME);
	    if (RDMServicesUtils.isNotNullAndNotEmpty(sDept)) {
		slDept = StringList.split(sDept, "\\|");
	    }

	    String sGroup = mUserInfo.get(GROUP_NAME);
	    if (RDMServicesUtils.isNotNullAndNotEmpty(sGroup)) {
		slGroups = StringList.split(sGroup, "\\|");
	    }

	    if ("Y".equals(sBlocked)) {
		isLoggedIn = false;
		iLoggedIn = -1;
	    } else {
		isLoggedIn = true;
		iLoggedIn = 0;
	    }

	    boolean allCntrls = slGroups.isEmpty() && RDMServicesConstants.ROLE_ADMIN.equals(sRole);
	    MapList mlControllers = query.getRoomsList();
	    for (int i = 0, iSz = mlControllers.size(); i < iSz; i++) {
		Map<String, String> mInfo = mlControllers.get(i);
		String group = mInfo.get(GROUP_NAME);

		if (allCntrls || RDMServicesUtils.isNullOrEmpty(group) || slGroups.contains(group)) {
		    slControllers.add(mInfo.get(ROOM_ID));
		}
	    }
	}

	return iLoggedIn;
    }

    public StringList getSavedGraphs() throws Exception {
	DataQuery query = new DataQuery();
	Map<String, String> mSavedGraphs = query.getUserSavedGraphs(sUserId);

	StringList slGraphs = new StringList();
	Iterator<String> itr = mSavedGraphs.keySet().iterator();
	while (itr.hasNext()) {
	    slGraphs.add(itr.next());
	}

	return slGraphs;
    }

    public Map<String, String> getGraphParams(String sName) throws Exception {
	Map<String, String> mInfo = new HashMap<String, String>();

	DataQuery query = new DataQuery();
	Map<String, String> mSavedGraphs = query.getUserSavedGraphs(sUserId);

	String sInfo = mSavedGraphs.get(sName);
	if (sInfo != null && !"".equals(sInfo)) {
	    int idx = sInfo.indexOf('|');
	    if (idx > -1) {
		String sRoomId = sInfo.substring(0, idx);
		String sParams = sInfo.substring(idx + 1);

		mInfo.put("RM_ID", sRoomId);
		mInfo.put("PARAMS", sParams);
	    }
	}

	return mInfo;
    }

    public boolean saveGraphParams(String name, String room, String[] saParams, boolean isPublic) throws Exception {
	StringBuilder sbParams = new StringBuilder();
	for (int i = 0; i < saParams.length; i++) {
	    if (i > 0) {
		sbParams.append(",");
	    }
	    sbParams.append(saParams[i]);
	}

	DataQuery query = new DataQuery();
	return query.saveGraphParams(sUserId, name, room, sbParams.toString(), isPublic);
    }

    public boolean deleteSavedGraph(String name) throws Exception {
	DataQuery query = new DataQuery();
	return query.deleteSavedGraph(sUserId, name);
    }

    public String getUserAccess(ParamSettings paramSettings) {
	if (RDMServicesConstants.ROLE_HELPER.equals(sRole)) {
	    return paramSettings.getHelperAccess();
	} else if (RDMServicesConstants.ROLE_SUPERVISOR.equals(sRole)) {
	    return paramSettings.getSupervisorAccess();
	} else if (RDMServicesConstants.ROLE_MANAGER.equals(sRole)) {
	    return paramSettings.getManagerAccess();
	} else if (RDMServicesConstants.ROLE_ADMIN.equals(sRole)) {
	    return paramSettings.getAdminAccess();
	}

	return RDMServicesConstants.ACCESS_NONE;
    }

    public boolean changePassword(String password) throws Exception {
	Map<String, String> mUserInfo = new HashMap<String, String>();
	mUserInfo.put(RDMServicesConstants.PASSWORD, password);

	DataQuery query = new DataQuery();
	query.updateUser(sUserId, mUserInfo);

	return true;
    }

    public void setHomePage(String sPage) throws Exception {
	Map<String, String> mUserInfo = new HashMap<String, String>();
	mUserInfo.put(RDMServicesConstants.HOME_PAGE, sPage);

	DataQuery query = new DataQuery();
	query.updateUser(sUserId, mUserInfo);

	this.sHomePage = sPage;
    }

    public boolean hasViewAccess(String sView) throws Exception {
	Map<String, Object> mView = RDMServicesUtils.getUserViews().get(sView);
	if (mView == null) {
	    return true;
	}

	String sHide = (String) mView.get(HIDE_VIEW);
	if ("true".equalsIgnoreCase(sHide)) {
	    return false;
	}

	StringList slRoles = (StringList) mView.get(ROLE_NAME);
	StringList slDepts = (StringList) mView.get(DEPT_NAME);

	boolean fg1 = (slRoles.isEmpty() || slRoles.contains(sRole));
	boolean fg2 = (slDepts.isEmpty() || slDept.isEmpty() || slDepts.contains(slDept));

	return (fg1 && fg2);
    }

    public static boolean logInTime(String sUserId, String sOID, String shiftCode) throws Exception {
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss", Locale.getDefault());
	String sLogIn = sdf.format(new java.util.Date());

	String sDate = sLogIn.substring(0, sLogIn.indexOf(' '));

	DataQuery query = new DataQuery();
	return query.updateTimesheet(sUserId, sOID, sDate, sLogIn, "", shiftCode);
    }

    public static boolean logOutTime(String sUserId, String sOID, String shiftCode) throws Exception {
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss", Locale.getDefault());
	String sLogOut = sdf.format(new java.util.Date());

	DataQuery query = new DataQuery();
	return query.updateTimesheet(sUserId, sOID, "", "", sLogOut, shiftCode);
    }

    public static int getUserTaskCnt(String sUserId) throws Exception {
	DataQuery query = new DataQuery();
	return query.getUserTaskCnt(sUserId);
    }
}
