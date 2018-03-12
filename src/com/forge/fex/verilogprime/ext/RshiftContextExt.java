package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RshiftContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RshiftContextExt extends AbstractBaseExt {

	public RshiftContextExt(RshiftContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RshiftContext getContext() {
		return (RshiftContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).rshift());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RshiftContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RshiftContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}