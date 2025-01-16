package com.client;

import java.net.ConnectException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;

import org.apache.axis2.client.Options;
import org.apache.axis2.transport.http.HTTPConstants;

import com.client.license.VerifyLicense;
import com.client.util.MapList;
import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;
import com.client.util.StringList;
import com.client.util.User;
import com.resourcedm.www.rdmplanttdb._2009._03._13.ArrayOfItems;
import com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlave;
import com.resourcedm.www.rdmplanttdb._2009._03._13.GetSlaveResponse;
import com.resourcedm.www.rdmplanttdb._2009._03._13.Item;
import com.resourcedm.www.rdmplanttdb._2009._03._13.RDMPlantTDBServicesSoapStub;
import com.resourcedm.www.rdmplanttdb._2009._03._13.SlaveDetail;

public class ServicesSession extends RDMServicesConstants
{
	private User contextUser = null;
	private static HashSet<String> hsActiveControllerTypes = new HashSet<String>();
	private static HashSet<String> hsInactiveControllerTypes = new HashSet<String>();
	private static Map<String, String> mControllers = new HashMap<String, String>();
	private static Map<String, StringList> mActiveControllers = new HashMap<String, StringList>();
	private static Map<String, StringList> mInactiveControllers = new HashMap<String, StringList>();
	
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

	public RDMPlantTDBServicesSoapStub getStub(String controller) throws Exception
	{
		if (checkConnectionIsAlive(controller))
		{
			String IP = getControllerIP(controller);
			String sEndPoint = "http://" + IP + "/cgi-bin/cgi.cgi?WebService";
			RDMPlantTDBServicesSoapStub stub = new RDMPlantTDBServicesSoapStub(sEndPoint);

			Options options = stub._getServiceClient().getOptions();
			options.setProperty(HTTPConstants.CHUNKED, false);
			options.setTimeOutInMilliSeconds(30000);

			return stub;
		}
		else
		{
			throw new ConnectException("Controller " + controller + " connection not available, please check with the Administrator");
		}
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
	
	public String getControllerIP(String sController) throws Exception
	{
		String IP = mControllers.get(sController);
		if(RDMServicesUtils.isNullOrEmpty(IP))
		{
			throw new Exception("Controller "+sController+" does not exists, please add the controller");
		}
		
		return IP;
	}
	
	public Map<String, String> getControllerParameters(String cntrlType) throws Exception
	{
		StringList slControllers = getAllControllers(cntrlType);
		for (int i = 0, iSz = slControllers.size(); i < iSz; i++)
		{
			try
			{
				String sController = slControllers.get(i);
				
				String realTime = RDMServicesUtils.getProperty("rdmservices.controller.realtime");
				boolean isRealTime = !"false".equalsIgnoreCase(realTime);
				if(isRealTime)
				{
					return getParameters(sController);
				}
				else
				{
					String sParam = "";
					String sUnit = "";
					Map<String, String> mCntrlParams = new HashMap<String, String>();
					
					PLCServices client = new PLCServices(this, sController);
					Map<String, String[]> mParams = client.getControllerData(false);

					Iterator<String> itrParams = mParams.keySet().iterator();
					while (itrParams.hasNext())
					{
						sParam = itrParams.next();
						sUnit = (mParams.get(sParam))[1];
						sUnit = ("None".equalsIgnoreCase(sUnit) ? "" : sUnit);
						if (!"".equals(sParam))
						{
							mCntrlParams.put(sParam, sUnit);
						}
					}
					
					if (!RDMServicesUtils.isGeneralController(sController))
					{
						Iterator<String> itr = SET_PARAMS.keySet().iterator();
						while (itr.hasNext())
						{
							sParam = itr.next();
							if (mCntrlParams.containsKey(sParam + " empty") || mCntrlParams.containsKey(sParam + " phase empty"))
							{
								mCntrlParams.put(sParam, SET_PARAMS.get(sParam));
							}
						}
					}
				}
			}
			catch (Exception e)
			{
				// do nothing
			}
		}

		return (new HashMap<String, String>());
	}
	
	private Map<String, String> getParameters(String sController) throws Exception
	{
		Map<String, String> mCntrlParams = new HashMap<String, String>();

		RDMPlantTDBServicesSoapStub stub = getStub(sController);
		if (stub != null)
		{
			GetSlave getSlave = new GetSlave();
			GetSlaveResponse getSlaveResp = stub.getSlave(getSlave);
			SlaveDetail slaveDetail = getSlaveResp.getGetSlaveResult();

			ArrayOfItems items = slaveDetail.getItems();
			Item[] item = items.getItem();
			String sParam = "";
			String sUnit = "";

			for (int i = 0; i < item.length; i++)
			{
				sParam = item[i].getName().trim();
				sUnit = item[i].getUnits().trim();
				sUnit = ("None".equalsIgnoreCase(sUnit) ? "" : sUnit);

				if (!"".equals(sParam))
				{
					mCntrlParams.put(sParam, sUnit);
				}
			}

			if (!RDMServicesUtils.isGeneralController(sController))
			{
				Iterator<String> itr = SET_PARAMS.keySet().iterator();
				while (itr.hasNext())
				{
					sParam = itr.next();
					if (mCntrlParams.containsKey(sParam + " empty") || mCntrlParams.containsKey(sParam + " phase empty"))
					{
						mCntrlParams.put(sParam, SET_PARAMS.get(sParam));
					}
				}
			}
		}

		return mCntrlParams;
	}
}