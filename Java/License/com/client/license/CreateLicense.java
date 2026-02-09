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
		System.out.print("License File Path: ");
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String sPath = br.readLine().trim();

		System.out.print("Machine Id: ");
		br = new BufferedReader(new InputStreamReader(System.in));
		String machineId = br.readLine().trim();

		System.out.print("MAC Address: ");
		br = new BufferedReader(new InputStreamReader(System.in));
		String macAddress = br.readLine().trim();

		System.out.print("Number of Rooms [0 for no limit, default 10]: ");
		br = new BufferedReader(new InputStreamReader(System.in));
		String sRooms = br.readLine().trim();

		System.out.print("Evaluation License [Y/N, default Y]: ");
		br = new BufferedReader(new InputStreamReader(System.in));
		String sEval = br.readLine().trim();

		if ("".equals(sPath)) {
			System.out.print("Please enter License File Path");
			return;
		}

		if ("".equals(machineId)) {
			System.out.print("Please enter Machine Id");
			return;
		}

		if ("".equals(macAddress)) {
			System.out.print("Please enter MAC Address");
			return;
		}

		if ("".equals(sEval)) {
			sEval = "Y";
		}

		int rooms = 10;
		if (!"".equals(sRooms)) {
			rooms = Integer.parseInt(sRooms);
		}

		Date expiryDate = null;
		if ("Y".equalsIgnoreCase(sEval)) {
			System.out.print("Specify trial period [no of days, default 60]: ");
			br = new BufferedReader(new InputStreamReader(System.in));
			String sNoDays = br.readLine().trim();

			int iNoDays = 60;
			if (!"".equals(sNoDays)) {
				iNoDays = Integer.parseInt(sNoDays);
			}

			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DAY_OF_YEAR, iNoDays);
			expiryDate = cal.getTime();
		} else {
			System.out.print("Specify end date [yyyy-MM-dd]: ");
			br = new BufferedReader(new InputStreamReader(System.in));
			String expDate = br.readLine().trim();
			if ("".equals(expDate)) {
				expDate = "2035-12-31";
			}
			expiryDate = sdf.parse(expDate);
		}

		File file = new File(sPath);
		if (file.isDirectory()) {
			createLicense(machineId, macAddress, expiryDate, rooms, sPath);

			System.out.println(("Y".equalsIgnoreCase(sEval) ? "Trail " : "") + "License created for " + sRooms
					+ " controllers, will be expired on " + sdf.format(expiryDate));
		} else {
			System.out.println("Path does not exists, enter correct file path");
		}
	}

	private static void createLicense(String machineId, String macAddress, Date expiryDate, int rooms, String sPath)
			throws Exception {
		License created = new License();
		created.add(Feature.Create.stringFeature(LicenseKeys.MACHINE_ID, machineId));
		created.add(Feature.Create.stringFeature(LicenseKeys.MAC_ADDRESS, macAddress));
		created.add(Feature.Create.dateFeature(LicenseKeys.EXPIRY_DATE, expiryDate));
		created.add(Feature.Create.intFeature(LicenseKeys.ROOM_COUNT, rooms));

		LicenseKeyPair lkp = LicenseKeyPair.Create.from(LicenseKeys.private_key, LicenseKeys.public_key);
		created.sign(lkp.getPair().getPrivate(), "SHA-512");

		try (LicenseWriter writer = new LicenseWriter(new File(sPath, LicenseKeys.LICENSE))) {
			writer.write(created, IOFormat.BINARY);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	private static void createKeys() throws Exception {
		LicenseKeyPair keyPair = LicenseKeyPair.Create.from("RSA", 2048);

		System.out.println("byte[] public_key = {");
		dump(keyPair.getPublic());
		System.out.println("};");
		System.out.println("");

		System.out.println("byte[] private_key = {");
		dump(keyPair.getPrivate());
		System.out.println("};");
	}

	private static void dump(final byte[] bytes) {
		for (int i = 0; i < bytes.length; i++) {
			System.out.printf("(byte)0x%02X, ", bytes[i]);
			if (i % 8 == 0) {
				System.out.println();
			}
		}
	}
}