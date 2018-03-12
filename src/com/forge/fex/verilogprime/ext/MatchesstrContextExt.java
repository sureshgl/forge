package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.MatchesstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class MatchesstrContextExt extends AbstractBaseExt {

	public MatchesstrContextExt(MatchesstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public MatchesstrContext getContext() {
		return (MatchesstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).matchesstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof MatchesstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + MatchesstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}