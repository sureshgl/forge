package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RealtimestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RealtimestrContextExt extends AbstractBaseExt {

	public RealtimestrContextExt(RealtimestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RealtimestrContext getContext() {
		return (RealtimestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).realtimestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RealtimestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RealtimestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}