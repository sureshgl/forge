package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Cycle_delay_const_range_expressionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Cycle_delay_const_range_expressionContextExt extends AbstractBaseExt {

	public Cycle_delay_const_range_expressionContextExt(Cycle_delay_const_range_expressionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Cycle_delay_const_range_expressionContext getContext() {
		return (Cycle_delay_const_range_expressionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).cycle_delay_const_range_expression());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Cycle_delay_const_range_expressionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Cycle_delay_const_range_expressionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}