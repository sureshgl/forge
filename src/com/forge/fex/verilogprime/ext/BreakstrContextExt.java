package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.BreakstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class BreakstrContextExt extends AbstractBaseExt {

	public BreakstrContextExt(BreakstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BreakstrContext getContext() {
		return (BreakstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).breakstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BreakstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BreakstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}