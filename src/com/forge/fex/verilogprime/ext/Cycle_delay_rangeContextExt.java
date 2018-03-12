package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cycle_delay_rangeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cycle_delay_rangeContextExt extends AbstractBaseExt {

	public Cycle_delay_rangeContextExt(Cycle_delay_rangeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cycle_delay_rangeContext getContext() {
		return (Cycle_delay_rangeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cycle_delay_range());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cycle_delay_rangeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cycle_delay_rangeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}