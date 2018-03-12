package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.NotstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class NotstrContextExt extends AbstractBaseExt {

	public NotstrContextExt(NotstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public NotstrContext getContext() {
		return (NotstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).notstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof NotstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + NotstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}