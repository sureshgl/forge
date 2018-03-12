package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarnochangestrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarnochangestrContextExt extends AbstractBaseExt {

	public DollarnochangestrContextExt(DollarnochangestrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarnochangestrContext getContext() {
		return (DollarnochangestrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarnochangestr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarnochangestrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarnochangestrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}