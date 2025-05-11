package com.client.license;

import java.io.BufferedReader;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Locale;

import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;

public class VerifyLicense extends RDMServicesConstants {
    private static final SimpleDateFormat sdf1 = new SimpleDateFormat("MM/dd/yyyy", Locale.getDefault());
    private static final SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());

    public static boolean verifyLicense(String s) throws Exception {
	try {
	    EncryptDecrypt decrypt = new EncryptDecrypt();
	    String decryptedValue = decrypt.decrypt(s);
	    String[] saDecryptValues = decryptedValue.split("~");
	    if (saDecryptValues.length < 4) {
		return false;
	    }

	    String OS = System.getProperty("os.name").toLowerCase();

	    InetAddress addr = InetAddress.getLocalHost();
	    String sHostName = addr.getHostName();

	    Date todayDate = new Date();
	    Date expiryDate = sdf1.parse(saDecryptValues[2]);

	    boolean bFlag = sHostName.equals(saDecryptValues[0])
		    && (todayDate.before(expiryDate) || todayDate.equals(expiryDate));

	    if (OS.indexOf("win") >= 0) {
		Enumeration<NetworkInterface> networks = NetworkInterface.getNetworkInterfaces();
		while (networks.hasMoreElements()) {
		    NetworkInterface network = networks.nextElement();
		    byte[] mac = network.getHardwareAddress();

		    if (mac != null) {
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < mac.length; i++) {
			    sb.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "-" : ""));
			}

			String sMacAddr = sb.toString();
			if (sMacAddr.equals(saDecryptValues[1]) && bFlag) {
			    return true;
			}
		    }
		}
	    } else if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") >= 0) {
		Process p = Runtime.getRuntime().exec("ifconfig");
		BufferedReader in = new BufferedReader(new java.io.InputStreamReader(p.getInputStream()));
		String line = in.readLine().trim();

		String sMacAddr = line.substring(line.lastIndexOf(" "));
		if (sMacAddr.equals(saDecryptValues[1]) && bFlag) {
		    return true;
		}
	    }
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	    return false;
	}

	return false;
    }

    public static int getLicenseRoomCount(String s) throws Exception {
	EncryptDecrypt decrypt = new EncryptDecrypt();
	String decryptedValue = decrypt.decrypt(s);
	String[] saDecryptValues = decryptedValue.split("~");

	int iCnt = 10;
	if (saDecryptValues.length == 4) {
	    try {
		iCnt = Integer.parseInt(saDecryptValues[3]);
	    } catch (NumberFormatException e) {
		iCnt = 10;
	    }
	}

	return iCnt;
    }

    public static String verifyLicenseExpiry(String s) throws Exception {
	EncryptDecrypt decrypt = new EncryptDecrypt();
	String decryptedValue = decrypt.decrypt(s);
	String[] saDecryptValues = decryptedValue.split("~");

	if (saDecryptValues.length == 4) {
	    Date todayDate = new Date();
	    Date expiryDate = sdf1.parse(saDecryptValues[2]);

	    if (todayDate.before(expiryDate)) {
		long diff = expiryDate.getTime() - todayDate.getTime();
		long diffDays = diff / (24 * 60 * 60 * 1000);

		if (diffDays <= 15) {
		    return sdf2.format(expiryDate);
		}
	    }
	}

	return "";
    }
}
