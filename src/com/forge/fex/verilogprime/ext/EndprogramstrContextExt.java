package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndprogramstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndprogramstrContextExt extends AbstractBaseExt {

	public EndprogramstrContextExt(EndprogramstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndprogramstrContext getContext() {
		return (EndprogramstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endprogramstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndprogramstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndprogramstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}