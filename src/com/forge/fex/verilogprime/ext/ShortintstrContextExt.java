package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ShortintstrContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class ShortintstrContextExt extends AbstractBaseExt {

	public ShortintstrContextExt(ShortintstrContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public ShortintstrContext getContext() {
		return (ShortintstrContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).shortintstr());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof ShortintstrContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + ShortintstrContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}