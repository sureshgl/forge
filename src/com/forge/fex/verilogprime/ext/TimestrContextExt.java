package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.TimestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class TimestrContextExt extends AbstractBaseExt {

	public TimestrContextExt(TimestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TimestrContext getContext() {
		return (TimestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).timestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TimestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TimestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}