package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Hold_timing_checkContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Hold_timing_checkContextExt extends AbstractBaseExt {

	public Hold_timing_checkContextExt(Hold_timing_checkContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hold_timing_checkContext getContext() {
		return (Hold_timing_checkContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hold_timing_check());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hold_timing_checkContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Hold_timing_checkContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}