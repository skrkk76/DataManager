package com.client.license;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax0.license3j.Feature;
import javax0.license3j.License;
import javax0.license3j.crypto.LicenseKeyPair;
import javax0.license3j.io.IOFormat;
import javax0.license3j.io.LicenseWriter;

public class CreateLicense {
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    public static void main(String[] args) throws Exception {
	System.out.print("Computer ID: ");
	BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
	String sUUID = br.readLine().trim();

	System.out.print("License Folder Path: ");
	br = new BufferedReader(new InputStreamReader(System.in));
	String sPath = br.readLine().trim();

	System.out.print("Number of Rooms [0 for no limit, default 10]: ");
	br = new BufferedReader(new InputStreamReader(System.in));
	String sRooms = br.readLine().trim();

	System.out.print("Evaluation License [Y/N, default Y]: ");
	br = new BufferedReader(new InputStreamReader(System.in));
	String sEval = br.readLine().trim();

	if ("".equals(sUUID)) {
	    System.out.print("Please enter Computer ID");
	    return;
	}

	if ("".equals(sPath)) {
	    System.out.print("Please enter License Folder Path");
	    return;
	}

	if ("".equals(sEval)) {
	    sEval = "Y";
	}

	int rooms = 10;
	if (!"".equals(sRooms)) {
	    rooms = Integer.parseInt(sRooms);
	}

	Date expDate = null;
	if ("Y".equalsIgnoreCase(sEval)) {
	    rooms = 2;

	    System.out.print("Specify trial period [no of days, default 60]: ");
	    br = new BufferedReader(new InputStreamReader(System.in));
	    String sNoDays = br.readLine().trim();

	    int iNoDays = 60;
	    if (!"".equals(sNoDays)) {
		iNoDays = Integer.parseInt(sNoDays);
	    }

	    Calendar cal = Calendar.getInstance();
	    cal.add(Calendar.DAY_OF_YEAR, iNoDays);
	    expDate = cal.getTime();
	} else {
	    expDate = sdf.parse("2035-12-31");
	}

	File file = new File(sPath);
	if (file.isDirectory()) {
	    /*
	    LicenseKeyPair keyPair = LicenseKeyPair.Create.from("RSA", 2048);
	    byte[] publicKey = keyPair.getPublic();
	    byte[] privateKey = keyPair.getPrivate();
	    */

	    createLicense(sUUID, expDate, rooms);

	    System.out.println(("Y".equalsIgnoreCase(sEval) ? "Trail " : "") + "License created for " + sRooms
		    + " controllers, will be expired on " + sdf.format(expDate));
	} else {
	    System.out.println("Folder does not exists, enter correct file path");
	}
    }

    private static void createLicense(String UUID, Date expDate, int rooms) throws Exception {
	License created = new License();
	created.add(Feature.Create.stringFeature(LicenseKeys.COMPUTER_UUID, UUID));
	created.add(Feature.Create.dateFeature(LicenseKeys.EXPIRY_DATE, expDate));
	created.add(Feature.Create.intFeature(LicenseKeys.ROOM_COUNT, rooms));

	LicenseKeyPair lkp = LicenseKeyPair.Create.from(LicenseKeys.private_key, LicenseKeys.public_key);
	created.sign(lkp.getPair().getPrivate(), "SHA-512");

	try (LicenseWriter writer = new LicenseWriter(LicenseKeys.LICENSE)) {
	    writer.write(created, IOFormat.BINARY);
	} catch (Exception e) {
	    throw new RuntimeException(e);
	}
    }
}