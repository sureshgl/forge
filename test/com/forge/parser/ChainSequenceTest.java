package com.forge.parser;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.Test;

import com.forge.fex.verilogprime.runner.CommandLineParser;
import com.forge.runner.ForgeRunnerSession;

public class ChainSequenceTest {

	private static final List<String> chain = new ArrayList<>();
	
	static {
		chain.add("topModule");
		chain.add("slave1");
		chain.add("slave2");
		chain.add("slave3");
	}
	
	@Test
	public void ChainSequence() throws FileNotFoundException {
		String forgeSpecFile = "test/com/forge/parser/ChainSequence.fs";
		File forgeSpec = new File(forgeSpecFile);
		CommandLineParser cp = new CommandLineParser(new File("./").getAbsolutePath());
		cp.setLec(false);
		File outFile = new File("./ChainSequenceTempDir");
		cp.setOutputDir(outFile);
		cp.setForge(forgeSpec);
		cp.setT("topModuleName");
		cp.setSt(new File("templates/hw"));
		cp.processArgs();
		ForgeUtils.setForgeSpecName("lecSpec");
		ForgeRunnerSession forgeRunnerSession = new ForgeRunnerSession(cp.getOutputDir(), cp.getForge().toString(), false, cp.getSt(),new HashMap<String,String>());
		List<String> chain_ = forgeRunnerSession.getChain();
		for(String entry : chain_){
			if(!ChainSequenceTest.chain.contains(entry)){
				org.junit.Assert.fail();
			}
		}
		
	}
}
