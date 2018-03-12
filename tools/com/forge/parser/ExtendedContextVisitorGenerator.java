package com.forge.parser;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.misc.NotNull;

import com.forge.parser.ANTLRv4.gen.ANTLRv4Lexer;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.RuleSpecContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4ParserBaseVisitor;

public class ExtendedContextVisitorGenerator extends ANTLRv4ParserBaseVisitor<String> {

	private List<String> rules;

	public ExtendedContextVisitorGenerator() {
		rules = new ArrayList<>();
	}

	@Override
	public String visitParserRuleSpec(@NotNull ANTLRv4Parser.ParserRuleSpecContext ctx) {
		String name = ctx.RULE_REF().getText();
		rules.add(name);
		return null;
	}

	List<RuleSpecContext> getRuleSpecList() throws IOException {
		File verilogFile = new File("./grammar/ForgeParser.g4");
		InputStream inputStream = new FileInputStream(verilogFile);
		ANTLRv4Lexer lexer = new ANTLRv4Lexer(new ANTLRInputStream(inputStream));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		ANTLRv4Parser parser = new ANTLRv4Parser(tokens);
		ANTLRv4Parser.GrammarSpecContext tree = parser.grammarSpec();
		return tree.rules().ruleSpec();
	}

	public static void main(String args[]) throws IOException {
		ExtendedContextVisitorGenerator extendedContextVisitorGenerator = new ExtendedContextVisitorGenerator();
		List<RuleSpecContext> ruleSpecContextList = extendedContextVisitorGenerator.getRuleSpecList();
		for (RuleSpecContext ruleSpecContext : ruleSpecContextList) {
			if (ruleSpecContext.parserRuleSpec() != null) {
				extendedContextVisitorGenerator.visitParserRuleSpec(ruleSpecContext.parserRuleSpec());
			}
		}
		for (String rule : extendedContextVisitorGenerator.rules) {
			rule = rule.substring(0, 1).toUpperCase() + rule.substring(1);
			String out = "@Override public AbstractBaseExt visit" + rule + "(ForgeParser." + rule
					+ "Context ctx) {return ctx.extendedContext;}";
			System.out.println(out);
			System.out.println();
		}
	}
}
