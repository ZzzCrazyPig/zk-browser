package com.crazypig.zkbrowser.conf;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class SystemConfig {
	
	private static Properties props;
	private static final String DEFAULT_PROP_FILENAME = "application-default.properties";
	private static final String CUSTOM_PROP_FILENAME = "application.properties";
	
	
	static {
		props = new Properties();
		try {
			loadConfig();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private static void loadConfig() throws IOException {
		ClassLoader cl = Thread.currentThread().getContextClassLoader();
		InputStream in = cl.getResourceAsStream(DEFAULT_PROP_FILENAME);
		if(in != null) {
			props.load(in);
		}
		in = cl.getResourceAsStream(CUSTOM_PROP_FILENAME);
		if(in != null) {
			props.load(in);
		}
	}
	
	public static String getProperty(String name) {
		return props.getProperty(name);
	}

}
