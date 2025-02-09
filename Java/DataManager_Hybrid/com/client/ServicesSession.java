package com.client;

import java.net.ConnectException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

import com.client.license.VerifyLicense;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;
import com.client.util.StringList;
import com.client.util.User;

public class ServicesSession extends RDMServicesConstants
{
	private User contextUser = null;
	private static HashSet<String> hsActiveControllerTypes = new HashSet<String>();
	private static HashSet<String> hsInactiveControllerTypes = new HashSet<String>();
	private static Map<String, String> mControllers = new HashMap<String, String>();
	private static Map<String, StringList> mActiveControllers = new HashMap<String, StringList>();
	private static Map<String, StringList> mInactiveControllers = new HashMap<String, StringList>();
	private static Map<String, String> mControllerVersion = new HashMap<String, String>();
	
	public ServicesSession() throws Exception
	{
		boolean bIsLicensed = VerifyLicense.verifyLicense();
		if(!bIsLicensed)
		{
			throw new Exception("Trial license has expired or license in invalid. Please contact the admin at L-Pit for license.");
		}
		
		setControllers(false);
	}
	
	public void setContextUser(User u)
	{
		contextUser = u;
	}
	
	public User getContextUser()
	{
		return contextUser;
	}
	
	public void setControllers(boolean flag) throws Exception
	{
		if(flag)
		{
			mControllers.clear();
			mActiveControllers.clear();
			mInactiveControllers.clear();
			hsActiveControllerTypes.clear();
			hsInactiveControllerTypes.clear();
			mControllerVersion.clear();
		}
		
		if(mControllers.isEmpty() || mControllers.size() == 0)
		{
			MapList mlControllers = RDMServicesUtils.getRoomsList();			
			if(mlControllers.size() > 0)
			{
				String cntrlType = null;
				String controller = null;
		    	Map<String, String> mInfo = null;
		    	
		    	for(int i=0, iSz=mlControllers.size(); i<iSz; i++)
		    	{
		    		mInfo = mlControllers.get(i);
		    		controller = mInfo.get(ROOM_ID);
		    		cntrlType = mInfo.get(CNTRL_TYPE);
		    		mControllers.put(controller, mInfo.get(ROOM_IP));
		    		mControllerVersion.put(controller, mInfo.get(CNTRL_VERSION));
		    		
		    		StringList slControllers = (ACTIVE.equals(mInfo.get(ROOM_STATUS)) ? 
		    			mActiveControllers.get(cntrlType) : mInactiveControllers.get(cntrlType));
		    		
    				if(slControllers == null)
					{
    					slControllers = new StringList();
					}
	    			slControllers.add(controller);
	    			slControllers = RDMServicesUtils.sort(slControllers);
	    			
	    			if(ACTIVE.equals(mInfo.get(ROOM_STATUS)))
	    			{
	    				hsActiveControllerTypes.add(cntrlType);
		    			mActiveControllers.put(cntrlType, slControllers);
	    			}
		    		else
	    			{
		    			hsInactiveControllerTypes.add(cntrlType);
		    			mInactiveControllers.put(cntrlType, slControllers);
	    			}
		    	}
			}
		}
	}
	
	public boolean checkConnectionIsAlive(String controller) throws ConnectException
	{
		String IP = mControllers.get(controller);
		if(RDMServicesUtils.isNullOrEmpty(IP))
		{
			throw new ConnectException("Controller "+controller+" does not exists, please add the controller");
		}
		
		return RDMServicesUtils.checkConnectionIsAlive(IP);
	}
	
	public StringList getAllControllers()
	{
		return getAllControllers("");
	}
	
	public StringList getAllControllers(String cntrlType)
	{
		StringList slControllers = new StringList();
		boolean bAll = "".equals(cntrlType);

		for(String type : hsActiveControllerTypes)
		{
			if(bAll || type.equals(cntrlType))
			{
				slControllers.addAll(mActiveControllers.get(type));
			}
		}

		slControllers = RDMServicesUtils.sort(slControllers);
		return slControllers;
	}

	public StringList getControllers(User u) throws Exception
	{
		StringList slControllers = new StringList();
		if(u.hasViewAccess(ROOMS_VIEW_DASHBOARD_GROWER))
		{
			slControllers.addAll(getControllers(TYPE_GENERAL_GROWER));
			slControllers.addAll(getControllers(TYPE_GROWER));
		}
		if(u.hasViewAccess(ROOMS_VIEW_DASHBOARD_BUNKER))
		{
			slControllers.addAll(getControllers(TYPE_GENERAL_BUNKER));
			slControllers.addAll(getControllers(TYPE_BUNKER));
		}
		if(u.hasViewAccess(ROOMS_VIEW_DASHBOARD_TUNNEL))
		{
			slControllers.addAll(getControllers(TYPE_GENERAL_TUNNEL));
			slControllers.addAll(getControllers(TYPE_TUNNEL));
		}

		slControllers = RDMServicesUtils.sort(slControllers);
		return slControllers;
	}
	
	public StringList getControllers()
	{
		StringList slControllers = new StringList();
		for(String cntrlType : hsActiveControllerTypes)
		{
			slControllers.addAll(getControllers(cntrlType));
		}
		
		slControllers = RDMServicesUtils.sort(slControllers);
		return slControllers;
	}
	
	public StringList getControllers(String cntrlType)
	{
		StringList controllers = new StringList();
		StringList slControllers = mActiveControllers.get(cntrlType);
		if(slControllers != null)
		{
			StringList userControllers = contextUser.getControllers();
			for(int i=0; i<slControllers.size(); i++)
			{
				String controller = slControllers.get(i);
				if(userControllers.contains(controller))
				{
					controllers.add(controller);
				}
			}
			controllers = RDMServicesUtils.sort(controllers);
		}
		
		return controllers;
	}
	
	public StringList getAllInactiveControllers()
	{
		StringList slControllers = new StringList();
		for(String type : hsInactiveControllerTypes)
		{
			slControllers.addAll(mInactiveControllers.get(type));
		}

		slControllers = RDMServicesUtils.sort(slControllers);
		return slControllers;
	}
	
	public StringList getInactiveControllers()
	{
		StringList slControllers = new StringList();
		for(String cntrlType : hsInactiveControllerTypes)
		{
			slControllers.addAll(getInactiveControllers(cntrlType));
		}
		
		slControllers = RDMServicesUtils.sort(slControllers);
		return slControllers;
	}
	
	public StringList getInactiveControllers(String cntrlType)
	{
		StringList controllers = new StringList();
		StringList slControllers = mInactiveControllers.get(cntrlType);
		if(slControllers != null)
		{
			StringList userControllers = contextUser.getControllers();
			for(int i=0; i<slControllers.size(); i++)
			{
				String controller = slControllers.get(i);
				if(userControllers.contains(controller))
				{
					controllers.add(controller);
				}
			}
			controllers = RDMServicesUtils.sort(controllers);
		}
		
		return controllers;
	}
	
	public StringList getControllers(int idx, int iRange, String cntrlType)
	{
		StringList slCntrls = new StringList();
		slCntrls.addAll(getControllers(cntrlType));
		
		int start = (idx * iRange);
		int end = start + iRange;
		end = (end > slCntrls.size() ? slCntrls.size() : end);
		
		StringList sl = new StringList();
		for(int i=start; i<end; i++)
		{
			sl.add(slCntrls.get(i));
		}
		
		return sl;
	}
	
	public StringList getControllersSelection(String cntrlType, int iRange)
	{
		StringList sl = new StringList();
		
		StringList slCntrls = new StringList();
		slCntrls.addAll(getControllers(cntrlType));
		
		int iSz = slCntrls.size();
		int iCnt = ((iSz%iRange > 0) ? ((iSz/iRange)*iRange)+iRange : (iSz/iRange)*iRange);
		iCnt = (iCnt / iRange);
		
		int start = 0;
		int end = 0;
		for(int i=0; i<iCnt; i++)
		{
			start = (i * iRange);
			end = start + (iRange - 1);
			end = ((end >= slCntrls.size()) ? (slCntrls.size() - 1) : end);
			
			sl.add(slCntrls.get(start)+" - "+slCntrls.get(end));
		}

		return sl;
	}
	
	public StringList getControllers(int idx, int iRange, StringList slCntrls)
	{
		int start = (idx * iRange);
		int end = start + iRange;
		end = (end > slCntrls.size() ? slCntrls.size() : end);
		
		StringList sl = new StringList();
		for(int i=start; i<end; i++)
		{
			sl.add(slCntrls.get(i));
		}
		
		return sl;
	}
	
	public StringList getControllersSelection(StringList slCntrls, int iRange)
	{
		StringList sl = new StringList();
		
		int iSz = slCntrls.size();
		int iCnt = ((iSz%iRange > 0) ? ((iSz/iRange)*iRange)+iRange : (iSz/iRange)*iRange);
		iCnt = (iCnt / iRange);
		
		int start = 0;
		int end = 0;
		for(int i=0; i<iCnt; i++)
		{
			start = (i * iRange);
			end = start + (iRange - 1);
			end = ((end >= slCntrls.size()) ? (slCntrls.size() - 1) : end);
			
			sl.add(slCntrls.get(start)+" - "+slCntrls.get(end));
		}

		return sl;
	}
	
	public Map<String, String> getControllerParameters(String cntrlType) throws Exception
	{
		boolean bOld = true;
		boolean bNew = true;
		Map<String, String> mOldCntrlParams = null;
		Map<String, String> mNewCntrlParams = null;
		
		StringList slControllers = mActiveControllers.get(cntrlType);
		for (int i = 0, iSz = slControllers.size(); i < iSz; i++)
		{
			try
			{
				String controller = slControllers.get(i);
				String sCntrlVersion = getControllerVersion(controller);
				
				PLCServices client = null;
				if(bOld && RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion))
				{
					client = new PLCServices_oldHW(this, controller);
					mOldCntrlParams = client.getControllerParameters(cntrlType);
					bOld = false;
				}
				else if(bNew && RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion))
				{
					client = new PLCServices_newHW(this, controller);
					mNewCntrlParams = client.getControllerParameters(cntrlType);
					bNew = false;
				}
				
			}
			catch(Exception e)
			{
				// do nothing
			}
		}
		
		Map<String, String> mCntrlParams = new HashMap<String, String>();
		if(mOldCntrlParams != null)
		{
			mCntrlParams.putAll(mOldCntrlParams);
		}
		if(mNewCntrlParams != null)
		{
			mCntrlParams.putAll(mNewCntrlParams);
		}
		
		return mCntrlParams;
	}
	
	public String getControllerIP(String sController) throws Exception
	{
		String IP = mControllers.get(sController);
		if(RDMServicesUtils.isNullOrEmpty(IP))
		{
			throw new Exception("Controller "+sController+" does not exists, please add the controller");
		}
		
		return IP;
	}
	
	public String getControllerVersion(String sController) throws Exception
	{
		String version = mControllerVersion.get(sController);
		if(RDMServicesUtils.isNullOrEmpty(version))
		{
			version = CNTRL_VERSION_OLD;
		}
		
		return version;
	}
}