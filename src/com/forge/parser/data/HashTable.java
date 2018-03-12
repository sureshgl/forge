package com.forge.parser.data;

import java.util.List;

import com.forge.parser.IR.IHashTable;

public class HashTable {
	
	private IHashTable hashTable;
	
	public HashTable(IHashTable hashTable){
		this.hashTable = hashTable;
	}

	public List<String> getModulesToInstantiate(){
		return hashTable.getModuleNames();
	}
	
}
