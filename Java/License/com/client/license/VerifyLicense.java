package com.client.license;

import java.io.BufferedReader;
import java.io.File;
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
		String sPath = br.readLine().trim();

		if ("".equals(sPath)) {
			System.out.print("Please enter License File Path");
			return;
		}

		boolean isValid = verifyLicense(sPath);
		System.out.println(isValid ? "Valid license" : "Invalid license");
	}

	private static boolean verifyLicense(String sPath) throws Exception {
		boolean isLicValid = false;
		try {
			License license;
			try (LicenseReader reader = new LicenseReader(new File(sPath, LicenseKeys.LICENSE))) {
				license = reader.read();
			} catch (IOException e) {
				throw new RuntimeException("Error reading license file " + e);
			}

			byte[] public_key = LicenseKeys.public_key;
			// dump(public_key);

			if (!license.isOK(public_key)) {
				System.out.println("Invalid License");
				return false;
			}

			String machineId = license.get(LicenseKeys.MACHINE_ID).getString();
			String macAddress = license.get(LicenseKeys.MAC_ADDRESS).getString();
			Date expiryDate = license.get(LicenseKeys.EXPIRY_DATE).getDate();
			int rooms = license.get(LicenseKeys.ROOM_COUNT).getInt();

			System.out.println("License Details....");
			System.out.println("Machine Id  : " + machineId);
			System.out.println("MAC Address : " + macAddress);
			System.out.println("Expiry Date : " + sdf.format(expiryDate));
			System.out.println("Room Count  : " + rooms);
			System.out.println("");

			Date todayDate = new Date();
			String[] systemInfo = LicenseServer.getSystemInfo();
			String sMachineId = systemInfo[0];
			String sMacAddress = systemInfo[1];

			System.out.println("Machine Details....");
			System.out.println("sMachineId  : " + sMachineId);
			System.out.println("sMacAddress : " + sMacAddress);
			System.out.println("todayDate   : " + sdf.format(todayDate));
			System.out.println("");

			isLicValid = sMachineId.equals(machineId) && sMacAddress.contains(macAddress)
					&& (todayDate.before(expiryDate) || todayDate.equals(expiryDate));
		} catch (Exception e) {
			e.printStackTrace(System.out);
		}

		return isLicValid;
	}

	private static void dump(byte[] bytes) {
		System.out.println("byte[] public_key = {");
		for (int i = 0; i < bytes.length; i++) {
			System.out.printf("(byte)0x%02X, ", bytes[i]);
			if (i % 8 == 0) {
				System.out.println();
			}
		}
		System.out.println("};");
	}
}
