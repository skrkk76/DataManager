package com.client.license;

import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;
import java.security.spec.KeySpec;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class EncryptDecrypt {
    public static enum ALGORITHM {
	AES, DES, MD5withDES
    };

    private static int iterationCount = 25;
    private static String key = "~!@#$%^&*()_+|-={}[]:;'<>?,./";
    private static byte[] pk = { (byte) 0x53, (byte) 0x4B, (byte) 0x61, (byte) 0x72, (byte) 0x54, (byte) 0x68,
	    (byte) 0x69, (byte) 0x4B };

    public static void main(String[] args) {
	try {
	    String text = "RaviSadineni~2C-DB-07-2D-37-1E~12/31/2030~20";

	    String encrypt = encrypt(text, ALGORITHM.DES);
	    System.out.println("Encrypt : " + encrypt);

	    String decrypt = decrypt(encrypt, ALGORITHM.DES);
	    System.out.println("Decrypt : " + decrypt);

	    String sEncryted = encryptWithSHA(decrypt);
	    System.out.println("SHA Encryted : " + sEncryted);
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	}
    }

    public static String encrypt(String text, ALGORITHM algorithm) throws Exception {
	if (text == null || "".equals(text.trim())) {
	    return null;
	}

	String encrypted = "";
	switch (algorithm) {
	case AES:
	    encrypted = aesEncryptDecrypt(Cipher.ENCRYPT_MODE, text);
	    break;
	case DES:
	    encrypted = desEncryptDecrypt(Cipher.ENCRYPT_MODE, text);
	    break;
	case MD5withDES:
	    encrypted = MD5AndDESEncryptDecrypt(Cipher.ENCRYPT_MODE, text);
	    break;
	}

	return encrypted;
    }

    public static String decrypt(String text, ALGORITHM algorithm) throws Exception {
	if (text == null || "".equals(text.trim())) {
	    return null;
	}

	String decrypted = "";
	switch (algorithm) {
	case AES:
	    decrypted = aesEncryptDecrypt(Cipher.DECRYPT_MODE, text);
	    break;
	case DES:
	    decrypted = desEncryptDecrypt(Cipher.DECRYPT_MODE, text);
	    break;
	case MD5withDES:
	    decrypted = MD5AndDESEncryptDecrypt(Cipher.DECRYPT_MODE, text);
	    break;
	}

	return decrypted;
    }

    private static String aesEncryptDecrypt(int mode, String s) throws Exception {
	String sRet = null;

	Key aesKey = new SecretKeySpec(key.getBytes(), "AES");
	Cipher cipher = Cipher.getInstance("AES");
	if (mode == Cipher.ENCRYPT_MODE) {
	    cipher.init(Cipher.ENCRYPT_MODE, aesKey);
	    byte[] encrypted = cipher.doFinal(s.getBytes());
	    sRet = new String(Base64.encodeBase64(encrypted));
	} else if (mode == Cipher.DECRYPT_MODE) {
	    cipher.init(Cipher.DECRYPT_MODE, aesKey);
	    byte[] in = Base64.decodeBase64(s.getBytes());
	    byte[] out = cipher.doFinal(in);
	    sRet = new String(out);
	}

	return sRet;
    }

    private static String desEncryptDecrypt(int mode, String s) throws Exception {
	String sRet = null;

	DESKeySpec dks = new DESKeySpec(key.getBytes());
	SecretKeyFactory skf = SecretKeyFactory.getInstance("DES");
	SecretKey desKey = skf.generateSecret(dks);

	Cipher cipher = Cipher.getInstance("DES");
	if (mode == Cipher.ENCRYPT_MODE) {
	    cipher.init(Cipher.ENCRYPT_MODE, desKey);
	    byte[] encrypted = cipher.doFinal(s.getBytes());
	    sRet = new String(Base64.encodeBase64(encrypted));
	} else if (mode == Cipher.DECRYPT_MODE) {
	    cipher.init(Cipher.DECRYPT_MODE, desKey);
	    byte[] in = Base64.decodeBase64(s.getBytes());
	    byte[] out = cipher.doFinal(in);
	    sRet = new String(out);
	}

	return sRet;
    }

    private static String MD5AndDESEncryptDecrypt(int mode, String s) throws Exception {
	String sRet = null;

	KeySpec keySpec = new PBEKeySpec(key.toCharArray(), pk, iterationCount);
	SecretKey secretKey = SecretKeyFactory.getInstance("PBEWithMD5AndDES").generateSecret(keySpec);
	AlgorithmParameterSpec paramSpec = new PBEParameterSpec(pk, iterationCount);

	Cipher cipher = Cipher.getInstance(secretKey.getAlgorithm());
	if (mode == Cipher.ENCRYPT_MODE) {
	    cipher.init(Cipher.ENCRYPT_MODE, secretKey, paramSpec);
	    byte[] in = s.getBytes();
	    byte[] out = cipher.doFinal(in);
	    sRet = new String(Base64.encodeBase64(out));
	} else if (mode == Cipher.DECRYPT_MODE) {
	    cipher.init(Cipher.DECRYPT_MODE, secretKey, paramSpec);
	    byte[] in = Base64.decodeBase64(s.getBytes());
	    byte[] out = cipher.doFinal(in);
	    sRet = new String(out);
	}
	return sRet;
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
