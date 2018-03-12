package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ForstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ForstrContextExt extends AbstractBaseExt {

	public ForstrContextExt(ForstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ForstrContext getContext() {
		return (ForstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).forstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ForstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ForstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}