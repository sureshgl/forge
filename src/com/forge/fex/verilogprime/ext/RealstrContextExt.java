package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RealstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RealstrContextExt extends AbstractBaseExt {

	public RealstrContextExt(RealstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RealstrContext getContext() {
		return (RealstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).realstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RealstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RealstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}