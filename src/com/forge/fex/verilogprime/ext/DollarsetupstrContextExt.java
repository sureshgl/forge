package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarsetupstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarsetupstrContextExt extends AbstractBaseExt {

	public DollarsetupstrContextExt(DollarsetupstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarsetupstrContext getContext() {
		return (DollarsetupstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarsetupstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarsetupstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarsetupstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}