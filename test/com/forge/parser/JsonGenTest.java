package com.forge.parser;

import java.io.File;
import java.util.HashMap;

import org.junit.Test;

import com.forge.parser.gen.ForgeParser.StartContext;
import com.forge.runner.FileParser;
import com.forge.runner.ForgeRunnerSession;

public class JsonGenTest {

	@Test
	public void jsonGen() {
		String forgeSpecFile = "test/com/forge/parser/genTest.fs";
		File forgeSpec = new File(forgeSpecFile);
		FileParser fp = new FileParser();
		StartContext sc = fp.getFileContent(forgeSpec);
		File out = new File("./tempOutDir");
		if (out.exists()) {
			out.delete();
		}
		out.mkdirs();
		ForgeRunnerSession frs = new ForgeRunnerSession(out, forgeSpec.toString(), true, null,new HashMap<String,String>());
		frs.emitJsonTest(sc);
	}
}
