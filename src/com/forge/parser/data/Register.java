package com.forge.parser.data;

import java.util.List;

public class Register {

	private List<RegInstance> instances;
	private String name;

	public Register(List<RegInstance> instances , String registers)  {
		this.instances = instances;
		this.name = registers;
	}

	public List<RegInstance> getInstances() {
		return instances;
	}
	
	public String getName() {
		return name;
	}
}
