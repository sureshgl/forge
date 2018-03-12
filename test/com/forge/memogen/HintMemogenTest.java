package com.forge.memogen;
import java.io.File;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.forge.parser.ForgeUtils;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.Memory;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;


public class HintMemogenTest {

	private static String cmdLine = "-v avago -t 16nm_odb -f 1000 -flop flopin=1:flopmem=0:flopout=1 -fr";
	
	@Test
	public void hintMemogen(){

		String forgeSpecFile = "test/com/forge/memogen/cmd.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		ForgeUtils.setForgeSpecName("cmd");
		for(Memory memory : memories){
			for(MemInstance instance : memory.getInstances()){
				String cmdLineFromForge = instance.getMemogenCmdLine();
				if (cmdLineFromForge.equals(cmdLine)){
					Assert.assertTrue(true);
				}else{
					Assert.fail();
				}
			}			
		}
	}
}
