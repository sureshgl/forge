package com.forge.hashtable;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.forge.common.FileUtils;
import com.forge.parser.ForgeUtils;
import com.forge.parser.data.HashTable;
import com.forge.parser.data.Memory;
import com.forge.parser.data.Register;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;
import com.forge.runner.ForgeRunnerSession;

public class SlvTopWithHashTablesTest {
	
	@Test
	public void SlvTopWithHashTables() {
		String forgeSpecFile = "test/com/forge/hashtable/ex.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<HashTable> hashtables = ForgeUtils.getHashTables(sc);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		List<Register> registers = ForgeUtils.getRegisters(sc);
		File st = new File("./templates/hw");
		File output = new File("./resources/test/hashtable");
		if(output.exists())
			FileUtils.Delete(output, true);
		output.mkdirs();
		ForgeRunnerSession frs = new ForgeRunnerSession(output, "ex", false, st,new HashMap<String,String>());
		frs.emitRnaxiSlvtop(memories,registers, true, hashtables);
		File slv_top = new File("./resources/test/hashtable/ex_rnaxi_slv_top.xv");
		if(!slv_top.exists())
			Assert.fail();
		File golden = new File("test/com/forge/hashtable/SlvTopGolden.xv");
		if(!FileUtils.readFileIntoString(golden).equals(FileUtils.readFileIntoString(slv_top)))
			Assert.fail();
		Assert.assertTrue(true);
	}

}
