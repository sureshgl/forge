package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ForeverstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ForeverstrContextExt extends AbstractBaseExt {

	public ForeverstrContextExt(ForeverstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ForeverstrContext getContext() {
		return (ForeverstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).foreverstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ForeverstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ForeverstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}