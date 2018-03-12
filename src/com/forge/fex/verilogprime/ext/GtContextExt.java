package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.GtContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class GtContextExt extends AbstractBaseExt {

	public GtContextExt(GtContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public GtContext getContext() {
		return (GtContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).gt());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof GtContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + GtContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}