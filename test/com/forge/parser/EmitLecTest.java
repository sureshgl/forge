package com.forge.parser;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.forge.fex.verilogprime.runner.CommandLineParser;
import com.forge.fex.verilogprime.runner.FexRunnerSession;
import com.forge.runner.ForgeRunnerSession;

public class EmitLecTest {

	@Test
	public void emitLECScriptsIfLecGiven() throws FileNotFoundException {
		String forgeSpecFile = "test/com/forge/parser/lecInputSpec.fs";
		File forgeSpec = new File(forgeSpecFile);
		CommandLineParser cp = new CommandLineParser(new File("./").getAbsolutePath());
		cp.setLec(true);
		cp.setOutputDir(new File("./lecTextOut"));
		cp.setForge(forgeSpec);
		cp.setT("lecSpec");
		cp.setSt(new File("templates/hw"));
		List<String> fOptionFiles = new ArrayList<>();
		fOptionFiles.add("test/com/forge/parser/lecSpecRtl.f");
		cp.setFOptionFiles(fOptionFiles);
		cp.processArgs();
		ForgeUtils.setForgeSpecName("lecSpec");
		ForgeRunnerSession forgeRunnerSession = new ForgeRunnerSession(cp.getOutputDir(), cp.getForge().toString(), false, cp.getSt(),new HashMap<String,String>());
		forgeRunnerSession.run();
		FexRunnerSession frs = new FexRunnerSession(cp);
		frs.setForgeSession(forgeRunnerSession);
		frs.run();
		Assert.assertTrue(new File(cp.getOutputDir() + "/lec_dc.sh").exists());
		Assert.assertTrue(new File(cp.getOutputDir() + "/lec.dofile").exists());

	}

	@Test
	public void emitLECScriptsIfLecNotGiven() throws FileNotFoundException {
		String forgeSpecFile = "test/com/forge/parser/lecInputSpec.fs";
		File forgeSpec = new File(forgeSpecFile);
		CommandLineParser cp = new CommandLineParser(new File("./").getAbsolutePath());
		cp.setOutputDir(new File("./lecTextOut"));
		cp.setForge(forgeSpec);
		cp.setT("lecSpec");
		cp.setSt(new File("templates/hw"));
		List<String> fOptionFiles = new ArrayList<>();
		fOptionFiles.add("test/com/forge/parser/lecSpecRtl.f");
		cp.setFOptionFiles(fOptionFiles);
		cp.processArgs();
		ForgeUtils.setForgeSpecName("lecSpec");
		ForgeRunnerSession forgeRunnerSession = new ForgeRunnerSession(cp.getOutputDir(), cp.getForge().toString(), false, cp.getSt(),new HashMap<String,String>());
		forgeRunnerSession.run();
		FexRunnerSession frs = new FexRunnerSession(cp);
		frs.setForgeSession(forgeRunnerSession);
		frs.run();
		Assert.assertFalse(new File(cp.getOutputDir() + "/lec_dc.sh").exists());
		Assert.assertFalse(new File(cp.getOutputDir() + "/lec.dofile").exists());

	}
}
