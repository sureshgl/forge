package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Simple_immediate_cover_statementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Simple_immediate_cover_statementContextExt extends AbstractBaseExt {

	public Simple_immediate_cover_statementContextExt(Simple_immediate_cover_statementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Simple_immediate_cover_statementContext getContext() {
		return (Simple_immediate_cover_statementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).simple_immediate_cover_statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Simple_immediate_cover_statementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Simple_immediate_cover_statementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}