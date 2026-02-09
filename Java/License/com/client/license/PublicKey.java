package com.client.license;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.commons.codec.binary.Base64;

public class PublicKey {
	public static void main(String[] args) throws Exception {
		System.out.print("PublicKey File Path: ");
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String sPubKeyPath = br.readLine().trim();

		System.out.print("Action(Create[1] or Verify[2]): ");
		br = new BufferedReader(new InputStreamReader(System.in));
		String action = br.readLine().trim();

		if ("".equals(sPubKeyPath)) {
			System.out.print("Please enter PublicKey File Path");
			return;
		}

		if ("".equals(action)) {
			System.out.print("Please specify Create[1] or Verify[2]");
			return;
		}

		if ("1".equals(action) || "Create".equalsIgnoreCase(action)) {
			createKey(sPubKeyPath);
		} else if ("2".equals(action) || "Verify".equalsIgnoreCase(action)) {
			verifyKey(sPubKeyPath);
		}
	}

	private static void createKey(String sPubKeyFile) throws Exception {
		byte[] bytes = EncryptDecrypt.encrypt(LicenseKeys.public_key, LicenseKeys.ALGORITHM_DES);
		String encPubKey = new String(Base64.encodeBase64(bytes));

		File file = new File(sPubKeyFile, LicenseKeys.PUBLIC_KEY);
		try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
			writer.write(encPubKey);
			System.out.println("PublicKey.dat created without errors");
		} catch (IOException e) {
			System.err.println("Error writing to the file: " + e.getMessage());
		}
	}

	private static void verifyKey(String sPubKeyFile) throws Exception {
		File file = new File(sPubKeyFile, LicenseKeys.PUBLIC_KEY);
		try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
			String encPubKey = reader.readLine();
			byte[] b = EncryptDecrypt.decrypt(encPubKey.getBytes(), LicenseKeys.ALGORITHM_DES);

			System.out.println("byte[] public_key = {");
			for (int i = 0; i < b.length; i++) {
				System.out.printf("(byte)0x%02X, ", b[i]);
				if (i % 8 == 0) {
					System.out.println();
				}
			}
			System.out.println("};");
		} catch (Exception e) {
			System.err.println("Error reading the file: " + e.getMessage());
		}
	}
}
