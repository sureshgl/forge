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

public class FlopArrayReadTest {
	
	@Test
	public void FlopArrayRead() {
		String forgeSpecFile = "test/com/forge/memogen/ex.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		for(Memory memory : memories){
			for(MemInstance mem : memory.getInstances()){
				if(mem.getName().contains("blah_mem")){
					//if(mem.isFlopArray()){
						//Assert.assertTrue(true);
					//}
				}
			}
		}
		Assert.fail();
	}

}
