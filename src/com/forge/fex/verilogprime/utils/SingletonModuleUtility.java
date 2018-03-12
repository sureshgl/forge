package com.forge.fex.verilogprime.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Data_declarationContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_declarationContext;

public class SingletonModuleUtility {

	private static final Logger L = LoggerFactory.getLogger(SingletonModuleUtility.class);
	private Map<String, Module_declarationContext> modules = new HashMap<>();
	private Map<String, List<Data_declarationContext>> addedlogics = new HashMap<>();

	private static SingletonModuleUtility singletonModuleUtility = new SingletonModuleUtility();

	private SingletonModuleUtility() {
	}

	public static SingletonModuleUtility getInstance() {
		return SingletonModuleUtility.singletonModuleUtility;
	}

	public void add(String name, Module_declarationContext module) {
		if (modules.containsKey(name)) {
			SingletonModuleUtility.L.info("module already existing " + name);
			SingletonModuleUtility.L.info("Overrding");
		}
		modules.put(name, module);
	}

	public void add(String name, Module_declarationContext module, List<Data_declarationContext> addedLogics) {
		if (modules.containsKey(name)) {
			SingletonModuleUtility.L.info("module already existing " + name);
			SingletonModuleUtility.L.info("Overrding");
		}
		modules.put(name, module);
		addedlogics.put(name, addedLogics);
	}

	public List<Data_declarationContext> getAddedLogics(String name) {
		if (addedlogics.containsKey(name)) {
			return addedlogics.get(name);
		} else {
			return new ArrayList<>();
		}
	}

	public Module_declarationContext getModule(String name) {
		if (modules.containsKey(name)) {
			return modules.get(name);
		} else {
			SingletonModuleUtility.L.warn("Module " + name + " not found");
			SingletonModuleUtility.L.error("returning null");
			return null;
		}
	}
}
