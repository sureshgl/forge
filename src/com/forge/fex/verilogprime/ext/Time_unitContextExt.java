package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Time_unitContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Time_unitContextExt extends AbstractBaseExt {

	public Time_unitContextExt(Time_unitContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Time_unitContext getContext() {
		return (Time_unitContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).time_unit());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Time_unitContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Time_unitContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}