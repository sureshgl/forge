package com.forge.parser;

import java.io.File;
import java.util.List;

import org.junit.Test;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;

import com.forge.parser.data.MemInstance;
import com.forge.parser.data.Memory;
import com.forge.parser.data.MemoryForStg;
import com.forge.parser.data.MemoryWrapForStg;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class MemoryGenTest {

	@Test
	public void MemoryGen() throws Exception {
		String forgeSpecFile = "test/com/forge/parser/genTest.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		ForgeUtils.setForgeSpecName("genTest");
		for (Memory memory : memories) {
			for (MemInstance memInstance : memory.getInstances()) {
				MemoryWrapForStg memoryWrapForStg = new MemoryWrapForStg(memInstance);
				STGroupFile grp = new STGroupFile("hw/memory_wrap.stg");
				ST memory_wrap = grp.getInstanceOf("memory_wrap");
				memory_wrap.add("memoryWrapForStg", memoryWrapForStg);
				System.out.println(memory_wrap.render());

				System.out.println();
				System.out.println();

				MemoryForStg memoryForStg = new MemoryForStg(memInstance);
				grp = new STGroupFile("hw/memory.stg");
				ST memory_stg = grp.getInstanceOf("memory");
				memory_stg.add("memoryForStg", memoryForStg);
				System.out.println(memory_stg.render());
			}
		}
	}
}
