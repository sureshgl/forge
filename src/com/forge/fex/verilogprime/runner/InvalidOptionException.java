package com.forge.fex.verilogprime.runner;

import com.beust.jcommander.ParameterException;

public class InvalidOptionException extends ParameterException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public InvalidOptionException(String file) {
		super(file + " does not exists or is not a directory");
	}

}