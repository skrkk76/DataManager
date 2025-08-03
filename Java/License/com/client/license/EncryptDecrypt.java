package com.client.license;

import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class EncryptDecrypt {
    private static String key = "~!@#$%^&*()_+|-={}[]:;'<>?,./\t\r\n";

    public static void main(String[] args) {
	try {
	    String text = "admin123";

	    String encrypt = encrypt(text, LicenseKeys.ALGORITHM_DES);
	    System.out.println("Encrypt : " + encrypt);

	    String decrypt = decrypt(encrypt, LicenseKeys.ALGORITHM_DES);
	    System.out.println("Decrypt : " + decrypt);

	    // String sEncryted = encryptWithSHA(decrypt);
	    // System.out.println("SHA Encryted : " + sEncryted);

	    byte[] b = encrypt(LicenseKeys.public_key, LicenseKeys.ALGORITHM_DES);
	    encrypt = new String(Base64.encodeBase64(b));
	    System.out.println("Encrypt : " + encrypt);

	    b = decrypt(encrypt.getBytes(), LicenseKeys.ALGORITHM_DES);

	    System.out.println("public_key = {");
	    for (int i = 0; i < b.length; i++) {
		System.out.printf("(byte)0x%02X, ", b[i]);
		if (i % 8 == 0) {
		    System.out.println();
		}
	    }
	    System.out.println("};");
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	}
    }

    public static String encrypt(String text, String algorithm) throws Exception {
	byte[] b = encrypt(text.getBytes(), algorithm);
	return new String(Base64.encodeBase64(b));
    }

    public static byte[] encrypt(byte[] bytes, String algorithm) throws Exception {
	if (LicenseKeys.ALGORITHM_AES.equals(algorithm)) {
	    return aesEncryptDecrypt(Cipher.ENCRYPT_MODE, bytes);
	} else if (LicenseKeys.ALGORITHM_DES.equals(algorithm)) {
	    return desEncryptDecrypt(Cipher.ENCRYPT_MODE, bytes);
	}
	return null;
    }

    public static String decrypt(String text, String algorithm) throws Exception {
	byte[] b = decrypt(text.getBytes(), algorithm);
	return new String(b);
    }

    public static byte[] decrypt(byte[] bytes, String algorithm) throws Exception {
	if (LicenseKeys.ALGORITHM_AES.equals(algorithm)) {
	    return aesEncryptDecrypt(Cipher.DECRYPT_MODE, bytes);
	} else if (LicenseKeys.ALGORITHM_DES.equals(algorithm)) {
	    return desEncryptDecrypt(Cipher.DECRYPT_MODE, bytes);
	}
	return null;
    }

    private static byte[] aesEncryptDecrypt(int mode, byte[] bytes) throws Exception {
	Key aesKey = new SecretKeySpec(key.getBytes(), LicenseKeys.ALGORITHM_AES);
	Cipher cipher = Cipher.getInstance(LicenseKeys.ALGORITHM_AES);
	if (mode == Cipher.ENCRYPT_MODE) {
	    cipher.init(Cipher.ENCRYPT_MODE, aesKey);
	    return cipher.doFinal(bytes);
	} else if (mode == Cipher.DECRYPT_MODE) {
	    cipher.init(Cipher.DECRYPT_MODE, aesKey);
	    byte[] in = Base64.decodeBase64(bytes);
	    return cipher.doFinal(in);
	}
	return null;
    }

    private static byte[] desEncryptDecrypt(int mode, byte[] bytes) throws Exception {
	DESKeySpec dks = new DESKeySpec(key.getBytes());
	SecretKeyFactory skf = SecretKeyFactory.getInstance(LicenseKeys.ALGORITHM_DES);
	SecretKey desKey = skf.generateSecret(dks);
	Cipher cipher = Cipher.getInstance(LicenseKeys.ALGORITHM_DES);
	if (mode == Cipher.ENCRYPT_MODE) {
	    cipher.init(Cipher.ENCRYPT_MODE, desKey);
	    return cipher.doFinal(bytes);
	} else if (mode == Cipher.DECRYPT_MODE) {
	    cipher.init(Cipher.DECRYPT_MODE, desKey);
	    byte[] in = Base64.decodeBase64(bytes);
	    return cipher.doFinal(in);
	}
	return null;
    }

    public static String encryptWithSHA(String text) throws NoSuchAlgorithmException, UnsupportedEncodingException {
	MessageDigest md = MessageDigest.getInstance("SHA-1");
	byte[] sha1hash = new byte[40];
	md.update(text.getBytes("iso-8859-1"), 0, text.length());
	sha1hash = md.digest();

	StringBuilder buf = new StringBuilder();
	for (int i = 0; i < sha1hash.length; i++) {
	    int halfbyte = (sha1hash[i] >>> 4) & 0x0F;
	    int two_halfs = 0;
	    do {
		if ((0 <= halfbyte) && (halfbyte <= 9)) {
		    buf.append((char) ('0' + halfbyte));
		} else {
		    buf.append((char) ('a' + (halfbyte - 10)));
		}
		halfbyte = sha1hash[i] & 0x0F;
	    } while (two_halfs++ < 1);
	}

	return buf.toString();
    }
}
