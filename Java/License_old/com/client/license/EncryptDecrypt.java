package com.client.license;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class EncryptDecrypt {
	private String key = "~!@#$%^&*()_+|-={}[]:;'<>?,./";

	public EncryptDecrypt() {
	}

	public String encrypt(String text) throws Exception {
		if (text == null || "".equals(text.trim())) {
			return null;
		}
		return desEncryptDecrypt(Cipher.ENCRYPT_MODE, text);
	}

	public String decrypt(String text) throws Exception {
		if (text == null || "".equals(text.trim())) {
			return null;
		}
		return desEncryptDecrypt(Cipher.DECRYPT_MODE, text);
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
			sRet = (new BASE64Encoder()).encode(encrypted);
		} else if (mode == Cipher.DECRYPT_MODE) {
			cipher.init(Cipher.DECRYPT_MODE, desKey);
			byte[] in = (new BASE64Decoder()).decodeBuffer(s);
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
