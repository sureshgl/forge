package com.forge.parser;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Assert;
import org.junit.Test;

import com.forge.parser.data.Field;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.Memory;
import com.forge.parser.data.RegInstance;
import com.forge.parser.data.Register;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;


public class ParametersInForgeSpecTest {

	private static Map<String,String> parameters = new HashMap<String,String>();

	static{
		ParametersInForgeSpecTest.parameters.put("PARAM1", "2");
		ParametersInForgeSpecTest.parameters.put("PARAM2", "4");
		ParametersInForgeSpecTest.parameters.put("PARAM3", "10");
		ParametersInForgeSpecTest.parameters.put("PARAM4", "64");
	}

	public ParametersInForgeSpecTest(){
		FileParser fp = new FileParser();
		File forgeSpec = new File("test/com/forge/parser/ParametersInForgeSpec.fs");
		this.sc = fp.getFileContent(forgeSpec);
		sc.extendedContext.resolveParameters(ParametersInForgeSpecTest.parameters);
	}

	private StartContext sc;

	@Test
	public void ListOfRegisters() {
		ParametersInForgeSpecTest parametersInForgeSpecTest = new ParametersInForgeSpecTest();
		List<Register> registers = ForgeUtils.getRegisters(parametersInForgeSpecTest.sc);
		for(Register register : registers){
			if(register.getInstances().get(0).getName().contains("drmt_reg_2")){
				if(register.getInstances().size() == 3){
					Assert.assertTrue(true);
				} else {
					Assert.fail();
				}
			}
			if(register.getInstances().get(0).getName().contains("drmt_reg_4")){
				if(register.getInstances().size() == 5){
					Assert.assertTrue(true);
				} else {
					Assert.fail();
				}
			}
		}
	}

	@Test
	public void ResetValueOfField() {
		ParametersInForgeSpecTest parametersInForgeSpecTest = new ParametersInForgeSpecTest();
		List<Register> registers = ForgeUtils.getRegisters(parametersInForgeSpecTest.sc);
		for(Register register : registers){
			if(register.getInstances().get(0).getName().contains("drmt_reg_3")){
				RegInstance instance = register.getInstances().get(0);
				for(Field f : instance.getFields()){
					if(f.getName().equals("fl1")){
						String size = f.getSize();
						if(size.equals("10")){
							Assert.assertTrue(true);
						} else {
							Assert.fail();
						}
					}
				}
			}
		}
	}

	@Test
	public void WordsInMemory() {
		ParametersInForgeSpecTest parametersInForgeSpecTest = new ParametersInForgeSpecTest();
		List<Memory> memories = ForgeUtils.getMemories(parametersInForgeSpecTest.sc);
		for(Memory memory : memories){
			if(memory.getInstances().get(0).getName().contains("memory1")){
				MemInstance instacne = memory.getInstances().get(0);
				if(instacne.getWords().equals("64")){
					Assert.assertTrue(true);
				} else {
					Assert.fail();
				}
			}
		}
	}


}
