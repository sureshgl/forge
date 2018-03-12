package com.forge.parser.IR;

public interface IMemogenCut {
	
	public String getNameForMemogen();
	
	public String getInstanceNameForMemogen();

	public String getWords();

	public String getReadPortValue();

	public String getWritePortValue();

	public String getBits();
	
	public String getMemogenCmdLine();
	
	public String getPortCap();
	
}
