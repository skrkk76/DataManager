package com.client.license;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Date;
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

	verifyLicense(sLicenseFile);
    }

    private static void verifyLicense(String sLicenseFile) throws Exception {
	License license;
	try (LicenseReader reader = new LicenseReader(sLicenseFile)) {
	    license = reader.read();
	} catch (IOException e) {
	    throw new RuntimeException("Error reading license file " + e);
	}

	if (!license.isOK(LicenseKeys.public_key)) {
	    System.out.println("Invalid License");
	    return;
	}

	String UUID = license.get(LicenseKeys.COMPUTER_UUID).getString();
	Date expDate = license.get(LicenseKeys.EXPIRY_DATE).getDate();
	int rooms = license.get(LicenseKeys.ROOM_COUNT).getInt();

	System.out.println("Computer Id : " + UUID);
	System.out.println("Expiry Date : " + sdf.format(expDate));
	System.out.println("Room Count  : " + rooms);
    }
}
