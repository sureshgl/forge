package com.forge.parser.data;

import java.util.List;

import com.forge.parser.ForgeUtils;

public class RnaxiSlvAddrDecoderForStg {

	private List<Register> registers;
	private List<Memory> memories;

	public RnaxiSlvAddrDecoderForStg(List<Register> registers, List<Memory> memories) {
		this.setRegisters(registers);
		this.setMemories(memories);
	}

	public boolean getHasRegisters() {
		return registers.size() > 0;
	}

	public String getFsName() {
		return ForgeUtils.getForgeSpecName();
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
