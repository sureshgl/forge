package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarinfostrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarinfostrContextExt extends AbstractBaseExt {

	public DollarinfostrContextExt(DollarinfostrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarinfostrContext getContext() {
		return (DollarinfostrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarinfostr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarinfostrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + DollarinfostrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}