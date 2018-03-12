package com.forge.data;

import java.util.List;

import org.stringtemplate.v4.ST;

import com.forge.parser.IR.IField;
import com.forge.parser.IR.IMemory;
import com.forge.runner.ForgeRunnerSession;

public class MemoryForTest implements IMemory{
	
	private String name;
	private Integer words;
	private Integer bits;
	private Boolean interface_only;
	private Integer read_port_value;
	private Integer write_port_value;
	private Integer array_size;

	public MemoryForTest(String name, Integer words, Integer bits,boolean interface_only, 
			Integer read_port_value, Integer write_port_value, Integer array_size){
		this.name = name;
		this.words = words;
		this.bits = bits;
		this.interface_only = interface_only;
		this.read_port_value = read_port_value;
		this.write_port_value = write_port_value;
		this.array_size = array_size;
	}
	
	@Override
	public String getName() {
		return name;
	}

	@Override
	public List<IField> getFields() {
		return null;
	}
	
	@Override
	public boolean hasInterfaceOnly() {
		return interface_only;
	}
	
	@Override
	public Integer getWords() {
		return words;
	}

	@Override
	public Integer getLogOfWords() {
		return (int) Math.ceil(Math.log10(words) / Math.log10(2));
	}
	
	@Override
	public Integer getBits() {
		return bits;
	}
	
	@Override
	public Integer getEccWidth() {
		return new Integer(0);
	}
	
	@Override
	public Integer getReadPortValue() {
		return read_port_value;
	}

	@Override
	public Integer getWritePortValue() {
		return write_port_value;
	}
	
	@Override
	public Boolean getIsReadMultiport() {
		return getReadPortValue() > 1;
	}

	@Override
	public Boolean getIsWriteMultiport() {
		return getWritePortValue() > 1;
	}
	
	@Override
	public Integer getRnaxiWords() {
		return (int) Math.ceil(getBits() / 32.0);
	}

	@Override
	public Integer getRnaxiWordsWidth() {
		return getRnaxiWords() * 32;
	}

	@Override
	public Integer getTotalSize() {
		return this.getWords() * this.getBits();
	}
	
	@Override
	public Integer getTotalSizeInWords() {
		Integer totalSize = getBitsInWords();
		totalSize = totalSize * array_size;
		return this.getWords() * totalSize;
	}
	
	@Override
	public Integer getSizeInWords() {
		return getWords() * getBitsInWords();
	}
	
	@Override
	public Integer getBitsInWords() {
		int totalBits = this.getBits();
		if (totalBits % 32 > 0) {
			totalBits = totalBits / 32 + 1;
		} else {
			totalBits = totalBits / 32;
		}
		return totalBits;
	}
	
	@Override
	public Integer getArraySize() {
		return array_size;
	}
	
	
	//not implemented yet
	
	@Override
	public Integer getMemoryOffset() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getStartOffset() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getEndOffset() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getEndOffset(int index) {
		// TODO Auto-generated method stub
		return null;
	}


	@Override
	public String getStartOffset(int index) {
		// TODO Auto-generated method stub
		return null;
	}

	
	@Override
	public ST getVHeaderFieldStructureST() {
		return null;
	}

	@Override
	public List<ST> getVHeaderMemoryStructureST(ForgeRunnerSession forgeRunnerSession) {
		return null;
	}

	@Override
	public ST getVHeaderMemory(ForgeRunnerSession forgeRunnerSession) {
		return null;
	}

	@Override
	public String getPortCap() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getMemogenCmdLine() {
		// TODO Auto-generated method stub
		return null;
	}
}
