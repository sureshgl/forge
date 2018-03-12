package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndfunctionstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndfunctionstrContextExt extends AbstractBaseExt {

	public EndfunctionstrContextExt(EndfunctionstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndfunctionstrContext getContext() {
		return (EndfunctionstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endfunctionstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndfunctionstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ EndfunctionstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}