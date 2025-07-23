package com.client.license;

public class TestLicense {
    public static void main(String[] args) {
	try {
	    String text = "RaviSadineni~2C-DB-07-2D-37-1E~12/31/2030~0";

	    EncryptDecrypt endecrypt = new EncryptDecrypt();
	    String encrypt = endecrypt.encrypt(text);
	    System.out.println("encrypt3 : " + encrypt);

	    System.out.println("Valid License : " + VerifyLicense.verifyLicense(encrypt));

	    System.out.println("Room Count : " + VerifyLicense.getLicenseRoomCount(encrypt));

	    System.out.println("Expiry Date : " + VerifyLicense.verifyLicenseExpiry(encrypt));

	    String decrypt = endecrypt.decrypt("6/oQsNS3SKKJfMv6H07dTg==");
	    System.out.println("decrypt3 : " + decrypt);
	    
	    String sEncryted = endecrypt.encryptWithSHA(decrypt);
	    System.out.println("sEncryted : " + sEncryted);
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	}
    }
}
