package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EventstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EventstrContextExt extends AbstractBaseExt {

	public EventstrContextExt(EventstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EventstrContext getContext() {
		return (EventstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).eventstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EventstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EventstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}