package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarwarningstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarwarningstrContextExt extends AbstractBaseExt {

	public DollarwarningstrContextExt(DollarwarningstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarwarningstrContext getContext() {
		return (DollarwarningstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarwarningstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarwarningstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarwarningstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}