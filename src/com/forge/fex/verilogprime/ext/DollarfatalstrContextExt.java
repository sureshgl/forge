package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarfatalstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarfatalstrContextExt extends AbstractBaseExt {

	public DollarfatalstrContextExt(DollarfatalstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarfatalstrContext getContext() {
		return (DollarfatalstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarfatalstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarfatalstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarfatalstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}