package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RparenContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RparenContextExt extends AbstractBaseExt {

	public RparenContextExt(RparenContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RparenContext getContext() {
		return (RparenContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rparen());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RparenContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RparenContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}