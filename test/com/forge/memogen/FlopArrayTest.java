package com.forge.memogen;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.forge.parser.ForgeUtils;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.MemogenCut;
import com.forge.parser.data.Memory;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;
import com.forge.runner.ForgeRunnerSession;

public class FlopArrayTest {

	@Test
	public void FlopArrayRead() {
		String forgeSpecFile = "test/com/forge/memogen/ex.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		File out = new File("./resources/FlopArrayTest");
		File tempaltes = new File("./templates/hw");
		ForgeUtils.setForgeSpecName("ex");
		ForgeRunnerSession frs = new ForgeRunnerSession(out, forgeSpecFile, false, tempaltes,new HashMap<String,String>());
		for(Memory memory : memories){
			for(MemInstance mem : memory.getInstances()){
				MemogenCut memogenCut = new MemogenCut(mem, out);
				List<String> cmd = memogenCut.getOptionsAsList();
				if(cmd.contains("-smurf")){
					Assert.assertTrue(true);
					try {
						frs.generateMemogenMem(memogenCut);
					} catch ( NoSuchMethodException| SecurityException | 
							ClassNotFoundException | MalformedURLException e) {
						e.printStackTrace();
					}
				} else {
					Assert.fail();
				}
			}
		}
		out.delete();
	}

}
