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
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.AlternativeContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.ElementContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.LabeledAltContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.LexerAltContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.LexerElementContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.RuleSpecContext;
import com.forge.parser.ANTLRv4.gen.ANTLRv4ParserBaseVisitor;

public class StringLiteralsToLexers extends ANTLRv4ParserBaseVisitor<String> {

	/*
	 * parserRuleSpec : DOC_COMMENT? ruleModifiers? RULE_REF ARG_ACTION?
	 * ruleReturns? throwsSpec? localsSpec? rulePrequel* COLON ruleBlock SEMI
	 * exceptionGroup ;
	 */

	@SuppressWarnings("unused")
	private List<String> literals;
	private StringBuilder temp;

	public StringLiteralsToLexers() {
		literals = new ArrayList<>();
	}

	@Override
	public String visitParserRuleSpec(@NotNull ANTLRv4Parser.ParserRuleSpecContext ctx) {
		temp = new StringBuilder();
		String name = ctx.RULE_REF().getText();
		temp.append(name);
		temp.append("\n");
		String camelCase = name.substring(0, 1).toUpperCase() + name.substring(1);
		temp.append("locals [ ");
		temp.append(camelCase);
		temp.append("ContextExt extendedContext ]\n");
		temp.append(":");
		visitRuleBlock(ctx.ruleBlock());
		temp.append(";");
		System.out.println(temp);
		System.out.println();
		return null;
	}

	/*
	 * ruleBlock : ruleAltList ;
	 */
	@Override
	public String visitRuleBlock(@NotNull ANTLRv4Parser.RuleBlockContext ctx) {
		return visitRuleAltList(ctx.ruleAltList());
	}

	/*
	 * ruleAltList : labeledAlt (OR labeledAlt)* ;
	 */
	@Override
	public String visitRuleAltList(@NotNull ANTLRv4Parser.RuleAltListContext ctx) {
		List<LabeledAltContext> labledAltList = ctx.labeledAlt();
		visitLabeledAlt(labledAltList.get(0));
		for (int i = 1; i < labledAltList.size(); i++) {
			temp.append("\n");
			temp.append("| ");
			visitLabeledAlt(labledAltList.get(i));
		}
		return null;
	}

	/*
	 * labeledAlt : alternative (POUND id)? ;
	 */
	@Override
	public String visitLabeledAlt(@NotNull ANTLRv4Parser.LabeledAltContext ctx) {
		// temp.append(" pre_pragma? ");
		visitAlternative(ctx.alternative());
		// temp.append(" post_pragma? ");
		if (ctx.id() != null) {
			temp.append(ctx.POUND().getText());
			temp.append(ctx.id().getText());
		}

		return null;
	}

	/*
	 * alternative : elementOptions? element* ;
	 */
	@Override
	public String visitAlternative(@NotNull ANTLRv4Parser.AlternativeContext ctx) {
		List<ElementContext> elementList = ctx.element();
		for (ElementContext elementContext : elementList) {
			visitElement(elementContext);
		}
		return null;
	}

	/*
	 * element : labeledElement ( ebnfSuffix | ) | atom ( ebnfSuffix | ) | ebnf |
	 * ACTION QUESTION? // SEMPRED is ACTION followed by QUESTION ;
	 */
	@Override
	public String visitElement(@NotNull ANTLRv4Parser.ElementContext ctx) {
		if (ctx.atom() != null) {
			visitAtom(ctx.atom());
			if (ctx.ebnfSuffix() != null) {
				temp.append(ctx.ebnfSuffix().getText() + " ");
			} else {
				temp.append(" ");
			}
		} else if (ctx.ebnf() != null) {
			visitEbnf(ctx.ebnf());
		}
		return null;
	}

	/*
	 * ebnf: block blockSuffix? ;
	 */
	@Override
	public String visitEbnf(@NotNull ANTLRv4Parser.EbnfContext ctx) {
		visitBlock(ctx.block());
		if (ctx.blockSuffix() != null) {
			temp.append(ctx.blockSuffix().getText() + " ");
		}
		return null;
	}

	/*
	 * * atom : range // Range x..y - only valid in lexers | terminal | ruleref |
	 * notSet | DOT elementOptions? ;
	 */
	@Override
	public String visitAtom(@NotNull ANTLRv4Parser.AtomContext ctx) {
		if (ctx.terminal() != null) {
			visitTerminal(ctx.terminal());
		} else {
			temp.append(" " + ctx.getText());
		}
		return null;
	}

	/*
	 * terminal : TOKEN_REF elementOptions? | STRING_LITERAL elementOptions? ;
	 * 
	 */

	@Override
	public String visitTerminal(@NotNull ANTLRv4Parser.TerminalContext ctx) {
		// if(ctx.STRING_LITERAL() != null){
		// // literals.add(ctx.STRING_LITERAL().getText());
		// temp.append(" "+ctx.getText()+"str");
		// } else{
		// temp.append(" "+ctx.getText());
		// }
		temp.append(ctx.getText());
		return null;
	}

	/*
	 * block : LPAREN ( optionsSpec? ruleAction* COLON )? altList RPAREN ;
	 */
	@Override
	public String visitBlock(@NotNull ANTLRv4Parser.BlockContext ctx) {
		temp.append("( ");
		visitAltList(ctx.altList());
		temp.append(" )");
		return null;
	}

	/*
	 * altList : alternative (OR alternative)* ;
	 */
	@Override
	public String visitAltList(@NotNull ANTLRv4Parser.AltListContext ctx) {
		List<AlternativeContext> alternativeList = ctx.alternative();
		visitAlternative(alternativeList.get(0));
		for (int i = 1; i < alternativeList.size(); i++) {
			temp.append("\n");
			temp.append("| ");
			visitAlternative(alternativeList.get(i));
		}
		return null;
	}

	/*
	 * lexerRule : DOC_COMMENT? FRAGMENT? TOKEN_REF COLON lexerRuleBlock SEMI ;
	 */

	@Override
	public String visitLexerRule(@NotNull ANTLRv4Parser.LexerRuleContext ctx) {
		temp = new StringBuilder();
		temp.append(ctx.TOKEN_REF().getText() + " : ");
		visitLexerRuleBlock(ctx.lexerRuleBlock());
		temp.append(";\n");
		return null;
	}
	/*
	 * lexerRuleBlock : lexerAltList ;
	 */

	@Override
	public String visitLexerRuleBlock(@NotNull ANTLRv4Parser.LexerRuleBlockContext ctx) {
		return visitLexerAltList(ctx.lexerAltList());
	}

	/*
	 * lexerAltList : lexerAlt (OR lexerAlt)* ;
	 */
	@Override
	public String visitLexerAltList(@NotNull ANTLRv4Parser.LexerAltListContext ctx) {
		List<LexerAltContext> labledAltList = ctx.lexerAlt();
		visitLexerAlt(labledAltList.get(0));
		for (int i = 1; i < labledAltList.size(); i++) {
			temp.append("\n");
			temp.append("| ");
			visitLexerAlt(labledAltList.get(i));
		}
		return null;
	}

	/*
	 * lexerAlt : lexerElements lexerCommands? | ;
	 */

	@Override
	public String visitLexerAlt(@NotNull ANTLRv4Parser.LexerAltContext ctx) {
		visitLexerElements(ctx.lexerElements());
		if (ctx.lexerCommands() != null) {
			visitLexerCommands(ctx.lexerCommands());
		}
		return null;
	}

	/*
	 * lexerElements : lexerElement+ ;
	 */
	@Override
	public String visitLexerElements(@NotNull ANTLRv4Parser.LexerElementsContext ctx) {
		for (LexerElementContext l : ctx.lexerElement()) {
			visitLexerElement(l);
		}
		return null;
	}

	/*
	 * lexerElement : labeledLexerElement ebnfSuffix? | lexerAtom ebnfSuffix? |
	 * lexerBlock ebnfSuffix? | ACTION QUESTION? // actions only allowed at end of
	 * outer alt actually, // but preds can be anywhere ;
	 * 
	 */

	@Override
	public String visitLexerElement(@NotNull ANTLRv4Parser.LexerElementContext ctx) {
		if (ctx.lexerAtom() != null) {
			visitLexerAtom(ctx.lexerAtom());
		} else if (ctx.lexerBlock() != null) {
			visitLexerBlock(ctx.lexerBlock());

		} else if (ctx.labeledLexerElement() != null) {
			visitLabeledLexerElement(ctx.labeledLexerElement());
		}
		if (ctx.ebnfSuffix() != null) {
			temp.append(ctx.ebnfSuffix().getText() + " ");
		} else {
			temp.append(" ");
		}
		return null;
	}

	/*
	 * labeledLexerElement : id (ASSIGN|PLUS_ASSIGN) ( lexerAtom | block ) ;
	 */
	@Override
	public String visitLabeledLexerElement(@NotNull ANTLRv4Parser.LabeledLexerElementContext ctx) {
		temp.append(ctx.id().getText());
		if (ctx.ASSIGN() != null) {
			temp.append(" = ");
		} else {
			temp.append(" += ");
		}
		if (ctx.lexerAtom() != null) {
			visitLexerAtom(ctx.lexerAtom());
		} else {
			visitBlock(ctx.block());
		}
		return null;
	}

	/*
	 * 
	 * lexerBlock : LPAREN lexerAltList RPAREN ;
	 */

	@Override
	public String visitLexerBlock(@NotNull ANTLRv4Parser.LexerBlockContext ctx) {
		temp.append("(");
		visitLexerAltList(ctx.lexerAltList());
		temp.append(")");
		return null;
	}

	/*
	 * lexerCommands : RARROW lexerCommand (COMMA lexerCommand)* ;
	 */
	@Override
	public String visitLexerCommands(@NotNull ANTLRv4Parser.LexerCommandsContext ctx) {
		temp.append(" ->");
		String prefix = "";
		for (com.forge.parser.ANTLRv4.gen.ANTLRv4Parser.LexerCommandContext l : ctx.lexerCommand()) {
			temp.append(prefix);
			prefix = ",";
			temp.append(l.getText());
		}
		return null;
	}

	/*
	 * lexerAtom : range | terminal | RULE_REF | notSet | LEXER_CHAR_SET | DOT
	 * elementOptions? ;
	 * 
	 */
	@Override
	public String visitLexerAtom(@NotNull ANTLRv4Parser.LexerAtomContext ctx) {
		temp.append(" " + ctx.getText());
		return null;
	}

	List<RuleSpecContext> getRuleSpecList() throws IOException {
		File verilogFile = new File("./grammar/Forge.g4");
		InputStream inputStream = new FileInputStream(verilogFile);
		ANTLRv4Lexer lexer = new ANTLRv4Lexer(new ANTLRInputStream(inputStream));
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		ANTLRv4Parser parser = new ANTLRv4Parser(tokens);
		ANTLRv4Parser.GrammarSpecContext tree = parser.grammarSpec();
		return tree.rules().ruleSpec();
	}

	public static void main(String args[]) throws IOException {
		StringLiteralsToLexers stringLiteralsToLexers = new StringLiteralsToLexers();
		List<RuleSpecContext> ruleSpecContextList = stringLiteralsToLexers.getRuleSpecList();
		for (RuleSpecContext ruleSpecContext : ruleSpecContextList) {
			if (ruleSpecContext.parserRuleSpec() != null) {
				stringLiteralsToLexers.visitParserRuleSpec(ruleSpecContext.parserRuleSpec());
				System.out.println(stringLiteralsToLexers.temp);
			} else {
				stringLiteralsToLexers.visitLexerRule(ruleSpecContext.lexerRule());
				System.out.println(stringLiteralsToLexers.temp);
			}
			// }
			// StringBuilder forLex = new StringBuilder();
			// for(String literal:stringLiteralsToLexers.literals){
			// stringLiteralsToLexers.temp.append(literal+"str\n");
			// stringLiteralsToLexers.temp.append("locals [ "+literal+"strContextExt
			// extendedContext ]\n");
			// String lex = literal+"str";
			// stringLiteralsToLexers.temp.append(": "+lex.toUpperCase()+";\n");
			//
			// forLex.append(lex.toUpperCase()+" : '"+literal+"' ;\n");
			// }
			// System.out.println(stringLiteralsToLexers.temp);
			// System.out.println(forLex);
		}
	}
}
