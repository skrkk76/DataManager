package com.client.license;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class GetComputerID {
    public static void main(String[] args) {
	new GetComputerID().getSystemUUID();
    }

    private GetComputerID() {

    }

    private void getSystemUUID() {
	String uuid = null;
	try {
	    String OS = System.getProperty("os.name").toLowerCase();
	    if (OS.indexOf("win") >= 0) {
		uuid = getWinUUID();
	    } else if (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") >= 0) {
		uuid = getLinuxUUID();
	    } else if (OS.indexOf("mac") >= 0) {
		uuid = getMacUUID();
	    }
	} catch (IOException e) {
	    throw new RuntimeException("Error reading Computer Id " + e);
	}

	System.out.println("Computer Id: " + uuid);
    }

    public String getWinUUID() throws IOException {
	Process process = Runtime.getRuntime().exec("wmic csproduct get UUID");
	BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
	String line;
	while ((line = reader.readLine()) != null) {
	    if (!line.contains("UUID") && !line.trim().isEmpty()) {
		return line.trim();
	    }
	}

	throw new IOException("Error reading UUID");
    }

    public String getLinuxUUID() throws IOException {
	Process process = Runtime.getRuntime().exec("cat /sys/class/dmi/id/product_uuid");
	BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
	return reader.readLine();
    }

    public String getMacUUID() throws IOException {
	String[] cmd = { "/bin/sh", "-c", "system_profiler SPHardwareDataType | awk '/UUID/ { print $3; }'" };
	Process process = Runtime.getRuntime().exec(cmd);
	BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
	return reader.readLine();
    }
}
