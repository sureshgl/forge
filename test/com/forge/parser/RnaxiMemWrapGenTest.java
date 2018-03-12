package com.forge.parser;

import java.io.File;
import java.util.List;

import org.junit.Test;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;

import com.forge.parser.data.Memory;
import com.forge.parser.data.RnaxiMemWrapForStg;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class RnaxiMemWrapGenTest {

	@Test
	public void RnaxiMemWrapGen() throws Exception {
		String forgeSpecFile = "test/com/forge/parser/genTest.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		ForgeUtils.setForgeSpecName("genTest");
		RnaxiMemWrapForStg rnaxiMemWrapForStg = new RnaxiMemWrapForStg(memories);
		STGroupFile grp = new STGroupFile("hw/rnaxi_mem_wrap.stg");
		ST rnaxi_mem_wrap = grp.getInstanceOf("rnaxi_mem_wrap");
		rnaxi_mem_wrap.add("rnaxiMemWrapForStg", rnaxiMemWrapForStg);
		System.out.println(rnaxi_mem_wrap.render());
	}
}
