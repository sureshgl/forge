package com.forge.runner;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.beust.jcommander.JCommander;

public class ForgeRunner {

	private static final Logger L = LoggerFactory.getLogger(ForgeRunner.class);
	private static JCommander jc = null;
	private static CommandLineParser cp = new CommandLineParser(new File("./").getAbsolutePath());

	public static void main(String[] args) {
		ForgeRunner.L.info("Launching forge to verilog generator");
		ForgeRunner.runForgeToVerilogGen(args, true);
	}

	public static void printHelp(JCommander jac) {
		jac.usage();
	}

	public static void runForgeToVerilogGen(String[] args, boolean systemExitOnException) {
		try {
			ForgeRunner.jc = new JCommander(ForgeRunner.cp);
			ForgeRunner.jc.setProgramName("proteus");
			ForgeRunner.jc.parse(args);
			if (ForgeRunner.cp.isHelp()) {
				ForgeRunner.printHelp(ForgeRunner.jc);
				System.exit(0);
			}
		} catch (Throwable t) {
			ForgeRunner.printHelp(ForgeRunner.jc);
			throw new RuntimeException("Error parsing Arguments");
		}
		try {
			ForgeRunnerSession session = new ForgeRunnerSession(ForgeRunner.cp.outputFile,
					ForgeRunner.cp.getParameters().get(0), false, null,null);
			session.run();
			ForgeRunner.L.info("Done");
		} catch (Throwable t) {
			t.printStackTrace();
			throw new RuntimeException("Error Running Proteus Session");
		}
	}

}
