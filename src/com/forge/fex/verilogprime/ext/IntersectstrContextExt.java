package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.IntersectstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class IntersectstrContextExt extends AbstractBaseExt {

	public IntersectstrContextExt(IntersectstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public IntersectstrContext getContext() {
		return (IntersectstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).intersectstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof IntersectstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + IntersectstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}