package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LifetimeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LifetimeContextExt extends AbstractBaseExt {

	public LifetimeContextExt(LifetimeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LifetimeContext getContext() {
		return (LifetimeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).lifetime());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LifetimeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + LifetimeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}