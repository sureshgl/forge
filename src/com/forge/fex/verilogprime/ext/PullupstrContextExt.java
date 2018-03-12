package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.PullupstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class PullupstrContextExt extends AbstractBaseExt {

	public PullupstrContextExt(PullupstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PullupstrContext getContext() {
		return (PullupstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pullupstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PullupstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PullupstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}