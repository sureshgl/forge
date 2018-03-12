package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Config_rule_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Config_rule_statementContextExt extends AbstractBaseExt {

	public Config_rule_statementContextExt(Config_rule_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Config_rule_statementContext getContext() {
		return (Config_rule_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).config_rule_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Config_rule_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Config_rule_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}