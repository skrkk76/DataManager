package com.client.license;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.NetworkInterface;

public class CreateLicense {
    public CreateLicense() throws Exception {
	System.out.print("License File Path: ");
	BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
	String sPath = br.readLine().trim();

	File file = new File(sPath);
	if (file.isDirectory()) {
	    StringBuilder sb = new StringBuilder();

	    InetAddress addr = InetAddress.getLocalHost();
	    String hostName = addr.getHostName();

	    String OS = System.getProperty("os.name").toLowerCase();
	    if (OS.indexOf("win") >= 0) {
		NetworkInterface network = NetworkInterface.getByInetAddress(addr);
		byte[] mac = network.getHardwareAddress();

		StringBuilder sbMac = new StringBuilder();
		for (int i = 0; i < mac.length; i++) {
		    sbMac.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "-" : ""));
		}

		String macAddr = sbMac.toString();
		sb.append(macAddr).append("^").append(hostName);
	    } else if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") >= 0) {
		Process p = Runtime.getRuntime().exec("ifconfig");
		BufferedReader in = new BufferedReader(new java.io.InputStreamReader(p.getInputStream()));
		String line = in.readLine().trim();

		String macAddr = line.substring(line.lastIndexOf(" "));
		sb.append(macAddr).append("^").append(hostName);
	    }

	    sb.append("^").append("10").append("^").append("12/31/2035");
	    String sLicenseString = sb.toString();

	    EncryptDecrypt encrypt = new EncryptDecrypt();
	    String sEncryptLicense = encrypt.encrypt(sLicenseString);
	    writeToFile(sEncryptLicense, sPath);

	    System.out.println("Product license created successfully");
	} else {
	    System.out.println("Folder does not exists, enter correct file path");
	}
    }

    private static void writeToFile(String sLicense, String file) {
	BufferedWriter bw = null;
	FileWriter fw = null;

	try {
	    fw = new FileWriter(new File(file, "LICENSE"));
	    bw = new BufferedWriter(fw);
	    bw.write(sLicense);
	} catch (IOException e) {
	    e.printStackTrace();
	} finally {
	    try {
		if (bw != null) {
		    bw.close();
		}
		if (fw != null) {
		    fw.close();
		}
	    } catch (IOException ex) {
		ex.printStackTrace();
	    }
	}
    }
}
