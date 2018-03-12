package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Timing_check_conditionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Timing_check_conditionContextExt extends AbstractBaseExt {

	public Timing_check_conditionContextExt(Timing_check_conditionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Timing_check_conditionContext getContext() {
		return (Timing_check_conditionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).timing_check_condition());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Timing_check_conditionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Timing_check_conditionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}