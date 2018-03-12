package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TimeunitContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TimeunitContextExt extends AbstractBaseExt {

	public TimeunitContextExt(TimeunitContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TimeunitContext getContext() {
		return (TimeunitContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).timeunit());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TimeunitContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TimeunitContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}