package com.forge.memogen;

import java.io.File;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.forge.parser.ForgeUtils;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.MemogenCut;
import com.forge.parser.data.Memory;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class EccTest {

	@Test
	public void ecc(){
		String forgeSpecFile = "test/com/forge/memogen/ex1.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		File out = new File("./resources/FlopArrayTest");
		for(Memory mem : memories){
			List<MemInstance> instances = mem.getInstances();
			for(MemInstance memInstance : instances){
				MemogenCut cut = new MemogenCut(memInstance, out);
				List<String> options = cut.getOptionsAsList();
				if(options.contains("-ecc") && options.contains("parity")){
					Assert.assertTrue(true);
				} else {
					Assert.fail();
				}
			}
		}
	}
}
