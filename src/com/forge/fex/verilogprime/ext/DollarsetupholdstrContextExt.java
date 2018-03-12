package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarsetupholdstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarsetupholdstrContextExt extends AbstractBaseExt {

	public DollarsetupholdstrContextExt(DollarsetupholdstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarsetupholdstrContext getContext() {
		return (DollarsetupholdstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarsetupholdstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarsetupholdstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarsetupholdstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}