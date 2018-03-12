package com.forge.runner;

import com.beust.jcommander.ParameterException;

public class InvalidOptionException extends ParameterException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 834570951687223200L;

	public InvalidOptionException(String file) {
		super(file + " does not exists or is not a directory");
	}

}
