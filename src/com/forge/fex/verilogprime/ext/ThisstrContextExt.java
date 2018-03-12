package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ThisstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ThisstrContextExt extends AbstractBaseExt {

	public ThisstrContextExt(ThisstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ThisstrContext getContext() {
		return (ThisstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).thisstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ThisstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ThisstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}