package com.crazypig.zkbrowser.entity;

import java.io.Serializable;
import java.util.List;

public class AppResult implements Serializable {

	private static final long serialVersionUID = 1L;

	public AppResult() {}
	
	private boolean success;
	private Object row;
	private List<Object> rows;
	private String errorMessage;
	
	public static AppResult buildSucessResult(Object row) {
		AppResult result = new AppResult();
		result.setSuccess(true);
		result.setRow(row);
		return result;
	}
	
	public static AppResult buildSucessResult(List<Object> rows) {
		AppResult result = new AppResult();
		result.setSuccess(true);
		result.setRows(rows);
		return result;
	}
	
	public static AppResult buildErrorResult(String errorMessage) {
		AppResult result = new AppResult();
		result.setSuccess(false);
		result.setErrorMessage(errorMessage);
		return result;
	}
	
	public boolean isSuccess() {
		return success;
	}
	public void setSuccess(boolean success) {
		this.success = success;
	}
	public Object getRow() {
		return row;
	}
	public void setRow(Object row) {
		this.row = row;
	}
	public List<Object> getRows() {
		return rows;
	}
	public void setRows(List<Object> rows) {
		this.rows = rows;
	}
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	
}
