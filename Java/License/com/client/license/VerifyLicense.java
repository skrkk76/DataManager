package com.client.license;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.NetworkInterface;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Locale;

import javax0.license3j.License;
import javax0.license3j.io.LicenseReader;

public class VerifyLicense {
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());

    public static void main(String[] args) throws Exception {
	System.out.print("License File Path: ");
	BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
	String sLicenseFile = br.readLine().trim();

	if ("".equals(sLicenseFile)) {
	    System.out.print("Please enter License File Path");
	    return;
	}

	boolean isValid = verifyLicense(sLicenseFile);
	System.out.println(isValid ? "Valid license" : "Invalid license");
    }

    private static boolean verifyLicense(String sLicenseFile) throws Exception {
	License license;
	try (LicenseReader reader = new LicenseReader(sLicenseFile)) {
	    license = reader.read();
	} catch (IOException e) {
	    throw new RuntimeException("Error reading license file " + e);
	}

	if (!license.isOK(LicenseKeys.public_key)) {
	    System.out.println("Invalid License");
	    return false;
	}

	String machineId = license.get(LicenseKeys.MACHINE_ID).getString();
	String macAddress = license.get(LicenseKeys.MAC_ADDRESS).getString();
	Date expiryDate = license.get(LicenseKeys.EXPIRY_DATE).getDate();
	int rooms = license.get(LicenseKeys.ROOM_COUNT).getInt();

	System.out.println("Machine Id  : " + machineId);
	System.out.println("MAC Address : " + macAddress);
	System.out.println("Expiry Date : " + sdf.format(expiryDate));
	System.out.println("Room Count  : " + rooms);

	try {
	    Date todayDate = new Date();
	    String OS = System.getProperty("os.name").toLowerCase();
	    String sMachineId = getMachineId(OS);
	    String sMacAddress = getMacAddress(OS);

	    System.out.println("sMachineId  : " + sMachineId);
	    System.out.println("sMacAddress : " + sMacAddress);
	    System.out.println("todayDate   : " + sdf.format(todayDate));

	    return sMachineId.equals(machineId) && sMacAddress.equals(macAddress)
		    && (todayDate.before(expiryDate) || todayDate.equals(expiryDate));
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	}

	return false;
    }

    private static String getMacAddress(String OS) throws IOException {
	String sMacAddress = null;

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
		    sMacAddress = sb.toString();
		}
	    }
	} else if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") >= 0) {
	    Process p = Runtime.getRuntime().exec("ifconfig");
	    BufferedReader in = new BufferedReader(new java.io.InputStreamReader(p.getInputStream()));
	    String line = in.readLine().trim();
	    sMacAddress = line.substring(line.lastIndexOf(" "));
	}

	return sMacAddress;
    }

    private static String getMachineId(String OS) throws IOException, InterruptedException {
	String sMachineId = null;

	if (OS.indexOf("win") >= 0) {
	    ProcessBuilder builder = new ProcessBuilder("powershell.exe", "-Command",
		    "(Get-CimInstance -Class Win32_ComputerSystemProduct).UUID");
	    builder.redirectErrorStream(true);
	    Process process = builder.start();

	    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
	    String line;
	    while ((line = reader.readLine()) != null) {
		String value = line.trim();
		if (!(value.isEmpty() || value.contains("Guid") || value.contains("--"))) {
		    sMachineId = value;
		    break;
		}
	    }

	    process.waitFor();
	} else if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") >= 0) {
	    Process process = Runtime.getRuntime().exec("cat /etc/machine-id");
	    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
	    String line = reader.readLine();
	    sMachineId = line.trim();
	}

	return sMachineId;
    }
}
