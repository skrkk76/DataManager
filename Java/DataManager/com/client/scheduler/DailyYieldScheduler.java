package com.client.scheduler;

import com.client.license.VerifyLicense;
import com.client.views.Yields;

public class DailyYieldScheduler
{
	public static void main(String[] args) throws Throwable
	{
		try
		{
			boolean licensed = VerifyLicense.verifyLicense();
			if(!licensed)
			{
				throw new Exception("Unlicensed software, please contact the provider for license");
			}
		
			new DailyYieldScheduler();
		}
		finally
		{
			System.exit(0);
		}
	}
	
	public DailyYieldScheduler() throws Throwable
	{
		Yields yields = new Yields();
		yields.updateDailyYield();
	}
}
