package com.forge.parser;

import java.io.File;
import java.util.List;

import org.junit.Test;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;

import com.forge.parser.data.HashTable;
import com.forge.parser.data.Memory;
import com.forge.parser.data.Register;
import com.forge.parser.data.RnaxiSlvTopForStg;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class RnaxiSlvTopGenTest {

	@Test
	public void RegWrapGen() throws Exception {
		String forgeSpecFile = "test/com/forge/parser/genTest.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Register> registers = ForgeUtils.getRegisters(sc);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		List<HashTable> hashtables = ForgeUtils.getHashTables(sc);
		ForgeUtils.setForgeSpecName("genTest");
		RnaxiSlvTopForStg rnaxiSlvTopForStg = new RnaxiSlvTopForStg(memories, registers.size() > 0,hashtables);
		STGroupFile grp = new STGroupFile("hw/rnaxi_slv_top.stg");
		ST rnaxi_slv_top = grp.getInstanceOf("rnaxi_slv_top");
		rnaxi_slv_top.add("rnaxiSlvTopForStg", rnaxiSlvTopForStg);
		System.out.println(rnaxi_slv_top.render());
	}
}
