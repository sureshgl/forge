package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RandstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RandstrContextExt extends AbstractBaseExt {

	public RandstrContextExt(RandstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RandstrContext getContext() {
		return (RandstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).randstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RandstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RandstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}