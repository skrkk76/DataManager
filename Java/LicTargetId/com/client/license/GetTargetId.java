package com.client.license;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.NetworkInterface;
import java.util.Enumeration;

public class GetTargetId {
	public static void main(String[] args) {
		String sTargetId = null;
		try {
			String OS = System.getProperty("os.name").toLowerCase();
			String sMachineId = getMachineId(OS);
			String sMacAddress = getMacAddress(OS);

			sTargetId = sMachineId + "|" + sMacAddress;
		} catch (Exception e) {
			e.printStackTrace(System.out);
		}

		System.out.println("Target Id: " + sTargetId);
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
			Process process = Runtime.getRuntime().exec("ip link");
			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

			boolean b = false;
			String line;
			while ((line = reader.readLine()) != null) {
				String value = line.trim();
				if (value.contains("BROADCAST,MULTICAST,UP,LOWER_UP")) {
					b = true;
				}

				if (b && value.contains("link/ether")) {
					value = value.substring(value.indexOf(" ")).trim();
					sMacAddress = value.substring(0, value.indexOf(" ")).trim();
					break;
				}
			}
		}

		if (sMacAddress != null) {
			sMacAddress = sMacAddress.trim();
		}
		return sMacAddress;
	}

	private static String getMachineId(String OS) throws InterruptedException, IOException {
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
			sMachineId = reader.readLine();
		}

		if (sMachineId != null) {
			sMachineId = sMachineId.trim();
		}
		return sMachineId;
	}
}
