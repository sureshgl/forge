package com.forge.parser.data;

import java.util.List;

import com.forge.parser.ForgeUtils;

public class RnaxiMemWrapForStg {

	private List<Memory> memories;

	public RnaxiMemWrapForStg(List<Memory> memories) {
		this.setMemories(memories);
	}

	public String getFsName() {
		return ForgeUtils.getForgeSpecName();
	}

	public List<Memory> getMemories() {
		return memories;
	}

	private void setMemories(List<Memory> memories) {
		this.memories = memories;
	}

}
