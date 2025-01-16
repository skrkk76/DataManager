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

public class EncryptDecrypt
{
	private static final String key = "~!@#$%^&*()_+|-={}[]:;'<>?,./'";
	
	public EncryptDecrypt()
	{
		
	}
	
	public String encrypt(String s) throws Exception
	{
		if("".equals(s))
		{
			return "";
		}
		return encryptOrDecrypt(Cipher.ENCRYPT_MODE, s);
	}

	public String decrypt(String s) throws Exception
	{
		if("".equals(s))
		{
			return "";
		}
		return encryptOrDecrypt(Cipher.DECRYPT_MODE, s);
	}

	private String encryptOrDecrypt(int mode, String s) throws Exception 
	{
		String sRet = "";
		
		DESKeySpec dks = new DESKeySpec(key.getBytes());
		SecretKeyFactory skf = SecretKeyFactory.getInstance("DES");
		SecretKey desKey = skf.generateSecret(dks);
		Cipher cipher = Cipher.getInstance("DES");

		if (mode == Cipher.ENCRYPT_MODE) 
		{
			cipher.init(Cipher.ENCRYPT_MODE, desKey);
			
			byte[] encVal = cipher.doFinal(s.getBytes());
			sRet = new BASE64Encoder().encode(encVal);
		} 
		else if (mode == Cipher.DECRYPT_MODE) 
		{
			cipher.init(Cipher.DECRYPT_MODE, desKey);
			
			byte[] decordedValue = new BASE64Decoder().decodeBuffer(s);
	        byte[] decValue = cipher.doFinal(decordedValue);
	        sRet = new String(decValue);
		}
		
		return sRet;
	}
	
	public String encryptWithSHA(String text) throws NoSuchAlgorithmException, UnsupportedEncodingException  
    { 
    	MessageDigest md = MessageDigest.getInstance("SHA-1");
    	byte[] sha1hash = new byte[40];
    	md.update(text.getBytes("iso-8859-1"), 0, text.length());
	    sha1hash = md.digest();
	 
        StringBuilder buf = new StringBuilder();
        for (int i = 0; i < sha1hash.length; i++) 
        { 
            int halfbyte = (sha1hash[i] >>> 4) & 0x0F;
            int two_halfs = 0;
            do 
            { 
                if ((0 <= halfbyte) && (halfbyte <= 9))
                {
                    buf.append((char) ('0' + halfbyte));
                }
                else
                {
                    buf.append((char) ('a' + (halfbyte - 10)));
                }
                halfbyte = sha1hash[i] & 0x0F;
            } while(two_halfs++ < 1);
        }

        return buf.toString();
    }
}
