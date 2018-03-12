package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.EndstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class EndstrContextExt extends AbstractBaseExt {

	public EndstrContextExt(EndstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public EndstrContext getContext() {
		return (EndstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).endstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof EndstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + EndstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}