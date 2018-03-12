package com.forge.parser.data;

import java.util.List;

public class HtmlForStg {
	private String fsName;
	private List<Register> registers;
	private List<Memory> memories;
	
	public HtmlForStg(String fsName, List<Register> registers, List<Memory> memories) {
		this.setFsName(fsName);
		this.setRegisters(registers);
		this.setMemories(memories);
	}

	public boolean getHasRegisters(){
		return registers.size()>0;
	}
	
	public String getFsName() {
		return fsName;
	}

	private void setFsName(String fsName) {
		this.fsName = fsName;
	}

	public List<Register> getRegisters() {
		return registers;
	}

	private void setRegisters(List<Register> registers) {
		this.registers = registers;
	}

	public List<Memory> getMemories() {
		return memories;
	}

	private void setMemories(List<Memory> memories) {
		this.memories = memories;
	}
}
