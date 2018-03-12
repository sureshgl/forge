package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LeContextExt extends AbstractBaseExt {

	public LeContextExt(LeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LeContext getContext() {
		return (LeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).le());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}