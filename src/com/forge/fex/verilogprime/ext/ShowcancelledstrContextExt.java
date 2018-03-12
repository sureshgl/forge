package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ShowcancelledstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ShowcancelledstrContextExt extends AbstractBaseExt {

	public ShowcancelledstrContextExt(ShowcancelledstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ShowcancelledstrContext getContext() {
		return (ShowcancelledstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).showcancelledstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ShowcancelledstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ ShowcancelledstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}