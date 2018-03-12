package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ForeachstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ForeachstrContextExt extends AbstractBaseExt {

	public ForeachstrContextExt(ForeachstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ForeachstrContext getContext() {
		return (ForeachstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).foreachstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ForeachstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ForeachstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}