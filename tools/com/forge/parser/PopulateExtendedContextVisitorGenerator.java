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

public class PopulateExtendedContextVisitorGenerator extends ANTLRv4ParserBaseVisitor<String> {

	private List<String> rules;

	public PopulateExtendedContextVisitorGenerator() {
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
		PopulateExtendedContextVisitorGenerator populateExtendedContextVisitorGenerator = new PopulateExtendedContextVisitorGenerator();
		List<RuleSpecContext> ruleSpecContextList = populateExtendedContextVisitorGenerator.getRuleSpecList();
		for (RuleSpecContext ruleSpecContext : ruleSpecContextList) {
			if (ruleSpecContext.parserRuleSpec() != null) {
				populateExtendedContextVisitorGenerator.visitParserRuleSpec(ruleSpecContext.parserRuleSpec());
			}
		}
		for (String rule : populateExtendedContextVisitorGenerator.rules) {
			rule = rule.substring(0, 1).toUpperCase() + rule.substring(1);
			String out = "@Override public org.antlr.v4.runtime.ParserRuleContext visit" + rule + "(ForgeParser." + rule
					+ "Context ctx) {\n";
			out += "\tsuper.visit" + rule + "(ctx);\n";
			out += "\tctx.extendedContext = new " + rule + "ContextExt(ctx);return ctx;\n";
			out += "}\n";
			System.out.println(out);
		}
	}
}
