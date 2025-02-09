package com.client.scheduler;

import java.util.ArrayList;
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
import com.client.util.RDMServicesConstants;
import com.client.util.StringList;

public class SysLogScheduler
{
	private Calendar cal = null;
	
	public static void main(String[] args) throws Throwable
	{
		try
		{
			boolean licensed = VerifyLicense.verifyLicense();
			if(!licensed)
			{
				throw new Exception("Unlicensed software, please contact the provider for license");
			}
			
			int i = 0;
			if(args.length == 1)
			{
				try
				{
					i = Integer.parseInt(args[0]);
					i = 0 - i;
				}
				catch(Exception e)
				{
					i = -30;
				}
			}
			
			new SysLogScheduler(i);
		}
		catch(Exception e)
		{
			throw new Exception(e.getLocalizedMessage());
		}
		finally
		{
			System.exit(0);
		}
	}
	
	public SysLogScheduler(int i) throws Throwable
	{
		if(i < 0)
		{
			cal = Calendar.getInstance();
			cal.add(Calendar.MINUTE, i);
			cal.add(Calendar.SECOND, (0 - cal.get(Calendar.SECOND)));
		}
		
		Map<String, ArrayList<String[]>> mControllerLogs = this.getControllerSysLog();
		this.saveLogs(mControllerLogs);
		this.deleteDuplicateLogs();
	}
	
	private Map<String, ArrayList<String[]>> getControllerSysLog() throws Throwable
	{
		Date toTime = ((cal == null) ? null : cal.getTime());
		String sController = "";
		ArrayList<String[]> alSysLog = null;
		PLCServices client = null;
		Map<String, ArrayList<String[]>> mControllerLog = new HashMap<String, ArrayList<String[]>>();
		
		ServicesSession session = new ServicesSession();
		StringList slControllers = session.getAllControllers();
		
		DataQuery query = new DataQuery();
		if(!query.checkAllowedRooms())
		{
			throw new Exception("Max number of Licensed Rooms has exceeded. Please contact the admin at L-Pit for licenses to create more Rooms.");
		}

		for(int i=0; i<slControllers.size(); i++)
		{
			try
			{
				sController = slControllers.get(i);
				String sCntrlVersion = session.getControllerVersion(sController);
				if(RDMServicesConstants.CNTRL_VERSION_OLD.equals(sCntrlVersion))
				{
					client = new PLCServices_oldHW(session, sController);
				}
				else if(RDMServicesConstants.CNTRL_VERSION_NEW.equals(sCntrlVersion))
				{
					client = new PLCServices_newHW(session, sController);
				}
				alSysLog = client.getSysLog(toTime);
				mControllerLog.put(sController, alSysLog);
			}
			catch(Exception e)
			{
				System.out.println(sController + " [getControllerSysLog] : " + e.getLocalizedMessage());
				e.printStackTrace(System.out);
			}
		}
		
		return mControllerLog;
	}
	
	private void saveLogs(Map<String, ArrayList<String[]>> mControllerLog) throws Exception
	{
		String sController = "";
		ArrayList<String[]> alSysLog;
		DataQuery query = new DataQuery();
		
		Iterator<String> itr = mControllerLog.keySet().iterator();
		while(itr.hasNext())
		{
			try
			{
				sController = itr.next();
				alSysLog = mControllerLog.get(sController);
				
				query.saveSysLogs("SYSTEM", sController, alSysLog);
			}
			catch(Exception e)
			{
				System.out.println(sController + " [saveLogs] : " + e.getLocalizedMessage());
				e.printStackTrace(System.out);
			}
		}
	}
	
	private void deleteDuplicateLogs() throws Exception
	{
		DataQuery query = new DataQuery();
		query.deleteDuplicateSysLogs();
	}
}
