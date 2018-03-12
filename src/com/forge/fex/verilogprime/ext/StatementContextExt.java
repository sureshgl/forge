package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StatementContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StatementContextExt extends AbstractBaseExt {

	public StatementContextExt(StatementContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StatementContext getContext() {
		return (StatementContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).statement());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StatementContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + StatementContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}