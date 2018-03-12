package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.DollarerrorstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class DollarerrorstrContextExt extends AbstractBaseExt {

	public DollarerrorstrContextExt(DollarerrorstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public DollarerrorstrContext getContext() {
		return (DollarerrorstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).dollarerrorstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof DollarerrorstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ DollarerrorstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}