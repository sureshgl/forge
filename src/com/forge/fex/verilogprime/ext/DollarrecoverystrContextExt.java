package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarrecoverystrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarrecoverystrContextExt extends AbstractBaseExt {

	public DollarrecoverystrContextExt(DollarrecoverystrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarrecoverystrContext getContext() {
		return (DollarrecoverystrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarrecoverystr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarrecoverystrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarrecoverystrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}