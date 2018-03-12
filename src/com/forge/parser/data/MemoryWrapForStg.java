package com.forge.parser.data;

import com.forge.parser.ForgeUtils;

public class MemoryWrapForStg {

	private MemInstance memory;

	public MemoryWrapForStg(MemInstance memory) {
		this.setMemory(memory);
	}

	public String getFsName() {
		return ForgeUtils.getForgeSpecName();
	}

	public MemInstance getMemory() {
		return memory;
	}

	private void setMemory(MemInstance memory) {
		this.memory = memory;
	}

}
