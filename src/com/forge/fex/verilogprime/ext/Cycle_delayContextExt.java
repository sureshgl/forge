package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cycle_delayContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cycle_delayContextExt extends AbstractBaseExt {

	public Cycle_delayContextExt(Cycle_delayContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cycle_delayContext getContext() {
		return (Cycle_delayContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cycle_delay());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cycle_delayContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Cycle_delayContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}