package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.RandcstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class RandcstrContextExt extends AbstractBaseExt {

	public RandcstrContextExt(RandcstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public RandcstrContext getContext() {
		return (RandcstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).randcstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof RandcstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + RandcstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}