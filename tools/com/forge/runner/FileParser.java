package com.forge.runner;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.atn.PredictionMode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.parser.DescriptiveErrorListener;
import com.forge.parser.ExtendedContextVisitor;
import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.ext.AbstractBaseExt;
import com.forge.parser.ext.StartContextExt;
import com.forge.parser.gen.ForgeLexer;
import com.forge.parser.gen.ForgeParser;
import com.forge.parser.gen.ForgeParser.StartContext;

public class FileParser {

	private static final Logger L = LoggerFactory.getLogger(FileParser.class);
	public static boolean hasForgeError = false;

	public StartContext getFileContent(File file) {
		FileParser.L.info("trying to parse " + file);
		ParserRuleContext p = trySLLModule(file);
		if (p == null) {
			p = tryLLModule(file);
		}
		if (p != null) {
			PopulateExtendedContextVisitor pecv = new PopulateExtendedContextVisitor();
			pecv.visit(p);
			ExtendedContextVisitor ecv = new ExtendedContextVisitor();
			AbstractBaseExt abxt = ecv.visit(p);
			StartContextExt stxt = (StartContextExt) abxt;
			if (stxt == null) {
				FileParser.L.warn("No context");
			}
			StartContext stc = stxt.getContext();
			FileParser.L.info("Done with " + file);
			return stc;
		} else {
			throw new IllegalStateException("Could not parse module :" + file);
		}
	}

	private ParserRuleContext trySLLModule(File file) {
		try {
			String moduleString = readFile(file);
			return trySLLContent(moduleString);
		} catch (IOException e) {
			FileParser.L.error("Error reading file " + file);
			e.printStackTrace();
			return null;
		}
	}

	private ParserRuleContext tryLLModule(File file) {
		try {
			String moduleString = readFile(file);
			return FileParser.tryLLContent(moduleString);
		} catch (IOException e) {
			FileParser.L.error("Error reading file " + file);
			e.printStackTrace();
			return null;
		}
	}

	private String readFile(File file) throws IOException {
		BufferedReader br = new BufferedReader(new FileReader(file));
		try {
			StringBuilder sb = new StringBuilder();
			String line = br.readLine();
			while (line != null) {
				if (!line.endsWith("\\")) {
					sb.append(line);
					sb.append("\n");
				} else {
					sb.append(line.substring(0, line.length() - 1));
				}
				line = br.readLine();
			}
			return sb.toString();
		} finally {
			br.close();
		}
	}

	public static ParserRuleContext tryLLContent(String content) {
		ForgeLexer lexer = new ForgeLexer(new ANTLRInputStream(content));
		lexer.removeErrorListeners();
		lexer.addErrorListener(DescriptiveErrorListener.INSTANCE);

		CommonTokenStream tokens = new CommonTokenStream(lexer);
		ForgeParser parser = new ForgeParser(null);
		try {
			parser.getInterpreter().setPredictionMode(PredictionMode.LL);
			// parser.setErrorHandler(new BailErrorStrategy());
			// parser.setErrorHandler(new ExceptionErrorStrategy ());
			parser.removeErrorListeners();
			DescriptiveErrorListener descError = DescriptiveErrorListener.INSTANCE;
			parser.addErrorListener(descError);

			parser.setBuildParseTree(true);
			parser.setTokenStream(tokens);
			ParserRuleContext tree = parser.start();
			FileParser.hasForgeError = descError.hasError;
			return tree;
		} catch (Exception e) {
			FileParser.L.error("Error parsing content with LL strategy");
			return null;
		}
	}

	public ParserRuleContext trySLLContent(String content) {
		ForgeLexer lexer = new ForgeLexer(new ANTLRInputStream(content));
		lexer.removeErrorListeners();
		lexer.addErrorListener(DescriptiveErrorListener.INSTANCE);

		CommonTokenStream tokens = new CommonTokenStream(lexer);
		ForgeParser parser = new ForgeParser(null);
		try {
			parser.getInterpreter().setPredictionMode(PredictionMode.SLL);
			// parser.setErrorHandler(new BailErrorStrategy());
			parser.removeErrorListeners();

			DescriptiveErrorListener descError = DescriptiveErrorListener.INSTANCE;
			parser.addErrorListener(descError);

			// parser.setErrorHandler(new ExceptionErrorStrategy());
			parser.setBuildParseTree(true);
			parser.setTokenStream(tokens);
			ParserRuleContext tree = parser.start();
			FileParser.hasForgeError = descError.hasError;
			return tree;
		} catch (Exception e) {
			FileParser.L.debug("Error parsing content with SLL strategy");
			return null;
		}
	}

	public StartContext getStartContext(String defineIdValue) {
		ParserRuleContext p = trySLLContent(defineIdValue);
		if (p == null) {
			p = FileParser.tryLLContent(defineIdValue);
		}
		if (p != null) {
			PopulateExtendedContextVisitor pecv = new PopulateExtendedContextVisitor();
			pecv.visit(p);
			ExtendedContextVisitor ecv = new ExtendedContextVisitor();
			AbstractBaseExt abxt = ecv.visit(p);
			StartContextExt dtxt = (StartContextExt) abxt;
			if (dtxt == null) {
				FileParser.L.warn("No context");
			}
			StartContext stc = dtxt.getContext();
			FileParser.L.warn("Done with " + defineIdValue);
			return stc;
		} else {
			throw new IllegalStateException("Could not parse content :" + defineIdValue);
		}
	}

}
