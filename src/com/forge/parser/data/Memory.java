package com.forge.parser.data;

import java.util.List;

public class Memory {

	private List<MemInstance> instances;
	
	private String name;

	public Memory(List<MemInstance> instances,String memories) {
		this.instances = instances;
		this.name = memories;
	}

	public List<MemInstance> getInstances() {
		return instances;
	}
	
	public String getName() {
		return name;
	}
}
