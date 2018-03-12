package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarremovalstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarremovalstrContextExt extends AbstractBaseExt {

	public DollarremovalstrContextExt(DollarremovalstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarremovalstrContext getContext() {
		return (DollarremovalstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarremovalstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarremovalstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarremovalstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}