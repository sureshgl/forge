package com.forge.fex.verilogprime.runner;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.beust.jcommander.JCommander;
import com.forge.parser.ForgeUtils;
import com.forge.runner.ForgeRunnerSession;

public class FexRunner {

	private static final Logger L = LoggerFactory.getLogger(FexRunner.class);
	private static JCommander jc = null;
	private static CommandLineParser cp = new CommandLineParser(new File("./").getAbsolutePath());

	public static void main(String[] args) {
		FexRunner.L.info("Launching Forge Expander");
		FexRunner.runVerilogParserRunner(args, true);
	}

	public static void printHelp(JCommander jac) {
		jac.usage();
	}

	public static void runVerilogParserRunner(String[] args, boolean systemExitOnException) {
		try {
			FexRunner.jc = new JCommander(FexRunner.cp);
			FexRunner.jc.setProgramName("Forge Expander");
			FexRunner.jc.parse(args);
			FexRunner.cp.processArgs();
			if (FexRunner.cp.isHelp()) {
				FexRunner.printHelp(FexRunner.jc);
				System.exit(0);
			}
		} catch (Throwable t) {
			FexRunner.printHelp(FexRunner.jc);
			throw new RuntimeException("Error parsing Arguments");
		}
		try {
			ForgeUtils.setForgeSpecName(cp.getT());
			FexRunnerSession fexSession = new FexRunnerSession(FexRunner.cp);
			Map<String,String> topModuleParameters = fexSession.collectTopModuleParameters();
			ForgeRunnerSession forgeRunnerSession = new ForgeRunnerSession(FexRunner.cp.getOutputDir(),
					FexRunner.cp.getForge().toString(), FexRunner.cp.isEmitjson(), FexRunner.cp.getSt(),topModuleParameters);
			if(cp.isStitchMaster()){
				List<String> chain = forgeRunnerSession.getChain();
				fexSession.stitchMaster(chain);
			} else {
				forgeRunnerSession.run();
				fexSession.setForgeSession(forgeRunnerSession);
				FexRunner.L.info("Done with Forge Gen");
				fexSession.run();
				FexRunner.L.info("Done with Forge.");
			}
		} catch (Throwable t) {
			t.printStackTrace();
			throw new RuntimeException("Error Running Forge Expander Session");
		}
	}

}
