package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Width_timing_checkContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Width_timing_checkContextExt extends AbstractBaseExt {

	public Width_timing_checkContextExt(Width_timing_checkContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Width_timing_checkContext getContext() {
		return (Width_timing_checkContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).width_timing_check());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Width_timing_checkContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Width_timing_checkContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}