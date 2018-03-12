package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Scalar_timing_check_conditionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Scalar_timing_check_conditionContextExt extends AbstractBaseExt {

	public Scalar_timing_check_conditionContextExt(Scalar_timing_check_conditionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Scalar_timing_check_conditionContext getContext() {
		return (Scalar_timing_check_conditionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).scalar_timing_check_condition());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Scalar_timing_check_conditionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Scalar_timing_check_conditionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}