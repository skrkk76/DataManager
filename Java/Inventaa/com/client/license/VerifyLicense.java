package com.client.license;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import com.client.util.RDMServicesConstants;
import com.client.util.RDMServicesUtils;

import javax0.license3j.License;
import javax0.license3j.io.LicenseReader;

public class VerifyLicense extends RDMServicesConstants {
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());

    public static boolean verifyLicense() throws Exception {
	try {
	    License license;
	    try (LicenseReader reader = new LicenseReader(RDMServicesUtils.getLicenseFile())) {
		license = reader.read();
	    } catch (IOException e) {
		throw new RuntimeException("Error reading license file " + e);
	    }

	    if (!license.isOK(public_key)) {
		return false;
	    }

	    String computerUUId = license.get(COMPUTER_UUID).getString();
	    Date expiryDate = license.get(EXPIRY_DATE).getDate();

	    Date todayDate = new Date();
	    String systemId = GetComputerID.getSystemUUID();

	    return systemId.equals(computerUUId) && (todayDate.before(expiryDate) || todayDate.equals(expiryDate));
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	}

	return false;
    }

    public static int getLicenseRoomCount() throws Exception {
	License license;
	try (LicenseReader reader = new LicenseReader(RDMServicesUtils.getLicenseFile())) {
	    license = reader.read();
	} catch (IOException e) {
	    throw new RuntimeException("Error reading license file " + e);
	}

	if (!license.isOK(public_key)) {
	    throw new RuntimeException("Invalid License");
	}

	return license.get(ROOM_COUNT).getInt();
    }

    public static String verifyLicenseExpiry() throws Exception {
	License license;
	try (LicenseReader reader = new LicenseReader(RDMServicesUtils.getLicenseFile())) {
	    license = reader.read();
	} catch (IOException e) {
	    throw new RuntimeException("Error reading license file " + e);
	}

	if (!license.isOK(public_key)) {
	    throw new RuntimeException("Invalid License");
	}

	Date todayDate = new Date();
	Date expiryDate = license.get(EXPIRY_DATE).getDate();

	if (todayDate.before(expiryDate)) {
	    long diff = expiryDate.getTime() - todayDate.getTime();
	    long diffDays = diff / (24 * 60 * 60 * 1000);

	    if (diffDays <= 15) {
		return sdf.format(expiryDate);
	    }
	}

	return "";
    }
}
