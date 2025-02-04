package com.client.license;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class CreateLicense 
{
	public static void main(String [] args) throws Exception 
	{
		System.out.print("License File Path: ");
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String sPath = br.readLine().trim();
		
		System.out.print("Number of Rooms [0 for no limit, default 10]: ");
		br = new BufferedReader(new InputStreamReader(System.in));
		String sRooms = br.readLine().trim();
		
		System.out.print("Evaluation License [Y/N, default Y]: ");
		br = new BufferedReader(new InputStreamReader(System.in));
		String sEval = br.readLine().trim();
		
		if("".equals(sPath))
		{
			System.out.print("Please enter License File Path");
			return;
		}
		
		if("".equals(sEval))
		{
			sEval = "Y";
		}
		
		if("".equals(sRooms))
		{
			sRooms = "10";
		}
		
		sRooms = ("Y".equalsIgnoreCase(sEval) ? "5" : sRooms);
		
		int iNoDays = 60;
		if("Y".equalsIgnoreCase(sEval))
		{
			System.out.print("Specify trial period [no of days, default 90]: ");
			br = new BufferedReader(new InputStreamReader(System.in));
			String sNoDays = br.readLine().trim();
			if(!"".equals(sNoDays))
			{
				iNoDays = Integer.parseInt(sNoDays);
			}
		}
		
		File file = new File(sPath);
		if(file.isDirectory())
		{
			StringBuilder sb = new StringBuilder();
			InetAddress addr = InetAddress.getLocalHost();
			
			String OS = System.getProperty("os.name").toLowerCase();
			if (OS.indexOf("win") >= 0)
			{
				NetworkInterface network = NetworkInterface.getByInetAddress(addr);
				byte[] mac = network.getHardwareAddress();
				
				sb.append(addr.getHostName()).append("~");
				for (int i = 0; i < mac.length; i++)
				{
					sb.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "-" : ""));		
				}
			}
			else if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") >= 0)
			{
				Process p = Runtime.getRuntime().exec("ifconfig");
				BufferedReader in = new BufferedReader(new java.io.InputStreamReader(p.getInputStream())); 
				String line = in.readLine().trim();
				
				String macAddr = line.substring(line.lastIndexOf(" "));
				sb.append(addr.getHostName()).append("~").append(macAddr);
			}

			String sDate = "";
			if("Y".equalsIgnoreCase(sEval))
			{
				SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy", Locale.ENGLISH);
				
				Calendar cal = Calendar.getInstance();
				cal.add(Calendar.DAY_OF_YEAR, iNoDays);
				
				Date dt = cal.getTime();
				sDate = sdf.format(dt);
			}
			else
			{
				sDate = "12/31/2030";
			}
			
			sb.append("~").append(sDate).append("~").append(sRooms);
			String sLicenseString = sb.toString();
			
			EncryptDecrypt encrypt = new EncryptDecrypt();
			String sEncryptLicense = encrypt.encrypt(sLicenseString);
			writeToFile(sEncryptLicense, sPath);
			
			if("Y".equalsIgnoreCase(sEval))
			{
				System.out.println("Trail license created for "+sRooms+" controllers, will be expired on "+sDate);
			}
			else
			{
				System.out.println("Product license created for "+sRooms+" controllers");
			}
		}
		else
		{
			System.out.println("Folder does not exists, enter correct file path");
		}
	}
	
	private static void writeToFile(String sLicense, String file)
	{
		BufferedWriter bw = null;
		FileWriter fw = null;

		try 
		{
			fw = new FileWriter(new File(file, "LICENSE"));
			bw = new BufferedWriter(fw);
			bw.write(sLicense);
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		} 
		finally 
		{
			try 
			{
				if (bw != null)
				{
					bw.close();
				}
				if (fw != null)
				{
					fw.close();
				}
			} 
			catch (IOException ex) 
			{
				ex.printStackTrace();
			}
		}
	}
}
