package com.forge.parser;

import java.io.File;
import java.util.List;

import org.junit.Test;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;

import com.forge.parser.data.Register;
import com.forge.parser.data.RnaxiRegWrapForStg;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class RnaxiRegWrapGenTest {

	@Test
	public void RegWrapGen() throws Exception {
		String forgeSpecFile = "test/com/forge/parser/genTest.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Register> registers = ForgeUtils.getRegisters(sc);
		ForgeUtils.setForgeSpecName("genTest");
		RnaxiRegWrapForStg rnaxiRegWrapForStg = new RnaxiRegWrapForStg(registers);
		STGroupFile grp = new STGroupFile("hw/rnaxi_reg_wrap.stg");
		ST rnaxi_reg_wrap = grp.getInstanceOf("rnaxi_reg_wrap");
		rnaxi_reg_wrap.add("rnaxiRegWrapForStg", rnaxiRegWrapForStg);
		System.out.println(rnaxi_reg_wrap.render());
	}
}
