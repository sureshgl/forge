package com.forge.parser.tot;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import com.forge.common.FileUtils;
import com.forge.fex.verilogprime.runner.CommandLineParser;
import com.forge.fex.verilogprime.runner.FexRunnerSession;
import com.forge.parser.ForgeUtils;
import com.forge.runner.ForgeRunnerSession;

public class InputFilesTOTTest {
	@Test
	public void totFile() throws IOException {
		String forgeSpecFile = "test/com/forge/parser/tot/tot.fs";
		File forgeSpec = new File(forgeSpecFile);
		CommandLineParser cp = new CommandLineParser(new File("./").getAbsolutePath());

		File out = new File("test/com/forge/parser/tot/out");
		cp.setOutputDir(out);
		cp.setForge(forgeSpec);
		cp.setSt(new File("templates/hw"));
		cp.setT("tot");
		String current = new java.io.File(".").getCanonicalPath();
		cp.setTot(current + "/test/com/forge/parser/tot/");
		List<String> fOptionFiles = new ArrayList<>();
		fOptionFiles.add("test/com/forge/parser/tot/tot.f");
		cp.setFOptionFiles(fOptionFiles);
		cp.processArgs();
		ForgeUtils.setForgeSpecName("tot");
		ForgeRunnerSession forgeRunnerSession = new ForgeRunnerSession(cp.getOutputDir(), cp.getForge().toString(),
				 false, cp.getSt(),new HashMap<String,String>());
		forgeRunnerSession.run();
		FexRunnerSession frs = new FexRunnerSession(cp);
		frs.run();

		List<String> lines = FileUtils.ReadLines(new File("test/com/forge/parser/tot/out/rtl_tot.xf"));
		for (String line : lines) {
			if (line.contains("rnaxi_mem_phy")) {
				boolean cond = line.equals(current + "/test/com/forge/parser/tot/rnaxi_mem_phy.v");
				Assert.assertTrue(cond);
			}
		}

		clearOutputDirectory(out);
	}

	private void clearOutputDirectory(File output) {
		if (output != null) {
			if (output.exists()) {
				List<File> files = FileUtils.allFilesInDir(output.toString());
				for (File f : files) {
					FileUtils.Delete(f, true);
				}
			}
			FileUtils.deleteAllEmptyDirs(output);
		}
	}
}
