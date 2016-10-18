package com.crazypig.zkbrowser.entity;

import java.io.Serializable;

import org.apache.zookeeper.data.Stat;

public class ZkNodeInfo implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String dataAsString;
	private byte[] data;
	private Stat stat;
	
	public ZkNodeInfo() {
		
	}

	public String getDataAsString() {
		return dataAsString;
	}

	public void setDataAsString(String dataAsString) {
		this.dataAsString = dataAsString;
	}

	public byte[] getData() {
		return data;
	}

	public void setData(byte[] data) {
		this.data = data;
	}

	public Stat getStat() {
		return stat;
	}

	public void setStat(Stat stat) {
		this.stat = stat;
	}
	
}
