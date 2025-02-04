package com.client.license;

public class TestLicense {
	public static void main(String[] args) {
		try {
			String text = "RaviSadineni~2C-DB-07-2D-37-1E~12/31/2030~0";

			EncryptDecrypt endecrypt = new EncryptDecrypt();
			String encrypt = endecrypt.encrypt(text);
			System.out.println("encrypt3 : " + encrypt);

			String decrypt = endecrypt.decrypt(encrypt);
			System.out.println("decrypt3 : " + decrypt);

			System.out.println("Valid License : " + VerifyLicense.verifyLicense(encrypt));
			
			System.out.println("Room Count : " + VerifyLicense.getLicenseRoomCount(encrypt));
			
			System.out.println("Expiry Date : " + VerifyLicense.verifyLicenseExpiry(encrypt));
		} catch (Exception e) {
			e.printStackTrace(System.out);
		}
	}
}
