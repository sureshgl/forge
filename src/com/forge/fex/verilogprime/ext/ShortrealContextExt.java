package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ShortrealContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ShortrealContextExt extends AbstractBaseExt {

	public ShortrealContextExt(ShortrealContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ShortrealContext getContext() {
		return (ShortrealContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).shortreal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ShortrealContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ShortrealContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}