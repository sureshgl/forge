package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ThresholdContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ThresholdContextExt extends AbstractBaseExt {

	public ThresholdContextExt(ThresholdContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ThresholdContext getContext() {
		return (ThresholdContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).threshold());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ThresholdContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ThresholdContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}