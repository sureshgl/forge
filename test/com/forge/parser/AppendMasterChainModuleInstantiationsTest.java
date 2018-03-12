package com.forge.parser;

import java.io.File;
import java.io.FileNotFoundException;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;
import org.junit.Assert;
import org.junit.Test;

import com.forge.common.FileUtils;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Source_textContext;
import com.forge.fex.verilogprime.runner.CommandLineParser;
import com.forge.fex.verilogprime.runner.ModuleParser;
import com.forge.fex.verilogprime.utils.ModuleIndexer;
import com.forge.runner.ForgeRunnerSession;

public class AppendMasterChainModuleInstantiationsTest {
	
	@Test
	public void appendMasterChainModuleInstantiations() throws FileNotFoundException{
		String forgeSpecFile = "test/com/forge/parser/ChainSequence.fs";
		File forgeSpec = new File(forgeSpecFile);
		CommandLineParser cp = new CommandLineParser(new File("./").getAbsolutePath());
		cp.setLec(false);
		File outFile = new File("./ChainSequenceTempDir");
		cp.setOutputDir(outFile);
		cp.setForge(forgeSpec);
		cp.setT("topModule");
		cp.setSt(new File("templates/hw"));
		cp.processArgs();
		ForgeUtils.setForgeSpecName("lecSpec");
		ForgeRunnerSession forgeRunnerSession = new ForgeRunnerSession(cp.getOutputDir(), cp.getForge().toString(), false, cp.getSt(),new HashMap<String,String>());
		List<String> chain = forgeRunnerSession.getChain();
		List<Path> paths = new ArrayList<>();
		paths.add(new File("test/com/forge/parser/tempVerilog.v").toPath());
		ModuleIndexer mi = new ModuleIndexer(paths);
		ModuleParser mp = new ModuleParser(mi);
		Source_textContext ctx = mp.getModule("topModule");
		ctx.extendedContext.appendRnaxiPorts(chain);
		System.out.println(ctx.extendedContext.getFormattedText());
		String expected = FileUtils.readFileIntoString(new File("test/com/forge/parser/expectedTempVerilog.v"));
		String actual = ctx.extendedContext.getFormattedText();
		if(!equals(expected,actual))
			Assert.fail();
	}

	private boolean equals(String expected, String actual) {
		String first = expected.replace(" ", "").replace("\n", "");
		String second = actual.replace(" ", "").replace("\n", "");
		return first.equals(second);
	}
}
