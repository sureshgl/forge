package com.forge.parser;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.misc.NotNull;

import com.forge.parser.ANTLRv4.gen.ANTLRv4Lexer;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.GrammarSpecContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.LabeledAltContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.RuleSpecContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4ParserBaseVisitor;

import lombok.Getter;

public class RulesOfGrammarFile extends ANTLRv4ParserBaseVisitor<String> {

	@Getter
	private List<String> parserRules;
	@Getter
	private Map<String, String> altRules;
	private String parent;
	private Boolean hasAltRules;

	public RulesOfGrammarFile(String fileName) throws Exception {
		parserRules = new ArrayList<>();
		altRules = new LinkedHashMap<>();
		hasAltRules = false;

		File verilogFile = new File(fileName);
		if (!verilogFile.exists()) {
			throw new Exception("Veriglo File Doesnt Exist");
		}
		InputStream inputStream = new FileInputStream(verilogFile);
		ANTLRv4Lexer lexer = new ANTLRv4Lexer(new ANTLRInputStream(inputStream));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		ANTLRv4Parser parser = new ANTLRv4Parser(tokens);
		GrammarSpecContext tree = parser.grammarSpec();
		for (RuleSpecContext ruleSpecContext : tree.rules().ruleSpec()) {
			if (ruleSpecContext.parserRuleSpec() != null) {
				visitParserRuleSpec(ruleSpecContext.parserRuleSpec());
			}
		}
	}

	@Override
	public String visitParserRuleSpec(@NotNull ANTLRv4Parser.ParserRuleSpecContext ctx) {
		String name = ctx.RULE_REF().getText();
		parent = name;
		visitRuleBlock(ctx.ruleBlock());
		if (!hasAltRules) {
			parserRules.add(name);
			hasAltRules = false;
		}
		return null;
	}

	@Override
	public String visitRuleBlock(@NotNull ANTLRv4Parser.RuleBlockContext ctx) {
		return visitRuleAltList(ctx.ruleAltList());
	}

	@Override
	public String visitRuleAltList(@NotNull ANTLRv4Parser.RuleAltListContext ctx) {
		List<LabeledAltContext> labledAltList = ctx.labeledAlt();
		visitLabeledAlt(labledAltList.get(0));
		for (int i = 1; i < labledAltList.size(); i++) {
			visitLabeledAlt(labledAltList.get(i));
		}
		return null;
	}

	@Override
	public String visitLabeledAlt(@NotNull ANTLRv4Parser.LabeledAltContext ctx) {
		if (ctx.id() != null) {
			hasAltRules = true;
			altRules.put(ctx.id().getText(), parent);
		}
		return null;
	}
}