package com.forge.memogen;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Assert;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.data.MemoryForTest;
import com.forge.fex.verilogprime.utils.MemogenErrorException;
import com.forge.parser.IR.IMemogenCut;
import com.forge.parser.IR.IMemory;
import com.forge.parser.data.MemInstance;
import com.forge.parser.data.Memory;
import com.forge.runner.ForgeRunnerSession;

public class MemogenTest {

	private static final Logger L = LoggerFactory.getLogger(MemogenTest.class);
	private static final Map<Memory, List<String>> MemogenMemoryNamesMap = new HashMap<>();

	static {
		List<MemInstance> memInstances = new ArrayList<MemInstance>();
		String name = null;
		IMemory mem = new MemoryForTest("mem1", 12, 1, false, 1, 1, 1);
		memInstances.add(new MemInstance(mem, 0));
		MemogenMemoryNamesMap.put(new Memory(memInstances,name), Arrays.asList("mem1_0_memogen.v"));

		memInstances = new ArrayList<MemInstance>();
		mem = new MemoryForTest("mem2", 10, 2, false, 2, 1, 2);
		memInstances.add(new MemInstance(mem, 0));
		memInstances.add(new MemInstance(mem, 1));
		MemogenMemoryNamesMap.put(new Memory(memInstances,name), Arrays.asList("mem2_0_memogen.v","mem2_1_memogen.v"));

		memInstances = new ArrayList<MemInstance>();
		mem = new MemoryForTest("mem3", 1, 2, false, 1, 1, 1);
		memInstances.add(new MemInstance(mem, 0));
		MemogenMemoryNamesMap.put(new Memory(memInstances,name), Arrays.asList("mem3_0_memogen.v"));

		memInstances = new ArrayList<MemInstance>();
		mem = new MemoryForTest("hello", 1, 2, false, 1, 1, 3);
		memInstances.add(new MemInstance(mem, 0));
		memInstances.add(new MemInstance(mem, 1));
		memInstances.add(new MemInstance(mem, 2));
		MemogenMemoryNamesMap.put(new Memory(memInstances,name), Arrays.asList("hello_0_memogen.v","hello_1_memogen.v","hello_0_memogen.v"));

	}
	
	@Test
	public void Memogen() throws IOException {
		File out = new File("./resources/isMemogenOutDirCreated");
		File tempaltes = new File("./templates/hw");
		ForgeRunnerSession frs = new ForgeRunnerSession(out, null, false, tempaltes,new HashMap<String,String>());
		List<Memory> memories =new ArrayList<Memory>(MemogenMemoryNamesMap.keySet());
		try {
			frs.emitMemories(memories, true);
		} catch (MemogenErrorException e) {
			L.error("Memogen memories not generated");
			Assert.fail();
		}
	}
}
