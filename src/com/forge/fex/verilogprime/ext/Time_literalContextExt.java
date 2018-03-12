package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Time_literalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Time_literalContextExt extends AbstractBaseExt {

	public Time_literalContextExt(Time_literalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Time_literalContext getContext() {
		return (Time_literalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).time_literal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Time_literalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Time_literalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}