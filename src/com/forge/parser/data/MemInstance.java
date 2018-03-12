package com.forge.parser.data;

import org.codehaus.jackson.annotate.JsonIgnore;

import com.forge.parser.IR.IMemogenCut;
import com.forge.parser.IR.IMemory;

public class MemInstance implements IMemogenCut {
	@JsonIgnore
	private IMemory mem;
	
	public MemInstance(IMemory mem, int i) {
		this.mem = mem;
		this.instanceNumber = i;
	}
	
	private int instanceNumber;
	
	public Integer getInstanceNumber() {
		return instanceNumber;
	}

	public Boolean getIsInterfaceOnly() {
		return mem.hasInterfaceOnly();
	}

	public String getStartOffset() {
		return mem.getStartOffset(instanceNumber);
	}

	public String getEndOffset() {
		return mem.getEndOffset(instanceNumber);
	}

	public boolean getIsReadMultiport() {
		return mem.getIsReadMultiport();
	}

	public boolean getIsWriteMultiport() {
		return mem.getIsWriteMultiport();
	}

	public String getEccWidth() {
		return mem.getEccWidth().toString();
	}

	public String getRnaxiWords() {
		return mem.getRnaxiWords().toString();
	}

	public boolean getIsSingleRnaxiWord() {
		Integer i = Integer.parseInt(getRnaxiWords());
		return i == 1 ? true : false;
	}

	public Integer getLogOfRnaxiWords() {
		Integer i = Integer.parseInt(getRnaxiWords());
		return i == 1 ? 1 : i == 0 ? 0 : (int) Math.ceil(Math.log(i) / Math.log(2));
	}

	public String getRnaxiWordsWidth() {
		return mem.getRnaxiWordsWidth().toString();
	}

	public String getName() {
		return mem.getName() + "_" + instanceNumber;
	}
	
	@Override
	public String getNameForMemogen(){
		return mem.getName();
	}

	public String getReadPortValue() {
		return mem.getReadPortValue().toString();
	}

	public String getWritePortValue() {
		return mem.getWritePortValue().toString();
	}

	public String getWords() {
		return mem.getWords().toString();
	}
	
	public String getPortCap(){
		return mem.getPortCap().toString();
	}

	public Integer getLogOfWords() {
		Integer i = Integer.parseInt(getWords());
		return i == 1 ? 1 : i == 0 ? 0 : (int) Math.ceil(Math.log(i) / Math.log(2));
	}

	public String getBits() {
		return mem.getBits().toString();
	}
	
	@Override
	public String getInstanceNameForMemogen() {
		return getName();
	}

	@Override
	public String getMemogenCmdLine() {
		return mem.getMemogenCmdLine();
	}
}
