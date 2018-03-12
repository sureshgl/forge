package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PulldownstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PulldownstrContextExt extends AbstractBaseExt {

	public PulldownstrContextExt(PulldownstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PulldownstrContext getContext() {
		return (PulldownstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pulldownstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PulldownstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PulldownstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}