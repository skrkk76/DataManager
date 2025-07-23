package com.client.license;

import java.io.UnsupportedEncodingException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;
import java.security.spec.KeySpec;
import org.apache.commons.codec.binary.Base64;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.PBEParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class EncryptDecrypt {
    private String key = "~!@#$%^&*()_+|-={}[]:;'<>?,./";

    private int iterationCount = 25;
    private byte[] pk = { (byte) 0x53, (byte) 0x4B, (byte) 0x61, (byte) 0x72, (byte) 0x54, (byte) 0x68, (byte) 0x69,
	    (byte) 0x4B };

    public EncryptDecrypt() {
    }

    public String encrypt(String text) throws Exception {
	if (text == null || "".equals(text.trim())) {
	    return null;
	}

	// return aesEncryptDecrypt(Cipher.ENCRYPT_MODE, text);
	return desEncryptDecrypt(Cipher.ENCRYPT_MODE, text);
	// return withMD5AndDESEncryptDecrypt(Cipher.ENCRYPT_MODE, text);
    }

    public String decrypt(String text) throws Exception {
	if (text == null || "".equals(text.trim())) {
	    return null;
	}

	// return aesEncryptDecrypt(Cipher.DECRYPT_MODE, text);
	return desEncryptDecrypt(Cipher.DECRYPT_MODE, text);
	// return withMD5AndDESEncryptDecrypt(Cipher.DECRYPT_MODE, text);
    }

    private String aesEncryptDecrypt(int mode, String s) throws Exception {
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

    private String desEncryptDecrypt(int mode, String s) throws Exception {
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

    private String withMD5AndDESEncryptDecrypt(int mode, String s) throws Exception {
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

    public String encryptWithSHA(String text) throws NoSuchAlgorithmException, UnsupportedEncodingException {
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
