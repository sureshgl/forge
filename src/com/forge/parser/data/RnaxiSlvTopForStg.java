package com.forge.parser.data;

import java.util.List;

import com.forge.parser.ForgeUtils;

public class RnaxiSlvTopForStg {

	private List<Memory> memories;
	private List<HashTable> hashTables;
	private boolean hasRegisters;

	public RnaxiSlvTopForStg(List<Memory> memories, Boolean hasRegisters,List<HashTable> hashTables) {
		this.hasRegisters = hasRegisters;
		this.memories = memories;
		this.hashTables = hashTables;
	}
	
	public List<HashTable> getHashTables(){
		return hashTables;
	}

	public boolean getHasMemories() {
		return memories.size() > 0;
	}

	public String getFsName() {
		return ForgeUtils.getForgeSpecName();
	}

	public List<Memory> getMemories() {
		return memories;
	}

	public boolean getHasRegisters() {
		return hasRegisters;
	}

}
