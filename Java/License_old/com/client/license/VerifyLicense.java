package com.client.license;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Locale;

public class VerifyLicense {
	private static final SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy", Locale.getDefault());

	public VerifyLicense() {
		try {
			System.out.print("License File Path: ");
			BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
			String sPath = br.readLine().trim();

			if ("".equals(sPath)) {
				System.out.print("Please enter License File Path");
				return;
			}

			File file = new File(sPath, "LICENSE");
			if (!file.exists()) {
				System.out.print("Please enter License File Path");
				return;
			}

			BufferedReader licenseFile = new BufferedReader(new FileReader(new File(sPath, "LICENSE")));
			String licenseKey = licenseFile.readLine();
			licenseFile.close();

			boolean isValid = verifyLicense(licenseKey);
			System.out.println(isValid ? "Valid License..." : "Invalid License...");

			EncryptDecrypt decrypt = new EncryptDecrypt();
			String decryptedValue = decrypt.decrypt(licenseKey);
			System.out.println("license Key : " + decryptedValue);

		} catch (Exception e) {
			e.printStackTrace(System.out);
		}
	}

	private boolean verifyLicense(String s) throws Exception {
		try {
			EncryptDecrypt decrypt = new EncryptDecrypt();
			String decryptedValue = decrypt.decrypt(s);
			String[] saDecryptValues = decryptedValue.split("\\^");
			if (saDecryptValues.length < 4) {
				return false;
			}

			System.out.println("License MAC Addr : " + saDecryptValues[0]);
			System.out.println("License HostName : " + saDecryptValues[1]);
			System.out.println("License Room Cnt : " + saDecryptValues[2]);
			System.out.println("License Exp Date : " + saDecryptValues[3]);

			String OS = System.getProperty("os.name").toLowerCase();

			InetAddress addr = InetAddress.getLocalHost();
			String sHostName = addr.getHostName();

			Date todayDate = new Date();
			Date expiryDate = sdf.parse(saDecryptValues[3]);

			boolean bFlag = sHostName.equals(saDecryptValues[1])
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

						System.out.println("HostName : " + sHostName);
						System.out.println("Sys Date : " + sdf.format(todayDate));
						System.out.println("MAC Addr : " + sMacAddr);

						if (sMacAddr.equals(saDecryptValues[0]) && bFlag) {
							return true;
						}
					}
				}
			} else if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") >= 0) {
				Process p = Runtime.getRuntime().exec("ifconfig");
				BufferedReader in = new BufferedReader(new java.io.InputStreamReader(p.getInputStream()));
				String line = in.readLine().trim();
				String sMacAddr = line.substring(line.lastIndexOf(" "));

				System.out.println("HostName : " + sHostName);
				System.out.println("Sys Date : " + sdf.format(todayDate));
				System.out.println("MAC Addr : " + sMacAddr);

				if (sMacAddr.equals(saDecryptValues[0]) && bFlag) {
					return true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace(System.out);
			return false;
		}
		return false;
	}
}
