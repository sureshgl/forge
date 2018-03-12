package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ForkjoinstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ForkjoinstrContextExt extends AbstractBaseExt {

	public ForkjoinstrContextExt(ForkjoinstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ForkjoinstrContext getContext() {
		return (ForkjoinstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).forkjoinstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ForkjoinstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ForkjoinstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}