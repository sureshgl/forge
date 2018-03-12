package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarunitstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarunitstrContextExt extends AbstractBaseExt {

	public DollarunitstrContextExt(DollarunitstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarunitstrContext getContext() {
		return (DollarunitstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarunitstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarunitstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DollarunitstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}