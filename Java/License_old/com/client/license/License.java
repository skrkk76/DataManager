package com.client.license;

public class License {
    public static void main(String[] args) {
	try {
	    if (args != null && args.length > 0 && "Verify".equalsIgnoreCase(args[0])) {
		new VerifyLicense();
	    } else {
		new CreateLicense();
	    }
	} catch (Exception e) {
	    e.printStackTrace(System.out);
	}
    }
}
