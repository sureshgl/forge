package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarperiodstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarperiodstrContextExt extends AbstractBaseExt {

	public DollarperiodstrContextExt(DollarperiodstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarperiodstrContext getContext() {
		return (DollarperiodstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarperiodstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarperiodstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarperiodstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}