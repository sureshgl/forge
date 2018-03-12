package com.forge.parser.data;

import java.util.List;

import com.forge.parser.ForgeUtils;

public class RnaxiRegWrapForStg {

	private List<Register> registers;

	public RnaxiRegWrapForStg(List<Register> registers) {
		this.setRegisters(registers);
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

}
