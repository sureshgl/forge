package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Non_consecutive_repetitionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Non_consecutive_repetitionContextExt extends AbstractBaseExt {

	public Non_consecutive_repetitionContextExt(Non_consecutive_repetitionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Non_consecutive_repetitionContext getContext() {
		return (Non_consecutive_repetitionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).non_consecutive_repetition());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Non_consecutive_repetitionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Non_consecutive_repetitionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}