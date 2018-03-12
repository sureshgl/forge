package com.forge.parser;

import java.io.File;
import java.util.List;

import org.junit.Test;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroupFile;

import com.forge.parser.data.Memory;
import com.forge.parser.data.Register;
import com.forge.parser.data.RnaxiSlvAddrDecoderForStg;
import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;

public class RnaxiSlvAddrDecoderGenTest {

	@Test
	public void SlvAddrDecGen() throws Exception {
		String forgeSpecFile = "test/com/forge/parser/genTest.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		List<Register> registers = ForgeUtils.getRegisters(sc);
		List<Memory> memories = ForgeUtils.getMemories(sc);
		ForgeUtils.setForgeSpecName("genTest");
		RnaxiSlvAddrDecoderForStg rnaxiSlvAddrDecoderForStg = new RnaxiSlvAddrDecoderForStg(registers,
				memories);
		STGroupFile grp = new STGroupFile("hw/rnaxi_slv_addr_decoder.stg");
		ST rnaxi_slv_addr_dec = grp.getInstanceOf("rnaxi_slv_addr_decoder");
		rnaxi_slv_addr_dec.add("rnaxiSlvAddrDecoderForStg", rnaxiSlvAddrDecoderForStg);
		System.out.println(rnaxi_slv_addr_dec.render());
	}
}
